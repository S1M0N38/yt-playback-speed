#!/usr/bin/env bash
# Sign an unlisted build on AMO and register it in updates.json.
#
#   1. cp .env.example .env   (fill in the AMO API key/secret)
#   2. bump "version" in yt-playback-speed/manifest.json
#   3. ./scripts/release.sh
#   4. upload dist/yt-playback-speed-<version>.xpi as a GitHub release
#   5. commit updates.json
set -euo pipefail

cd "$(dirname "$0")/.."

if [[ -f .env ]]; then
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
fi

: "${WEB_EXT_API_KEY:?set WEB_EXT_API_KEY (see .env.example)}"
: "${WEB_EXT_API_SECRET:?set WEB_EXT_API_SECRET (see .env.example)}"

SRC=yt-playback-speed
VERSION=$(node -p "require('./$SRC/manifest.json').version")
ID=$(node -p "require('./$SRC/manifest.json').browser_specific_settings.gecko.id")
XPI="dist/yt-playback-speed-$VERSION.xpi"
REPO=$(git config --get remote.origin.url)
REPO=${REPO#*github.com}
REPO=${REPO#:}
REPO=${REPO#/}
REPO=${REPO%.git}
LINK="https://github.com/$REPO/releases/download/v$VERSION/yt-playback-speed-$VERSION.xpi"

echo "==> linting $ID $VERSION"
npx --yes web-ext@latest lint --source-dir "$SRC" --self-hosted

echo "==> signing $VERSION (unlisted)"
rm -rf dist web-ext-artifacts
npx --yes web-ext@latest sign --source-dir "$SRC" --channel unlisted \
  --artifacts-dir dist --no-input

SIGNED=$(find dist -name '*.xpi' -print -quit)
[[ -n "$SIGNED" ]] || { echo "no signed .xpi produced" >&2; exit 1; }
mv "$SIGNED" "$XPI"
cp "$XPI" dist/yt-playback-speed.xpi   # stable name for releases/latest/download

HASH=$(shasum -a 256 "$XPI" | cut -d' ' -f1)

echo "==> registering $VERSION in updates.json"
node - "$ID" "$VERSION" "$LINK" "$HASH" <<'EOF'
const fs = require("fs");
const [id, version, link, hash] = process.argv.slice(2);
const file = "updates.json";
const data = JSON.parse(fs.readFileSync(file, "utf8"));
const entry = {
  version,
  update_link: link,
  update_hash: `sha256:${hash}`,
  applications: { gecko: { strict_min_version: "142.0" } },
};
const updates = (data.addons[id].updates || []).filter((u) => u.version !== version);
data.addons[id].updates = [entry, ...updates];
fs.writeFileSync(file, JSON.stringify(data, null, 2) + "\n");
EOF

cat <<EOF

Signed: $XPI
SHA256: $HASH

Next:
  gh release create v$VERSION "$XPI" dist/yt-playback-speed.xpi --title "v$VERSION"
  git add updates.json && git commit -m "chore: release v$VERSION"
  git push

Upload both assets: the versioned one is what updates.json points to, the
unversioned one keeps the latest-download link stable.
EOF

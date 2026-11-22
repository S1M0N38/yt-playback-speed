## YT Playback Speed

> This extension started as a fork of [nathvnt/3x-youtube](https://github.com/nathvnt/3x-youtube) and evolve a lot since then. Big thanks to the original author :)

YouTube caps its own speed menu at 2x and keeps 3x behind Premium. This
extension replaces that row in the player's settings menu with an equivalent
one that goes up to 3x, and it remembers the speed you pick.

<p align="center">
  <img width="540" height="415" alt="playback speed screenshot" src="https://github.com/user-attachments/assets/77f3d1fe-390b-4c0f-a747-a62d01a8a662" />
</p>


## Features

- **Speed panel in the player**: gear menu → *Playback speed*, with a slider
  from 0.25x to 3x and the presets from 1.0 to 2.5.
- **Remembers your speed** and re-applies it to every video, including after
  navigating and when the player is rebuilt.
- **Keyboard shortcuts**: <kbd>↑</kbd> / <kbd>↓</kbd> step by 0.25x and show the
  new speed over the video (this replaces YouTube's own volume shortcut).

## Install

Click **[yt-playback-speed.xpi](https://github.com/S1M0N38/yt-playback-speed/releases/latest/download/yt-playback-speed.xpi)**
and Firefox asks to install it — confirm, and it stays installed.

If your browser saves the file instead, open `about:addons` → gear icon →
**Install Add-on From File…** and pick it.

## Development

1. Open `about:debugging#/runtime/this-firefox`.
2. Click *Load Temporary Add-on…*.
3. Select `yt-playback-speed/manifest.json`.
4. Reload the YouTube tab.

Temporary add-ons are removed on every browser restart.

## Release

Self-hosted, unlisted Firefox add-on. One-time setup: `cp .env.example .env` and fill
in the [AMO API key/secret](https://addons.mozilla.org/en-US/developers/addon/api/key/).

```bash
# 1. bump "version" in yt-playback-speed/manifest.json
./scripts/release.sh        # lint + sign on AMO + update updates.json
gh release create v<version> dist/yt-playback-speed-<version>.xpi dist/yt-playback-speed.xpi
git add updates.json && git commit -m "chore: release v<version>" && git push
```

Installed copies update themselves within ~24h. Don't change `gecko.id` or
`update_url` in the manifest: existing installs keep the values they were
installed with.

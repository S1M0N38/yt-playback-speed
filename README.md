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

A build loaded through `about:debugging` is temporary: Firefox drops it on every
restart, including restarts after a browser update. To keep the extension around,
install a signed build instead.

### Permanent install

One-time setup:

1. Create a free account on [addons.mozilla.org](https://addons.mozilla.org) and
   generate API credentials at
   <https://addons.mozilla.org/en-US/developers/addon/api/key/>.
2. `cp .env.example .env` and paste the key/secret into it.

For every release:

1. Bump `version` in `yt-playback-speed/manifest.json`.
2. `./scripts/release.sh` — lints, signs the add-on on AMO (unlisted channel) and
   registers the build in `updates.json`. The signed file lands at
   `dist/yt-playback-speed-<version>.xpi`.
3. Publish that file as a GitHub release tagged `v<version>`, with the asset
   named exactly `yt-playback-speed-<version>.xpi`:
   `gh release create v<version> dist/yt-playback-speed-<version>.xpi`.
4. Commit `updates.json` and push — this is what lets installed copies update
   themselves.

Install it: **Add-ons and themes** (`about:addons`) → gear icon →
**Install Add-on From File** → pick the signed `.xpi` → **Add**.

Firefox checks `update_url` roughly once a day; to force it, use *Check for
Updates* in the add-on's context menu. Never change the add-on `id` or
`update_url` in the manifest: installed copies keep using the values they were
installed with, so a change silently breaks updates.

### Temporary install (development)

1. Open `about:debugging#/runtime/this-firefox`.
2. Click *Load Temporary Add-on…* and select `yt-playback-speed/manifest.json`.
3. Reload the YouTube tab.

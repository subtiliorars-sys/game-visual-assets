# Graphics deep-dive notes (2026-07-13)

## Why house games look “basic”

Several fleet titles (notably **Ninefold**) ship **procedural rectangles / Web Audio
stubs** instead of spritesheets. That is intentional for vertical-slice speed —
not a finished art pass.

## Existing media repos (do not conflate)

| Repo | Role |
|------|------|
| `MeniscusMaximus---Media` | Private MM brand / mascot / video |
| `Ilerioluwa-Media` | Private academy branding / match photos |
| **`game-visual-assets`** (this) | Shared free/CC0 game visuals |
| **`game-audio-assets`** | Shared free/CC0 game audio |

## Recommended art upgrade path for Ninefold

1. Copy tiles/characters from `vendor/kenney/pixel-platformer` +
   `new-platformer-pack` into `Ninefold/public/assets/`.
2. Replace drawn `Graphics` rectangles with Phaser `spritesheet` / `tilemap`.
3. Layer `game-audio-assets/vendor/kenney/ui-audio` + `rpg-audio` for UI/world.
4. Keep `original/jimmythehat` only as emergency placeholders.

## Design direction (house)

- Prefer coherent Kenney-adjacent “clean pixel” for jam speed.
- Brand accent: OmniTender / JTH orange `#F7792C` on UI chrome only.
- No Zelda asset clones — design lessons only (see Ninefold `references.md`).

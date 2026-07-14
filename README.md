# game-visual-assets

House library of **free / CC0-redistributable visual game assets** for
JimmyTheHat / subtiliorars-sys games (Ninefold, PixelSports, Cetacea, Warp Monkeys, â€¦).

> **Not** brand vaults. For product-specific brand media see
> `MeniscusMaximus---Media` and `Ilerioluwa-Media` (private, restricted).

## Whatâ€™s in here

| Path | Contents |
|------|----------|
| `vendor/kenney/` | Curated Kenney.nl packs (CC0) pulled for house use |
| `original/jimmythehat/` | Small original tiles/UI generated for house prototypes |
| `catalog/` | External free-source index (do not confuse with vendor) |
| `scripts/` | Fetch / verify helpers |

## License policy (load-bearing)

1. **Only** ship third-party art that is **CC0** or an equivalent public-domain
   dedication that **allows commercial redistribution**.
2. Keep an **ATTRIBUTION.md** row for every vendor pack even when attribution
   is optional (good manners + audit trail).
3. Never copy Zelda / PokÃ©mon / Academy (â€œGuardian of Goalâ€) / commercial
   soundtrack assets.
4. Prefer Kenney, OpenGameArt CC0 filters, and in-house procedurals.

## Quick use (Phaser / Vite)

```bash
git clone https://github.com/subtiliorars-sys/game-visual-assets.git
# copy what you need into your game's public/assets (do not npm-link whole repo)
```

Example mapping for games that look â€œtoo basicâ€ today (procedural rectangles):

| Game | Suggested vendor packs |
|------|------------------------|
| Ninefold | `vendor/kenney/pixel-platformer`, `new-platformer-pack` |
| PixelSports / Bocce / Volleyball | `vendor/kenney/sports-pack` |
| Space / Warp Monkeys | catalog â†’ Kenney space shooter / modular space (fetch later) |

## Status

Deep scrape 2026-07-13:
- **43** Kenney CC0 packs
- **40** ambientCG PBR materials (1K) under `vendor/ambientcg/`
- **25** Poly Haven textures (1K) under `vendor/polyhaven/`

See `catalog/TEXTURE_SCRAPE.md` to pull more legally. Gaps: `catalog/GAPS.md`.
Audio: game-audio-assets · 3D kits: game-3d-assets.

## Textures (go-big)

PBR / environment maps: [`game-texture-assets`](https://github.com/subtiliorars-sys/game-texture-assets) (~1585 ambientCG + 780 Poly Haven @ 1K). Release: [gobig-2026-07-13](https://github.com/subtiliorars-sys/game-texture-assets/releases/tag/gobig-2026-07-13).


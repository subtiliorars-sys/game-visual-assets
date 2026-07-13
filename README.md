# game-visual-assets

House library of **free / CC0-redistributable visual game assets** for
JimmyTheHat / subtiliorars-sys games (Ninefold, PixelSports, Cetacea, Warp Monkeys, …).

> **Not** brand vaults. For product-specific brand media see
> `MeniscusMaximus---Media` and `Ilerioluwa-Media` (private, restricted).

## What’s in here

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
3. Never copy Zelda / Pokémon / Academy (“Guardian of Goal”) / commercial
   soundtrack assets.
4. Prefer Kenney, OpenGameArt CC0 filters, and in-house procedurals.

## Quick use (Phaser / Vite)

```bash
git clone https://github.com/subtiliorars-sys/game-visual-assets.git
# copy what you need into your game's public/assets (do not npm-link whole repo)
```

Example mapping for games that look “too basic” today (procedural rectangles):

| Game | Suggested vendor packs |
|------|------------------------|
| Ninefold | `vendor/kenney/pixel-platformer`, `new-platformer-pack` |
| PixelSports / Bocce / Volleyball | `vendor/kenney/sports-pack` |
| Space / Warp Monkeys | catalog → Kenney space shooter / modular space (fetch later) |

## Status

Initial seed: 2026-07-13 — Kenney packs + original tile starter + catalog.
Audio lives in sibling repo: [`game-audio-assets`](https://github.com/subtiliorars-sys/game-audio-assets).

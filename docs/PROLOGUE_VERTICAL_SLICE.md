# Prologue vertical slice

The first playable milestone is a small pre-colonial village where the player can move, meet the Village Elder, complete one data-driven quest, read the resulting journal entry, and save the result.

## Current systems

- Reusable `Player` scene with walk/run input.
- Player-follow camera and static collision boundaries for the village.
- `Area2D` proximity interactions with reusable village NPCs.
- JSON-driven dialogue and quest content.
- Quest completion updates the persistent journal.
- Persistent save data includes a schema version, completed quests, journal entries, and settings.

## Next implementation tasks

1. Add a quest log, portraits, and dialogue choices with recorded outcomes.
2. Replace placeholder shapes with reviewed hand-painted assets.
3. Add automated regression tests for save/load and quest completion.

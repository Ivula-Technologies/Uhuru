# Prologue vertical slice

The first playable milestone is a small pre-colonial village where the player can move, meet the Village Elder, complete one data-driven quest, read the resulting journal entry, and save the result.

## Current systems

- Reusable `Player` scene with walk/run input.
- Player-follow camera and static collision boundaries for the village.
- `Area2D` proximity interactions with reusable village NPCs.
- JSON-driven dialogue and quest content.
- Quest completion updates the persistent journal.
- Quest log (`Q`), journal/codex (`J`), dialogue portraits, and saved player choices.
- Persistent save data includes a schema version, completed quests, journal entries, and settings.

## Next implementation tasks

1. Replace placeholder shapes with reviewed hand-painted assets.
2. Add automated regression tests for save/load, dialogue choices, and quest completion.

# Prologue vertical slice

The first playable milestone is a small pre-colonial village where the player can move, meet the Village Elder, complete one data-driven quest, read the resulting journal entry, and save the result.

## Current systems

- Reusable `Player` scene with walk/run input.
- Player-follow camera and static collision boundaries for the village.
- `Area2D` proximity interactions with reusable village NPCs.
- JSON-driven dialogue and quest content.
- Quest completion updates the persistent journal.
- Quest log (`Q`), journal/codex (`J`), dialogue portraits, and saved player choices.
- Opening cutscene and an exploration quest that completes after meeting four working villagers.
- Persistent inventory (`I`) and collectible objects linked to journal discoveries and an exploration quest.
- Reusable time-of-day clock and environmental tinting for dawn, day, dusk, and night.
- Data-driven NPC schedules that reposition villagers by time-of-day phase.
- Persistent save data includes a schema version, completed quests, journal entries, and settings.

## Next implementation tasks

1. Replace placeholder shapes with reviewed hand-painted assets.
2. Add Godot runtime tests for save/load, dialogue choices, and quest completion. The JSON/project-layout checks are available in `tests/validate_content.py`.

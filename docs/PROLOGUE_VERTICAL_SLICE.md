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
- Village map panel (`M`) as the basis for regional navigation.
- Persistent save data includes a schema version, completed quests, journal entries, and settings.
- A completed Prologue now presents a reflective conclusion and a clear transition to the Chapter 1 foundation.
- A pause menu, manual-save action and persisted dialogue text-size setting support accessible reading and safer play sessions.

## Next implementation tasks

1. Replace placeholder shapes with reviewed hand-painted assets.
2. Add original/licensed ambient audio and sound effects; the current audio settings system is ready for those assets.
3. Add Godot runtime tests for save/load, dialogue choices, and quest completion. The JSON/project-layout checks are available in `tests/validate_content.py`.

## Chapter 1 foundation

The first Chapter 1 playable settlement is now available after completing the Prologue. It uses a small, historically careful quest loop: listen to three community perspectives, gather market and route observations, and carry a community message to the Messenger. It is a demo foundation rather than a complete account of first encounters or the Uganda Railway.

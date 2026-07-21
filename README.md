# Uhuru: Eyes of the Land

**Uhuru: Eyes of the Land** is a Godot 4 educational narrative-adventure prototype about Kenya's history as experienced through families, work, memory and community life. The playable hackathon slice is set in the Prologue, *Kenya Before Colonial Rule*.

Rather than placing the player in the role of a famous leader, the game begins by asking them to listen: to an elder, farmer, trader, weaver and water carrier. Each person contributes knowledge that becomes part of the player's journal.

## Play the prototype

### Requirements

- Godot 4.3 or later (developed with Godot 4.7)
- Windows, Linux, or a compatible Godot editor installation

### Setup

1. Clone this repository or download it as a ZIP.
2. Open Godot Project Manager and choose **Import**.
3. Select `project.godot` in the downloaded folder.
4. Choose **Import & Edit**, wait for the first asset import, then press **F6** or the play button.
5. Choose **Begin the Prologue**.

No API key, external service, account, or sample-data setup is required.

## Controls

| Action | Keys |
| --- | --- |
| Move | WASD or arrow keys |
| Run | Shift |
| Talk / collect | E |
| Journal | J |
| Quest log | Q |
| Inventory | I |
| Village map | M |
| Manual save | F5 |
| Return to title | Esc |

Dialogue pauses player movement, the world clock and NPC schedules, so every conversation can be read at the player's own pace.

## What is implemented

- responsive title, HUD, dialogue and game panels;
- five community NPCs with branching conversations and relationship choices;
- quests, collectibles, journal/codex entries, inventory, map and local JSON saves;
- time of day, NPC schedules and an opening cutscene; and
- a Chapter 1 settlement slice where local voices discuss new visitors, trade and proposed routes; and
- data validation in `tests/validate_content.py`.

## How Codex and GPT-5.6 were used

This project was developed collaboratively in Codex Desktop with GPT-5.6. The model was used as an implementation partner to turn the design and research documents into a scoped Godot vertical slice; build the quest, NPC, dialogue, save and UI systems; organise the supplied concept boards; and refine the UI after visual feedback. The creator supplied the direction, historical focus, visual assets, review feedback and final decisions.

## Art and historical care

The supplied PNG boards are retained in `assets/source_boards/` and cropped panels support the title screen. They are concept/presentation art, not claimed as final transparent production sprites. The prototype is intentionally limited to the Prologue; later chapters require continued historical consultation and original or licensed production assets.

## Validate

Run `python tests/validate_content.py`. The current project passes its layout, quest, NPC, collectible and chapter-data checks.

## Hackathon files

- `HACKATHON_SUBMISSION.md` — pitch and feature summary.
- `DEMO_VIDEO_SCRIPT.md` — required voiceover outline.
- `SUBMIT_TODAY.md` — practical local submission checklist.

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

No API key, external service, account, or sample-data setup is required. Select **Play / Save Slots** from the title screen to continue one of three local save slots or start a fresh journey.

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

Press **Esc** during exploration to open the pause menu. It pauses the world and offers Resume, Save Game and Return to Title Screen. The title-screen settings menu also includes a persisted dialogue text-size control (80% to 150%).

## What is implemented

- responsive title, HUD, dialogue and game panels;
- five community NPCs with branching conversations and relationship choices;
- quests, collectibles, journal/codex entries, inventory, map and three local JSON save slots;
- time of day, NPC schedules and an opening cutscene; and
- a Chapter 1 settlement slice with listening, exploration and message-delivery quests about new visitors, trade and proposed routes; and
- data validation in `tests/validate_content.py`.

## How Codex and GPT-5.6 were used

This project was developed collaboratively in **Codex Desktop with GPT-5.6**. I used Codex as a practical coding partner while I remained responsible for the game's purpose, historical focus, supplied visual material, testing feedback and final decisions.

### Planning and scope

I provided the game-design document, historical research bible, technical design, production plan and asset boards. With GPT-5.6, I turned those documents into a realistic Godot vertical slice: the Prologue first, followed by a small Chapter 1 foundation, instead of claiming to complete the entire historical timeline at once.

### Building the game

Codex and GPT-5.6 helped implement and organise the Godot 4 project, including:

- the folder structure, title screen and settings;
- player movement, camera, collisions and interactions;
- reusable NPC dialogue, choices and relationship tracking;
- quests, collectibles, inventory, journal/codex, map and local save data;
- time of day and NPC schedules;
- the Prologue completion flow and the Chapter 1 listening-quest prototype; and
- the README, test checks and GitHub commits.

### Iteration from feedback

I tested the prototype in Godot and gave Codex concrete feedback when the interface clipped and conversations were difficult to read. GPT-5.6 then helped change fixed-position UI into responsive, anchored layouts; made dialogue pause player movement, time and NPC schedules; and added clearer player and villager visual markers. This was an iterative workflow: I reviewed the result, identified what was not working, and directed the changes.

### Assets and responsible use

I supplied the generated visual concept boards. Codex organised the boards within the project and used cropped branding/menu panels for presentation, while the README clearly identifies them as concept art rather than final production sprites. GPT-5.6 also helped keep the prototype's historical framing careful: it focuses on community perspectives and identifies later content as requiring continued research and consultation.

### Verification and ownership

Codex ran the project's content validation after changes and pushed the reviewed code to GitHub. AI assistance accelerated implementation and documentation, but the project's creative direction, source material, review feedback and submission decisions are mine.

## Art and historical care

The supplied PNG boards are retained in `assets/source_boards/` and cropped panels support the title screen. They are concept/presentation art, not claimed as final transparent production sprites. The prototype is intentionally limited to the Prologue; later chapters require continued historical consultation and original or licensed production assets.

## Validate

Run `python tests/validate_content.py`. The current project passes its layout, quest, NPC, collectible and chapter-data checks.

## Hackathon files

- `HACKATHON_SUBMISSION.md` — pitch and feature summary.
- `DEMO_VIDEO_SCRIPT.md` — required voiceover outline.
- `SUBMIT_TODAY.md` — practical local submission checklist.

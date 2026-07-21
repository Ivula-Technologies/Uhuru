# Uhuru: Eyes of the Land

## One-line pitch

An educational narrative adventure where players experience Kenya's history through the everyday lives of families and communities.

## Hackathon demo

This submission is a playable Godot 4 vertical slice of the Prologue, **Kenya Before Colonial Rule**. It presents a respectful, community-centred introduction rather than treating history as a list of famous people or battles.

Players can:

- explore a village with keyboard movement and a following camera;
- meet villagers through branching conversations;
- collect historical discoveries and unlock journal knowledge;
- complete main and side quests;
- manage a small inventory and view the journal, map and quest log;
- save and restore progress; and
- preview the Chapter 1 transition.

## Controls

| Action | Key |
| --- | --- |
| Move | WASD or arrow keys |
| Run | Shift |
| Interact | E |
| Journal | J |
| Quests | Q |
| Inventory | I |
| Map | M |
| Manual save | F5 |

## Run locally

1. Open Godot 4 Project Manager.
2. Select **Import** and choose `project.godot` from this folder.
3. Select **Import & Edit**, then press **F6** or the play button.
4. Choose **Begin the Prologue** on the branded title screen.

## Technology

- Godot 4.7 / GDScript
- Desktop-friendly 1280 x 720 layout using Godot's Compatibility renderer
- Data-driven quests, NPCs, collectibles and chapter definitions in `data/`
- Lightweight local JSON save data, suitable for a low-spec laptop

## Art and historical care

The supplied visual boards are preserved under `assets/reference/` and their cropped logo/menu panels are used by the title screen. These boards are concept and presentation art, not claimed as final production sprites. The game design keeps the Mau Mau and colonial-era material outside this prototype and frames future chapters around community impact, historical grounding and respectful research.

## Scope after the hackathon

The next production step is to replace prototype shapes with licensed or purpose-created transparent sprites, then expand through Chapter 1 while validating historical material with Kenyan historians, educators and community reviewers.

"""Lightweight regression checks for game content that run without Godot."""

from __future__ import annotations

import json
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def load_json(relative_path: str) -> dict:
    with (ROOT / relative_path).open(encoding="utf-8") as source:
        return json.load(source)


def check_project_layout() -> None:
    required_files = [
        "project.godot",
        "scenes/menus/TitleScreen.tscn",
        "scenes/world/PrologueVillage.tscn",
        "scenes/player/Player.tscn",
        "scripts/save/save_game.gd",
        "scripts/quests/quest_manager.gd",
        "scripts/inventory/inventory_manager.gd",
        "scripts/systems/time_of_day.gd",
        "scripts/ui/dialogue_panel.gd",
        "scripts/npc/village_npc.gd",
        "scripts/world/collectible.gd",
    ]
    missing = [path for path in required_files if not (ROOT / path).is_file()]
    assert not missing, f"Missing required project files: {', '.join(missing)}"


def check_quest_data() -> None:
    quests = load_json("data/quests/prologue.json").get("quests", {})
    assert quests, "At least one quest is required."
    for quest_id, quest in quests.items():
        assert quest.get("title"), f"{quest_id} needs a title."
        assert quest.get("objectives"), f"{quest_id} needs an objective."
        assert quest.get("journal_entry"), f"{quest_id} needs a journal entry."


def check_npc_data() -> None:
    npcs = load_json("data/npcs/prologue.json").get("npcs", [])
    assert len(npcs) >= 4, "The Prologue needs at least four NPC profiles."
    npc_ids = [npc.get("id") for npc in npcs]
    assert len(npc_ids) == len(set(npc_ids)), "NPC IDs must be unique."
    choice_ids: list[str] = []
    for npc in npcs:
        assert npc.get("display_name"), "Every NPC needs a display name."
        assert len(npc.get("position", [])) == 2, f"{npc['id']} needs a 2D position."
        dialogue = npc.get("dialogue", {})
        assert dialogue.get("text"), f"{npc['id']} needs dialogue text."
        for choice in dialogue.get("choices", []):
            assert choice.get("id") and choice.get("text"), f"{npc['id']} has an invalid choice."
            choice_ids.append(choice["id"])
        schedule = npc.get("schedule", {})
        for phase, position in schedule.items():
            assert phase in {"dawn", "day", "dusk", "night"}, f"{npc['id']} has an invalid phase."
            assert len(position) == 2, f"{npc['id']} has an invalid {phase} schedule position."
    assert len(choice_ids) == len(set(choice_ids)), "Dialogue choice IDs must be unique."


def check_collectible_data() -> None:
    collectibles = load_json("data/collectibles/prologue.json").get("collectibles", [])
    assert len(collectibles) >= 3, "The Prologue needs at least three collectibles."
    item_ids = [item.get("id") for item in collectibles]
    assert len(item_ids) == len(set(item_ids)), "Collectible IDs must be unique."
    for item in collectibles:
        assert item.get("display_name"), "Every collectible needs a display name."
        assert len(item.get("position", [])) == 2, f"{item['id']} needs a 2D position."
        assert item.get("journal_entry"), f"{item['id']} needs a journal entry."


def main() -> int:
    checks = [check_project_layout, check_quest_data, check_npc_data, check_collectible_data]
    for check in checks:
        check()
        print(f"PASS {check.__name__}")
    return 0


if __name__ == "__main__":
    sys.exit(main())

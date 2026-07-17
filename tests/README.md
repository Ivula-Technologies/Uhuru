# Tests

Run the content regression checks without Godot:

```powershell
python tests/validate_content.py
```

The checks validate required scene/system files, quest data, NPC profiles, and unique dialogue-choice IDs. Add Godot scene tests for save migration, quest state, and UI behavior when Godot is installed in the development environment.

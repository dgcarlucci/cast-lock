# Cast-Lock

A magical idle-clicker adventure built with Godot 4.3+. Cast spells, research ancient equipment, and progress your wizard through infinite levels of magical mastery.

## 🧙 Features

- **Dynamic Wizard Customization**: Deep equipment system with Chest, Legs, Head, and Accessory slots.
- **Progressive Research**: Unlock tiers of powerful gear from Apprentice to Infinite sets.
- **Spell Mastery**: Train and rank up your spells to increase their power.
- **Adaptive Scaling**: Enemies grow stronger as you level up, ensuring a constant challenge.
- **Idle & Active Play**: Toggle between active typing/clicking and passive auto-attacks.

## 🚀 Getting Started

### Prerequisites
- [Godot Engine 4.3+](https://godotengine.org/download)

### Development
1. Clone the repository.
2. Open Godot Engine and click **Import**.
3. Navigate to the project folder and select `project.godot`.
4. Press **F5** to run the game.

## 📦 How to Build (Export)

To create a playable `.exe` for Windows:

1. **Download Templates**: Go to `Editor -> Manage Export Templates` and ensure the Windows Desktop templates are installed.
2. **Setup Preset**:
   - Go to `Project -> Export...`.
   - Click **Add...** and select **Windows Desktop**.
3. **Export**:
   - Click **Export Project...** at the bottom.
   - Choose a target folder (e.g., `/export/`).
   - Name your file (e.g., `Cast-Lock.exe`).

**Note**: Godot will generate two files: `Cast-Lock.exe` and `Cast-Lock.pck`. **Both files must stay in the same folder to run the game.**

## 🛠️ Project Structure

- `scenes/`: Godot scenes (.tscn) for UI, Player, and Enemies.
- `scripts/`: GDScript logic for game systems and managers.
- `resources/`: SVG assets, themes, and data resources.
- `project.godot`: Main engine configuration.

## 📜 License

This project is for personal use and development. Assets and code are property of the project owner.

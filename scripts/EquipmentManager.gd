extends Node

var categories = {
	"main_hand": {
		"name": "Staves & Wands",
		"items": [
			{"id": "wand_basic", "name": "Apprentice Wand", "cost": 50, "power_boost": 2, "texture": "res://resources/player/appearance/wand_basic.svg", "tier": 1},
			{"id": "staff_basic", "name": "Oak Staff", "cost": 150, "power_boost": 5, "texture": "res://resources/player/appearance/staff_basic.svg", "tier": 2},
			{"id": "staff_arcane", "name": "Crystal Staff", "cost": 500, "power_boost": 12, "texture": "res://resources/player/appearance/staff_arcane.svg", "tier": 3}
		]
	},
	"head": {
		"name": "Wizard Hats",
		"items": [
			{"id": "hat_basic", "name": "Pointy Hat", "cost": 30, "haste_boost": 0.05, "texture": "res://resources/player/appearance/hat_basic.svg", "tier": 1},
			{"id": "hat_apprentice", "name": "Apprentice Hood", "cost": 100, "haste_boost": 0.1, "texture": "res://resources/player/appearance/hat_apprentice.svg", "tier": 2}
		]
	}
}

func get_item_data(category: String, index: int):
	if categories.has(category) and index < categories[category]["items"].size():
		return categories[category]["items"][index]
	return null

func get_next_research_cost(category: String, current_tier: int) -> int:
	var next_idx = current_tier
	var data = get_item_data(category, next_idx)
	return data["cost"] if data else -1

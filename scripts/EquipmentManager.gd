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
	},
	"body": {
		"name": "Magical Robes",
		"items": [
			{"id": "robe_basic", "name": "Apprentice Robe", "cost": 40, "haste_boost": 0.02, "texture": "res://resources/player/appearance/robe_basic.svg", "tier": 1},
			{"id": "robe_expert", "name": "Scholar's Robe", "cost": 200, "power_boost": 4, "texture": "res://resources/player/appearance/robe_basic.svg", "tier": 2}
		]
	}
}

func get_item_data(category: String, index: int):
	var cat = categories.get(category)
	if cat:
		var items = cat.get("items", [])
		if index >= 0 and index < items.size():
			return items[index]
	return null

func get_category_items(category: String) -> Array:
	var cat = categories.get(category)
	return cat.get("items", []) if cat else []

func get_next_research_cost(category: String, current_tier: int) -> int:
	var data = get_item_data(category, current_tier)
	if data:
		return data.get("cost", -1)
	return -1

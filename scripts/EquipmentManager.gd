extends Node

var categories = {
	"main_hand": {
		"name": "Staves & Wands",
		"items": [
			{"id": "wand_basic", "name": "Apprentice Wand", "cost": 50, "power_boost": 2, "texture": "res://resources/player/appearance/wand_basic.svg", "tier": 1},
			{"id": "staff_basic", "name": "Oak Staff", "cost": 150, "power_boost": 5, "texture": "res://resources/player/appearance/staff_basic.svg", "tier": 2},
			{"id": "wand_willow", "name": "Willow Wand", "cost": 350, "power_boost": 10, "texture": "res://resources/player/appearance/wand_willow.svg", "tier": 3},
			{"id": "staff_arcane", "name": "Crystal Staff", "cost": 800, "power_boost": 25, "texture": "res://resources/player/appearance/staff_arcane.svg", "tier": 4},
			{"id": "staff_dragon", "name": "Dragonbone Staff", "cost": 2500, "power_boost": 60, "texture": "res://resources/player/appearance/staff_dragon.svg", "tier": 5}
		]
	},
	"head": {
		"name": "Wizard Hats",
		"items": [
			{"id": "hat_basic", "name": "Pointy Hat", "cost": 30, "haste_boost": 0.05, "texture": "res://resources/player/appearance/hat_basic.svg", "tier": 1},
			{"id": "hat_apprentice", "name": "Apprentice Hood", "cost": 120, "haste_boost": 0.1, "texture": "res://resources/player/appearance/hat_apprentice.svg", "tier": 2},
			{"id": "hat_scholar", "name": "Scholar Cap", "cost": 400, "haste_boost": 0.2, "texture": "res://resources/player/appearance/hat_scholar.svg", "tier": 3},
			{"id": "hat_sage", "name": "Sage Crown", "cost": 1200, "haste_boost": 0.4, "texture": "res://resources/player/appearance/hat_sage.svg", "tier": 4},
			{"id": "hat_archmage", "name": "Archmage Hat", "cost": 5000, "haste_boost": 0.8, "texture": "res://resources/player/appearance/hat_archmage.svg", "tier": 5}
		]
	},
	"body": {
		"name": "Magical Robes",
		"items": [
			{"id": "robe_basic", "name": "Apprentice Robe", "cost": 40, "haste_boost": 0.02, "texture": "res://resources/player/appearance/robe_basic.svg", "tier": 1},
			{"id": "robe_scholar", "name": "Scholar's Robe", "cost": 250, "power_boost": 4, "texture": "res://resources/player/appearance/robe_scholar.svg", "tier": 2},
			{"id": "robe_sage", "name": "Sage's Vestment", "cost": 900, "power_boost": 15, "texture": "res://resources/player/appearance/robe_sage.svg", "tier": 3},
			{"id": "robe_archmage", "name": "Archmage Gown", "cost": 3000, "power_boost": 40, "texture": "res://resources/player/appearance/robe_archmage.svg", "tier": 4}
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

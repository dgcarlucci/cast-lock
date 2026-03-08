extends Node

var categories = {
	"main_hand": {
		"name": "Staves & Wands",
		"items": [
			{"id": "wand_apprentice", "name": "Apprentice Wand", "cost": 50, "power_boost": 2, "texture": "res://resources/player/appearance/wand_apprentice.svg", "tier": 1},
			{"id": "staff_oak", "name": "Oak Staff", "cost": 150, "power_boost": 5, "texture": "res://resources/player/appearance/staff_oak.svg", "tier": 2},
			{"id": "wand_willow", "name": "Willow Wand", "cost": 350, "power_boost": 10, "texture": "res://resources/player/appearance/wand_willow.svg", "tier": 3},
			{"id": "staff_arcane", "name": "Crystal Staff", "cost": 800, "power_boost": 25, "texture": "res://resources/player/appearance/staff_arcane.svg", "tier": 4},
			{"id": "wand_ebony", "name": "Ebony Wand", "cost": 1500, "power_boost": 45, "texture": "res://resources/player/appearance/wand_ebony.svg", "tier": 5},
			{"id": "staff_dragon", "name": "Dragonbone Staff", "cost": 3000, "power_boost": 80, "texture": "res://resources/player/appearance/staff_dragon.svg", "tier": 6},
			{"id": "wand_phoenix", "name": "Phoenix Wand", "cost": 6000, "power_boost": 150, "texture": "res://resources/player/appearance/wand_phoenix.svg", "tier": 7},
			{"id": "staff_void", "name": "Void Staff", "cost": 12000, "power_boost": 300, "texture": "res://resources/player/appearance/staff_void.svg", "tier": 8},
			{"id": "wand_celestial", "name": "Celestial Wand", "cost": 25000, "power_boost": 600, "texture": "res://resources/player/appearance/wand_celestial.svg", "tier": 9},
			{"id": "staff_godly", "name": "Godshaper Staff", "cost": 60000, "power_boost": 1500, "texture": "res://resources/player/appearance/staff_godly.svg", "tier": 10}
		]
	},
	"head": {
		"name": "Wizard Hats",
		"items": [
			{"id": "hat_apprentice", "name": "Apprentice Hat", "cost": 30, "haste_boost": 0.05, "texture": "res://resources/player/appearance/hat_apprentice.svg", "tier": 1},
			{"id": "hat_scholar", "name": "Scholar's Hood", "cost": 120, "haste_boost": 0.1, "texture": "res://resources/player/appearance/hat_scholar.svg", "tier": 2},
			{"id": "hat_scholar_cap", "name": "Scholar Cap", "cost": 400, "haste_boost": 0.15, "texture": "res://resources/player/appearance/hat_scholar.svg", "tier": 3},
			{"id": "hat_sage", "name": "Sage Crown", "cost": 1000, "haste_boost": 0.2, "texture": "res://resources/player/appearance/hat_sage.svg", "tier": 4},
			{"id": "hat_archmage", "name": "Archmage Hat", "cost": 2500, "haste_boost": 0.3, "texture": "res://resources/player/appearance/hat_archmage.svg", "tier": 5},
			{"id": "hat_warlock", "name": "Warlock Horns", "cost": 6000, "haste_boost": 0.4, "texture": "res://resources/player/appearance/hat_warlock.svg", "tier": 6},
			{"id": "hat_druid", "name": "Druid Antlers", "cost": 12000, "haste_boost": 0.5, "texture": "res://resources/player/appearance/hat_druid.svg", "tier": 7},
			{"id": "hat_necromancer", "name": "Death Hood", "cost": 25000, "haste_boost": 0.7, "texture": "res://resources/player/appearance/hat_necromancer.svg", "tier": 8},
			{"id": "hat_cosmic", "name": "Nebula Crown", "cost": 50000, "haste_boost": 1.0, "texture": "res://resources/player/appearance/hat_cosmic.svg", "tier": 9},
			{"id": "hat_infinite", "name": "Infinite Halo", "cost": 120000, "haste_boost": 1.5, "texture": "res://resources/player/appearance/hat_infinite.svg", "tier": 10}
		]
	},
	"chest": {
		"name": "Chest Pieces",
		"items": [
			{"id": "chest_apprentice", "name": "Apprentice Robe", "cost": 40, "haste_boost": 0.02, "texture": "res://resources/player/appearance/robe_apprentice.svg", "tier": 1},
			{"id": "chest_scholar", "name": "Scholar's Robe", "cost": 250, "power_boost": 4, "texture": "res://resources/player/appearance/robe_scholar.svg", "tier": 2},
			{"id": "chest_sage", "name": "Sage's Vestment", "cost": 900, "power_boost": 15, "texture": "res://resources/player/appearance/robe_sage.svg", "tier": 3},
			{"id": "chest_archmage", "name": "Archmage Gown", "cost": 3000, "power_boost": 40, "texture": "res://resources/player/appearance/robe_archmage.svg", "tier": 4},
			{"id": "chest_warlock", "name": "Demonic Tunic", "cost": 7500, "power_boost": 100, "texture": "res://resources/player/appearance/robe_warlock.svg", "tier": 5},
			{"id": "chest_druid", "name": "Nature's Embrace", "cost": 15000, "power_boost": 250, "texture": "res://resources/player/appearance/robe_druid.svg", "tier": 6},
			{"id": "chest_necromancer", "name": "Bone Mail", "cost": 30000, "power_boost": 600, "texture": "res://resources/player/appearance/robe_necromancer.svg", "tier": 7},
			{"id": "chest_cosmic", "name": "Starry Cloak", "cost": 65000, "power_boost": 1200, "texture": "res://resources/player/appearance/robe_cosmic.svg", "tier": 8},
			{"id": "chest_infinite", "name": "Eternal Robe", "cost": 150000, "power_boost": 3000, "texture": "res://resources/player/appearance/robe_infinite.svg", "tier": 9}
		]
	},
	"legs": {
		"name": "Legwear",
		"items": [
			{"id": "legs_apprentice", "name": "Apprentice Legs", "cost": 25, "haste_boost": 0.01, "texture": "res://resources/player/appearance/legs_apprentice.svg", "tier": 1}
		]
	},
	"accessories": {
		"name": "Waist Accessories",
		"items": [
			{"id": "acc_apprentice", "name": "Apprentice Tome", "cost": 60, "power_boost": 3, "texture": "res://resources/player/appearance/acc_apprentice.svg", "tier": 1},
			{"id": "acc_pouch", "name": "Potion Pouch", "cost": 200, "haste_boost": 0.08, "texture": "res://resources/player/appearance/acc_pouch.svg", "tier": 2},
			{"id": "acc_bag", "name": "Reagent Bag", "cost": 750, "power_boost": 10, "texture": "res://resources/player/appearance/acc_bag.svg", "tier": 3},
			{"id": "acc_sword", "name": "Ceremonial Blade", "cost": 2000, "power_boost": 30, "texture": "res://resources/player/appearance/acc_sword.svg", "tier": 4},
			{"id": "acc_skull", "name": "Shrunken Skull", "cost": 5000, "power_boost": 75, "texture": "res://resources/player/appearance/acc_skull.svg", "tier": 5},
			{"id": "acc_lantern", "name": "Soul Lantern", "cost": 12000, "haste_boost": 0.25, "texture": "res://resources/player/appearance/acc_lantern.svg", "tier": 6},
			{"id": "acc_orb", "name": "Miniature Orb", "cost": 28000, "power_boost": 200, "texture": "res://resources/player/appearance/acc_orb.svg", "tier": 7},
			{"id": "acc_scroll", "name": "Elder Scroll", "cost": 60000, "power_boost": 500, "texture": "res://resources/player/appearance/acc_scroll.svg", "tier": 8},
			{"id": "acc_crystal", "name": "Floating Shard", "cost": 140000, "power_boost": 1500, "texture": "res://resources/player/appearance/acc_crystal.svg", "tier": 9}
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

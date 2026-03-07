extends Node

# Spell metadata
var spells = {
	"magic_missile": {
		"name": "Magic Missile",
		"upgrade_name": "Arcane Blast",
		"icon": "res://resources/player/appearance/magic_missile.svg",
		"description": "Standard purple bolts of energy.",
		"cost_per_rank": 15
	},
	"fireball": {
		"name": "Fireball",
		"upgrade_name": "Fire Blast",
		"icon": "res://resources/player/appearance/fireball.svg",
		"description": "Explosive heat and flame.",
		"cost_per_rank": 25
	}
}

func get_spell_name(id: String, rank: int) -> String:
	if rank >= 10:
		return spells[id]["upgrade_name"]
	return spells[id]["name"]

func get_training_cost(id: String, current_rank: int) -> int:
	return spells[id]["cost_per_rank"] * current_rank

func get_spell_visual_path(id: String) -> String:
	return spells[id]["icon"]

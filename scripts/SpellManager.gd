extends Node

# Spell metadata
var spells = {
	"magic_missile": {
		"name": "Magic Missile",
		"icon": "res://resources/player/appearance/magic_missile.svg",
		"description": "Standard purple bolts of energy.",
		"cost_per_rank": 15,
		"required_spell": "",
		"required_rank": 0,
		"evolves_to": "arcane_blast"
	},
	"arcane_blast": {
		"name": "Arcane Blast",
		"icon": "res://resources/player/appearance/arcane_blast.svg",
		"description": "A massive surge of pure arcane power.",
		"cost_per_rank": 100,
		"required_spell": "magic_missile",
		"required_rank": 10
	},
	"fireball": {
		"name": "Fireball",
		"icon": "res://resources/player/appearance/fireball.svg",
		"description": "Explosive heat and flame.",
		"cost_per_rank": 25,
		"required_spell": "magic_missile",
		"required_rank": 5,
		"evolves_to": "fire_blast"
	},
	"fire_blast": {
		"name": "Fire Blast",
		"icon": "res://resources/player/appearance/fire_blast.svg",
		"description": "Incinerate everything in a wide area.",
		"cost_per_rank": 150,
		"required_spell": "fireball",
		"required_rank": 10
	}
}

func is_spell_unlocked(id: String, learned_dict: Dictionary) -> bool:
	if id == "magic_missile": return true
	if learned_dict.has(id): return true
	
	var spell_cfg = spells.get(id)
	if not spell_cfg: return false
	
	var req = spell_cfg.get("required_spell", "")
	var rank_req = spell_cfg.get("required_rank", 0)
	
	if req != "" and learned_dict.has(req):
		var req_data = learned_dict.get(req)
		if req_data and req_data is Dictionary:
			return req_data.get("rank", 0) >= rank_req
	return false

func get_spell_name(id: String, rank: int) -> String:
	var cfg = spells.get(id)
	return cfg.get("name", "Unknown") if cfg else "Unknown"

func get_training_cost(id: String, current_rank: int) -> int:
	var cfg = spells.get(id)
	if cfg:
		return cfg.get("cost_per_rank", 10) * current_rank
	return 0

func get_spell_visual_path(id: String) -> String:
	var cfg = spells.get(id)
	return cfg.get("icon", "") if cfg else ""

func gain_mastery(id: String, amount: int, stats: WizardStats):
	if not stats or not stats.learned_spells: return
	if not stats.learned_spells.has(id): return
	
	var data = stats.learned_spells.get(id)
	if data and data is Dictionary:
		data["mastery"] = data.get("mastery", 0) + amount
		
		if data["mastery"] >= 100:
			data["mastery"] = 0
			data["rank"] = data.get("rank", 1) + 1

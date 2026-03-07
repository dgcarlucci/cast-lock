extends Node

const WIZARD_STATS_PATH = "res://resources/player/data/WizardStats.tres"
var stats: WizardStats
var enemy_data: EnemyData = EnemyData.new()

func _ready():
	load_or_create_stats()

func load_or_create_stats():
	if ResourceLoader.exists(WIZARD_STATS_PATH):
		stats = load(WIZARD_STATS_PATH)
	else:
		stats = WizardStats.new()
	
	# Load from JSON save if available
	var save_data = SaveManager.load_game()
	if not save_data.is_empty():
		stats.level = save_data.get("level", stats.level)
		stats.gold = save_data.get("gold", stats.gold)
		stats.xp = save_data.get("xp", stats.xp)
		stats.attack_power = save_data.get("attack_power", stats.attack_power)
		stats.crit_chance = save_data.get("crit_chance", stats.crit_chance)
		stats.haste = save_data.get("haste", stats.haste)
		
		# Load customization
		if save_data.has("skin_color"): stats.skin_color = Color(save_data.skin_color)
		if save_data.has("robe_color"): stats.robe_color = Color(save_data.robe_color)
		if save_data.has("hat_color"): stats.hat_color = Color(save_data.hat_color)
		if save_data.has("eye_color"): stats.eye_color = Color(save_data.eye_color)
		if save_data.has("hair_color"): stats.hair_color = Color(save_data.hair_color)
		
		stats.robe_style = save_data.get("robe_style", stats.robe_style)
		stats.hat_style = save_data.get("hat_style", stats.hat_style)
		stats.hair_style = save_data.get("hair_style", stats.hair_style)
		stats.beard_style = save_data.get("beard_style", stats.beard_style)
		
		stats.active_spell_id = save_data.get("active_spell_id", stats.active_spell_id)
		stats.learned_spells = save_data.get("learned_spells", stats.learned_spells)
		stats.spell_mastery_xp = save_data.get("spell_mastery_xp", stats.spell_mastery_xp)
		stats.unlocked_tiers = save_data.get("unlocked_tiers", stats.unlocked_tiers)
		stats.total_casts = save_data.get("total_casts", stats.total_casts)

func save_stats():
	SaveManager.save_game(stats)

func get_enemy_hp() -> float:
	return enemy_data.get_hp_for_level(stats.level)

func get_gold_reward() -> float:
	return enemy_data.get_gold_for_level(stats.level)

func add_xp(amount: int):
	stats.xp += amount
	if stats.xp >= get_xp_needed():
		level_up()
	save_stats()

func get_xp_needed() -> int:
	return int(100 * pow(1.2, stats.level - 1))

func level_up():
	stats.level += 1
	stats.xp = 0
	stats.attack_power *= 1.1
	print("LEVEL UP! Current Level: ", stats.level)
	save_stats()

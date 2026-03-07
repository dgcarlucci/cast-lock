extends Node2D

@onready var wizard = $Wizard
@onready var ui = $UI_Overlay
@onready var enemy = $Enemy
@onready var attack_timer = $AttackTimer

var current_enemy_hp: float = 0.0
var max_enemy_hp: float = 0.0

var enemy_textures = [
	preload("res://resources/enemies/slime_sprite.svg"),
	preload("res://resources/enemies/bat_sprite.svg"),
	preload("res://resources/enemies/ghost_sprite.svg"),
	preload("res://resources/enemies/fire_elemental.svg"),
	preload("res://resources/enemies/ice_elemental.svg"),
	preload("res://resources/enemies/rock_golem.svg"),
	preload("res://resources/enemies/skeleton.svg"),
	preload("res://resources/enemies/zombie.svg"),
	preload("res://resources/enemies/vampire_bat.svg"),
	preload("res://resources/enemies/forest_spider.svg"),
	preload("res://resources/enemies/angry_mushroom.svg"),
	preload("res://resources/enemies/treant_sapling.svg"),
	preload("res://resources/enemies/imp.svg"),
	preload("res://resources/enemies/hellhound.svg"),
	preload("res://resources/enemies/mimic.svg"),
	preload("res://resources/enemies/beholder_eye.svg"),
	preload("res://resources/enemies/wraith.svg"),
	preload("res://resources/enemies/orc_grunt.svg"),
	preload("res://resources/enemies/goblin_thief.svg"),
	preload("res://resources/enemies/harpy.svg"),
	preload("res://resources/enemies/medusa_head.svg"),
	preload("res://resources/enemies/dragon_wyrm.svg"),
	preload("res://resources/enemies/manticore_cub.svg"),
	preload("res://resources/enemies/crab_monstrosity.svg"),
	preload("res://resources/enemies/cactus_thug.svg"),
	preload("res://resources/enemies/sand_worm.svg"),
	preload("res://resources/enemies/yeti_scout.svg"),
	preload("res://resources/enemies/dark_knight.svg")
]

var last_input_cast_time: float = 0.0
var input_cast_cooldown: float = 0.1

func _ready():
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, true)
	get_viewport().transparent_bg = true
	
	ui.appearance_changed.connect(_on_wizard_appearance_changed)
	
	spawn_enemy()
	refresh_companion_mode()

func refresh_companion_mode():
	var stats = StatsManager.stats
	if stats.companion_mode_typing:
		attack_timer.stop()
	else:
		start_combat()

func _input(event):
	if not StatsManager.stats.companion_mode_typing:
		return
		
	if event is InputEventKey or event is InputEventMouseButton:
		if event.is_pressed():
			var now = Time.get_ticks_msec() / 1000.0
			if now - last_input_cast_time >= input_cast_cooldown:
				last_input_cast_time = now
				attack()

func _on_wizard_appearance_changed():
	wizard.update_appearance(StatsManager.stats)
	StatsManager.save_stats()
	# Check if mode changed
	refresh_companion_mode()

func spawn_enemy():
	max_enemy_hp = StatsManager.get_enemy_hp()
	current_enemy_hp = max_enemy_hp
	ui.update_enemy_health(current_enemy_hp, max_enemy_hp)
	var tex = enemy_textures[randi() % enemy_textures.size()]
	enemy.set_texture(tex)

func start_combat():
	if StatsManager.stats.companion_mode_typing: return
	attack_timer.wait_time = 1.5 / StatsManager.stats.haste
	attack_timer.start()

func _on_attack_timer_timeout():
	attack()

func attack():
	if wizard.current_state != wizard.State.IDLE or current_enemy_hp <= 0:
		return
		
	wizard.play_cast_animation(func():
		var damage = StatsManager.stats.attack_power
		var is_crit = randf() < StatsManager.stats.crit_chance
		if is_crit:
			damage *= 2.0
			ui.show_floating_text("CRIT!", Color.YELLOW)
		else:
			ui.show_floating_text(str(int(damage)), Color.WHITE)
			
		current_enemy_hp -= damage
		ui.update_enemy_health(current_enemy_hp, max_enemy_hp)
		enemy.play_hit_animation()
		
		SpellManager.gain_mastery(StatsManager.stats.active_spell_id, 5, StatsManager.stats)
		StatsManager.stats.total_casts += 1
		ui.update_stats()
		
		if current_enemy_hp <= 0:
			on_enemy_death()
	)

func on_enemy_death():
	attack_timer.stop()
	enemy.play_death_animation(func():
		var gold = StatsManager.get_gold_reward()
		StatsManager.stats.gold += int(gold)
		StatsManager.add_xp(20)
		ui.update_stats()
		spawn_enemy()
		refresh_companion_mode()
	)

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

func _ready():
	# Explicitly set window background to transparent in DisplayServer (Godot 4)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, true)
	get_viewport().transparent_bg = true
	
	ui.craft_pressed.connect(_on_ui_craft_pressed)
	ui.appearance_changed.connect(_on_wizard_appearance_changed)
	
	spawn_enemy()
	start_combat()

func _on_wizard_appearance_changed():
	wizard.update_appearance(StatsManager.stats)
	StatsManager.save_stats()

func _on_ui_craft_pressed():
	var cost = 10
	if StatsManager.stats.gold >= cost:
		StatsManager.stats.gold -= cost
		ui.update_stats()
		
		var roll = randf()
		if roll < 0.05:
			# Lionheart!
			StatsManager.stats.attack_power *= 2.0
			StatsManager.stats.haste += 0.1
			ui.add_loot_entry("Lionheart Crafted! x2 AP, +0.1 Haste")
			ui.show_floating_text("LIONHEART!", Color.GOLD)
			# Update timer if haste changed
			attack_timer.wait_time = 1.5 / StatsManager.stats.haste
		else:
			ui.add_loot_entry("Iron Dagger (Junk)")
		
		StatsManager.save_stats()
	else:
		ui.show_floating_text("NOT ENOUGH GOLD!", Color.RED)

func spawn_enemy():
	max_enemy_hp = StatsManager.get_enemy_hp()
	current_enemy_hp = max_enemy_hp
	ui.update_enemy_health(current_enemy_hp, max_enemy_hp)
	
	# Random texture
	var tex = enemy_textures[randi() % enemy_textures.size()]
	enemy.set_texture(tex)

func start_combat():
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
		
		# Gain spell mastery
		SpellManager.gain_mastery(StatsManager.stats.active_spell_id, 5, StatsManager.stats)
		ui.update_stats() # Update UI to show progress
		
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
		start_combat()
	)

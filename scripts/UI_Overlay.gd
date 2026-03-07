extends Control

signal craft_pressed
signal appearance_changed

@onready var gold_label = $TopBar/GoldLabel
@onready var level_label = $TopBar/LevelLabel
@onready var xp_bar = $TopBar/XPBar
@onready var enemy_health_bar = $PlaterBar
@onready var floating_text_container = $FloatingTextContainer

@onready var customization_panel = $Overlays/CustomizationPanel
@onready var stats_panel = $Overlays/StatsPanel
@onready var settings_panel = $Overlays/SettingsPanel
@onready var crafting_panel = $Overlays/CraftingPanel
@onready var loot_log_label = $Overlays/CraftingPanel/VBox/LootLogLabel
@onready var stats_label = $Overlays/StatsPanel/VBox/Scroll/StatsLabel

var loot_log: Array = []

func _ready():
	update_stats()

func _on_craft_button_pressed():
	craft_pressed.emit()

func _on_customize_button_pressed():
	_close_all_panels()
	customization_panel.visible = true

func _on_stats_button_pressed():
	_close_all_panels()
	update_stats()
	stats_panel.visible = true

func _on_settings_button_pressed():
	_close_all_panels()
	settings_panel.visible = true

func _on_close_button_pressed():
	_close_all_panels()

func _on_save_button_pressed():
	StatsManager.save_stats()
	show_floating_text("GAME SAVED", Color.GREEN)

func _close_all_panels():
	customization_panel.visible = false
	stats_panel.visible = false
	settings_panel.visible = false

func _on_randomize_button_pressed():
	var stats = StatsManager.stats
	stats.robe_color = Color(randf(), randf(), randf())
	stats.hat_color = stats.robe_color
	stats.skin_color = Color(0.8 + randf() * 0.2, 0.6 + randf() * 0.2, 0.5 + randf() * 0.2)
	stats.hair_color = Color(randf(), randf(), randf())
	appearance_changed.emit()

func _on_beard_toggle_pressed():
	var stats = StatsManager.stats
	stats.beard_style = 1 if stats.beard_style == 0 else 0
	appearance_changed.emit()

func _on_hair_toggle_pressed():
	var stats = StatsManager.stats
	stats.hair_style = 1 if stats.hair_style == 0 else 0
	appearance_changed.emit()

func update_stats():
	var stats = StatsManager.stats
	gold_label.text = "GOLD: " + str(int(stats.gold))
	level_label.text = "LVL: " + str(stats.level)
	
	xp_bar.max_value = StatsManager.get_xp_needed()
	xp_bar.value = stats.xp
	
	stats_label.text = "Level: %d\n" % stats.level
	stats_label.text += "Attack Power: %.1f\n" % stats.attack_power
	stats_label.text += "Crit Chance: %.1f%%\n" % (stats.crit_chance * 100.0)
	stats_label.text += "Haste: %.2f\n" % stats.haste
	stats_label.text += "Gold: %d" % int(stats.gold)

func update_enemy_health(current, max_hp):
	enemy_health_bar.max_value = max_hp
	enemy_health_bar.value = current

func add_loot_entry(entry_text):
	crafting_panel.visible = true
	loot_log.push_front(entry_text)
	if loot_log.size() > 8:
		loot_log.pop_back()
	
	var log_text = ""
	for entry in loot_log:
		log_text += "- " + entry + "\n"
	loot_log_label.text = log_text

func show_floating_text(text, color):
	var label = Label.new()
	label.text = text
	label.add_theme_color_override("font_color", color)
	label.add_theme_font_size_override("font_size", 10)
	floating_text_container.add_child(label)
	
	var tween = get_tree().create_tween()
	tween.tween_property(label, "position", label.position + Vector2(0, -40), 1.0)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 1.0)
	tween.tween_callback(label.queue_free)

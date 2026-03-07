extends Control

signal craft_pressed
signal appearance_changed

@onready var gold_label = $TopBar/GoldLabel
@onready var level_label = $TopBar/LevelLabel
@onready var xp_bar = $TopBar/XPBar
@onready var enemy_health_bar = $PlaterBar
@onready var floating_text_container = $FloatingTextContainer

@onready var grimoire = $Grimoire
@onready var tab_container = $Grimoire/TabContainer
@onready var stats_label = $Grimoire/TabContainer/Stats/LeftPage/VBox/StatsLabel
@onready var combat_label = $Grimoire/TabContainer/Stats/RightPage/VBox/Label
@onready var loot_log_label = $Grimoire/TabContainer/Workshop/RightPage/VBox/LootLogLabel
@onready var wizard_preview = $Grimoire/TabContainer/Barber/RightPage/PreviewContainer/SubViewport/WizardPreview

var loot_log: Array = []

func _ready():
	update_stats()
	grimoire.visible = false
	grimoire.scale = Vector2(0.5, 0.5)
	grimoire.modulate.a = 0

func _on_book_button_pressed():
	if grimoire.visible:
		_close_grimoire()
	else:
		_open_grimoire()

func _open_grimoire():
	update_stats()
	wizard_preview.update_appearance(StatsManager.stats)
	grimoire.visible = true
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(grimoire, "scale", Vector2(1.0, 1.0), 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(grimoire, "modulate:a", 1.0, 0.2)

func _close_grimoire():
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(grimoire, "scale", Vector2(0.8, 0.8), 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(grimoire, "modulate:a", 0.0, 0.2)
	tween.chain().tween_callback(func(): grimoire.visible = false)

func _on_nav_btn_pressed(index: int):
	tab_container.current_tab = index
	if index == 0:
		update_stats()

func _on_craft_button_pressed():
	craft_pressed.emit()

func _on_close_button_pressed():
	_close_grimoire()

func _on_save_button_pressed():
	StatsManager.save_stats()
	show_floating_text("PROGRESS SAVED", Color.GREEN)

func _on_randomize_button_pressed():
	var stats = StatsManager.stats
	stats.robe_color = Color(randf(), randf(), randf())
	stats.hat_color = stats.robe_color
	stats.skin_color = Color(0.8 + randf() * 0.2, 0.6 + randf() * 0.2, 0.5 + randf() * 0.2)
	stats.hair_color = Color(randf(), randf(), randf())
	appearance_changed.emit()
	wizard_preview.update_appearance(stats)

func _on_beard_toggle_pressed():
	var stats = StatsManager.stats
	stats.beard_style = 1 if stats.beard_style == 0 else 0
	appearance_changed.emit()
	wizard_preview.update_appearance(stats)

func _on_hair_toggle_pressed():
	var stats = StatsManager.stats
	stats.hair_style = 1 if stats.hair_style == 0 else 0
	appearance_changed.emit()
	wizard_preview.update_appearance(stats)

func update_stats():
	var stats = StatsManager.stats
	if not stats: return
	
	gold_label.text = "GOLD: " + str(int(stats.gold))
	level_label.text = "LVL: " + str(stats.level)
	
	xp_bar.max_value = StatsManager.get_xp_needed()
	xp_bar.value = stats.xp
	
	stats_label.text = "Wizard Level: %d\n" % stats.level
	stats_label.text += "Experience: %d / %d\n" % [stats.xp, StatsManager.get_xp_needed()]
	stats_label.text += "Total Gold: %d" % int(stats.gold)
	
	combat_label.text = "COMBAT SKILLS\n\n"
	combat_label.text += "Attack Power: %.1f\n" % stats.attack_power
	combat_label.text += "Crit Chance: %.1f%%\n" % (stats.crit_chance * 100.0)
	combat_label.text += "Attack Speed: %.2f" % stats.haste

func update_enemy_health(current, max_hp):
	enemy_health_bar.max_value = max_hp
	enemy_health_bar.value = current

func add_loot_entry(entry_text):
	loot_log.push_front(entry_text)
	if loot_log.size() > 10:
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
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 4)
	floating_text_container.add_child(label)
	
	var tween = get_tree().create_tween()
	tween.tween_property(label, "position", label.position + Vector2(0, -40), 1.0)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 1.0)
	tween.tween_callback(label.queue_free)

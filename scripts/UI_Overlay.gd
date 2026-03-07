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

# Spell UI
@onready var spell_title = $Grimoire/TabContainer/Spells/RightPage/VBox/SpellTitle
@onready var spell_info = $Grimoire/TabContainer/Spells/RightPage/VBox/SpellInfo
@onready var train_button = $Grimoire/TabContainer/Spells/RightPage/VBox/TrainButton
@onready var equip_button = $Grimoire/TabContainer/Spells/RightPage/VBox/EquipButton

var loot_log: Array = []
var selected_spell_id: String = "magic_missile"

func _ready():
	update_stats()
	update_spell_ui()
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
	update_spell_ui()
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
	elif index == 3: # Spells
		update_spell_ui()

func _on_craft_button_pressed():
	craft_pressed.emit()

func _on_close_button_pressed():
	_close_grimoire()

func _on_save_button_pressed():
	StatsManager.save_stats()
	show_floating_text("PROGRESS SAVED", Color.GREEN)

# Barber Shop Logic
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

# Spell Book Logic
func _on_spell_select_pressed(spell_id: String):
	selected_spell_id = spell_id
	update_spell_ui()

func _on_train_spell_pressed():
	var stats = StatsManager.stats
	if not stats.learned_spells.has(selected_spell_id):
		stats.learned_spells[selected_spell_id] = {"rank": 1, "mastery": 0}
		
	var spell_data = stats.learned_spells[selected_spell_id]
	var cost = SpellManager.get_training_cost(selected_spell_id, spell_data["rank"])
	
	if stats.gold >= cost:
		stats.gold -= cost
		spell_data["rank"] += 1
		show_floating_text("RANK UP!", Color.CYAN)
		update_stats()
		update_spell_ui()
		StatsManager.save_stats()
	else:
		show_floating_text("NOT ENOUGH GOLD!", Color.RED)

func _on_equip_spell_pressed():
	StatsManager.stats.active_spell_id = selected_spell_id
	update_spell_ui()
	show_floating_text("SPELL EQUIPPED", Color.MEDIUM_PURPLE)
	StatsManager.save_stats()

func update_spell_ui():
	var stats = StatsManager.stats
	var is_learned = stats.learned_spells.has(selected_spell_id)
	var spell_data = stats.learned_spells.get(selected_spell_id, {"rank": 1, "mastery": 0})
	
	spell_title.text = SpellManager.get_spell_name(selected_spell_id, spell_data["rank"])
	if selected_spell_id == stats.active_spell_id:
		spell_title.text += " (Equipped)"
		equip_button.disabled = true
	else:
		equip_button.disabled = false
		
	var info_text = SpellManager.spells[selected_spell_id]["description"] + "\n\n"
	info_text += "Rank: %d\n" % spell_data["rank"]
	# Mastery is placeholder for now
	info_text += "Mastery: %d / 100" % spell_data["mastery"]
	spell_info.text = info_text
	
	var train_cost = SpellManager.get_training_cost(selected_spell_id, spell_data["rank"])
	train_button.text = "TRAIN (%dG)" % train_cost

# Global Updates
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

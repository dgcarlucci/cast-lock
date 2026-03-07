extends Control

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

# Previews
@onready var wizard_preview_barber = $Grimoire/TabContainer/Barber/RightPage/PreviewContainer/SubViewport/WizardPreviewBarber
@onready var wizard_preview_armory = $Grimoire/TabContainer/Armory/RightPage/PreviewContainer/SubViewport/WizardPreviewArmory

# Spell UI
@onready var spell_list_container = $Grimoire/TabContainer/Spells/LeftPage/VBox/Scroll/SpellList
@onready var spell_title = $Grimoire/TabContainer/Spells/RightPage/VBox/SpellTitle
@onready var spell_info = $Grimoire/TabContainer/Spells/RightPage/VBox/SpellInfo
@onready var train_button = $Grimoire/TabContainer/Spells/RightPage/VBox/TrainButton
@onready var equip_button = $Grimoire/TabContainer/Spells/RightPage/VBox/EquipButton

# Workshop UI
@onready var equip_list_container = $Grimoire/TabContainer/Workshop/LeftPage/VBox/EquipmentList
@onready var item_title = $Grimoire/TabContainer/Workshop/RightPage/VBox/ItemTitle
@onready var item_preview = $Grimoire/TabContainer/Workshop/RightPage/VBox/Center/ItemPreview
@onready var item_info = $Grimoire/TabContainer/Workshop/RightPage/VBox/ItemInfo
@onready var research_button = $Grimoire/TabContainer/Workshop/RightPage/VBox/ResearchButton

# Armory UI
@onready var unlocked_items_container = $Grimoire/TabContainer/Armory/LeftPage/VBox/Scroll/UnlockedItems

# Library / Settings
@onready var reset_confirmation = $ResetConfirmation
@onready var idle_mode_check = $Grimoire/TabContainer/Library/LeftPage/VBox/IdleModeCheck

var loot_log: Array = []
var selected_spell_id: String = "magic_missile"
var selected_equip_cat: String = "main_hand"

func _ready():
	update_stats()
	update_spell_ui()
	update_workshop_ui()
	update_armory_ui()
	grimoire.visible = false
	grimoire.scale = Vector2(0.5, 0.5)
	grimoire.modulate.a = 0
	_update_mode_label()

func _on_book_button_pressed():
	if grimoire.visible: _close_grimoire()
	else: _open_grimoire()

func _open_grimoire():
	update_stats()
	update_spell_ui()
	update_workshop_ui()
	update_armory_ui()
	_update_all_previews()
	_update_mode_label()
	grimoire.visible = true
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(grimoire, "scale", Vector2(1.0, 1.0), 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(grimoire, "modulate:a", 1.0, 0.2)

func _close_grimoire():
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(grimoire, "scale", Vector2(0.8, 0.8), 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(grimoire, "modulate:a", 0.0, 0.2)
	tween.chain().tween_callback(func(): grimoire.visible = false)

func _update_all_previews():
	wizard_preview_barber.update_appearance(StatsManager.stats)
	wizard_preview_armory.update_appearance(StatsManager.stats)

func _update_mode_label():
	if idle_mode_check:
		idle_mode_check.set_pressed_no_signal(StatsManager.stats.idle_mode_enabled)

func _on_nav_btn_pressed(index: int):
	tab_container.current_tab = index
	if index == 0: update_stats()
	elif index == 1: update_workshop_ui()
	elif index == 3: update_armory_ui()
	elif index == 4: update_spell_ui()
	_update_all_previews()

func _on_close_button_pressed():
	_close_grimoire()

func _on_save_button_pressed():
	StatsManager.save_stats()
	show_floating_text("PROGRESS SAVED", Color.GREEN)

func _on_reset_button_pressed():
	reset_confirmation.popup_centered()

func _on_reset_confirmed():
	StatsManager.reset_data()
	update_stats()
	update_spell_ui()
	update_workshop_ui()
	update_armory_ui()
	_update_all_previews()
	_update_mode_label()
	appearance_changed.emit()
	show_floating_text("PROGRESS RESET", Color.RED)

func _on_idle_mode_toggled(toggled_on: bool):
	StatsManager.stats.idle_mode_enabled = toggled_on
	appearance_changed.emit()
	StatsManager.save_stats()

# --- BARBER SHOP ---
func _on_randomize_button_pressed():
	var stats = StatsManager.stats
	stats.robe_color = Color(randf(), randf(), randf())
	stats.hat_color = stats.robe_color
	stats.skin_color = Color(0.8 + randf() * 0.2, 0.6 + randf() * 0.2, 0.5 + randf() * 0.2)
	stats.hair_color = Color(randf(), randf(), randf())
	appearance_changed.emit()
	_update_all_previews()

func _on_beard_toggle_pressed():
	var stats = StatsManager.stats
	stats.beard_style = 1 if stats.beard_style == 0 else 0
	appearance_changed.emit()
	_update_all_previews()

func _on_hair_toggle_pressed():
	var stats = StatsManager.stats
	stats.hair_style = 1 if stats.hair_style == 0 else 0
	appearance_changed.emit()
	_update_all_previews()

# --- ARMORY ---
func update_armory_ui():
	for child in unlocked_items_container.get_children(): child.queue_free()
	var stats = StatsManager.stats
	for cat_id in EquipmentManager.categories.keys():
		var label = Label.new()
		label.text = EquipmentManager.categories.get(cat_id).get("name", cat_id)
		label.add_theme_font_size_override("font_size", 8)
		label.add_theme_color_override("font_color", Color.SADDLE_BROWN)
		unlocked_items_container.add_child(label)
		
		var unlocked_tier = stats.unlocked_tiers.get(cat_id, 0)
		var items = EquipmentManager.get_category_items(cat_id)
		
		# If it's a category that starts with tier 1 (like weapon), show at least one
		var display_count = unlocked_tier
		if cat_id != "accessories" and display_count == 0: display_count = 1
		
		for i in range(display_count):
			if i < items.size():
				var item = items[i]
				var btn = Button.new()
				btn.add_theme_font_size_override("font_size", 7)
				btn.text = item.get("name")
				btn.pressed.connect(_on_equip_item_pressed.bind(cat_id, item.get("tier", 1)))
				unlocked_items_container.add_child(btn)

func _on_equip_item_pressed(category: String, tier: int):
	var stats = StatsManager.stats
	if category == "main_hand": stats.main_hand_style = tier
	elif category == "head": stats.hat_style = tier
	elif category == "body": stats.robe_style = tier
	elif category == "accessories": stats.accessory_style = tier
	appearance_changed.emit()
	_update_all_previews()
	update_stats()

# --- WORKSHOP ---
func _on_equip_cat_select(cat_id: String):
	selected_equip_cat = cat_id
	update_workshop_ui()

func _on_research_button_pressed():
	var stats = StatsManager.stats
	var current_tier = stats.unlocked_tiers.get(selected_equip_cat, 0)
	var item = EquipmentManager.get_item_data(selected_equip_cat, current_tier)
	if not item: return
	
	if stats.gold >= item.get("cost", 0):
		stats.gold -= item.get("cost", 0)
		stats.unlocked_tiers[selected_equip_cat] = item.get("tier", 1)
		if selected_equip_cat == "main_hand": stats.main_hand_style = item.get("tier", 1)
		elif selected_equip_cat == "head": stats.hat_style = item.get("tier", 1)
		elif selected_equip_cat == "body": stats.robe_style = item.get("tier", 1)
		elif selected_equip_cat == "accessories": stats.accessory_style = item.get("tier", 1)
		if item.has("power_boost"): stats.attack_power += item.get("power_boost", 0)
		if item.has("haste_boost"): stats.haste += item.get("haste_boost", 0)
		show_floating_text("RESEARCH COMPLETE!", Color.GOLD)
		update_stats()
		update_workshop_ui()
		update_armory_ui()
		appearance_changed.emit()
		_update_all_previews()
		StatsManager.save_stats()
	else:
		show_floating_text("NOT ENOUGH GOLD!", Color.RED)

func update_workshop_ui():
	for child in equip_list_container.get_children(): child.queue_free()
	for cat_id in EquipmentManager.categories.keys():
		var btn = Button.new()
		btn.add_theme_font_size_override("font_size", 8)
		var cat_data = EquipmentManager.categories.get(cat_id)
		btn.text = "Research " + cat_data.get("name", cat_id) if cat_data else cat_id
		btn.pressed.connect(_on_equip_cat_select.bind(cat_id))
		equip_list_container.add_child(btn)
		
	var stats = StatsManager.stats
	var current_unlocked = stats.unlocked_tiers.get(selected_equip_cat, 0)
	var item = EquipmentManager.get_item_data(selected_equip_cat, current_unlocked)
	if item:
		item_title.text = "Blueprint: " + item.get("name", "Unknown Item")
		item_preview.texture = load(item.get("texture", ""))
		item_preview.visible = true
		var info = "Unlocks tier %d\n" % item.get("tier", 1)
		if item.has("power_boost"): info += "Stat: +%d Atk\n" % item.get("power_boost")
		if item.has("haste_boost"): info += "Stat: +%.2f Spd\n" % item.get("haste_boost")
		item_info.text = info
		research_button.text = "RESEARCH (%dG)" % item.get("cost", 0)
		research_button.disabled = false
	else:
		item_title.text = "Maximum Research"
		item_info.text = "All blueprints unlocked for this category."
		item_preview.visible = false
		research_button.text = "MAXED"
		research_button.disabled = true

# --- SPELLS ---
func _on_spell_select_pressed(spell_id: String):
	selected_spell_id = spell_id
	update_spell_ui()

func _on_train_spell_pressed():
	var stats = StatsManager.stats
	if not stats.learned_spells.has(selected_spell_id):
		stats.learned_spells[selected_spell_id] = {"rank": 1, "mastery": 0}
	var s_data = stats.learned_spells.get(selected_spell_id)
	var cost = SpellManager.get_training_cost(selected_spell_id, s_data.get("rank", 1))
	if stats.gold >= cost:
		stats.gold -= cost
		s_data["rank"] = s_data.get("rank", 1) + 1
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
	for child in spell_list_container.get_children(): child.queue_free()
	var stats = StatsManager.stats
	for s_id in SpellManager.spells.keys():
		var btn = Button.new()
		btn.add_theme_font_size_override("font_size", 8)
		if SpellManager.is_spell_unlocked(s_id, stats.learned_spells):
			var s_data = stats.learned_spells.get(s_id, {"rank":1})
			btn.text = SpellManager.get_spell_name(s_id, s_data.get("rank", 1))
			btn.pressed.connect(_on_spell_select_pressed.bind(s_id))
		else:
			btn.text = "??? (LOCKED)"
			btn.disabled = true
		spell_list_container.add_child(btn)
	
	var s_data = stats.learned_spells.get(selected_spell_id, {"rank": 1, "mastery": 0})
	spell_title.text = SpellManager.get_spell_name(selected_spell_id, s_data.get("rank", 1))
	equip_button.visible = stats.learned_spells.has(selected_spell_id)
	equip_button.disabled = (selected_spell_id == stats.active_spell_id)
	var spell_cfg = SpellManager.spells.get(selected_spell_id, {})
	spell_info.text = spell_cfg.get("description", "") + "\n\nRank: %d\nMastery: %d / 100" % [s_data.get("rank", 1), s_data.get("mastery", 0)]
	train_button.text = "TRAIN (%dG)" % SpellManager.get_training_cost(selected_spell_id, s_data.get("rank", 1))
	train_button.visible = SpellManager.is_spell_unlocked(selected_spell_id, stats.learned_spells)

# --- GLOBAL STATS ---
func update_stats():
	var stats = StatsManager.stats
	if not stats: return
	
	_update_mode_label()
		
	gold_label.text = "GOLD: " + str(int(stats.gold))
	level_label.text = "LVL: " + str(stats.level)
	xp_bar.max_value = StatsManager.get_xp_needed()
	xp_bar.value = stats.xp
	stats_label.text = "Wizard Level: %d\nExperience: %d / %d\nTotal Gold: %d" % [stats.level, stats.xp, StatsManager.get_xp_needed(), int(stats.gold)]
	combat_label.text = "COMBAT SKILLS\n\nAttack Power: %.1f\nCrit Chance: %.1f%%\nAttack Speed: %.2f" % [stats.attack_power, stats.crit_chance * 100.0, stats.haste]

func update_enemy_health(current, max_hp):
	enemy_health_bar.max_value = max_hp
	enemy_health_bar.value = current

func add_loot_entry(entry_text):
	loot_log.push_front(entry_text)
	if loot_log.size() > 10: loot_log.pop_back()

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

extends Control

signal craft_pressed # Deprecated but keeping for compatibility
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
@onready var wizard_preview = $Grimoire/TabContainer/Barber/RightPage/PreviewContainer/SubViewport/WizardPreview

# Spell UI
@onready var spell_list_container = $Grimoire/TabContainer/Spells/LeftPage/VBox/SpellList
@onready var spell_title = $Grimoire/TabContainer/Spells/RightPage/VBox/SpellTitle
@onready var spell_info = $Grimoire/TabContainer/Spells/RightPage/VBox/SpellInfo
@onready var train_button = $Grimoire/TabContainer/Spells/RightPage/VBox/TrainButton
@onready var equip_button = $Grimoire/TabContainer/Spells/RightPage/VBox/EquipButton

# Workshop UI
@onready var equip_list_container = $Grimoire/TabContainer/Workshop/LeftPage/VBox/EquipmentList
@onready var item_title = $Grimoire/TabContainer/Workshop/RightPage/VBox/ItemTitle
@onready var item_info = $Grimoire/TabContainer/Workshop/RightPage/VBox/ItemInfo
@onready var research_button = $Grimoire/TabContainer/Workshop/RightPage/VBox/ResearchButton

var loot_log: Array = []
var selected_spell_id: String = "magic_missile"
var selected_equip_cat: String = "main_hand"

func _ready():
	update_stats()
	update_spell_ui()
	update_workshop_ui()
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
	update_workshop_ui()
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
	if index == 0: update_stats()
	elif index == 1: update_workshop_ui()
	elif index == 3: update_spell_ui()

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

# Workshop Logic
func _on_equip_cat_select(cat_id: String):
	selected_equip_cat = cat_id
	update_workshop_ui()

func _on_research_button_pressed():
	var stats = StatsManager.stats
	var current_tier = 0
	if selected_equip_cat == "main_hand": current_tier = stats.main_hand_style
	elif selected_equip_cat == "head": current_tier = stats.hat_style
	
	var item = EquipmentManager.get_item_data(selected_equip_cat, current_tier)
	if not item: return
	
	if stats.gold >= item["cost"]:
		stats.gold -= item["cost"]
		if selected_equip_cat == "main_hand": 
			stats.main_hand_style = item["tier"]
			if item.has("power_boost"): stats.attack_power += item["power_boost"]
		elif selected_equip_cat == "head": 
			stats.hat_style = item["tier"]
			if item.has("haste_boost"): stats.haste += item["haste_boost"]
			
		show_floating_text("RESEARCH COMPLETE!", Color.GOLD)
		update_stats()
		update_workshop_ui()
		appearance_changed.emit()
		StatsManager.save_stats()
	else:
		show_floating_text("NOT ENOUGH GOLD!", Color.RED)

func update_workshop_ui():
	for child in equip_list_container.get_children(): child.queue_free()
	
	for cat_id in EquipmentManager.categories.keys():
		var btn = Button.new()
		btn.add_theme_font_size_override("font_size", 8)
		btn.text = EquipmentManager.categories[cat_id]["name"]
		btn.pressed.connect(_on_equip_cat_select.bind(cat_id))
		equip_list_container.add_child(btn)
		
	var stats = StatsManager.stats
	var current_tier = 0
	if selected_equip_cat == "main_hand": current_tier = stats.main_hand_style
	elif selected_equip_cat == "head": current_tier = stats.hat_style
	
	var item = EquipmentManager.get_item_data(selected_equip_cat, current_tier)
	if item:
		item_title.text = item["name"]
		var info = "Tied to Category: %s\n" % selected_equip_cat
		if item.has("power_boost"): info += "Power: +%d\n" % item["power_boost"]
		if item.has("haste_boost"): info += "Haste: +%.2f\n" % item["haste_boost"]
		item_info.text = info
		research_button.text = "RESEARCH (%dG)" % item["cost"]
		research_button.disabled = false
	else:
		item_title.text = "Max Tier Reached"
		item_info.text = "No further research available."
		research_button.text = "MAXED"
		research_button.disabled = true

# Spell Book Logic
func _on_spell_select_pressed(spell_id: String):
	selected_spell_id = spell_id
	update_spell_ui()

func _on_train_spell_pressed():
	var stats = StatsManager.stats
	if not stats.learned_spells.has(selected_spell_id):
		stats.learned_spells[selected_spell_id] = {"rank": 1, "mastery": 0}
		
	var s_data = stats.learned_spells[selected_spell_id]
	var cost = SpellManager.get_training_cost(selected_spell_id, s_data["rank"])
	
	if stats.gold >= cost:
		stats.gold -= cost
		s_data["rank"] += 1
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
			btn.text = SpellManager.get_spell_name(s_id, stats.learned_spells.get(s_id, {"rank":1})["rank"])
			btn.pressed.connect(_on_spell_select_pressed.bind(s_id))
		else:
			btn.text = "??? (LOCKED)"
			btn.disabled = true
		spell_list_container.add_child(btn)
	
	var s_data = stats.learned_spells.get(selected_spell_id, {"rank": 1, "mastery": 0})
	spell_title.text = SpellManager.get_spell_name(selected_spell_id, s_data["rank"])
	equip_button.visible = stats.learned_spells.has(selected_spell_id)
	equip_button.disabled = (selected_spell_id == stats.active_spell_id)
	spell_info.text = SpellManager.spells[selected_spell_id]["description"] + "\n\nRank: %d\nMastery: %d / 100" % [s_data["rank"], s_data["mastery"]]
	train_button.text = "TRAIN (%dG)" % SpellManager.get_training_cost(selected_spell_id, s_data["rank"])
	train_button.visible = SpellManager.is_spell_unlocked(selected_spell_id, stats.learned_spells)

# Stats Logic
func update_stats():
	var stats = StatsManager.stats
	if not stats: return
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
	# Optional: show in workshop if needed

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

extends Control

signal craft_pressed
signal appearance_changed

@onready var gold_label = $TopBar/GoldLabel
@onready var level_label = $TopBar/LevelLabel
@onready var enemy_health_bar = $PlaterBar
@onready var floating_text_container = $FloatingTextContainer
@onready var loot_log_label = $LootLogLabel
@onready var customization_panel = $CustomizationPanel

var loot_log: Array = []
var log_fade_tween: Tween

func _ready():
	update_stats()
	# Start with hidden log
	loot_log_label.modulate.a = 0.0

func _on_craft_button_pressed():
	craft_pressed.emit()

func _on_customize_button_pressed():
	customization_panel.visible = true

func _on_close_button_pressed():
	customization_panel.visible = false

func _on_randomize_button_pressed():
	var stats = StatsManager.stats
	stats.robe_color = Color(randf(), randf(), randf())
	stats.hat_color = stats.robe_color # Keep them matching for now
	stats.skin_color = Color(0.8 + randf() * 0.2, 0.6 + randf() * 0.2, 0.5 + randf() * 0.2) # Flesh tones
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
	gold_label.text = "GOLD: " + str(int(StatsManager.stats.gold))
	level_label.text = "LVL: " + str(StatsManager.stats.level)

func update_enemy_health(current, max_hp):
	enemy_health_bar.max_value = max_hp
	enemy_health_bar.value = current

func add_loot_entry(entry_text):
	loot_log.push_front(entry_text)
	if loot_log.size() > 5:
		loot_log.pop_back()
	
	var log_text = "Recent Loot:\n"
	for entry in loot_log:
		log_text += "- " + entry + "\n"
	loot_log_label.text = log_text
	
	# Show then fade out log
	if log_fade_tween:
		log_fade_tween.kill()
	
	loot_log_label.modulate.a = 1.0
	log_fade_tween = get_tree().create_tween()
	log_fade_tween.tween_interval(3.0) # Show for 3 seconds
	log_fade_tween.tween_property(loot_log_label, "modulate:a", 0.0, 1.0) # Fade for 1 second

func show_floating_text(text, color):
	# Very basic floating text implementation
	var label = Label.new()
	label.text = text
	label.add_theme_color_override("font_color", color)
	floating_text_container.add_child(label)
	
	var tween = get_tree().create_tween()
	tween.tween_property(label, "position", label.position + Vector2(0, -30), 0.5)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 0.5)
	tween.tween_callback(label.queue_free)

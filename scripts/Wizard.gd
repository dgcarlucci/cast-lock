extends Node2D

enum State { IDLE, CAST, RECOVER }
var current_state: State = State.IDLE

@onready var body = $Layers/Body
@onready var robe = $Layers/Robe
@onready var hat = $Layers/Hat
@onready var eyes = $Layers/Eyes
@onready var hair = $Layers/Hair
@onready var beard = $Layers/Beard
@onready var layers = $Layers

func _ready():
	# Initial update to match stats
	update_appearance(StatsManager.stats)

func update_appearance(stats: WizardStats):
	body.modulate = stats.skin_color
	robe.modulate = stats.robe_color
	hat.modulate = stats.hat_color
	eyes.modulate = stats.eye_color
	hair.modulate = stats.hair_color
	beard.modulate = stats.hair_color
	
	# Visibility logic based on styles (0 usually means none or basic)
	hair.visible = stats.hair_style > 0
	beard.visible = stats.beard_style > 0
	
	# In a full system, you'd load different textures based on styles:
	# robe.texture = load("res://resources/wizard/robe_" + str(stats.robe_style) + ".svg")

func play_cast_animation(callback: Callable):
	if current_state != State.IDLE:
		return
		
	current_state = State.CAST
	
	var tween = get_tree().create_tween()
	
	# Squish and stretch for "cuteness"
	# CAST Phase: Squish down, then jump up
	tween.tween_property(layers, "scale", Vector2(1.2, 0.8), 0.1)
	tween.parallel().tween_property(layers, "position", Vector2(0, 5), 0.1)
	
	tween.tween_property(layers, "scale", Vector2(0.8, 1.2), 0.1)
	tween.parallel().tween_property(layers, "position", Vector2(0, -20), 0.1)
	
	tween.tween_callback(func(): 
		current_state = State.RECOVER
		callback.call()
	)
	
	# RECOVER Phase: Land and bounce
	tween.tween_property(layers, "scale", Vector2(1.0, 1.0), 0.2).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(layers, "position", Vector2(0, 0), 0.2).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	
	tween.tween_callback(func(): 
		current_state = State.IDLE
	)

extends Node2D

@onready var sprite = $Sprite2D
@onready var shadow = $Shadow

func _ready():
	start_idle_animation()

func start_idle_animation():
	var tween = get_tree().create_tween().set_loops()
	# Slow bobbing
	tween.tween_property(sprite, "position", Vector2(0, -5), 1.0).set_trans(Tween.TRANS_SINE)
	tween.tween_property(sprite, "position", Vector2(0, 0), 1.0).set_trans(Tween.TRANS_SINE)
	
	var shadow_tween = get_tree().create_tween().set_loops()
	shadow_tween.tween_property(shadow, "scale", Vector2(1.1, 1.1), 1.0).set_trans(Tween.TRANS_SINE)
	shadow_tween.tween_property(shadow, "scale", Vector2(1.0, 1.0), 1.0).set_trans(Tween.TRANS_SINE)

func play_hit_animation():
	var tween = get_tree().create_tween()
	sprite.modulate = Color.RED
	tween.tween_property(sprite, "position", Vector2(10, 0), 0.05)
	tween.tween_property(sprite, "position", Vector2(0, 0), 0.05)
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.1)

func play_death_animation(callback: Callable):
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "scale", Vector2(0, 0), 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(shadow, "modulate:a", 0, 0.2)
	tween.tween_callback(callback)

func set_texture(texture: Texture2D):
	sprite.texture = texture
	# Reset scale in case it was dying
	sprite.scale = Vector2(1, 1)
	shadow.modulate.a = 0.2

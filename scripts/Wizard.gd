extends Node2D

enum State { IDLE, CAST, RECOVER }
var current_state: State = State.IDLE

@onready var body = $Layers/Body
@onready var legs = $Layers/Legs
@onready var chest = $Layers/Chest
@onready var hat = $Layers/Hat
@onready var eyes = $Layers/Eyes
@onready var hair = $Layers/Hair
@onready var beard = $Layers/Beard
@onready var weapon = $Layers/Weapon
@onready var accessory = $Layers/Accessory
@onready var layers = $Layers
@onready var shadow = $Shadow

func _ready():
	# Initial update to match stats
	update_appearance(StatsManager.stats)
	start_idle_animation()

func update_appearance(stats: WizardStats):
	body.modulate = stats.skin_color
	chest.modulate = stats.chest_color
	legs.modulate = stats.legs_color
	hat.modulate = stats.hat_color
	hair.modulate = stats.hair_color
	beard.modulate = stats.hair_color
	
	if stats.eye_color != Color.BLACK:
		eyes.modulate = stats.eye_color
	else:
		eyes.modulate = Color.WHITE
	
	hair.visible = stats.hair_style > 0
	beard.visible = stats.beard_style > 0
	
	# Chest visibility and texture
	if stats.chest_style == 0:
		chest.visible = false
	else:
		chest.visible = true
		if stats.chest_style == 1:
			chest.texture = load("res://resources/player/appearance/robe_basic.svg")
		elif stats.chest_style == 2:
			chest.texture = load("res://resources/player/appearance/robe_scholar.svg")
		elif stats.chest_style == 3:
			chest.texture = load("res://resources/player/appearance/robe_sage.svg")
		elif stats.chest_style == 4:
			chest.texture = load("res://resources/player/appearance/robe_archmage.svg")
		elif stats.chest_style == 5:
			chest.texture = load("res://resources/player/appearance/robe_warlock.svg")
		elif stats.chest_style == 6:
			chest.texture = load("res://resources/player/appearance/robe_druid.svg")
		elif stats.chest_style == 7:
			chest.texture = load("res://resources/player/appearance/robe_necromancer.svg")
		elif stats.chest_style == 8:
			chest.texture = load("res://resources/player/appearance/robe_cosmic.svg")
		elif stats.chest_style == 9:
			chest.texture = load("res://resources/player/appearance/robe_infinite.svg")

	# Legs visibility and texture
	if stats.legs_style == 0:
		legs.visible = false
	else:
		legs.visible = true
		if stats.legs_style == 1:
			legs.texture = load("res://resources/player/appearance/pants_basic.svg")
		
	# Hat visibility and texture
	if stats.hat_style == 0:
		hat.visible = false
	else:
		hat.visible = true
		if stats.hat_style == 1:
			hat.texture = load("res://resources/player/appearance/hat_basic.svg")
		elif stats.hat_style == 2:
			hat.texture = load("res://resources/player/appearance/hat_apprentice.svg")
		elif stats.hat_style == 3:
			hat.texture = load("res://resources/player/appearance/hat_scholar.svg")
		elif stats.hat_style == 4:
			hat.texture = load("res://resources/player/appearance/hat_sage.svg")
		elif stats.hat_style == 5:
			hat.texture = load("res://resources/player/appearance/hat_archmage.svg")
		elif stats.hat_style == 6:
			hat.texture = load("res://resources/player/appearance/hat_warlock.svg")
		elif stats.hat_style == 7:
			hat.texture = load("res://resources/player/appearance/hat_druid.svg")
		elif stats.hat_style == 8:
			hat.texture = load("res://resources/player/appearance/hat_necromancer.svg")
		elif stats.hat_style == 9:
			hat.texture = load("res://resources/player/appearance/hat_cosmic.svg")
		elif stats.hat_style == 10:
			hat.texture = load("res://resources/player/appearance/hat_infinite.svg")

	# Weapon visibility and texture
	if stats.main_hand_style == 0:
		weapon.visible = false
	else:
		weapon.visible = true
		weapon.modulate = Color.WHITE
		if stats.main_hand_style == 1:
			weapon.texture = load("res://resources/player/appearance/wand_basic.svg")
		elif stats.main_hand_style == 2:
			weapon.texture = load("res://resources/player/appearance/staff_basic.svg")
		elif stats.main_hand_style == 3:
			weapon.texture = load("res://resources/player/appearance/wand_willow.svg")
		elif stats.main_hand_style == 4:
			weapon.texture = load("res://resources/player/appearance/staff_arcane.svg")
		elif stats.main_hand_style == 5:
			weapon.texture = load("res://resources/player/appearance/wand_ebony.svg")
		elif stats.main_hand_style == 6:
			weapon.texture = load("res://resources/player/appearance/staff_dragon.svg")
		elif stats.main_hand_style == 7:
			weapon.texture = load("res://resources/player/appearance/wand_phoenix.svg")
		elif stats.main_hand_style == 8:
			weapon.texture = load("res://resources/player/appearance/staff_void.svg")
		elif stats.main_hand_style == 9:
			weapon.texture = load("res://resources/player/appearance/wand_celestial.svg")
		elif stats.main_hand_style == 10:
			weapon.texture = load("res://resources/player/appearance/staff_godly.svg")

	# Accessory visibility and texture
	if stats.accessory_style == 0:
		accessory.visible = false
	else:
		accessory.visible = true
		accessory.modulate = Color.WHITE
		if stats.accessory_style == 1:
			accessory.texture = load("res://resources/player/appearance/acc_book.svg")
		elif stats.accessory_style == 2:
			accessory.texture = load("res://resources/player/appearance/acc_pouch.svg")
		elif stats.accessory_style == 3:
			accessory.texture = load("res://resources/player/appearance/acc_bag.svg")
		elif stats.accessory_style == 4:
			accessory.texture = load("res://resources/player/appearance/acc_sword.svg")
		elif stats.accessory_style == 5:
			accessory.texture = load("res://resources/player/appearance/acc_skull.svg")
		elif stats.accessory_style == 6:
			accessory.texture = load("res://resources/player/appearance/acc_lantern.svg")
		elif stats.accessory_style == 7:
			accessory.texture = load("res://resources/player/appearance/acc_orb.svg")
		elif stats.accessory_style == 8:
			accessory.texture = load("res://resources/player/appearance/acc_scroll.svg")
		elif stats.accessory_style == 9:
			accessory.texture = load("res://resources/player/appearance/acc_crystal.svg")

func start_idle_animation():
	var tween = get_tree().create_tween().set_loops()
	tween.tween_property(layers, "scale", Vector2(1.02, 0.98), 1.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property(layers, "scale", Vector2(1.0, 1.0), 1.5).set_trans(Tween.TRANS_SINE)
	# Subtle shadow scale
	var shadow_tween = get_tree().create_tween().set_loops()
	shadow_tween.tween_property(shadow, "scale", Vector2(1.1, 1.1), 1.5).set_trans(Tween.TRANS_SINE)
	shadow_tween.tween_property(shadow, "scale", Vector2(1.0, 1.0), 1.5).set_trans(Tween.TRANS_SINE)

	# Subtle weapon bobbing
	var weapon_tween = get_tree().create_tween().set_loops()
	weapon_tween.tween_property(weapon, "position", Vector2(12, -2), 1.5).set_trans(Tween.TRANS_SINE)
	weapon_tween.tween_property(weapon, "position", Vector2(12, 0), 1.5).set_trans(Tween.TRANS_SINE)


func play_cast_animation(callback: Callable):
	if current_state != State.IDLE:
		return
		
	current_state = State.CAST
	var spell_id = StatsManager.stats.active_spell_id
	
	if spell_id == "magic_missile":
		_animate_magic_missile(callback)
	elif spell_id == "fireball":
		_animate_fireball(callback)
	else:
		_animate_generic_spell(callback)

func _animate_magic_missile(callback: Callable):
	var tween = get_tree().create_tween()
	for i in range(3):
		tween.tween_property(layers, "position", Vector2(5, 0), 0.05)
		tween.tween_callback(func(): _spawn_projectile(Vector2(20, -30), 0.15))
		tween.tween_property(layers, "position", Vector2(0, 0), 0.05)
		tween.tween_interval(0.05)
	
	tween.tween_callback(func(): 
		current_state = State.RECOVER
		callback.call()
	)
	tween.tween_interval(0.1)
	tween.tween_callback(func(): current_state = State.IDLE)

func _animate_fireball(callback: Callable):
	var tween = get_tree().create_tween()
	tween.tween_property(layers, "scale", Vector2(1.3, 0.7), 0.3)
	tween.parallel().tween_property(layers, "modulate", Color(2, 1, 1), 0.3)
	
	tween.tween_callback(func(): 
		_spawn_projectile(Vector2(20, -40), 0.4, 2.0, true)
	)
	
	tween.tween_property(layers, "scale", Vector2(0.7, 1.3), 0.1)
	tween.parallel().tween_property(layers, "modulate", Color.WHITE, 0.1)
	tween.tween_property(layers, "scale", Vector2(1.0, 1.0), 0.2)
	
	tween.tween_callback(func(): 
		current_state = State.RECOVER
		callback.call()
	)
	tween.tween_interval(0.3)
	tween.tween_callback(func(): current_state = State.IDLE)

func _animate_generic_spell(callback: Callable):
	var tween = get_tree().create_tween()
	tween.tween_property(layers, "scale", Vector2(1.2, 0.8), 0.1)
	tween.tween_callback(func(): _spawn_projectile(Vector2(20, -30), 0.2))
	tween.tween_property(layers, "scale", Vector2(1.0, 1.0), 0.1)
	tween.tween_callback(func(): 
		current_state = State.RECOVER
		callback.call()
	)
	tween.tween_callback(func(): current_state = State.IDLE)

func _spawn_projectile(start_offset: Vector2, speed: float, scale_mult: float = 1.0, arc: bool = false):
	var spell_sprite = Sprite2D.new()
	var spell_id = StatsManager.stats.active_spell_id
	spell_sprite.texture = load(SpellManager.get_spell_visual_path(spell_id))
	spell_sprite.scale = Vector2(0.5, 0.5) * scale_mult
	spell_sprite.position = layers.position + start_offset
	add_child(spell_sprite)
	
	var stween = get_tree().create_tween().set_parallel(true)
	var target_pos = spell_sprite.position + Vector2(100, 0)
	
	if arc:
		stween.tween_property(spell_sprite, "position:x", target_pos.x, speed)
		var y_tween = get_tree().create_tween()
		y_tween.tween_property(spell_sprite, "position:y", spell_sprite.position.y - 30, speed/2.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		y_tween.tween_property(spell_sprite, "position:y", spell_sprite.position.y, speed/2.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	else:
		stween.tween_property(spell_sprite, "position", target_pos, speed)
		
	stween.tween_property(spell_sprite, "modulate:a", 0.0, speed).set_delay(speed * 0.8)
	stween.chain().tween_callback(spell_sprite.queue_free)

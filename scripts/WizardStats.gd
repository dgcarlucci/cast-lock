extends Resource
class_name WizardStats

@export_group("Stats")
@export var level: int = 1
@export var gold: int = 0
@export var xp: int = 0
@export var attack_power: float = 10.0
@export var crit_chance: float = 0.05
@export var haste: float = 1.0 # Multiplier for attack speed

@export_group("Customization")
@export var skin_color: Color = Color("ffe0bd") # Default light skin
@export var chest_color: Color = Color("4a1a6b") # Default purple
@export var legs_color: Color = Color("4a1a6b") # Default purple
@export var hat_color: Color = Color("4a1a6b") # Default purple
@export var eye_color: Color = Color("000000") # Default black
@export var hair_color: Color = Color("ffffff") # Default white/grey
@export var hair_style: int = 1
@export var beard_style: int = 1
@export var chest_style: int = 1
@export var legs_style: int = 1
@export var hat_style: int = 1
@export var main_hand_style: int = 1 # 1: Wand, 2: Staff
@export var off_hand_style: int = 0
@export var accessory_style: int = 0

@export var unlocked_tiers: Dictionary = {
	"main_hand": 1,
	"head": 1,
	"chest": 1,
	"legs": 1,
	"accessories": 0
}

@export_group("Spells")
@export var active_spell_id: String = "magic_missile"
@export var learned_spells: Dictionary = {
	"magic_missile": {"rank": 1, "mastery": 0}
}
@export var spell_mastery_xp: int = 0
@export var total_casts: int = 0
@export var idle_mode_enabled: bool = false # false = Active (Typing), true = Passive (Idle)

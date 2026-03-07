extends Resource
class_name EnemyData

@export var base_hp: float = 50.0
@export var base_gold: float = 5.0

func get_hp_for_level(level: int) -> float:
	return base_hp * pow(1.15, level - 1)

func get_gold_for_level(level: int) -> float:
	return base_gold * pow(1.12, level - 1)

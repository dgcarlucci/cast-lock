extends Node

const SAVE_PATH = "user://save_game.json"

func save_game(stats: WizardStats):
	var save_dict = {
		"level": stats.level,
		"gold": stats.gold,
		"xp": stats.xp,
		"attack_power": stats.attack_power,
		"crit_chance": stats.crit_chance,
		"haste": stats.haste,
		"skin_color": stats.skin_color.to_html(),
		"robe_color": stats.robe_color.to_html(),
		"hat_color": stats.hat_color.to_html(),
		"eye_color": stats.eye_color.to_html(),
		"hair_color": stats.hair_color.to_html(),
		"robe_style": stats.robe_style,
		"hat_style": stats.hat_style,
		"hair_style": stats.hair_style,
		"beard_style": stats.beard_style
	}
	
	var json_string = JSON.stringify(save_dict)
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(json_string)
		file.close()
		# Only print in debug or just remove to clean up logs
		# print("Game saved!")

func load_game() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {}
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(content)
	if parse_result == OK:
		return json.get_data()
	else:
		print("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line())
		return {}

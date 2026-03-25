## used to save data to bin file (uncoded)
extends Node

const SAVE_PATH: String = "user://save.bin"

@export var current_level : String = "res://levels/level_1.tscn"
@export var spawn_position : Vector2 = Vector2(48, 446)
@export var date : String = "00.00.0000 00:00"
var death_count : int = 0

var target_door_id : int = -1

func string_to_vector2(string := "") -> Vector2:
	if string:
		var new_string: String = string
		new_string = new_string.erase(0, 1)
		new_string = new_string.erase(new_string.length() - 1, 1)
		var array: Array = new_string.split(", ")
		return Vector2(int(array[0]), int(array[1]))
	return Vector2.ZERO

func _notification(notification: int) -> void:
	if notification == NOTIFICATION_WM_CLOSE_REQUEST:
		GameManager.close_game()


func get_current_level_scene():
	if get_tree().get_node_count_in_group("level") == 0:
		return "level_1"
	
	var level_name := get_tree().get_nodes_in_group("level")[0].name
	var level_number = level_name.right(level_name.length()-5).to_int()
	return "level_" + str(level_number)

func format_with_zero(number : int):
	var text = str(number)
	if len(text) > 1:
		return text
	
	return "0" + text

func delete_save():
	if FileAccess.file_exists(SAVE_PATH):
		var result = DirAccess.remove_absolute(SAVE_PATH)
		if result == OK:
			print("Save deleted")
		else:
			print("Error deleting save: ", result)
	else:
		print("Save file does not exist")
	
	spawn_position = Vector2(48, 446)
	target_door_id = -1
	GameManager.gravity_direction = 1
	death_count = 0
	
	print("saveexists: ", FileAccess.file_exists(SAVE_PATH))
	

func get_cdate_string() -> String:
	var dt = Time.get_datetime_dict_from_system()
	
	var date = format_with_zero(dt.day) + "." + format_with_zero(dt.month) + "." + str(dt.year)
	var time = format_with_zero(dt.hour) + ":" + format_with_zero(dt.minute)
	
	var dt_string : String = date + " " + time
	return dt_string
	

func save_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data : Dictionary = {
		"current_level" : "res://levels/" + get_current_level_scene() + ".tscn",
		"spawn_position" : spawn_position,
		"date" : get_cdate_string(),
		"death_count" : death_count,
	}
	
	
	
	file.store_line(JSON.stringify(data))
	print("Saving to: ", ProjectSettings.globalize_path(SAVE_PATH))
	file.close()

func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		return
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	print(file.get_path_absolute())
	if file.eof_reached():
		return
	
	var data = JSON.parse_string(file.get_line())
	
	if typeof(data) == TYPE_DICTIONARY:
		current_level = data.get("current_level", current_level)
		spawn_position = string_to_vector2(data.get("spawn_position", spawn_position))
		date = data.get("date", date)
		death_count = data.get("death_count", death_count) 
	
	print("Loading save from: ", ProjectSettings.globalize_path(SAVE_PATH))
	file.close()

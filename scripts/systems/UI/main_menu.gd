extends Control


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass


func _on_quit_pressed() -> void:
	GameSaveSystem.save_game()
	get_tree().quit()

	
func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/test_scene.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/Settings.tscn")
	

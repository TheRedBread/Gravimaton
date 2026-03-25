extends Control

func _ready() -> void:
	%Credits.append_text("\n\nYour total deaths: " + str(GameSaveSystem.death_count))

func _on_button_pressed() -> void:
	SceneTransition.change_scene("res://UI/main menu/main_menu.tscn", "Blue1")

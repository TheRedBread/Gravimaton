extends Area2D

@export var end_scene : String = "res://global elements/credits.tscn"

func _on_body_entered(body: Node2D) -> void:
	await get_tree().create_timer(3).timeout
	SceneTransition.change_scene(end_scene, "Blue1")

	

extends Power

@onready var button_timer: Timer = $ButtonTimer
@onready var interaction_area: Area2D = $InteractionArea
@onready var lever: Sprite2D = $lever

@export var enabling_power_supply : Power


const INTERACTION_POPUP = preload("res://levels/interaction_popup.tscn")
var is_player_in_area : bool = false

func _ready() -> void:
	on = false
	
	lever.frame = int(on)
	
	if enabling_power_supply and !enabling_power_supply.on:
		lever.frame = 2

func _physics_process(_delta: float) -> void:
	if enabling_power_supply and !enabling_power_supply.on:
		lever.frame = 2
		return
	else:
		lever.frame = int(on)
		
	
	if Input.is_action_just_pressed("Interact") and is_player_in_area:
		on = true
		lever.frame = int(on)
		
		button_timer.start()

func _on_interaction_area_body_entered(_body: Node2D) -> void:
	if enabling_power_supply and !enabling_power_supply.on:
		lever.frame = 2
		return
		
	is_player_in_area = true
	var popup = INTERACTION_POPUP.instantiate()
	popup.position = position + Vector2(0, -12)
	
	get_parent().add_child(popup)


func _on_interaction_area_body_exited(_body: Node2D) -> void:
	is_player_in_area = false


func _on_button_timer_timeout() -> void:
	on = false
	lever.frame = int(on)

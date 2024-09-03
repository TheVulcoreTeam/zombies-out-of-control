extends CharacterBody2D

var movement_direction_x := 0
var speed := 10000

var store_global_position : Vector2


func _ready() -> void:
	store_global_position = global_position


func _physics_process(delta: float) -> void:
	movement_direction_x = Input.get_axis("ui_left", "ui_right")
	velocity.x = movement_direction_x * delta * speed
	#move_and_collide(Vector2(movement_direction_x * delta * speed, 0))
	move_and_slide()


func _process(delta: float) -> void:
	global_position.y = store_global_position.y

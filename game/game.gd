extends Node2D

const ZOMBIE = preload("res://game/enemies/zombies/zombie.tscn")


func _ready() -> void:
	randomize()


func create_zombie():
	var zombie_inst = ZOMBIE.instantiate()
	zombie_inst.global_position.x = randi_range(0 + 50, 640 - 50)
	zombie_inst.global_position.y = -50
	add_child(zombie_inst)


func _on_timer_timeout() -> void:
	create_zombie()

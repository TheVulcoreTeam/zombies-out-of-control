extends RigidBody2D

class_name Bullet

var direction 
var speed := 300


func _ready() -> void:
	apply_impulse(direction * speed)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()

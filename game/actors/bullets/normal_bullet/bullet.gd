extends RigidBody2D

class_name Bullet

var direction 
var speed := 300
var damage := Main.stats_bullet_damage


func _ready() -> void:
	apply_impulse(direction * speed)
	$Sound.play()


func dead():
	$SoundExplosion.play()
	$Anim.play("DEAD")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_timer_timeout() -> void:
	dead()


func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "DEAD":
		queue_free()

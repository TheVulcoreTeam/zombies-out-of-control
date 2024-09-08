extends RigidBody2D
class_name Zombie


var hp : int:
	set(value):
		hp = value
		$HP.value_changed.emit(float(hp))
		
		if hp <= 0:
			dead(true)


func _ready() -> void:
	var new_hp = randi_range(1, clamp(int(Main.difficulty * 2), 1, 200))
	$HP.max_value = new_hp
	$HP.value = new_hp
	hp = new_hp
	
	print("hp", hp)
	
	
	$HP.value_changed.connect(_on_value_changed)


func dead(with_score := false) -> void:
	if with_score:
		Main.money += int(Main.difficulty)
		Main.score += int(Main.difficulty)
		
		get_node("Aargh" + str(randi_range(1, 5))).play()
	
	$Collision.call_deferred("set_disabled", true)
	$HurtArea/Collision.call_deferred("set_disabled", true)
	$HP.hide()
	$Anim.play("DEAD")


func _on_hurt_area_body_entered(body: Node2D) -> void:
	if body is Bullet:
		$HP.show()
		hp -= body.damage
		body.dead()


func _on_value_changed(value : float):
	$HP.value = int(value)
	$TimeToDead.wait_time = 10


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	$Anim.play("SHOW")


func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "DEAD":
		$Anim.animation_finished.disconnect(_on_anim_animation_finished)
		queue_free()


func _on_time_to_dead_timeout() -> void:
	dead()

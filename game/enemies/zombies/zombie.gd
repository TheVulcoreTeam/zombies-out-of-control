extends RigidBody2D

var hp : int:
	set(value):
		hp = value
		$HP.value_changed.emit(float(hp))
		
		if hp <= 0:
			dead()
		

func _ready() -> void:
	$HP.max_value = int(Main.difficulty)
	$HP.value = int(Main.difficulty)
	hp = int(Main.difficulty)
	
	$HP.value_changed.connect(_on_value_changed)


func dead() -> void:
	Main.money += int(Main.difficulty)
	Main.score += int(Main.difficulty)
	$Anim.play("DEAD")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_hurt_area_body_entered(body: Node2D) -> void:
	if body is Bullet:
		body.queue_free()
		hp -= 1

func _on_value_changed(value : float):
	$HP.value = int(value)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	$Anim.play("SHOW")


func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "DEAD":
		$Anim.animation_finished.disconnect(_on_anim_animation_finished)
		queue_free()

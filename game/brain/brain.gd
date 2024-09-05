extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Zombie:
		body.dead()
		get_node("Aargh" + str(randi_range(1, 5))).play()
		$Anim.play("HURT")
		Main.hp -= 1

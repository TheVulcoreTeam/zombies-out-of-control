extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Zombie:
		body.dead()
		$Anim.play("HURT")
		Main.hp -= 1
		
		$Bite.play()
		await get_tree().create_timer(0.5).timeout
		get_node("Aargh" + str(randi_range(1, 5))).play()

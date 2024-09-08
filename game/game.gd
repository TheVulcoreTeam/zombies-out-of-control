extends Node2D

const ZOMBIE = preload("res://game/enemies/zombies/zombie.tscn")


func _ready() -> void:
	randomize()
	
	Signals.money_added.connect(_on_money_added)
	Signals.score_added.connect(_on_score_added)
	
	Signals.hp_changed.connect(_on_hp_changed)
	
	Signals.price_automatic_tower_changed.connect(_on_price_automatic_tower_changed)
	
	$HP.max_value = Main.hp_max
	$HP.value = Main.hp
	
	$BulletDamage/Price.text = "$" + str(Main.stats_bullet_damage_price)
	$MaxHP/Price.text = "$" + str(Main.stats_hp_max_price)


func create_zombie():
	var zombie_inst = ZOMBIE.instantiate()
	zombie_inst.global_position.x = randi_range(0 + 50, 640 - 50)
	zombie_inst.global_position.y = -50
	#zombie_inst["physics_material_override/bounce"] -= 0.0001
	#print(zombie_inst["physics_material_override/bounce"])
	
	add_child(zombie_inst)


func animate_button(button : TextureButton):
	var tween = create_tween()
	tween.tween_property(
		button,
		"scale",
		Vector2.ONE * 1.4,
		0.2
	).from_current().set_ease(Tween.EASE_OUT)
	tween.tween_property(
		button,
		"scale",
		Vector2.ONE,
		0.2
	).from_current().set_ease(Tween.EASE_OUT)


func all_towers_are_activated() -> bool:
	for tower in get_tree().get_nodes_in_group("Tower"):
		if not tower.automatic_tower:
			return false
	return true

func _on_hp_changed(new_value):
	$HP.value = new_value
	
	if new_value == 0:
		$Display/Anim.play("GAME_OVER")
		Main.is_game_started = false
		
		for zombie in get_tree().get_nodes_in_group("ZOMBIES"):
			if is_instance_valid(zombie):
				zombie.dead()
				await get_tree().create_timer(0.05).timeout
		
		for tower in get_tree().get_nodes_in_group("Tower"):
			if is_instance_valid(tower):
				tower.destroy()
				await get_tree().create_timer(0.25).timeout
		
		await get_tree().create_timer(0.05).timeout
		$Paddle.paddle_dead()


func _on_timer_timeout() -> void:
	if Main.is_game_started:
		create_zombie()
		$Timer.wait_time = clamp($Timer.wait_time - 0.001, 0.05, 5)
		print($Timer.wait_time)


func _on_score_added():
	$Score.text = "Score: " + str(Main.score)


func _on_money_added():
	$Money.text = "Money: " + str(Main.money)
	
	if Main.money >= Main.price_automatic_tower and not all_towers_are_activated():
		$BuyTurret.show()
	else:
		$BuyTurret.hide()
	
	if Main.money >= Main.stats_hp_max_price and not Main.hp_max >= 10:
		$MaxHP/ButtonMaxHP.disabled = false
		animate_button($MaxHP/ButtonMaxHP)
	else:
		$MaxHP/ButtonMaxHP.disabled = true
		
		if Main.hp_max >= 10:
			$MaxHP/Price.hide()

	#if Main.money >= Main.stats_bullet_velocity_price and not $Paddle/FireTimer.wait_time <= 0.2:
		#$BulletVelocity/ButtonBulletVelocity.disabled = false
		#animate_button($BulletVelocity/ButtonBulletVelocity)
	#else:
		#$BulletVelocity/ButtonBulletVelocity.disabled = true

	if Main.money >= Main.stats_bullet_damage_price and not Main.stats_bullet_damage >= 5:
		$BulletDamage/ButtonBulletDamage.disabled = false
		animate_button($BulletDamage/ButtonBulletDamage)
	else:
		$BulletDamage/ButtonBulletDamage.disabled = true
		
		if Main.stats_bullet_damage >= 5:
			$BulletDamage/Price.hide()


func _on_price_automatic_tower_changed(new_value):
	$BuyTurret/TurretValue.text = "$" + str(new_value)


func _on_difficulty_timeout() -> void:
	Main.difficulty += 0.25


func _on_buy_turret_pressed() -> void:
	Main.buy_automatic_tower_state = true


func _on_health_timeout() -> void:
	if Main.is_game_started and Main.hp < Main.hp_max:
		Main.hp += 1
		$Brain.health_anim()


func _on_button_max_hp_pressed() -> void:
	if Main.money >= Main.stats_hp_max_price:
		Main.money -= Main.stats_hp_max_price
		Main.hp_max += 1
		Main.hp += 1
		$MaxHP.text = "HP: " + str(Main.hp_max)
		$HP.max_value = Main.hp_max
		$HP.value = Main.hp
		Main.stats_hp_max_price += 10
		$MaxHP/Price.text = "$" + str(Main.stats_hp_max_price)


func _on_button_bullet_velocity_pressed() -> void:
	if Main.money >= Main.stats_bullet_velocity_price:
		Main.money -= Main.stats_bullet_velocity_price
		Main.stats_bullet_velocity_price += 10
		$BulletVelocity/Price.text = "$" + str(Main.stats_bullet_velocity_price)
		$Paddle/FireTimer.wait_time = clamp(
			$Paddle/FireTimer.wait_time - 0.1,
			0.2,
			1
		)
		Main.stats_bullet_velocity = $Paddle/FireTimer.wait_time
		$BulletVelocity.text = "Velocity: " + str($Paddle/FireTimer.wait_time)


func _on_button_bullet_damage_pressed() -> void:
	if Main.money >= Main.stats_bullet_damage_price:
		Main.money -= Main.stats_bullet_damage_price
		Main.stats_bullet_damage_price += 45
		$BulletDamage/Price.text = "$" + str(Main.stats_bullet_damage_price)
		Main.stats_bullet_damage += 1
		$BulletDamage.text = "Damage: " + str(Main.stats_bullet_damage)


func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "SHOW":
		var towers = get_tree().get_nodes_in_group("Tower")
		for tower in towers:
			tower.show()
			await get_tree().create_timer(0.15).timeout
		
		Main.is_game_started = true
	elif anim_name == "GAME_OVER":
		var data = DataManager.persistence.data
		
		if not data.has("SCORE"):
			data["SCORE"] = Main.score
			DataManager.persistence.save()
		else:
			if data["SCORE"] < Main.score:
				data["SCORE"] = Main.score
				DataManager.persistence.save()
		
		Main.reset_values()
		Transition.change_scene_to_file("res://game/main_screens/main_menu/main_menu.tscn")

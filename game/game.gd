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


func create_zombie():
	var zombie_inst = ZOMBIE.instantiate()
	zombie_inst.global_position.x = randi_range(0 + 50, 640 - 50)
	zombie_inst.global_position.y = -50
	add_child(zombie_inst)


func _on_hp_changed(new_value):
	$HP.value = new_value


func _on_timer_timeout() -> void:
	create_zombie()
	$Timer.wait_time = clamp($Timer.wait_time - Main.difficulty / 16, 1, 5)


func _on_score_added():
	$Score.text = "Score: " + str(Main.score)


func _on_money_added():
	$Money.text = "Money: " + str(Main.money)
	
	if Main.money >= Main.price_automatic_tower:
		$BuyTurret.show()
	else:
		$BuyTurret.hide()
	
	if Main.money >= Main.stats_hp_max_price:
		$MaxHP/ButtonMaxHP.disabled = false
	else:
		$MaxHP/ButtonMaxHP.disabled = true

	if Main.money >= Main.stats_bullet_velocity_price:
		$BulletVelocity/ButtonBulletVelocity.disabled = false
	else:
		$BulletVelocity/ButtonBulletVelocity.disabled = true


func _on_price_automatic_tower_changed(new_value):
	$BuyTurret/TurretValue.text = str(new_value)


func _on_difficulty_timeout() -> void:
	Main.difficulty += 0.5


func _on_buy_turret_pressed() -> void:
	Main.buy_automatic_tower_state = true


func _on_health_timeout() -> void:
	if Main.hp < Main.hp_max:
		Main.hp += 1


func _on_button_max_hp_pressed() -> void:
	if Main.money >= Main.stats_hp_max_price:
		Main.money -= Main.stats_hp_max_price
		Main.hp_max += 1
		$MaxHP.text = "Max HP: " + str(Main.hp_max)
		$HP.max_value = Main.hp_max
		Main.stats_hp_max_price += 10
		$MaxHP/Price.text = "$" + str(Main.stats_hp_max_price)


func _on_button_bullet_velocity_pressed() -> void:
	if Main.money >= Main.stats_bullet_velocity_price:
		Main.money -= Main.stats_bullet_velocity_price
		Main.stats_bullet_velocity_price += 10
		$BulletVelocity/Price.text = "$" + str(Main.stats_bullet_velocity_price)
		$Paddle/FireTimer.wait_time -= 0.4
		Main.stats_bullet_velocity = $Paddle/FireTimer.wait_time
		$BulletVelocity.text = "Bullet Velocity: " + str($Paddle/FireTimer.wait_time)

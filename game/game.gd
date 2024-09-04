extends Node2D

const ZOMBIE = preload("res://game/enemies/zombies/zombie.tscn")


func _ready() -> void:
	randomize()
	
	Signals.money_added.connect(_on_money_added)
	Signals.score_added.connect(_on_score_added)


func create_zombie():
	var zombie_inst = ZOMBIE.instantiate()
	zombie_inst.global_position.x = randi_range(0 + 50, 640 - 50)
	zombie_inst.global_position.y = -50
	add_child(zombie_inst)


func _on_timer_timeout() -> void:
	create_zombie()
	$Timer.wait_time = clamp($Timer.wait_time - Main.difficulty / 16, 1, 5)


func _on_money_added():
	$Score.text = "Score: " + str(Main.score)


func _on_score_added():
	$Money.text = "Money: " + str(Main.money)


func _on_difficulty_timeout() -> void:
	Main.difficulty += 0.5


func _on_buy_turret_pressed() -> void:
	Signals.buy_turret.emit()

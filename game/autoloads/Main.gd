extends Node

var difficulty := 1.0

var score := 0:
	set(value):
		score = value
		Signals.score_added.emit()

var money := 0:
	set(value):
		money = value
		Signals.money_added.emit()

var buy_automatic_tower_state := false:
	set(value):
		buy_automatic_tower_state = value
		
		Signals.state_buying.emit(value)

var hp := 3:
	set(value):
		hp = value
		Signals.hp_changed.emit(hp)

var hp_max := 3:
	set(value):
		hp_max = value

var price_automatic_tower := 10:
	set(value):
		price_automatic_tower = value
		Signals.price_automatic_tower_changed.emit(value)

var stats_bullet_damage := 1
var stats_bullet_damage_price := 10

var stats_bullet_velocity := 1
var stats_bullet_velocity_price := 5

var stats_hp_max := 3
var stats_hp_max_price := 5

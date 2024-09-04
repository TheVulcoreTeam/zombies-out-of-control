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

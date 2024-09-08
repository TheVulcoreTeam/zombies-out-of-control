extends Control

func _ready() -> void:
	var data = DataManager.persistence.data
	
	if data.has("SCORE"):
		$MaxScore.show()
		$MaxScore.text = "Max Score: " + str(data["SCORE"])


func _on_start_pressed() -> void:
	Transition.change_scene_to_file("res://game/game.tscn")


func _on_credits_meta_clicked(meta: Variant) -> void:
	OS.shell_open(meta)

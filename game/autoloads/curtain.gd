extends Control

var new_scene : StringName

func change_scene_to_file(_new_scene : StringName) -> void:
	$Anim.play("SHOW")
	new_scene = _new_scene


func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "SHOW":
		get_tree().change_scene_to_file(new_scene)
		$Anim.play("HIDE")

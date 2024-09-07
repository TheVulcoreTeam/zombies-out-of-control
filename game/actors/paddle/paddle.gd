extends CharacterBody2D

const BULLET = preload("res://game/actors/bullets/normal_bullet/Bullet.tscn")

var movement_direction_x := 0
var speed := 6000

var store_global_position : Vector2


func _ready() -> void:
	store_global_position = global_position
	$FireTimer.wait_time = Main.stats_bullet_velocity


func _physics_process(delta: float) -> void:
	if Main.is_game_started:
		movement_direction_x = Input.get_axis("ui_left", "ui_right")
		velocity.x = movement_direction_x * delta * speed
		
		move_and_slide()


func _process(delta: float) -> void:
	if Main.is_game_started:
		global_position.y = store_global_position.y
		
		$CannonBase/Cannon.look_at(get_global_mouse_position())
		$CannonBase/Cannon.rotation_degrees += 90


func create_bullet():
	var bullet_inst = BULLET.instantiate()
	bullet_inst.global_position = $CannonBase/Cannon/Marker2D.global_position
	bullet_inst.direction = $CannonBase/Cannon.global_position.direction_to(get_global_mouse_position())
	
	get_parent().add_child(bullet_inst)


func paddle_dead():
	$Anim.play("DEAD")
	$Explosion.play()


func _on_cannon_animation_finished() -> void:
	$CannonBase/Cannon.frame = 0


func _on_fire_timer_timeout() -> void:
	if Main.is_game_started:
		create_bullet()
		$CannonBase/Cannon.play()

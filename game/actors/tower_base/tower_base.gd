extends StaticBody2D

const BULLET = preload("res://game/actors/bullets/normal_bullet/Bullet.tscn")

var mouse_inside := false
var automatic_tower := false:
	set(value):
		automatic_tower = value
		
		if value:
			$Sprite/Tower.show()

var targeting_an_enemy := false
var nearest_enemy
var enemies := []


func _ready() -> void:
	Signals.state_buying.connect(_on_state_buying)


func _process(delta: float) -> void:
	if automatic_tower and targeting_an_enemy:
		nearest_enemy = get_nearest()
		
		if is_instance_valid(nearest_enemy):
			$Sprite/Tower.look_at(nearest_enemy.global_position)


func _input(event: InputEvent) -> void:
	if Main.buy_automatic_tower_state and mouse_inside and event.is_action_pressed("fire"):
		create_automatic_tower()


func fire() -> void:
	if nearest_enemy:
		var bullet_inst = BULLET.instantiate()
		
		if is_instance_valid(bullet_inst) and is_instance_valid(nearest_enemy) and nearest_enemy.global_position.distance_to(bullet_inst.global_position) <= 500:
			bullet_inst.global_position = global_position
			
			var direction = bullet_inst.global_position.direction_to(nearest_enemy.global_position) as Vector2
			bullet_inst.direction = direction
		
			get_parent().add_child(bullet_inst)


func get_nearest():
	var distance := 5000.0
	
	for enemy in enemies:
		if is_instance_valid(enemy) and enemy.global_position.distance_to(self.global_position) < distance:
			distance = enemy.global_position.distance_to(self.global_position)
			nearest_enemy = enemy
	
	return nearest_enemy


func create_automatic_tower():
	automatic_tower = true
	Main.buy_automatic_tower_state = false
	Main.money -= Main.price_automatic_tower
	Main.price_automatic_tower += 15


func _on_fire_area_body_entered(body: Node2D) -> void:
	if body is Zombie:
		targeting_an_enemy = true
		enemies.append(body)


func _on_fire_area_body_exited(body: Node2D) -> void:
	if body is Zombie:
		var idx = enemies.find(body.get_parent())
		if idx != -1:
			enemies.remove_at(idx)
	
	if enemies.size() <= 0:
		targeting_an_enemy = false


func _on_fire_delay_timeout() -> void:
	fire()


func _on_mouse_inside_mouse_entered() -> void:
	mouse_inside = true


func _on_mouse_inside_mouse_exited() -> void:
	mouse_inside = false


func _on_state_buying(buyed : bool):
	if buyed and not $Sprite/Tower.visible:
		$Sprite["self_modulate"] = "green"
	else:
		$Sprite["self_modulate"] = "white"

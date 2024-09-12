extends CharacterBody2D
class_name Player

var bomb = preload("res://scenes/bomb.tscn")
var can_shoot: bool = true
var bomb_speed := 1000
@export var life = 100
var is_dead : bool = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var SPEED = 300.0
const JUMP_VELOCITY = -400.0
var jump_count = 0

func _ready() -> void:
	$ProgressBarLife.value = life

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	spawn_bomb()
	
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and jump_count == 1:
		velocity.y = JUMP_VELOCITY
		jump_count = 2
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_count = 1
		
	if !Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump_count = 0

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.flip_h = direction < 0

		if is_on_floor():
			$AnimatedSprite2D.play("run")
		else:
			$AnimatedSprite2D.play("jump")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			$AnimatedSprite2D.play("idle")
		else:
			$AnimatedSprite2D.play("jump")

	move_and_slide()

func _process(delta: float) -> void:
	bomb_position()

func bomb_position():
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - global_position).normalized()
	var angle = direction.angle()
	if angle > 0 and angle <= PI/4:
		$Bullet.position = Vector2(30, 16)
	elif angle > PI/4 and angle <= PI/2:
		$Bullet.position = Vector2(20, 45)
	elif angle > PI/2 and angle <= 3*PI/4:
		$Bullet.position = Vector2(-20, 45)
	elif angle > 3*PI/4 and angle <= PI:
		$Bullet.position = Vector2(-40, 16)
	elif angle < 0 and angle >= -PI/4:
		$Bullet.position = Vector2(30, -16)
	elif angle < -PI/4 and angle >= -PI/2:
		$Bullet.position = Vector2(20, -40)
	elif angle < -PI/2 and angle >= -3*PI/4:
		$Bullet.position = Vector2(-30, -40)
	elif angle < -3*PI/4 and angle >= -PI:
		$Bullet.position = Vector2(-40, -16)

func spawn_bomb():
	if can_shoot:
		$Sprite2DBomb.visible = true
		if Input.is_action_pressed("shoot"):

			var bomb_instance = bomb.instantiate() as RigidBody2D
			var mouse_position = get_global_mouse_position()
			var direction = (mouse_position - global_position).normalized()
			var bomb_velocity = direction * bomb_speed
			

			bomb_instance.position = $Bullet.get_global_position()

			bomb_instance.linear_velocity = bomb_velocity
			get_parent().add_child(bomb_instance)
			
			can_shoot = false
			$Sprite2DBomb.visible = false
			await get_tree().create_timer(4).timeout
			can_shoot = true
			$Sprite2DBomb.visible = true

func decrease_life(value):
	life -= value
	$ProgressBarLife.value = life
	if life == 0:
		death()

func death():
	is_dead = true
	velocity = Vector2.ZERO
	$AnimatedSprite2D.play("hit_die")
	await get_tree().create_timer(1).timeout
	$AnimatedSprite2D.play("die")
	$ProgressBarLife.visible = false
	$Sprite2DBomb.visible = false
	await get_tree().create_timer(2).timeout
	$Sprite2DBomb.visible = false
	print('me mori')

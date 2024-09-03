extends Area2D

signal hit

@export var speed = 400
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
		#print(position)
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta #suma a la posicion del player la velocidad * delta
	position = position.clamp(Vector2.ZERO, screen_size) #para que no salga del tamaño de la pantalla clamp
	
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
	# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
		

func _on_body_entered(body: Node2D) -> void:
	hide() #desaparece despues de golpearlo
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true) #si algo le pega deshabilita la colision para que no le pegue 2 veces
	
func start():
	#position = pos
	show()
	$CollisionShape2D.disabled = false
	
	

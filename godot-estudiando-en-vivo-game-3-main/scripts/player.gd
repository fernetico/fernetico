extends CharacterBody2D
class_name Player

@export var SPEED = 50.0
@export var life = 100
@export var bullet_sword_scene: PackedScene
@export var bullet_thor_scene: PackedScene
#instanciar las escenas de sword y thor para que se puedan cargar desde el inspector

var direction_player: Vector2

func _ready() -> void:
	$ProgressBar.value = life

func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	#if Input.is_action_just_pressed("ui_accept"):
		#print('espacio')
		#create_bullet()
	pass

func _physics_process(delta: float) -> void:
	
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		$AnimatedSprite2D.flip_h = direction.x < 0
		$AnimatedSprite2D.play("run")
		direction_player = direction
	else:
		velocity = Vector2(0,0)
		$AnimatedSprite2D.play("idle")

	move_and_slide()
	
func decrease_life(value):
	life -= value
	$ProgressBar.value = life
	if life == 0:
		death()

func death():
	print('me morisí')

# Alternativa #2: Esto nos sirve para destruir todo lo que esté fuera de este rango
func _on_limit_enemy_area_exited(area: Area2D) -> void:
	if area.is_in_group("enemy_group"):
		area.queue_free()
		print('enemigo eliminado por salir de los límites del player')

#renombro la escena pero para instaniar > Player > inspector > cargar > bullet_sword_scene
func create_bullet_sword():
	var bullet = bullet_sword_scene.instantiate()
	bullet.position = position
	bullet.direction_player = direction_player
	get_parent().add_child(bullet)

func _on_timer_sworm_arm_timeout() -> void:
	create_bullet_sword()
	
	
func create_bullet_thor():
	var bullet = bullet_thor_scene.instantiate()
	bullet.position = position  #la position del bullet es igual a la posicion del player
	get_parent().add_child(bullet)


func _on_timer_thor_arm_timeout() -> void: #señal echa con el timer cada 5 segundos
	create_bullet_thor()

#func _on_limit_enemy_body_entered(body: Node2D) -> void:
	#if body is Enemy:
		#pass

#func shake_camera(duration: float = 0.5, intensity: float = 10.0):
	#var original_offset = offset
	#var elapsed_time = 0.0
#
	#while elapsed_time < duration:
		#offset = original_offset + Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		#elapsed_time += get_process_delta_time()
	#
	#offset = original_offset  # Restaurar la posición original después del temblor

extends RigidBody2D
class_name Bomb

@export var damage := 25
var is_exploding: bool = false

func _ready() -> void:
	$Timer.start() #activa el timer para que empiece cuentra regresiva antes de explotar
	$Timer.timeout.connect(_on_timer_timeout)
	
	$Area2D.set_monitoring(false)
	$Area2D.body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	is_exploding = true
	linear_velocity = Vector2.ZERO
	$AnimatedSprite2D.play("explode")
	
	#activa el area2d solamente cuando esta explotando
	$Area2D.set_monitoring(true)
	
	await get_tree().create_timer(0.4).timeout
	queue_free()

func _on_body_entered(body: Node) -> void:
	if body is Player:
		body.decrease_life(damage)
		print("daño al player:", damage)

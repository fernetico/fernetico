extends RigidBody2D


func _ready() -> void:
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names() #obtenemos la lista de nombres de animación de la propiedad sprite_frames del AnimatedSprite2D
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()]) #Luego debemos tomar un número al azar entre 0 y 2 para seleccionar uno de los nombres en la lista (los índices de los array comienzan en 0). randi() % n selecciona un entero al azar entre 0 y n-1.


func _process(delta: float) -> void:
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

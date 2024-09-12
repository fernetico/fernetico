extends Node2D

@export var mob_scene: PackedScene
var score


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_player_hit() -> void:
	game_over() 

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()


func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate() #instancia la escena de mob

	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf() #elige de manera aleatoria donde aparece

	var direction = mob_spawn_location.rotation + PI / 2 #la direccion sera recta de donde sale, fuincion para hacer eso

	mob.position = mob_spawn_location.position #la posicion del mob

	direction += randf_range(-PI / 4, PI / 4) #agrega aleatoreidad a la direccion
	mob.rotation = direction

	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	add_child(mob) #spawn del mob agregandolo como hijo de main

@tool
extends Sprite2D


func calculate_aspect_ratio():
	material.set_shader_parameter("aspect_ratio", scale.y / scale.x)

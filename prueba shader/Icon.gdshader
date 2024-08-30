shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on. manipular los puntos esquinas
	VERTEX += cos(TIME) * vec2(20.0, 20.0);
	//VERTEX.y += sin(TIME) * 20.0;	
	
}

void fragment() {
	// Called for every pixel the material is visible on.
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}

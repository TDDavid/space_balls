shader_type canvas_item;

void vertex() {
	vec2 curr_ver = VERTEX;
	curr_ver.x *= clamp(sin(TIME), 0., 1.);
	curr_ver.y *= clamp(cos(TIME), 0., 1.);
	//VERTEX = curr_ver;
	UV += sin(TIME)/20.;
}

void fragment() {
	
	vec4 curr_col = texture(TEXTURE, UV); // Read from texture again.;
	curr_col.g *= sin(UV.x/2.);
	curr_col.b *= cos(UV.y/2.);
	curr_col.a = 1.;
	//COLOR = curr_col;
	
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

shader_type canvas_item;


uniform float fade_start : hint_range(0.0, 1.0) = 0.25;
uniform float fade_length : hint_range(0.0, 1.0) = 0.15;

void vertex() {
	// Called for every vertex the material is visible on.
	
}
void fragment() {
    float distance = length(UV - vec2(0.5));
    float fade = smoothstep(fade_start, fade_start + fade_length, distance);
    COLOR.a *= 1. - fade;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

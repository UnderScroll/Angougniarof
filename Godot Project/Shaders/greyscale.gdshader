shader_type canvas_item;

uniform sampler2D screen : hint_screen_texture;


void fragment() {
	vec3 c = texture(screen, SCREEN_UV, 0.0).rgb;
	float greyscale = (c.r + c.g + c.b) / 3.0f;
	COLOR.rgb = vec3(1.0) * greyscale;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

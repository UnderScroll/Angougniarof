shader_type canvas_item;

uniform sampler2D reference_image : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 reference_fragment = texture(reference_image, UV, 0.0).rgb;
	float reference_value = (reference_fragment.r + reference_fragment.g + reference_fragment.b) / 3.0f;
	
	vec4 texel = texture(TEXTURE, UV);
	float texel_value = (COLOR.r + COLOR.g + COLOR.b) / 3.0f;
	
	float diff = texel_value - reference_value;
	float normalized_diff = abs(diff);
	
	COLOR.rgb = vec3(normalized_diff);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

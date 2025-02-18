shader_type canvas_item;

uniform float cell_x = 16;
uniform float cell_y = 16;
uniform float line_width = 0.5;
uniform float pos_min = 0.1;
uniform float pos_max = 0.9;

vec2 grid(vec2 uv, float columns, float rows){
	return fract(vec2(uv.x * columns, uv.y * rows));
}

float line(vec2 p1, vec2 p2, float width, vec2 uv, float sps)
{
	float dist = distance(p1, p2); // Distance between points
	float dist_uv = distance(p1, uv); // Distance from p1 to current pixel

	// If point is on line, according to dist, it should match current UV
	// Ideally the '0.001' should be SCREEN_PIXEL_SIZE.x, but we can't use that outside of the fragment function.
	return 1.0 - floor(1.0 - (sps * width) + distance (mix(p1, p2, clamp(dist_uv / dist, 0.0, 1.0)),  uv));
}

vec2 scale(vec2 uv, float x, float y)
{
	mat2 scale = mat2(vec2(x, 0.0), vec2(0.0, y));
	
	uv -= 0.5;
	uv = uv * scale;
	uv += 0.5;
	return uv;
}

void fragment() {
	vec2 grid = grid(UV, cell_x, cell_y);
	vec2 p1 = vec2(0.5, pos_min);
	vec2 p2 = vec2(0.5, pos_max);
	vec2 p3 = vec2(pos_min, 0.5);
	vec2 p4 = vec2(pos_max, 0.5);
	
	vec3 color = vec3(line(p1,p2,line_width,grid,SCREEN_PIXEL_SIZE.x));
	color += vec3(line(p3,p4,line_width,grid,SCREEN_PIXEL_SIZE.x));
	
	COLOR = vec4(1.0-color,1.0);
	
}
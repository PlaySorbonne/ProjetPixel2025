shader_type spatial;
render_mode blend_premul_alpha, unshaded, ambient_light_disabled;

uniform sampler2D depth_texture : hint_depth_texture;
uniform int step_count : hint_range(3, 15, 2) = 3;
uniform float thickness : hint_range(1.0, 16.0, 0.1) = 3.0;
uniform vec3 edge_color : source_color = vec3(0.);
uniform float depth_sensitivity : hint_range(0.0001, 0.1, 0.0001) = 0.005;
uniform bool compensate_distance = true;

void fragment() {
	vec2 step_length = 1.0 / VIEWPORT_SIZE * thickness;
	float step_angle = TAU / float(step_count);
	float start_angle = fract(sin(dot(SCREEN_UV, vec2(12.9898, 78.233))) * 43758.5453) * TAU;
	vec2 dir = vec2(cos(start_angle), sin(start_angle));
	mat2 rot = mat2(
		vec2(cos(step_angle), -sin(step_angle)),
		vec2(sin(step_angle),  cos(step_angle)));

	float center_depth = texture(depth_texture, SCREEN_UV).r;
	float depth_diff = 0.0;
	float avg_depth = 0.0;

	for (int i = 0; i < step_count; i++) {
		vec2 uv1 = SCREEN_UV + dir * step_length;
		vec2 uv2 = SCREEN_UV - dir * step_length;
		float d1 = texture(depth_texture, uv1).r;
		float d2 = texture(depth_texture, uv2).r;
		depth_diff += abs(d1 - center_depth) + abs(d2 - center_depth);
		avg_depth += (d1 + d2) * 0.5;
		dir = rot * dir;
	}

	depth_diff /= float(step_count);
	avg_depth /= float(step_count);

	// Compensate for distance: make small depth differences more visible far away
	if (compensate_distance) {
		// Depth grows smaller (closer to 1.0) with distance; invert it
		float depth_factor = pow(1.0 - avg_depth, 0.5);
		depth_diff *= mix(1.0, 50.0, depth_factor); // tweak the 50.0 for stronger far outlines
	}

	// Convert depth difference to edge intensity
	float edge = smoothstep(depth_sensitivity, depth_sensitivity * 2.0, depth_diff);

	ALBEDO = edge_color * edge;
	ALPHA = edge;
}

shader_type spatial;


uniform vec4 highlight_color : source_color = vec4(0.0, 0.0, 1.0, 0.75);

uniform float pulse_speed = 7.0;
uniform float pulse_strength = 0.6;


void fragment() {
	float pulse = 0.5 + 0.5 * sin(TIME * pulse_speed);
	pulse = mix(1.0, pulse, pulse_strength);

	float highlight = pulse;

	vec3 color = highlight_color.rgb * highlight;

	ALBEDO = color;
	ALPHA = highlight * highlight_color.a;
}
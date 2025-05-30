shader_type spatial;
render_mode unshaded;

uniform sampler2D texture_image;

uniform mediump vec4 line_color : source_color = vec4(0.0, 0.0, 1.0, 1.0);
uniform mediump float line_width : hint_range(0, 1) = 0.005;
uniform mediump float line_blur : hint_range(0, 1) = 0.2;
uniform mediump float line_speed : hint_range(-1, 1) = 0.02;
uniform  bool straight_lines = true;

uniform mediump float interrupt_width : hint_range(0, 1) = 0.5;
uniform mediump float interrupt_blur : hint_range(0, 1) = 0.25;
uniform mediump float interrupt_speed : hint_range(-1, 1) = 0.2;

uniform mediump vec4 glow_color : source_color = vec4(0.5, 0.75, 1.0, 1.0);
uniform lowp float glow_itensity : hint_range(0, 20) = 9.5;
uniform lowp float glow_amount : hint_range(0, 20) = 4.5;
uniform lowp float flickering : hint_range(0, 1) = 0.55;

vec3 fresnel_glow(float amount, float intensity, vec3 color, vec3 normal, vec3 view) {
	return pow((1.0 - dot(normalize(normal), normalize(view))), amount) * color * intensity;
}

void fragment () {
	vec2 canvas;
	if (straight_lines) {
			canvas = SCREEN_UV;
	} else {
		canvas = vec2(VIEW.x, VIEW.y);
	}
	vec2 lines = vec2(clamp(sin((TIME * line_speed + canvas.y) / line_width), line_blur, 1.0 - line_blur), canvas.x);
	vec2 interupts = vec2(clamp(sin((TIME * interrupt_speed + canvas.y) / interrupt_width * 3.0), interrupt_blur, 1.0 - interrupt_blur), canvas.x);

	float flicker = clamp(fract(cos(TIME) * 43758.5453123), flickering, 1.0);
	vec4 imgtex = flicker * line_color * texture(texture_image, lines * interupts);
	vec3 imgtex_color = vec3(imgtex.r, imgtex.g, imgtex.b);
	vec3 fresnel_color = vec3(glow_color.r, glow_color.g, glow_color.b);
	vec3 fresnel = fresnel_glow(glow_amount, glow_itensity, fresnel_color, NORMAL, VIEW);
	ALBEDO = imgtex_color + fresnel;

	//ALBEDO = vec3(imgtex.r, imgtex.g, imgtex.b);
	EMISSION = glow_amount * vec3(glow_color.r, glow_color.g, glow_color.b);
	ALPHA = lines.x * interupts.x;
}
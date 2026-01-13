shader_type canvas_item;

/* ================= SCROLL SETTINGS ================= */

uniform float scroll_speed : hint_range(0, 2) = 0.08;
uniform float angle_degrees : hint_range(0, 360) = 45.0;
uniform float repeat_x : hint_range(0.1, 20) = 1.0;
uniform float repeat_y : hint_range(0.1, 20) = 1.0;
uniform sampler2D texture_to_scroll;

/* ================= GLITCH SETTINGS ================= */

uniform float glitch_chance : hint_range(0.0, 1.0) = 0.2;
uniform float glitch_speed = 7.0;
uniform float slice_density = 14.0;
uniform float slice_strength = 0.38;
uniform float shake_strength = 0.02;
uniform float chroma_offset = 0.016;
uniform float noise_strength = 0.2;
uniform float color_flash_strength = 0.4;
uniform float scanline_strength = 0.18;
uniform float local_warp_strength = 0.14;
uniform float flip_chance : hint_range(0.0,1.0) = 0.15;

/* ================= RANDOM ================= */

float rand(float x) { 
	return fract(sin(x * 143758.5453) * 43758.5453); 
}

float rand2(vec2 p) { 
	return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453); 
}

/* ================= FRAGMENT ================= */

void fragment() {

	/* ---------- TEXTURE SCROLL ---------- */

	float angle_rad = radians(angle_degrees);
	vec2 direction = vec2(cos(angle_rad), sin(angle_rad));

	vec2 uv = UV - (TIME * scroll_speed * direction);

	float row = fract(floor(uv.y * repeat_y) * 0.5);

	vec2 scaled_uv = vec2(
		fract(uv.x * repeat_x),
		fract(uv.y * repeat_y)
	);

	vec2 texel_size = vec2(1.0) / vec2(textureSize(texture_to_scroll, 0));
	vec2 snapped_uv = round(scaled_uv / texel_size) * texel_size;

	/* ---------- GLITCH TRIGGER ---------- */

	float glitch = step(1.0 - glitch_chance, rand(floor(TIME * glitch_speed)));

	/* ---------- SLICE EFFECT ---------- */

	float slice_id = floor(snapped_uv.y * slice_density + rand(floor(TIME)));
	float slice_rand = rand(slice_id + floor(TIME * glitch_speed));
	float slice_mask = step(0.5, slice_rand) * glitch;

	if (rand(slice_id * TIME) < flip_chance) {
		snapped_uv.x = 1.0 - snapped_uv.x;
	}

	snapped_uv.x += (slice_rand - 0.5) * slice_strength * slice_mask;

	/* ---------- MICRO JITTER ---------- */

	float jitter = step(0.85, rand(TIME * 12.0)) * glitch;
	snapped_uv.x += (rand(TIME * 3.0) - 0.5) * 0.08 * jitter;

	/* ---------- LOCAL WARP ---------- */

	float warp_zone = step(0.65, rand2(vec2(slice_id, TIME)));
	snapped_uv +=
		(vec2(rand2(snapped_uv + TIME), rand2(snapped_uv - TIME)) - 0.5)
		* local_warp_strength * warp_zone * glitch;

	/* ---------- GLOBAL SHAKE ---------- */

	snapped_uv += vec2(
		rand(TIME * 1.3) - 0.5,
		rand(TIME * 1.7) - 0.5
	) * shake_strength * glitch;

	/* ---------- BASE SAMPLE ---------- */

	vec4 base = texture(texture_to_scroll, snapped_uv);

	/* ---------- CHROMATIC SPLIT ---------- */

	float r = texture(texture_to_scroll, snapped_uv + vec2(chroma_offset * glitch, 0.0)).r;
	float b = texture(texture_to_scroll, snapped_uv - vec2(chroma_offset * glitch, 0.0)).b;
	vec3 color = vec3(r, base.g, b);

	/* ---------- DIGITAL NOISE ---------- */

	color += (rand2(snapped_uv * TIME * 1.5) - 0.5) * noise_strength * glitch;

	/* ---------- SCANLINE DROP ---------- */

	float scan = step(0.9, rand(snapped_uv.y * 100.0 + TIME * 10.0));
	color *= 1.0 - scan * scanline_strength * glitch;

	/* ---------- COLOR FLASH ---------- */

	vec3 flash_color = vec3(
		step(0.5, rand(TIME + 0.1)),
		step(0.5, rand(TIME + 3.1)),
		step(0.5, rand(TIME + 6.1))
	);

	color = mix(
		color,
		flash_color,
		rand(TIME * 4.0) * color_flash_strength * glitch
	);
	
	vec2 p = FRAGCOORD.xy - SCREEN_UV.xy / SCREEN_PIXEL_SIZE;

	COLOR = vec4(color, base.a);
}

shader_type canvas_item;

uniform vec3 core_color : source_color = vec3(1.0, 0.95, 0.85);
uniform vec3 glow_color : source_color = vec3(1.0, 0.8, 0.6);

uniform float core_radius : hint_range(0.0, 1.0) = 0.12;
uniform float glow_radius : hint_range(0.0, 1.0) = 0.45;

uniform float flare_speed : hint_range(0.0, 50.0) = 2.0;
uniform float flare_strength : hint_range(0.0, 1.0) = 0.25;

// UV location of the star (0–1 in texture space)
uniform vec2 star_center = vec2(0.5, 0.5);

void fragment() {
	vec2 uv = UV - star_center;
	
	float dist = length(uv);
	
	// --- Core glow ---
	float core = exp(-pow(dist / core_radius, 2.0));
	
	// --- Outer glow ---
	float glow = exp(-pow(dist / glow_radius, 2.0));
	
	// --- Animated flaring effect ---
	float flare = 1.0 + flare_strength * sin(TIME * flare_speed);
	
	vec3 color = core * core_color * flare +
				glow * glow_color * (0.6 * flare);
	
	COLOR = vec4(color, glow); // fade out alpha with glow
}

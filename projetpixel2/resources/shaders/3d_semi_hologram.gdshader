shader_type spatial;
render_mode unshaded, cull_disabled, depth_draw_always;

uniform float point_size : hint_range(0.001, 0.1) = 0.02;
uniform vec4 point_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform bool animate = false;
uniform float time_scale = 1.0;
uniform float jitter_strength = 0.02;

void vertex() {
    // Optional: add some motion or randomness
    if (animate) {
        float t = TIME * time_scale;
        vec3 jitter = vec3(
            sin(VERTEX.x * 13.0 + t),
            cos(VERTEX.y * 17.0 + t),
            sin(VERTEX.z * 19.0 + t)
        ) * jitter_strength;
        VERTEX += jitter;
    }

    //POINT_SIZE = point_size * 100.0;
	VERTEX += NORMAL * 0.001;
}

void fragment() {
    // Draw points as if each fragment is part of a small glowing sphere
    vec2 uv = FRAGCOORD.xy / VIEWPORT_SIZE;
    vec2 center = vec2(0.5);
    float dist = length(UV - center);
    
    // Circular falloff to make round points
    float alpha = smoothstep(point_size, point_size * 0.5, dist);
    ALBEDO = point_color.rgb;
    ALPHA = 1.0 - alpha - 0.5;
}

void light() {
    // Disable default lighting
}

// Godot 4.x spatial post-process shader – Imphenzia-style cavity shading
shader_type spatial;
render_mode unshaded;

// === Blender-like Cavity Parameters ===
uniform float world_ridge_strength : hint_range(0.0, 8.0) = 2.5;
uniform float world_valley_strength : hint_range(0.0, 8.0) = 2.5;
uniform float screen_ridge_strength : hint_range(0.0, 8.0) = 2.0;
uniform float screen_valley_strength : hint_range(0.0, 8.0) = 2.0;

uniform float ridge_brightness = 0.15;
uniform float valley_darkness = 0.45;
uniform float cavity_contrast = 1.3;

uniform float sample_radius = 1.0;
uniform float depth_sensitivity = 1.0;
uniform float normal_sensitivity = 1.0;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;
uniform sampler2D NORMAL_TEXTURE : hint_normal, filter_linear_mipmap;

// Convert non-linear depth to linear view-space depth
float linearize_depth(float d) {
    float zNear = 0.1;
    float zFar = 100.0;
    return zNear * zFar / (zFar - d * (zFar - zNear));
}

void fragment() {
    vec2 uv = SCREEN_UV;
    vec4 base_col = texture(SCREEN_TEXTURE, uv);

    float depth_center = texture(DEPTH_TEXTURE, uv).r;
    vec3 normal_center = texture(NORMAL_TEXTURE, uv).rgb * 2.0 - 1.0;

    float cavity = 0.0;
    float accum = 0.0;

    vec2 offsets[8] = vec2[](
        vec2(1, 0), vec2(-1, 0),
        vec2(0, 1), vec2(0, -1),
        vec2(1, 1), vec2(-1, 1),
        vec2(1, -1), vec2(-1, -1)
    );

    vec2 texel = 1.0 / vec2(textureSize(SCREEN_TEXTURE, 0));

    for (int i = 0; i < 8; i++) {
        vec2 offset_uv = uv + offsets[i] * sample_radius * texel;

        float d_sample = texture(DEPTH_TEXTURE, offset_uv).r;
        vec3 n_sample = texture(NORMAL_TEXTURE, offset_uv).rgb * 2.0 - 1.0;

        // --- World-space cavity (depth-based) ---
        float depth_diff = (depth_center - d_sample) * depth_sensitivity;
        float ridge = smoothstep(0.0, 0.005, depth_diff);
        float valley = smoothstep(0.0, -0.005, depth_diff);

        // --- Screen-space cavity (normal-based) ---
        float n_diff = dot(normal_center, n_sample);
        float n_ridge = 1.0 - smoothstep(0.8, 1.0, n_diff);
        float n_valley = smoothstep(0.8, 1.0, n_diff);

        float world_cavity = world_ridge_strength * ridge - world_valley_strength * valley;
        float screen_cavity = screen_ridge_strength * n_ridge - screen_valley_strength * n_valley;

        cavity += (world_cavity + screen_cavity);
        accum += 1.0;
    }

    cavity = (cavity / accum) * cavity_contrast;

    float ridge_effect = max(cavity, 0.0) * ridge_brightness;
    float valley_effect = max(-cavity, 0.0) * valley_darkness;

    vec3 final_col = base_col.rgb * (1.0 - valley_effect) + ridge_effect;

    ALBEDO = final_col;
}

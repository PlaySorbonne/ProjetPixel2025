shader_type canvas_item;

uniform float speed = 2.0;
uniform float glow_strength = 1.5;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    float glow = (cos(TIME * speed) + 1.0) * 0.5; // normalize to 0..1
    glow *= glow_strength;

    COLOR = tex * (1.0 + glow);
}
shader_type canvas_item;

uniform float speed = 15.0;
uniform float glow_strength = 0.25;

void fragment() {
    vec3 tex = texture(TEXTURE, UV).rgb;
    float glow = ((cos(TIME * speed) + 1.0) * 0.5) * glow_strength; 
    COLOR.rgb = (tex * (1.0 + glow));
}
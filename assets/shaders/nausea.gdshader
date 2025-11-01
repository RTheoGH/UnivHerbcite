shader_type canvas_item;
render_mode blend_mix, unshaded;

uniform float strength : hint_range(0.0, 1.0) = 0.0;
uniform float time_speed = 3.0;

void fragment() {
	vec2 uv = UV;
    uv.x += sin(TIME * time_speed + uv.y * 20.0) * 0.02 * strength;
    uv.y += cos(TIME * time_speed + uv.x * 10.0) * 0.02 * strength;

    vec4 col = texture(TEXTURE, uv);
    if (col.a == 0.0) col = vec4(0.0, 0.0, 0.0, 1.0);
    COLOR = col;
}
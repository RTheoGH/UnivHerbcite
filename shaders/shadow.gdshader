shader_type canvas_item;

uniform vec2 offset_ = vec2(-0.01, -0.04);
uniform float time_effect: hint_range(0.0, 1.0, 0.05);
void fragment() {
	vec2 offset = offset_  * (vec2(1.0) - vec2(sin(TIME / 1.0), cos(TIME / 1.0)) * time_effect);
	// Read screen texture
	vec4 current_color = texture(TEXTURE, UV);
	if (current_color.a == 0.0){
		vec4 offset_color = texture(TEXTURE, UV + offset);
		if (offset_color.a != 0.0){
			//COLOR = vec4(0, 0, 0, 1);
			COLOR = offset_color - vec4(0.6, 0.6, 0.6, 0);
		}
		offset_color = texture(TEXTURE, UV - offset / 2.0);
		if (offset_color.a != 0.0){
			//COLOR = vec4(1, 1, 1, 0.5);
			COLOR = offset_color + vec4(0.2, 0.2, 0.2, 1);
		}
	}else{
		COLOR = current_color;
	}
}
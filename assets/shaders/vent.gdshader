shader_type spatial;

uniform float strength : hint_range(0.0, 2.0) = 0.5;
uniform float speed : hint_range(0.0, 5.0) = 1.0;
uniform vec3 direction = vec3(1.0, 0.0, 0.3);

uniform float wiggle_strength : hint_range(0.0, 2.0) = 1.0;
uniform float wiggle_speed : hint_range(0.0, 10.0) = 5.0;

uniform float global_wind;
uniform sampler2D tex;

void vertex() {
	vec3 dir = normalize(direction);
	
	float t = TIME * speed * global_wind;
	float wave = sin((VERTEX.x + VERTEX.z) * 0.1 + t) * 0.5 + 0.5;
	
	float f = clamp(VERTEX.y,0.0,1.0);
	float wiggle = sin(t * wiggle_speed + VERTEX.x * 2.0) * wiggle_strength * f;
	
	vec3 wind_offset = dir * wave * strength;
	VERTEX += wind_offset;
	VERTEX.y += wiggle * 0.05;
}

void fragment() {
	vec4 tex_color = texture(tex, UV);
	ALBEDO = tex_color.rgb;
	ALPHA = tex_color.a;
}


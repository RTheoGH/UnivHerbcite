// NOTE: Shader automatically converted from Godot Engine 4.5.stable's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;
uniform ivec2 albedo_texture_size;
uniform float point_size : hint_range(0.1, 128.0, 0.1);

uniform float roughness : hint_range(0.0, 1.0);
uniform sampler2D texture_metallic : hint_default_white, filter_linear_mipmap, repeat_enable;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_roughness_r, filter_linear_mipmap, repeat_enable;

uniform float specular : hint_range(0.0, 1.0, 0.01);
uniform float metallic : hint_range(0.0, 1.0, 0.01);

uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

uniform float coeff;
uniform float plus_haut = 1.0;
uniform float g : hint_range(0.0, 2.0) = 1.0;

varying float h;

global uniform float strength : hint_range(0.0, 2.0);
global uniform float speed : hint_range(0.0, 5.0);
global uniform vec3 direction;

uniform float wiggle_strength : hint_range(0.0, 2.0) = 2.0;
uniform float wiggle_speed : hint_range(0.0, 10.0) = 10.0;

global uniform float global_wind;

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

void vertex() {
	vec3 world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	vec3 dir = normalize(direction);

	float t = TIME * speed * global_wind;

	float rnd = hash(world_pos.xz);
	t += rnd * 10.0;

	float wave = sin(dot(world_pos.xz, vec2(0.1,0.13)) + t) * 0.5 + 0.5;
	wave = pow(wave, 1.5);

	float f = clamp(VERTEX.y / plus_haut,0.0,1.0);
	f = pow(f, 0.33);

	float wiggle = sin(t * wiggle_speed + rnd * 2.0) * wiggle_strength * f;

	vec3 wind_offset = dir * wave * strength;
	wind_offset.y = wiggle * 0.05;

	mat3 inv = inverse(mat3(MODEL_MATRIX));
	vec3 wind_local = inv * wind_offset;

	VERTEX += wind_local;

	UV = UV * uv1_scale.xy + uv1_offset.xy;
	h = (MODEL_MATRIX * vec4(VERTEX,1.0)).y;
}

void fragment() {
	vec2 base_uv = UV;


	vec4 albedo_tex = texture(texture_albedo, base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;

	float height_f = pow(clamp((h + plus_haut) * 0.5, 0.0, 1.0),2.0);
	float gradient = mix(0.25,1.0,height_f * g);

	ALBEDO *= gradient;
	//ALBEDO = vec3(h);

	float metallic_tex = dot(texture(texture_metallic, base_uv), metallic_texture_channel);
	METALLIC = metallic_tex * metallic;
	SPECULAR = specular;

	vec4 roughness_texture_channel = vec4(1.0, 0.0, 0.0, 0.0);
	float roughness_tex = dot(texture(texture_roughness, base_uv), roughness_texture_channel);
	ROUGHNESS = roughness_tex * roughness;
	ALPHA *= albedo.a * albedo_tex.a;
}

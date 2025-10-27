shader_type spatial;
render_mode fog_disabled;
uniform sampler2D source_panorama : filter_linear, hint_default_black;
void vertex() {
	// Called for every vertex the material is visible on.
}

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}

void fragment()
{
	FOG = -FOG;
	vec2 noise = (texture(source_panorama, UV + (TIME / 50.0)).rg - 0.5) * 10.0;

	vec3 base_color = vec3(0.0, 0.0, 0.1);
	float basic_fresnel = noise.x * (fresnel(1.5, NORMAL, VIEW));
	float alpha_fresnel = noise.x * (fresnel(3.1, NORMAL, VIEW));

	EMISSION = base_color + vec3(1.0, 0.0, 0.0) * basic_fresnel;
	//ALPHA = 1.0-alpha_fresnel;
	ROUGHNESS = 0.0;
	ALBEDO = noise.y * base_color;
}


//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}

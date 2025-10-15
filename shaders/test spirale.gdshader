shader_type canvas_item;

uniform sampler2D screen_tex : hint_screen_texture;
uniform sampler2D rect_tex : source_color;
uniform float progression = -0.001;
uniform sampler2D gradient_order : filter_nearest;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	//COLOR = texture(screen_tex, SCREEN_UV);
	COLOR = texture(TEXTURE, UV);
	float grad = texture(gradient_order, UV).r;

	if(progression > grad){
		COLOR = texture(screen_tex, SCREEN_UV);
	}


}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

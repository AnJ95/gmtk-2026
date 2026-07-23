shader_type canvas_item;
uniform sampler2D screen : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	vec4 color = texture(screen, UV);
	for (int i = 0; i < 4; i++) {
		color[i] = trunc(3.0 * color[i]) / 3.0;
	}
	
	COLOR = color ;
}

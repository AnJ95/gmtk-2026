shader_type canvas_item;

void fragment() {
	float noise = clamp(fract(sin(dot(UV, vec2(12.9898, 7.8233*trunc(mod(TIME*10.0,20.0))))) * 43758.5453) - 0.5, 0.0, 1.0) * 2.0;

	for (int i = 0; i < 4; i++) {
		COLOR[i] = noise;
	}
	
	COLOR = color ;
}

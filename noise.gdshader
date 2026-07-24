shader_type canvas_item;

void fragment() {
	float noise = fract(sin(dot(UV, vec2(12.9898, 7.8233*trunc(mod(TIME*10.0,20.0))))) * 43758.5453);
	if (noise > 0.75) {
		COLOR = vec4(0.6,0,0,1);
	} else if (noise > 0.5) {
		COLOR = vec4(0,0.6,0,1);
	} else if (noise > 0.25) {
		COLOR = vec4(0,0,0.6,1);
	} else {
		COLOR = vec4(0.6,0.6,0.6,1);
	}
}

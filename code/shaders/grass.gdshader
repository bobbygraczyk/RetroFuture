shader_type spatial;
render_mode cull_disabled;

uniform sampler2D splat : source_color;
uniform vec4 top_color : source_color;
uniform vec4 bottom_color : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = top_color.rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}

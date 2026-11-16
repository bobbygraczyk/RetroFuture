shader_type spatial;

uniform sampler2D splat;
uniform vec4 grass_color : source_color;
uniform vec4 dirt_color : source_color;
uniform vec4 rock_color : source_color;
uniform vec4 grass_index_color : source_color;
uniform vec3 size;
uniform vec3 start;

varying float v_normal; 
varying vec3 loc;

void vertex() {
	v_normal = smoothstep(0.75, 0.95, NORMAL.y);
	loc = VERTEX / size;
}

void fragment() {
	vec4 splat_color = texture(splat, vec2(loc.x, loc.z));
	vec4 base_color = mix(dirt_color, grass_color, splat_color.a);
	ALBEDO = mix(rock_color, base_color, v_normal).rgb;
}

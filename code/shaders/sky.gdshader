shader_type sky;

uniform vec3 top_color : source_color = vec3(0.1, 0.4, 0.8);
uniform vec3 bottom_color : source_color = vec3(0.6, 0.8, 1.0);

void sky() {
    // EYEDIR.y goes from -1.0 (bottom) to 1.0 (top)
    float horizon = clamp(EYEDIR.y, 0.0, 1.0);
    COLOR = mix(bottom_color, top_color, horizon);
}
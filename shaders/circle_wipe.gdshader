shader_type canvas_item;

// White circle wipe. Cover: white fills inside a growing circle (screen goes white).
// Reveal (invert=1): white fills OUTSIDE the circle, so a growing hole irises the scene back in.
// aspect = viewport width / height keeps the circle round on 16:9.

uniform float radius = 0.0;
uniform vec2 center = vec2(0.5, 0.5);
uniform float invert = 0.0;
uniform float aspect = 1.777;

void fragment() {
	vec2 d = UV - center;
	d.x *= aspect;
	float inside = step(length(d), radius);
	COLOR = vec4(1.0, 1.0, 1.0, mix(inside, 1.0 - inside, invert));
}

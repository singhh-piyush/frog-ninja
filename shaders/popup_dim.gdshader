shader_type canvas_item;

// Backdrop for the in-game popups (pause / death / win / level-complete). Inside a circle that
// irises out from a point (same radius/center/aspect driver as circle_wipe.gdshader via PopupWipe)
// it blurs and lightly dims the frozen game behind it; outside the circle the game shows crisp.
// `tint` is the dim colour+strength, `blur` the spread in screen pixels.

uniform sampler2D screen_tex : hint_screen_texture, filter_linear_mipmap;
uniform float radius = 0.0;
uniform vec2 center = vec2(0.5, 0.5);
uniform float invert = 0.0;          // unused here; kept for API parity with circle_wipe
uniform float aspect = 1.777;
uniform vec4 tint : source_color = vec4(0.0, 0.0, 0.0, 0.3);
uniform float blur = 3.5;            // blur spread in screen pixels

vec3 blur_sample(vec2 uv, vec2 px) {
	// 13-tap: a 3x3 box at radius `px` plus an outer ring at 2*`px` for a wider, smoother blur.
	vec3 c = texture(screen_tex, uv).rgb * 4.0;
	c += texture(screen_tex, uv + vec2(-px.x, 0.0)).rgb * 2.0;
	c += texture(screen_tex, uv + vec2( px.x, 0.0)).rgb * 2.0;
	c += texture(screen_tex, uv + vec2(0.0, -px.y)).rgb * 2.0;
	c += texture(screen_tex, uv + vec2(0.0,  px.y)).rgb * 2.0;
	c += texture(screen_tex, uv + vec2(-px.x, -px.y)).rgb;
	c += texture(screen_tex, uv + vec2( px.x, -px.y)).rgb;
	c += texture(screen_tex, uv + vec2(-px.x,  px.y)).rgb;
	c += texture(screen_tex, uv + vec2( px.x,  px.y)).rgb;
	c += texture(screen_tex, uv + vec2(-2.0 * px.x, 0.0)).rgb;
	c += texture(screen_tex, uv + vec2( 2.0 * px.x, 0.0)).rgb;
	c += texture(screen_tex, uv + vec2(0.0, -2.0 * px.y)).rgb;
	c += texture(screen_tex, uv + vec2(0.0,  2.0 * px.y)).rgb;
	return c / 20.0;
}

void fragment() {
	vec2 d = UV - center;
	d.x *= aspect;
	float inside = step(length(d), radius);
	vec3 g = blur_sample(SCREEN_UV, SCREEN_PIXEL_SIZE * blur);
	vec3 dimmed = mix(g, tint.rgb, tint.a);
	COLOR = vec4(dimmed, inside);
}

shader_type spatial;

uniform sampler2D camera_y;
uniform sampler2D camera_CbCr;

uniform bool flip_horz = false;
uniform bool flip_vert = false;

void vertex() {
	if (flip_horz) {
		UV.x = 1.0 - UV.x;
	}
	if (flip_vert) {
		UV.y = 1.0 - UV.y;
	}
}

void fragment() {
	vec3 color;
	color.r = texture(camera_y, UV).r;
	color.gb = texture(camera_CbCr, UV).rg - vec2(0.5, 0.5);
	
	// YCbCr -> SRGB conversion
	// Using BT.709 which is the standard for HDTV
	color.rgb = mat3(
						vec3(1.00000, 1.00000, 1.00000),
						vec3(0.00000, -0.18732, 1.85560),
						vec3(1.57481, -0.46813, 0.00000)) *
				color.rgb;
	
	ALBEDO = color;	
}
shader_type spatial;

void fragment() {
	ALBEDO = vec3(0.0, 0.0, 0.0);
	ALPHA = 0.5;
}

void light() {
	DIFFUSE_LIGHT = ALBEDO;
	float a = clamp(1.0 - length(ATTENUATION), 0.0, 1.0) * 0.75;
	if (a < 0.1) {
		discard;
	}
}

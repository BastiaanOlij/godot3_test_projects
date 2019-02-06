shader_type spatial;
render_mode blend_mix, cull_back;

// Many many many many thanks to Bzztbomb for this!

void fragment() {
	ALBEDO = vec3(0.0, 0.0, 0.0);
	ALPHA = 0.1;
	ROUGHNESS = 0.0;
	METALLIC = 1.0;
}


void light() {
	DIFFUSE_LIGHT = DIFFUSE_LIGHT;
	ALPHA = clamp(1.0 - length(ATTENUATION), 0.0, 1.0) * 0.75;
	if (ALPHA < 0.1) {
		discard;
	}
}


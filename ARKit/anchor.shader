shader_type spatial;
render_mode cull_disabled;
uniform vec4 albedo : hint_color;
uniform float specular : hint_range(0,1);
uniform float metallic : hint_range(0,1);
uniform float roughness : hint_range(0,1);

void fragment() {
	ALBEDO = albedo.rgb;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = specular;
	ALPHA = 1.0;
}

void light() {
	DIFFUSE_LIGHT = ALBEDO;
	ALPHA = min(ALPHA, clamp(1.0 - length(ATTENUATION), 0.0, 1.0));
}

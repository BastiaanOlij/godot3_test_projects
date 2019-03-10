extends ARVRAnchor

export (Material) var material = null setget set_material, get_material

func set_material(p_new_material):
	material = p_new_material
	if is_inside_tree() and $MeshInstance.mesh:
		$MeshInstance.set_surface_material(0, material)

func get_material():
	return material

func _on_ARVRAnchor_mesh_updated(mesh):
	if mesh:
		# update our mesh
		$MeshInstance.mesh = mesh
		$MeshInstance.set_surface_material(0, material)
		$MeshInstance.visible = true
		
		# update our collision shape
		$StaticBody/CollisionShape.shape = mesh.create_trimesh_shape()
		$StaticBody/CollisionShape.disabled = false
	else:
		$MeshInstance.visible = false
		$StaticBody/CollisionShape.disabled = true
		
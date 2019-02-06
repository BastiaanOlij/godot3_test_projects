extends ARVRAnchor

var material = null

func _ready():
	material = $MeshInstance.get_surface_material(0)

func _on_ARVRAnchor_mesh_updated(mesh):
	# update our mesh
	$MeshInstance.mesh = mesh
	
	# update our collision shape
	$StaticBody/CollisionShape.shape = mesh.create_trimesh_shape()
	
	# reapply our material
	$MeshInstance.set_surface_material(0, material)
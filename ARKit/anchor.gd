extends ARVRAnchor

var material = null

func _ready():
	material = $MeshInstance.get_surface_material(0)

func _on_ARVRAnchor_mesh_updated(mesh):
	$MeshInstance.mesh = mesh
	
	# reapply our material
	$MeshInstance.set_surface_material(0, material)
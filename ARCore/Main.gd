extends Spatial

# ARCore test project, at this stage we are not using our camera as a background yet
# ARCore isn't initialising but if it was we should get spatial tracking after the user
# moves his/her phone around and we should have the spinning cube anchored in real space.
# That gives us our starting point...

var angle = 0;
var permissions = null
var interface = null

# Called when the node enters the scene tree for the first time.
func _ready():
	# This code should be moved into our ARCore interface.
	# It should handle the permissions
	# Then we can do our normal ARVR initialise logic instead of doing it in _process
	if Engine.has_singleton("AndroidPermissions"):
		permissions = Engine.get_singleton("AndroidPermissions")
		permissions.init(get_instance_id(), false)
		
		$Info.text = $Info.text + "Asking for camera permissions\n"
		
		permissions.requestCameraPermission()
	else:
		$Info.text = $Info.text + "Couldn't get android permissions\n"

# Called when a request dialog is finished
func _on_request_permission_result(request_code, permissions, granted):
	if granted:
		$Info.text = $Info.text + "Request code: " + str(request_code) + " granted\n"

func _process(delta):
	angle += delta
	$Box.transform.basis = Basis(Vector3(1.0, 1.0, 1.0).normalized(), angle)
	
	# Temporary workaround until we properly implement permissions.
	# ARCore initialisation should be in _ready
	if permissions and !interface:
		if permissions.isCameraPermissionGranted():
			interface = ARVRServer.find_interface('ARCore')
			if interface:
				if interface.initialize():
					$Info.text = $Info.text + "Started ARCore\n"
					get_viewport().arvr = true
				else:
					$Info.text = $Info.text + "Failed to start ARCore\n"
			else:
				$Info.text = $Info.text + "Failed to find ARCore\n"
	

func _on_Button_pressed():
	get_tree().quit()
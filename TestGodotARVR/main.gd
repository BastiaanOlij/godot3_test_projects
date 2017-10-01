extends Spatial

var vr_origin = null
var camera = null

var arvr_interface = null

func _ready():
	# Grab some handy nodes. 
	# Note that because Camera is inside our viewport its not based on its parents location. 
	# To improve latency our AR/VR server will automatically apply any tracking to the camera but it must
	# share the same origin location with our controllers. To implement things like teleporting change 
	# the position of vr_origin, we'll copy its location into our camera node.
	vr_origin = get_node("VR_Origin")
	camera = get_node("VR_Origin/Camera")
	
	# find an arvr interface, some day make this user selectable, for now just use the last one (likely openvr)
	if (ARVRServer.get_interface_count() > 0):
		arvr_interface = ARVRServer.get_interface(ARVRServer.get_interface_count() - 1)
#		arvr_interface = ARVRServer.get_interface(0)
		if (arvr_interface.initialize()):
			# set viewport to VR mode, our ar/vr server will be in control of our output
			get_viewport().set_use_arvr(true)
			
			# work around short coming in openvr, it does not like our 16bit per color channel HDR buffers
			if arvr_interface.get_name() == 'OpenVR':
				get_viewport().hdr = false
			
			# reset to our initial reference frame. This will center our HMD to our origin point.
			# ARVRServer.request_reference_frame(true, false)
			
			$Using.text = "Using: " + arvr_interface.get_name()
		else:
			arvr_interface = null
			
	# couldn't find a VR interface?
	if (!arvr_interface):
		# set viewport to normal mode, this will make our screen work as per usual...
		get_viewport().set_use_arvr(false)
		$Using.text = "No AR/VR interface"

	set_process(true)

func _process(delta):
	# Test for escape to close application, space to reset our reference frame
	if (Input.is_key_pressed(KEY_ESCAPE)):
		get_tree().quit()
	elif (Input.is_key_pressed(KEY_SPACE)):
		ARVRServer.request_reference_frame(true, false)
	
	if (Input.is_key_pressed(KEY_LEFT)):
		vr_origin.rotation.y += delta
	elif (Input.is_key_pressed(KEY_RIGHT)):
		vr_origin.rotation.y -= delta

	if (Input.is_key_pressed(KEY_UP)):
		vr_origin.translation -= vr_origin.transform.basis.z * delta;
	elif (Input.is_key_pressed(KEY_DOWN)):
		vr_origin.translation += vr_origin.transform.basis.z * delta;
		
extends Spatial

var vr_origin = null

var arvr_interface = null

func _ready():
	# Everything is tracked in relation to our origin point.
	# Our camera and controller child nodes will automatically be repositioned.
	# For player movement outside of physical movement in the real world you minipulate the origin point.
	vr_origin = get_node("VR_Origin")
	
	# find an arvr interface, some day make this user selectable, for now just use the last one (likely openvr)
	arvr_interface = ARVRServer.find_interface("OpenVR")
	if (arvr_interface and arvr_interface.initialize()):
		# set viewport to VR mode, our ar/vr server will be in control of our output
		get_viewport().set_use_arvr(true)
		
		# work around short coming in openvr, it does not like our 16bit per color channel HDR buffers
		get_viewport().hdr = false
			
		# reset to our initial reference frame. This will center our HMD to our origin point.
		# ARVRServer.request_reference_frame(true, false)
			
		$Using.text = "Using: " + arvr_interface.get_name()
	else:
		arvr_interface = null
		
	# couldn't find a VR interface?
	if (!arvr_interface):
		# set viewport to normal mode, this will make our screen work as per usual...
		get_viewport().arvr = false
		$Using.text = "No AR/VR interface"

	set_process(true)

func _process(delta):
	# Test for escape to close application, space to reset our reference frame
	if (Input.is_key_pressed(KEY_ESCAPE)):
		get_tree().quit()
	elif (Input.is_key_pressed(KEY_SPACE)):
		# Calling center_on_hmd will cause the ARVRServer to adjust all tracking data so the player is centered on the origin point looking forward
		ARVRServer.center_on_hmd(true, true)

	# We minipulate our origin point to move around. Note that with roomscale tracking a little more then this is needed
	# because we'll rotate around our origin point, not around our player. But that is a subject for another day.
	if (Input.is_key_pressed(KEY_LEFT)):
		vr_origin.rotation.y += delta
	elif (Input.is_key_pressed(KEY_RIGHT)):
		vr_origin.rotation.y -= delta

	if (Input.is_key_pressed(KEY_UP)):
		vr_origin.translation -= vr_origin.transform.basis.z * delta;
	elif (Input.is_key_pressed(KEY_DOWN)):
		vr_origin.translation += vr_origin.transform.basis.z * delta;
		
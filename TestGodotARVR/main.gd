extends Spatial

var arvr_interface = null

func _ready():
	# find an arvr interface, some day make this user selectable, for now just use the last one (likely openvr)
	arvr_interface = ARVRServer.find_interface("OpenVR")
	if (arvr_interface and arvr_interface.initialize()):
		# set viewport to VR mode, our ar/vr server will be in control of our output
		get_viewport().set_use_arvr(true)
		
		# work around short coming in openvr, it does not like our 16bit per color channel HDR buffers
		get_viewport().hdr = false
			
		# resize our window so we see a smaller preview of our left eye
		var size = arvr_interface.get_render_targetsize() / 2.0
		OS.set_window_size(size);
			
		$Using.text = "Using: " + arvr_interface.get_name()
	else:
		arvr_interface = null
		
	# couldn't find a VR interface?
	if (!arvr_interface):
		# set viewport to normal mode, this will make our screen work as per usual...
		get_viewport().arvr = false
		$Using.text = "No AR/VR interface"

func _process(delta):
	# Test for escape to close application, space to reset our reference frame
	if (Input.is_key_pressed(KEY_ESCAPE)):
		get_tree().quit()

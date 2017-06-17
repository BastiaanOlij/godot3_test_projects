extends Spatial

var vr_origin = null
var camera = null

var arvr_interface = null
var vive_controller = preload("res://Controllers/vive_controller/vive_controller.tscn")

func tracker_disconnected(p_name):
	if (vr_origin.has_node(p_name)):
		var controller = vr_origin.get_node(p_name)
		vr_origin.remove_child(controller)

func resize():
	var os_size = OS.get_window_size()
	# nothing left to do here, all handled inside of our ar/vr server :)

func _ready():
	# Grab some handy nodes. 
	# Note that because Camera is inside our viewport its not based on its parents location. 
	# To improve latency our AR/VR server will automatically apply any tracking to the camera but it must
	# share the same origin location with our controllers. To implement things like teleporting change 
	# the position of vr_origin, we'll copy its location into our camera node.
	vr_origin = get_node("VR_Origin")
	camera = get_node("VR_Origin/Camera")
	
	# We need to bind to our signal for removing trackers, we will handle adding trackers in our process
	ArVrServer.connect("tracker_removed", self, "tracker_disconnected")
	
	# find an arvr interface, some day make this user selectable, for now just use the last one (likely openvr)
	if (ArVrServer.get_interface_count() > 0):
		arvr_interface = ArVrServer.get_interface(ArVrServer.get_interface_count() - 1)
		if (arvr_interface.initialize()):
			# set viewport to VR mode, our ar/vr server will be in control of our output
			get_viewport().set_use_arvr(true)
			
			$Using.text = "Using: " + arvr_interface.get_name()
		else:
			arvr_interface = null
			
	# couldn't find a VR interface?
	if (!arvr_interface):
		# set viewport to normal mode, this will make our screen work as per usual...
		get_viewport().set_use_arvr(false)
		$Using.text = "No AR/VR interface"
		camera.translation = Vector3(0.0, 1.85, 0.0)

	# size our viewport for the first time 
	resize()
	get_node("/root").connect("size_changed", self, "resize")
	
	set_process(true)

func _process(delta):
	var text = ""

		# Test for escape to close application
	if (Input.is_key_pressed(KEY_ESCAPE)):
		get_tree().quit()
	
	# Need to handle controllers, note that we'll add some handy spatial nodes soon that allow you to automate some of this..
	var idx = 0
	while (idx < ArVrServer.get_tracker_count()):
		var tracker = ArVrServer.get_tracker(idx)
		if (tracker.get_type() == ArVrServer.TRACKER_HMD):
			# we no longer apply the tracker to our node
			
			# we do however check if we have location tracking
			if (tracker.get_tracks_position()):
				# our position tracking will deal with this
				camera.translation = Vector3(0.0, 0.0, 0.0)
			else:
				camera.translation = Vector3(0.0, 1.85, 0.0)
		elif (tracker.get_type() == ArVrServer.TRACKER_CONTROLLER):
			var name = tracker.get_name()
			var controller = null
			if (vr_origin.has_node(name)):
				controller = vr_origin.get_node(name)
			else:
				controller = vive_controller.instance()
				controller.set_name(name)
				controller.set_joy_id(tracker.get_joy_id())
				vr_origin.add_child(controller)
			
			var tform = controller.get_transform()

			# apply orientation
			if (tracker.get_tracks_orientation()):
				tform.basis = tracker.get_orientation()
				
			# apply positioning
			if (tracker.get_tracks_position()):
				tform.origin = tracker.get_position()
			
			text += name + " transform: " + str(tform) + "\n"
			
			controller.set_transform(tform)
		idx = idx + 1
	
	# Now that we've updated all the locations of our controllers we can implement some game logic around it....
	# not in this demo though, well not yet ;)
		
	# debugging....
#	$DebugText.set_text(text)
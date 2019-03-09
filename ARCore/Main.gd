extends Spatial

# ARCore test project, at this stage we are not using our camera as a background yet
# ARCore isn't initialising but if it was we should get spatial tracking after the user
# moves his/her phone around and we should have the spinning cube anchored in real space.
# That gives us our starting point...

export (PackedScene) var anchor_scene = null

var angle = 0;
var arcore = null

func tracker_added(tracker_name, tracker_type, tracker_id):
	if tracker_type == ARVRServer.TRACKER_ANCHOR:
		var new_anchor = anchor_scene.instance()
		
		new_anchor.tracker_id = tracker_id
		new_anchor.set_name("anchor_" + str(tracker_id))
		
		$ARVROrigin.add_child(new_anchor)

func tracker_removed(tracker_name, tracker_type, tracker_id):
	if tracker_type == ARVRServer.TRACKER_ANCHOR:
		var anchor = $ARVROrigin.get_node("anchor_" + str(tracker_id))
		if anchor:
			anchor.queue_free()

func _add_log(text):
	$Log.text = $Log.text + text + "\n"

# Called when the node enters the scene tree for the first time.
func _ready():
	# register our signals
	ARVRServer.connect("tracker_added", self, "tracker_added")
	ARVRServer.connect("tracker_removed", self, "tracker_removed")
	
	# ARCore initialisation should be in _ready
	arcore = ARVRServer.find_interface('ARCore')
	# arcore = ARVRServer.find_interface('Native mobile')
	if arcore:
		if arcore.initialize():
			# this just means we started our initialisation process successfully
			_add_log("Started ARCore")
			get_viewport().arvr = true
			
			# assign our camera
			get_viewport().get_camera().environment.background_camera_feed_id = arcore.get_camera_feed_id()
		else:
			_add_log("Failed to start ARCore")
	else:
		_add_log("Failed to find ARCore")
	
	

func _process(delta):
	angle += delta
	$Box.transform.basis = Basis(Vector3(1.0, 1.0, 1.0).normalized(), angle)	
	
	var info_text = "FPS: " + str(Engine.get_frames_per_second()) + "\n"
	
	if arcore:
		var status = arcore.get_tracking_status() 
		if status == 4:
			info_text += "Not tracking, move your device around for ARCore to detect features\n"
		elif status == 0:
			info_text += "Tracking a-ok\n"
		elif status == 1:
			info_text += "Insufficient tracking, moving your device to fast\n"
		elif status == 2:
			info_text += "Insufficient features, move further away or improve lighting conditions\n"
		else:
			info_text += "Unknown tracking status\n"
			
	$Info.text = info_text

func _on_Button_pressed():
	get_tree().quit()
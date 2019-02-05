extends Spatial

var arkit = null
var anchor = preload("res://Anchor.tscn")

func tracker_added(p_name, p_type, p_id):
	if p_type == ARVRServer.TRACKER_ANCHOR:
		var name = "anchor_" + str(p_id)
		print("Adding " + name + " (" + p_name + ")")
		
		var new_anchor = anchor.instance()
		$ARVROrigin.add_child(new_anchor)
		new_anchor.anchor_id = p_id
		new_anchor.name = name

func tracker_removed(p_name, p_type, p_id):
	if p_type == ARVRServer.TRACKER_ANCHOR:
		var name = "anchor_" + str(p_id)
		print("Removing " + name + " (" + p_name + ")")

		var old_anchor = $ARVROrigin.find_node(name, false, false)
		if old_anchor:
			$ARVROrigin.remove_child(old_anchor)
		else:
			print("Couldn't find " + name)

func _ready():
	# Register some signals we need
	ARVRServer.connect("tracker_added", self, "tracker_added")
	ARVRServer.connect("tracker_removed", self, "tracker_removed")
	
	# Called every time the node is added to the scene.
	# Initialization here
	arkit = ARVRServer.find_interface('ARKit')
	if arkit:
		print("Found ARKit")
		arkit.initialize()
		
		arkit.ar_is_anchor_detection_enabled = true
		get_node("toggle_plane_detection").set_text("Turn plane detection off")
		
		# we're doing AR :)
		get_viewport().arvr = true
		
		# can't we just set this in the environment? doesn't seem to work out of the box
		# arkit is ALWAYS 1
		$ARVROrigin/ARVRCamera.environment.background_camera_feed_id = 1
	else:
		print("Couldn't find ARKit")
		get_node("toggle_plane_detection").set_text("No ARKIT")


func _on_toggle_plane_detection():
	if arkit:
		if (arkit.ar_is_anchor_detection_enabled):
			arkit.ar_is_anchor_detection_enabled = false
			get_node("toggle_plane_detection").set_text("Turn plane detection on")
		else:
			arkit.ar_is_anchor_detection_enabled = true
			get_node("toggle_plane_detection").set_text("Turn plane detection off")
			
func _process(delta):
	var info_text = "FPS: " + str(Engine.get_frames_per_second()) + "\n"

	if arkit:
		var status = arkit.get_tracking_status() 
		if status == 4:
			info_text += "Not tracking, move your device around for ARKit to detect features\n"
		elif status == 0:
			info_text += "Tracking a-ok\n"
		elif status == 1:
			info_text += "Insufficient tracking, moving your device to fast\n"
		elif status == 2:
			info_text += "Insufficient features, move further away or improve lighting conditions\n"
		else:
			info_text += "Unknown tracking status\n"
			
	$Info.text = info_text

func _input(event):
	if event.is_class("InputEventMouseButton") and event.pressed:
		# we only check our first anchor
		for anchor in $ARVROrigin.get_children():
			if (anchor.is_class("ARVRAnchor")):
				var camera = get_node("ARVROrigin/ARVRCamera")
				var from = camera.project_ray_origin(event.position)
				var direction = camera.project_ray_normal(event.position)
			
				var plane = Plane(anchor.translation, anchor.translation + anchor.transform.basis.x, anchor.translation + anchor.transform.basis.z)
				var intersect = plane.intersects_ray(from, direction)
				if intersect:
					intersect.y += 0.01
					$GodotBalls.translation = intersect
					$GodotBalls.visible = true
				
				return
extends Spatial

var arkit = null
var anchor = preload("res://Anchor.tscn")

func tracker_added(p_name, p_type, p_id):
	if p_type == ARVRServer.TRACKER_ANCHOR:
		var name = "anchor_" + str(p_id)
		print("Adding " + name + " (" + p_name + ")")
		
		var new_anchor = anchor.instance()
		new_anchor.anchor_id = p_id
		new_anchor.name = name
		
		$ARVROrigin.add_child(new_anchor)

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
	
	# Hide our godotballs for now
	$GodotBalls.visible = false
	
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
		
		# make sure our environment is set to the right camera feed
		get_viewport().get_camera().environment.background_camera_feed_id = arkit.get_camera_feed_id()
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
		var camera = get_node("ARVROrigin/ARVRCamera")
		var space = camera.get_world().get_space()
		var state = PhysicsServer.space_get_direct_state(space)
		
		var from = camera.project_ray_origin(event.position)
		var direction = camera.project_ray_normal(event.position)
		
		var result = state.intersect_ray(from, from + (direction * 100.0))
		if !result.empty():
			var transform = Transform()
			
			# position at our intersection point
			transform.origin = result["position"]
			
			# and apply to our godot balls
			$GodotBalls.global_transform = transform
			$GodotBalls.visible = true

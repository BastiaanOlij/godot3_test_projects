extends Spatial

var arkit = null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	arkit = ARVRServer.find_interface('ARKit')
	if arkit:
		print("Found ARKit")
		arkit.initialize()
		
		arkit.ar_is_anchor_detection_enabled = true
		get_node("toggle_plane_detection").set_text("Turn plane detection off")
		
		get_viewport().arvr = true
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
	# we only check our first anchor
	var anchor = get_node("ARVROrigin/ARVRAnchor")
	
	if (event.is_class("InputEventMouseButton") and event.pressed and anchor.get_is_active()):
		var camera = get_node("ARVROrigin/ARVRCamera")
		var from = camera.project_ray_origin(event.position)
		var direction = camera.project_ray_normal(event.position)
		
		var plane = Plane(anchor.translation, anchor.translation + anchor.transform.basis.x, anchor.translation + anchor.transform.basis.z)
		var intersect = plane.intersects_ray(from, direction)
		if intersect:
			$GodotBalls.translation = intersect
			$GodotBalls.visible = true
		
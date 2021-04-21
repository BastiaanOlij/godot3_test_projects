extends Spatial

var camera_feeds = Array()
var current_camera_feed = null

func update_cameras():
	var found = false
	
	$CameraFeeds.clear()
	camera_feeds = CameraServer.feeds()
	
	for feed in camera_feeds:
		var id = $CameraFeeds.get_item_count() + 1
		var name = feed.get_name()
		$CameraFeeds.add_item(name, id)
		
		print("Added " + name + " at " + str(id))
		
		if (feed == current_camera_feed):
			$CameraFeeds.selected = $CameraFeeds.get_item_index(id)
			$CameraFeeds.text = name
			found = true
	
	# no active camera or our camera was unplugged
	if (!found and camera_feeds.size() > 0):
		current_camera_feed = camera_feeds[0]
		$CameraFeeds.selected = 0
		$CameraFeeds.text = current_camera_feed.get_name()
		
		# and make it active!
		current_camera_feed.set_active(true);
		
		# and update our environment
		$Camera.get_environment().background_camera_feed_id = current_camera_feed.get_id()
		
		print("Current camera: " + current_camera_feed.get_name() + ", " + str(current_camera_feed.get_transform()))

func _on_CameraFeeds_item_selected( id ):
	print("Selecting " + str(id))
	var new_camera_feed = camera_feeds[id]
	if (current_camera_feed != new_camera_feed):
		# make the old one inactive
		current_camera_feed.set_active(false);
		
		# make the new one active
		current_camera_feed = new_camera_feed
		current_camera_feed.set_active(true);
		
		# and update our environment
		$Camera.get_environment().background_camera_feed_id = current_camera_feed.get_id()
		
		print("Current camera: " + current_camera_feed.get_name() + ", " + str(current_camera_feed.get_transform()))

func _ready():
	update_cameras()
	
	if current_camera_feed:
		print("Current camera: " + current_camera_feed.get_name() + ", " + str(current_camera_feed.get_transform()))
	
	# if we add or remove a camera, make sure we update our cameras
	CameraServer.connect("camera_feed_added", self, "update_cameras")
	CameraServer.connect("camera_feed_removed", self, "update_cameras")

func _process(delta):
	$FPS.set_text("FPS: " + String(Engine.get_frames_per_second()))
	
	if (Input.is_key_pressed(KEY_ESCAPE)):
		get_tree().quit()


extends Spatial

var camera_feeds = Array()
var current_camera_feed = null

func update_cameras(p_id):
	var found = false
	
	$CameraFeeds.clear()
	camera_feeds = CameraServer.feeds()
	
	for feed in camera_feeds:
		if (feed == current_camera_feed):
			$CameraFeeds.text = feed.get_name()
			found = true
		
		$CameraFeeds.add_item(feed.get_name())
	
	# no active camera or our camera was unplugged
	if (!found and camera_feeds.size() > 0):
		current_camera_feed = camera_feeds[0]
		$CameraFeeds.text = current_camera_feed.get_name()
		
		# and make it active!
		current_camera_feed.set_active(true);
		
		# and update our environment
		$Camera.get_environment().background_camera_feed_id = current_camera_feed.get_id()
		
func _on_CameraFeeds_item_selected( ID ):
	var new_camera_feed = camera_feeds[ID]
	if (current_camera_feed != new_camera_feed):
		# make the old one inactive
		current_camera_feed.set_active(false);
		
		# make the new one active
		current_camera_feed = new_camera_feed
		current_camera_feed.set_active(true);
		
		# and update our environment
		$Camera.get_environment().background_camera_feed_id = current_camera_feed.get_id()

func _ready():
	update_cameras(0)
	
	print("Current camera: " + current_camera_feed.get_name() + ", " + str(current_camera_feed.get_transform()))
	
	# if we add or remove a camera, make sure we update our cameras
	CameraServer.connect("camera_feed_added", self, "update_cameras")
	CameraServer.connect("camera_feed_removed", self, "update_cameras")

func _process(delta):
	$FPS.set_text("FPS: " + String(Engine.get_frames_per_second()))
	
	if (Input.is_key_pressed(KEY_ESCAPE)):
		get_tree().quit()


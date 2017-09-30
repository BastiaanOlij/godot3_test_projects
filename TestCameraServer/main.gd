extends Spatial

var camera_feeds = Array()
var current_camera_feed_id = 0 # first feed is 1

func update_cameras(p_id):
	var found = false
	
	$CameraFeeds.clear()
	camera_feeds = CameraServer.feeds()
	
	for feed in camera_feeds:
		if (feed["id"] == current_camera_feed_id):
			$CameraFeeds.text = feed["name"]
			found = true
		
		$CameraFeeds.add_item(feed["name"])
	
	# no active camera or our camera was unplugged
	if (!found and camera_feeds.size() > 0):
		current_camera_feed_id = camera_feeds[0]["id"]
		$CameraFeeds.text = camera_feeds[0]["name"]
		
		# and make it active!
		CameraServer.feed_set_active(current_camera_feed_id, true)
		
		# and update our environment
		$Camera.get_environment().background_camera_feed_id = current_camera_feed_id
		
func _on_CameraFeeds_item_selected( ID ):
	var new_camera_feed_id = camera_feeds[ID]["id"]
	if (current_camera_feed_id != new_camera_feed_id):
		# make the old one inactive
		CameraServer.feed_set_active(current_camera_feed_id, false)
		
		# make the new one active
		current_camera_feed_id = new_camera_feed_id
		CameraServer.feed_set_active(current_camera_feed_id, true)
		
		# and update our environment
		$Camera.get_environment().background_camera_feed_id = current_camera_feed_id

func _ready():
	update_cameras(0)
	
	# if we add or remove a camera, make sure we update our cameras
	CameraServer.connect("camera_feed_added", self, "update_cameras")
	CameraServer.connect("camera_feed_removed", self, "update_cameras")

func _process(delta):
	$FPS.set_text("FPS: " + String(Engine.get_frames_per_second()))
	
	if (Input.is_key_pressed(KEY_ESCAPE)):
		get_tree().quit()


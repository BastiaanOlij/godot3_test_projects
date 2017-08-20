extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# If we have feeds, we just enable feed 1
	if CameraServer.number_of_feeds()>0:
		CameraServer.feed_set_active(0, true);

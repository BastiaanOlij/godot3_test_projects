extends ARVRController

func _ready():
	set_process(true)

func _process(delta):
# Will implement this again shortly, we need to find out which joystick Id belongs to our controller
	var rot = get_node("Trigger_origin").get_rotation_deg()
	rot.x = get_joystick_axis(1) * -30.0
	get_node("Trigger_origin").set_rotation_deg(rot)
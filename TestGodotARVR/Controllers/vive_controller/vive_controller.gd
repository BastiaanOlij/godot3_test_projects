extends Spatial

var joy_id = -1

func get_joy_id():
	return joy_id
	
func set_joy_id(p_joy_id):
	joy_id = p_joy_id

func _ready():
	set_process(true)

func _process(delta):
	# need to find out which joystick relates to this controller, maybe set through an export variable?
	var rot = get_node("Trigger_origin").get_rotation_deg()
#	rot.x = get_trigger() * -30.0
	get_node("Trigger_origin").set_rotation_deg(rot)
	
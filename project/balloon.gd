extends Sprite2D

var colors = ["Blue", "Cyan", "Green", "Orange", "Pink", "Purple", "Red", "Sky_Blue", "Yellow"]
const bob_height: float = 5.0
const bob_width: float = 3.0
const max_bob_speed: float = 2.5
var bob_speed: float = 0
var rnd
var balloonColor = "White"
var popped = []

@onready var start_position: Vector2 =  global_position

func _ready() -> void:
	rnd = randf_range(0, 1)
	bob_speed = randf_range(0, max_bob_speed) + 1
	#self.scale = Vector2(1.0,1.0)
	popped = [false, false, false, false, false, false] #num_teams = 6
	

func _physics_process(_delta: float) -> void:
	var time = Time.get_unix_time_from_system()
	
	#rotate
	#self.scale.x = sin(time * rotate_speed)
	
	#bob up and down
	var y_pos 	= ((1+sin(time * bob_speed)) / 2) * bob_height
	global_position.y = start_position.y - y_pos
	
	var x_pos = ((1+cos(time * bob_speed / 2)) / 2) * bob_width
	global_position.x = start_position.x - x_pos
	
	#rotation = ((sin(time * 0.5)) / 2) * rnd
	
func set_balloon_color(color: String):
	balloonColor = color
	
#Draw balloon string
func _draw() -> void:
	var xPos = position.x
	var yPos = position.y
	if xPos < 350:
		draw_set_transform(Vector2(-30,-5),rotation * -1 + deg_to_rad(-20))
	elif xPos < 450:
		draw_set_transform(Vector2(-20,0),rotation * -1 + deg_to_rad(-10))
	elif xPos > 1500:
		draw_set_transform(Vector2(20,0),rotation * -1 + deg_to_rad(12))
	
	draw_line(Vector2(0,92), Vector2.DOWN * (1580 - yPos), Color(balloonColor), 1.0, true)
	
func pop(teamNum: int):
	popped[teamNum] = true

func is_popped(teamNum):
	return popped[teamNum]

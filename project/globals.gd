extends Node

const colors: Array[String] = ["Blue", "Green", "Orange", "Pink", "Purple", "Red", "Sky_Blue", "Yellow"] #Cyan
var randColor
var top_bpr: int = 15 #balloons per row
var rows: int = 7
var num_balloons: int = 100
var num_teams: int = 6
var balloons = [] #array of all balloons
#var balloonsArray = [] #array of above
var remainingBalloons: Array = []  #array with unpopped balloons. balloon removed when "popped"
var remainingArray: Array[Array] = [] #array of remainingBalloons[] for each team
var guesses = [] #[0] = team1, etc.
var answer
var numToPop = []
var currentTeam = 0
var bob_speed: float = 2.5
var bob_height: float = 5.0
var bob_width: float = 5.0
const textureLoc = "res://images/balloons/"
var textureName
const BALLOON = preload("res://balloon.tscn")
var scale: float = 0.8

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	guesses.resize(num_teams)
	guesses.fill(0)
	numToPop.resize(num_teams)
	guesses.fill(0)
	numToPop.resize(num_teams)
	numToPop.fill(0)
	
func build_remaining_array():
	for i in range(num_teams):
		remainingArray.append(remainingBalloons.duplicate(true))

func set_guess(val: int):
	guesses[currentTeam] = val
	
func get_guess(i: int):
	return guesses[i]
	
func set_num_to_pop(teamNum: int, val: int):
	numToPop[teamNum] = val
	
func get_num_to_pop(i: int):
	return numToPop[i]

func set_answer(val: int):
	answer = val
	
func get_answer():
	return answer
	
func get_rand_balloon(teamNum: int):
	var balloonNum = randi_range(0,remainingArray[teamNum].size() - 1)
	return remainingArray[teamNum][balloonNum]
	
func set_current_team(teamNum: int):
	currentTeam = teamNum

func get_current_team():
	return currentTeam

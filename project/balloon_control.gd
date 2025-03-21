extends Node

var colors   #array of colors taken from Main
var window_width	
var window_height
var ratio
var balloon_size #balloonsize

func _ready() -> void:
	#var screenSize = DisplayServer.window_get_size()
	#window_width = get_parent().size.x #screenSize.x
	#window_height = get_parent().size.y #screenSize.y
	ratio = 1
	colors = Main.colors
	balloon_size = 100
	
	populate_balloons()
	
func populate_balloons(color: String = "Default", originX: int = 0, originY: int = 0):
	var top_bpr = Main.top_bpr
	var bpr = top_bpr
	var xOffset = 220 #* ratio
	var x = 0
	var y = -1
	var iOffset = 0
	var yParabola = 0    #multiplier to make parabola shape
	var xParabola = 0    #multiplier to account for rows with fewer balloons
	#var guesses = [0,0,0,0,0,0,0,0]
	var scale = Main.scale * ratio
	var size = balloon_size * ratio
	var balloonControlX = originX
	var balloonControlY = originY
	
	#WARNING: If you try to get the position of the parent here, the most recent values won't be updated
	#call_deferred() seems to be the suggested solution, but I'll just divide the screen size
	#var bcNum = int(self.name.right(1))
	#if bcNum % 2 == 1:  #odd teams
		#balloonControlX = 962
	
	for i in range(Main.num_balloons):
		#Reduce 4th row by 1
		if i == 3 * top_bpr:
			iOffset = 3 * bpr
			bpr -= 1
			x=0
			xOffset += 50
			xParabola = 0.5
		#Reduce last row by 1 again
		if i == 3 * (top_bpr + (top_bpr - 1)):
			iOffset = 3 * (2* top_bpr - 1)
			bpr -= 1
			x=0
			xOffset += 50
			xParabola = 1
		
		#Go to next row once max balloons per row has been reached
		if ((i - iOffset) % bpr == 0):
			x = 0
			y += 1
			
		yParabola = (-2*((x+xParabola)**2)+28.7*(x + xParabola))*ratio	#multiplier to make parabola shape y=ax^2+bx+c
		
		#Create new balloon instance
		var newBalloon = Main.BALLOON.instantiate()
		var rnd = randi_range(-10,10)
		newBalloon.transform = Transform2D(deg_to_rad(rnd / 2), Vector2((xOffset+(balloon_size * x) + rnd)*ratio, 280+y * 70 + rnd - yParabola*2))*ratio #2d(instance int, transform2d(rot, trans)
		newBalloon.position += Vector2(balloonControlX, balloonControlY)
		
		#Set balloon color
		var randColor = colors[randi() % Main.colors.size()]
		if color != "Default":
			randColor = color
			
		var textureName = Main.textureLoc + "balloon" + randColor + "Sm.png"
		newBalloon.texture = load(textureName)
		newBalloon.scale = Vector2(scale, scale)
		newBalloon.name = "Balloon" + str(i).pad_zeros(2)
		newBalloon.set_balloon_color(randColor)
		Main.balloons.append(newBalloon)
		Main.remainingBalloons.append(newBalloon)
		add_child(newBalloon)
		
		
		x += 1
	Main.build_remaining_array()


func _check_answers():
	#Set answer variable based on textbox val or imported csv
	var ans = int(%AnswerBox.value)
	Main.set_answer(ans)
	
	var currentTeam = Main.currentTeam
	#For each team, check how wrong they were, then pop those balloons
	#for i in range(1): #range(Main.guesses.size())
	calc_num_to_pop(currentTeam)
	pop_balloons(currentTeam)
	
			
func calc_num_to_pop(teamNum: int):
	var percentOff = abs(Main.get_answer() - Main.get_guess(teamNum))
	print("Popping " + str(percentOff) + ", team guess: " + str(Main.get_guess(teamNum)))
	Main.set_num_to_pop(teamNum, percentOff)	
	
func pop_balloons(teamNum: int):
	for i in range(Main.get_num_to_pop(teamNum)):  #run [numToPop] times
		if Main.remainingArray[teamNum].size() >= 1:  #If there are any balloons left, make invisible and remove from remainingBalloons
			var balloon = Main.get_rand_balloon(teamNum)
			balloon.popped[teamNum] = true
			balloon.visible = false
			Main.remainingArray[teamNum].erase(balloon)
	%RemainingBalloonNum.text = str(Main.remainingArray[teamNum].size())
			
func show_teams_balloons(teamNum: int):
	var balloons = Main.balloons
	for balloon in balloons:
		if balloon.is_popped(teamNum):
			balloon.visible = false
		else:
			balloon.visible = true
	


func _print_guess() -> void:
	print(str(Main.get_guess(0)))

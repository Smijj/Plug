class_name GameManager
extends Node3D

@export var _CutsceneManager: CutsceneManager
@export var Player: PlayerCtrl

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ReturnToStartMenu()

#func _input(event: InputEvent) -> void:
	## DEBUG
	## Start Game normally
	#if event.is_action_pressed("1"):
		#StartGame()
	## Skip to Gameplay
	#if event.is_action_pressed("2"):
		#StateManager.GameState = StateManager.GAMEPLAY
	## Win Game
	#if event.is_action_pressed("3"):
		#_CutsceneManager.PlayCutscene("Cutscene_GoalReached", "GoalReached")

func _on_col_goal_body_entered(body: Node3D) -> void:
	# Play goal reach anim
	# return to the start menu when thats finished
	_CutsceneManager.PlayCutscene("Cutscene_GoalReached", "GoalReached")

func ReturnToStartMenu() -> void:
	# Instead of jumpiong straight to the startmenu, could also create an animation to get back there
	StateManager.GameState = StateManager.STARTMENU

func StartGame() -> void:
	# While intro cutscene is playing:
	# reset player pos
	Player.ResetPlayerPos()
	_CutsceneManager.PlayCutscene("Cutscene_Intro", "Intro")
	
	# When intro cutscene ends:
		# hide cutscene player model - might be able to do this in the animation itself

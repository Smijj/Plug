# https://docs.godotengine.org/en/3.5/tutorials/plugins/running_code_in_the_editor.html
class_name CutsceneManager
extends Node3D

static var IsCutscenePlaying:bool = false
static var CurrentCutsceneName:String = ""
signal CutsceneFinished(cutsceneName:String)

#@export_category("Info")

@export_category("AnimationPlayer References")
@export var _CutsceneAnimationPlayers:Array[AnimationPlayer]

func _ready() -> void:
	pass

func PlayCutscene(cutsceneName:String, newGameState := StateManager.GAMEPLAY, animationName:String = "Animation") -> void:
	if cutsceneName.is_empty(): 
		print("No Cutscene Name Provided")
		return
	if IsCutscenePlaying: 
		print("Cutscene Already Playing")
		return
		
	var animPlayer:AnimationPlayer = _GetCutsceneAnimPlayer(cutsceneName)
	if animPlayer:
		IsCutscenePlaying = true
		StateManager.GameState = StateManager.CUTSCENE
		animPlayer.play(animationName)
		animPlayer.animation_finished.connect(func(x):
			_AnimationFinished(cutsceneName)
			StateManager.GameState = newGameState
		)
		

func ExecuteOnCutsceneFinished(function:Callable) -> void:
	CutsceneFinished.connect(function)

func _GetCutsceneAnimPlayer(cutsceneName:String) -> AnimationPlayer:
	print("Try Get Cutscene: " + cutsceneName)
	for animPlayer in _CutsceneAnimationPlayers:
		if animPlayer.get_parent().name == cutsceneName:
			print("Found "+cutsceneName)
			return animPlayer
	
	print("No registered cutscenes")
	return null

func _AnimationFinished(cutsceneName:String) -> void:
	print("Cutscene Finsihed: "+cutsceneName)
	
	IsCutscenePlaying = false
	CurrentCutsceneName = ""
	CutsceneFinished.emit(cutsceneName)

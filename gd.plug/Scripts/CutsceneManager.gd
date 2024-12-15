# https://docs.godotengine.org/en/3.5/tutorials/plugins/running_code_in_the_editor.html
class_name CutsceneManager
extends Node3D

class _CutsceneData:
	var Name:String:
		get: return Settings.Name
	var Settings: CutsceneSettings = CutsceneSettings.new()
	var AnimPlayer: AnimationPlayer = null
	var Camera: Camera3D = null
	var CutsceneNode: Node3D = null

static var IsCutscenePlaying:bool = false
static var CurrentCutsceneData:_CutsceneData = null
signal CutsceneFinished(cutsceneName:String)

@export_category("AnimationPlayer References")
var _Cutscenes:Array[_CutsceneData] = []
@export var _CutsceneSettings:Array[CutsceneSettings]

#@export var _CutsceneNodes:Array[Node3D]


func _ready() -> void:
	_PopulateCutsceneReferences()

func _PopulateCutsceneReferences() -> void:
	for settings:CutsceneSettings in _CutsceneSettings:
		var data:_CutsceneData = _CutsceneData.new()
		data.Settings = settings
		
		print(settings.CutsceneNodePath)
		
		data.CutsceneNode = get_node(settings.CutsceneNodePath)
		data.CutsceneNode.visible = data.Settings.VisiblePreCutscene
		
		var animPlayer:AnimationPlayer = data.CutsceneNode.get_node_or_null("AnimationPlayer")
		if animPlayer: data.AnimPlayer = animPlayer
		var camera:Camera3D = data.CutsceneNode.get_node_or_null("Camera")
		if camera: data.Camera = camera
		
		_Cutscenes.append(data)

func PlayCutscene(cutsceneName:String, animationName:String) -> void:
	if cutsceneName.is_empty(): 
		print("No Cutscene Name Provided")
		return
	if IsCutscenePlaying: 
		print("Cutscene Already Playing")
		return
		
	var data:_CutsceneData = _GetCutsceneData(cutsceneName)
	if data:
		IsCutscenePlaying = true
		CurrentCutsceneData = data
		
		data.CutsceneNode.visible = true
		data.Camera.current = true
		StateManager.GameState = StateManager.CUTSCENE
		
		data.AnimPlayer.play(animationName)
		data.AnimPlayer.animation_finished.connect(func(x):
			_AnimationFinished(data)
		)
		
func ExecuteOnCutsceneFinished(function:Callable) -> void:
	CutsceneFinished.connect(function)

func _GetCutsceneData(cutsceneName:String) -> _CutsceneData:
	print("Try Get CutsceneData: " + cutsceneName)
	for data in _Cutscenes:
		if data.Name == cutsceneName:
			print("Found "+cutsceneName)
			return data
	
	print("No registered cutscene with the name: " + cutsceneName)
	return null

func _AnimationFinished(cutsceneData:_CutsceneData) -> void:
	print("Cutscene Finsihed: "+cutsceneData.Name)
	
	# Set Cutscene node's visibility based on its settings
	cutsceneData.CutsceneNode.visible = cutsceneData.Settings.VisiblePostCutscene
	
	StateManager.GameState = cutsceneData.Settings.NewGameState
	IsCutscenePlaying = false
	CurrentCutsceneData = null
	CutsceneFinished.emit(cutsceneData.Name)

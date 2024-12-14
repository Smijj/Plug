# https://docs.godotengine.org/en/3.5/tutorials/plugins/running_code_in_the_editor.html
# https://forum.godotengine.org/t/how-to-track-changes-in-an-exported-variable/39185
@tool
extends Node3D

# https://github.com/godotengine/godot-proposals/issues/18#issuecomment-706795815
#class CutsceneData:
	#var Name:String
	#var AnimPlayer: AnimationPlayer
	#var ParentNode:Node3D
#@export var Cutscenes:Array[CutsceneData]

@export_category("Debug")
## Ghetto button. Goes through all the Nodes set in CutsceneNodes, finds their AnimationPlayers, and adds them to the Cutscenes dictionary with the CutsceneNode.name as the key.
@export var _RefreshCutsceneAnimReferences: bool:
	set(value):
		_SetAnimPlayers()

@export var _CutsceneNodes:Array[Node3D]
@export var Cutscenes:Dictionary


# TODO: Fix this shit, cant access the anim player in a PackedScene, so need to setup something to drag n drop the AnimPlayer into
func _SetAnimPlayers() -> void:
	Cutscenes.clear()
	for cutsceneNode in _CutsceneNodes:
		#var importedResource = load("res://Creative Assets/Animations/"+cutsceneNode.name+".blend")
		var animPlayer:AnimationPlayer = cutsceneNode.get_node_or_null("AnimationPlayer")
		if animPlayer:
			Cutscenes[cutsceneNode.name] = animPlayer
			print("Added AnimationPlayer with key: " + cutsceneNode.name)

	#for cutsceneNode in _CutsceneNodes:
		#var animPlayer:AnimationPlayer = _GetAnimPlayer(cutsceneNode)
		#if animPlayer:
			#Cutscenes[cutsceneNode.name] = animPlayer
			#print("Added AnimationPlayer with key: " + cutsceneNode.name)

func _GetAnimPlayer(cutsceneNode:Node3D) -> AnimationPlayer:
	if !cutsceneNode: return null
	
	for child in cutsceneNode.get_children():
		if child is AnimationPlayer:
			return child
	return null

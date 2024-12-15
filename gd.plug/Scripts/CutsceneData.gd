class_name CutsceneSettings
extends Resource

@export var Name:String = ""
@export var CutsceneNodePath:NodePath
@export var VisiblePreCutscene:bool = true
@export var VisiblePostCutscene:bool = true
@export var NewGameState:int = StateManager.GAMEPLAY

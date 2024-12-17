extends Node3D

@export_group("Camera")
@export var _MouseSensitivity := 0.2
@export var _CamerYPivot :Node3D
@export var _CameraXPivot :Node3D

func _init() -> void:
	StateManager.GameStateChanged.connect(_OnGameStateChanged)

func _OnGameStateChanged(newState) -> void:
	# Disable the player camera unless the gamestate is GAMEPLAY
	if newState == StateManager.STARTMENU:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		pass
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event:InputEvent):
	_HandleCamera(event)	# Handle Camera and player y rotation
	
func _HandleCamera(event:InputEvent):
	if not event is InputEventMouseMotion: return
	
	# Rotate whole player around the y axis to look left and right
	if _CamerYPivot:
		_CamerYPivot.rotate_y(deg_to_rad(-event.relative.x * _MouseSensitivity))
	
	# Rotate just the camera around the x axis to look up and down
	if _CameraXPivot:
		_CameraXPivot.rotate_x(deg_to_rad(-event.relative.y * _MouseSensitivity))
		_CameraXPivot.rotation.x = clamp(_CameraXPivot.rotation.x, deg_to_rad(-90), deg_to_rad(45))	# Clamp camera up/down motion

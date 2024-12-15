extends Camera3D


func _init() -> void:
	StateManager.GameStateChanged.connect(_OnGameStateChanged)

func _OnGameStateChanged(newState) -> void:
	# Disable the camera unless the gamestate is STARTMENUY
	if newState == StateManager.STARTMENU:
		current = true
	else:
		current = false

extends Node

enum {
	NONE,
	STARTMENU,
	MENU,
	GAMEPLAY,
	CUTSCENE
}

signal GameStateChanged(newGameState)

var GameState := NONE:
	set(value):
		LastGameState = GameState
		GameState = value
		GameStateChanged.emit(GameState)
		print("new gamestate: "+str(GameState))
	get:
		return GameState

var LastGameState := NONE

func ReturnToPreviousState() -> void:
	GameState = LastGameState

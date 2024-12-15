class_name PlayerCtrl
extends CharacterBody3D

@export var SPEED:float = 5.0
@export var JUMP_VELOCITY:float = 4.5
@export var RotationSmoothing:float = 5

@export var _Anim: AnimationPlayer
@export var _CharacterModel: Node3D
@export var _Camera: Camera3D

var _OnGroundLastFrame: bool = true
var _MovingLastFrame: bool = false
var _Jumping: bool = false
var _ModelLookPos: Vector3 = Vector3.ZERO

var _StartingPos:Vector3 = Vector3.ZERO

func _init() -> void:
	StateManager.GameStateChanged.connect(_OnGameStateChanged)

func _ready() -> void:
	_StartingPos = global_position

func _OnGameStateChanged(newState) -> void:
	# Disable the player camera unless the gamestate is GAMEPLAY
	if newState == StateManager.GAMEPLAY:
		if !_Camera.current: _Camera.current = true
		visible = true
	else:
		if _Camera.current: _Camera.current = false
		visible = false

func _physics_process(delta: float) -> void:
	# Dont allow the player to move if the gamestate isnt set to GAMEPLAY
	if StateManager.GameState != StateManager.GAMEPLAY:
		return
	
	# If you just landed on the and wen't on the ground last frame, play idle anim
	if is_on_floor() and !_OnGroundLastFrame:
		_Jumping = false
		_Anim.play("Idle")
	_OnGroundLastFrame = is_on_floor()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		_Jumping = true
		_Anim.play("Jump")

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("Move_Left", "Move_Right", "Move_Forward", "Move_Backwards")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		#_CharacterModel.look_at(global_position+direction)
		_ModelLookPos = _ModelLookPos.move_toward(global_position + direction, RotationSmoothing)
		_CharacterModel.look_at(_ModelLookPos, Vector3(0,1,0), false)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		_MovingLastFrame = true
		
		if !_Jumping:
			_Anim.play("Move_Forward")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
		# If you stop moving and are on teh floor, play idle
		if is_on_floor() and _MovingLastFrame:
			_Anim.play("Idle")
		_MovingLastFrame = false

	move_and_slide()

func ResetPlayerPos() ->void:
	global_position = _StartingPos

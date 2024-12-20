extends Node3D

@export var PlugPos_Default:Node3D
@export var PlugPos_Play:Node3D

@export var PinOveridePos:Node3D
@export var EndPos:StaticBody3D
@export var PlugBody:RigidBody3D

@export var _GameManager:GameManager
@export var Camera:Camera3D

var InStartMenu:bool = false

func _init() -> void:
	StateManager.GameStateChanged.connect(_OnGameStateChanged)
	
func _OnGameStateChanged(newState) -> void:
	if newState == StateManager.STARTMENU:
		if PlugBody: PlugBody.freeze = true
		if PlugPos_Default and PlugBody: PlugBody.global_position = PlugPos_Default.global_position
		if PlugBody: PlugBody.freeze = false
		InStartMenu = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if PinOveridePos and EndPos:
		EndPos.global_position = PinOveridePos.global_position


func _physics_process(delta: float) -> void:
	if not InStartMenu: return
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_DetectCollisionAndMovePlug()

func _DetectCollisionAndMovePlug() -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 100
	var from = Camera.project_ray_origin(mouse_pos)
	var to = from + Camera.project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	ray_query.collide_with_areas = true
	ray_query.collide_with_bodies = false
	ray_query.collision_mask = 2
	
	var raycast_result:Dictionary = space.intersect_ray(ray_query)
	if raycast_result: 
		var direction:Vector3 = (raycast_result["position"] - PlugBody.global_position)
		PlugBody.apply_central_force(direction * 300)


func _OnPlaySocketColliderEntered(body: Node3D) -> void:
	print("PLAY!")
	InStartMenu = false
	if PlugBody: PlugBody.freeze = true
	if PlugPos_Play and PlugBody: PlugBody.global_position = PlugPos_Play.global_position
	
	if _GameManager: _GameManager.StartGame()
	

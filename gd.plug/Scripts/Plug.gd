extends Node3D

@export var PinOveridePos:Node3D
@export var EndPos:StaticBody3D
@export var PlugBody:RigidBody3D

#@onready var Camera:Camera3D = get_viewport().get_camera_3d()
@export var Camera:Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if PinOveridePos and EndPos:
		EndPos.global_position = PinOveridePos.global_position


func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_DetectCollisionAndMovePlug()
		
		# Move end pin
		if PinOveridePos and EndPos:
			EndPos.global_position = PinOveridePos.global_position

func _input(event: InputEvent) -> void:
	pass
	#if !Camera: return
	#if event.is_pressed():
		#print("LMB")
	#if event is InputEventMouseButton:
		#if (event.pressed == true and event.button_index == 1):
			#
		
		#if (event.pressed == true and event.button_index == 1):
			#var Camera = get_node("Camera")
			#var from = Camera.project_ray_origin(event.position);
			#var to = from + camera_project_ray_normal(event.position) * distance_from_camera;
			## Apply the position to whatever object you want (we'll assume a node named "Cube")
			#get_node("Cube").global_transform.origin = to;

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
	#ray_query.collision_mask = 5
	
	var raycast_result:Dictionary = space.intersect_ray(ray_query)
	if raycast_result: 
		PlugBody.global_position = raycast_result["position"]
		#print(raycast_result["position"])
	#else:
		#print("No Result")

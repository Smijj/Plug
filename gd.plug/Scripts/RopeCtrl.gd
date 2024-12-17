extends Node3D
 
@export var skeleton_path : NodePath
@export var rope_body : PackedScene
@export var rope_end_pin : RigidBody3D
@export var bias : float = 0.4
@export var damping : float = 1.0
@export var impulse_clamp:float = 0.0
 
#Getting the skeleton.
@onready var skeleton : Skeleton3D = get_node(skeleton_path) as Skeleton3D
 
var skeleton_movement
var ROPE_BODIES : Array
var last_rigidbody
 
 
 
func _ready()->void:
	#Adding a RigidBody for every bone. 
	for i in skeleton.get_bone_count(): 
		_add_rigidbody(skeleton.get_bone_global_pose(i))
	pass
	
func _physics_process(delta:float)->void:
	#Making the bones move as the rigidbodies move. 
	for i in skeleton.get_bone_count(): 
		var bone_name =skeleton.get_bone_name(i)
		var id = skeleton.find_bone(bone_name)
		skeleton_movement= ROPE_BODIES[i].transform
		skeleton.set_bone_global_pose_override(id, skeleton_movement, 1)
	pass 
	
##Adding a RigidBody for every bone.## 
func _add_rigidbody(pos:Transform3D)->void:
	#Instancing the rope_body scene, which is a RigigBody with collision.
	var rigidbody = rope_body.instantiate()
	rigidbody.position = pos.origin
	#Appending RigidBodies to the array to check later the transforms of the RigidBodies.
	ROPE_BODIES.append(rigidbody)
	add_child(rigidbody)
	#Adding a PinJoint between RigidBodies.
	_add_pin_joint(last_rigidbody,rigidbody)
	#Saving the last added RigidBody for _add_pin_joint function to get position between the old RigidBody and new RigidBody.
	last_rigidbody = rigidbody
	pass
	
##Adding a PinJoint between the RigidBodies.##
func _add_pin_joint(node_A, node_B)->void:
	#Creating a new PinJoint and setting the params for it.
	var pin = PinJoint3D.new()
	pin.set("params/bias",bias)
	pin.set("params/damping",damping)
	pin.set("params/impulse_clamp",impulse_clamp)
	#Setting the node_B(AKA rigidbody variable) for PinJoint
	pin.set_node_b(node_B.get_path())
	#Checking if the node_A(AKA  last_rigidbody variable) is null, and if it is true, PinJoint's position = Vector.ZERO.  
	if node_A == null:
		#pin.transform.origin = Vector3.ZERO 
		#If node_A is null, set Node A to the pin pos
		pin.set_node_a(rope_end_pin.get_path())
		#Getting the position between node_A and node_B (AKA last_rigidbody and rigidbody variables).
		var between = _get_pos_between_vectors(rope_end_pin.transform.origin,node_B.transform.origin)
		#Setting the given position for the PinJoint.
		pin.transform.origin = between 
	else:
		#If node_A is not = null then we are setting the node_A for PinJoint.  
		pin.set_node_a(node_A.get_path())
		#Getting the position between node_A and node_B (AKA last_rigidbody and rigidbody variables).
		var between = _get_pos_between_vectors(node_A.transform.origin,node_B.transform.origin)
		#Setting the given position for the PinJoint.
		pin.transform.origin = between 
	#Adding the PinJoint as a child.
	add_child(pin)
	pass
	
##Getting the position between two vectors.##
func _get_pos_between_vectors(A:Vector3,B:Vector3)->Vector3:
	return (A+B)/2

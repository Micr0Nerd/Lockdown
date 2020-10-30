extends Node2D

	
func _ready():
	#CPEdited.player = $Player
#	$Player/Camera2D/AnimationPlayer.play("Camera_trembling")
#	yield(get_tree().create_timer(CPEdited.time_befor_transition), "timeout")
#	$Player/Camera2D/Transition.transition_to_scene("res://Transition/EndRace.tscn")
	pass

#var is_camera_trembling = false
func game_over():
	$Player/Camera2D/AnimationPlayer.play("Camera_trembling")
	yield(get_tree().create_timer(CPEdited.time_befor_transition), "timeout")
	$Player/Camera2D/Transition.transition_to_scene("res://Transition/EndRace.tscn")
	pass
	

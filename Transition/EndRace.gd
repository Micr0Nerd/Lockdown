extends Control



func _on_Restore_pressed():
	$Transition.transition_to_scene("res://main.tscn")
	#get_tree().change_scene("res://Store/Store.tscn")
	pass # Replace with function body.


func _on_Off_pressed():
	#$Transition.transition_to_scene("res://MainMenu.tscn")
	#get_tree().change_scene("res://MainMenu.tscn")
	pass # Replace with function body.

func _ready():
	#$AudioStreamPlayer2D.stream = fo
	$AudioStreamPlayer.play(0)
	pass

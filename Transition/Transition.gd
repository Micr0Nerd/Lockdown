extends ColorRect

# Path to the next scene to transition to
export(String, FILE, "*.tscn") var next_scene_path

# Reference to the _AnimationPlayer_ node
onready var _anim_player = $AnimationPlayer

func _ready() -> void:
	# Plays the animation backward to fade in
	modulate.a = 1
	_anim_player.play_backwards("Fade")
	#visible = true
	pass
	
func transition_to_scene(_next_scene) -> void:
	# Plays the Fade animation and wait until it finishes
	#_anim_player.play_backwards("Fade")
	_anim_player.play("Fade")
	yield(_anim_player, "animation_finished")
	# Changes the scene
	get_tree().change_scene(_next_scene)
	
func transition_to_object(function_name : String) -> void:
	# Plays the Fade animation and wait until it finishes
	#_anim_player.play_backwards("Fade")
	_anim_player.play("Fade")
	yield(_anim_player, "animation_finished")
	# launch a suitable transition function
	get_parent().call_deferred(function_name)
	
func transition_in():
	# Plays the animation backward to fade in
	modulate.a = 1
	_anim_player.play_backwards("Fade")

#var is_transition_in = false
#var is_transition_out = false
#var time_transition = 3
#var speed_transition = 1.0 / float(time_transition)
##
##
##const shader_name = "res://Transition.shader"
##var shader : Shader
#var next_scene = ""
#var func_name = ""
#onready var _modulate = get_parent().modulate
#func transition_to_scene_1(_next_scene):
#	self_modulate.a = 0
#	next_scene = _next_scene
#	func_name = ""
#	is_transition_out = true
#	# Changes the scene
#	#get_tree().change_scene(_next_scene)
#
#func transition_in():
#	modulate.a = 1
#	is_transition_in = true
##
##func _ready():
##	shader = material.get_shader()
##	#shader.set_shader_param("cutoff", 1.0)
##	material.set_shader_param("cutoff", 0.6)
##	material.set_shader_param("smooth_size", 0.6)
##	pass
##
#func _process(delta):
#	if is_transition_in && modulate.a > 0:
#		modulate.a -= speed_transition * delta
#	elif is_transition_out && modulate.a < 1:
#		self_modulate.a += speed_transition * delta
#		print(self_modulate.a)
#	else:
#		if is_transition_in:
#			is_transition_in = false
#		if is_transition_out:
#			is_transition_out = false
#			if next_scene != "":
#				get_tree().change_scene(next_scene)
#			elif func_name != "":
#				get_parent().call_deferred(func_name)
	

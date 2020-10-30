extends Area2D


func _ready():
	pass
	

var is_active = true

func _on_Teleport_area_entered(area):
	if area is Bullet:
		if is_active && area.parent == area.PLAYER:
			is_active = false
			CPEdited.player.teleport(global_position)
			area.queue_free()
			yield(get_tree().create_timer(CPEdited.teleport_time_inactive),"timeout")
			is_active = true
	pass # Replace with function body.


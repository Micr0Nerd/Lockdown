extends Node

###########################
# DRONE
var drone_max_health = 500
var drone_middle_health = 250
var drone_distance_for_destroy = 350 # расстояние до плеера, при котором дрон будет уничтожен
var drone_rate_for_ray_casting = 1
###########################
# PLAYER
var player_speed_bullet = 380
var player_rate_of_fire = 0.3 # скорострельность - секунд между выстрелами
var player_bullet_distance = 1000 # дальность полета снаряда 
var player_overpower_time = 3 # время длительности Оверповера
var player_damage_overpower = 30
var player_damage_bullet = 50

###########################
#TELEPORT
var teleport_time_befor = 0.3
var teleport_time_inactive = 3 #teleport_time_befor + 3




###########################
#HATERS
var security_max_health = 500
var security_speed_patrol = 80
var security_speed_run = 300
var security_speed_bullet = 400
var security_rate_of_fire = 0.6 # скорострельность - секунд между выстрелами
var security_damage_bullet = 30
var security_with_player_dist_nearby = 200 # расстояние, когда охранник начинает убегать от Плеера
var security_with_player_dist_far = 300 # расстояние, когда охранник перестает убегать от Плеера

#############################
# CAMERA
#var camera_trembling_amplitude = 10 # амплитуда дрожания камеры на гейм овере
var time_befor_transition = 2
#var time_camera_trembling = 2 # время дрожания камеры перед началом перехода на гейм овер


#############################
#DroneRepairStation
var drs_drone_repair_speed = 60 # единиц здоровья в секунду
var drs_drone_shutdown_warning_threshold = 100 #предупреждающий порог отключения дрона
var drs_squared_drone_shutdown_warning_threshold = pow(drs_drone_shutdown_warning_threshold, 2)



###########################
# НЕ ДЛЯ РЕДКТИРОВАНИЯ
var player : Player
var bullet_1 = preload("res://Bullet/Bullet.tscn").instance()


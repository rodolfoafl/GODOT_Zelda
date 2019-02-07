extends "res://Scripts/Entity.gd"

const TYPE = "Enemy"
const DAMAGE = 1

var move_timer_length = 60
var move_timer = 0

func _ready():
	$AnimationPlayer.play("default")
	move_direction = rand()
	
func _physics_process(delta):
	pass
	movement()
	if(move_timer > 0):
		move_timer -= 1
	if(move_timer == 0):
		move_direction = rand()
		move_timer = move_timer_length


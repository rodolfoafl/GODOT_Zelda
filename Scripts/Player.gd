extends "res://Scripts/Entity.gd"

const TYPE = "Player"
const DAMAGE = 1

var is_attacking = false

func _process(delta):
	if(Input.is_action_just_pressed("attack") && !is_attacking):
		attack()
	else:	
		if(move_direction != Vector2(0, 0) && !is_attacking):
			control_animation("walk")
		elif(!is_attacking):
			control_animation("idle")

func _physics_process(delta):
	if(health > 0):
		controls()
		if(!is_attacking):
			movement()
			set_sprite()
	else:
		control_animation("idle")

func controls():
	var left = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	var up = Input.is_action_pressed("ui_up")
	var down = Input.is_action_pressed("ui_down")
	
	move_direction.x = -int(left) + int(right)
	move_direction.y = -int(up) + int(down)
	
func attack():	
	is_attacking = true
	control_animation("attack")
	yield(get_tree().create_timer(0.2), "timeout")
	is_attacking = false

func _on_SwordArea2D_body_entered(body):
	if(body.name != "Player"):
		print("enemy health: " + str(body.health))
		body.health -= 1
		if(body.health > 0):
			body.get_hurt()
		else:
			body.die()
		print("enemy health: " + str(body.health))


extends KinematicBody2D

export (int) var speed

const TYPE = ""
const DAMAGE = 0

var move_direction = Vector2(0, 0)
var knock_direction = Vector2(0, 0)

var sprite_direction = "down"

export (int) var health = 1
export (int) var damage = 1

var hit_stun = 0
var default_color

func _ready():
	if(TYPE == "Enemy"):
		set_collision_mask_bit(1, 1)
		set_physics_process(false)
			
	default_color = get_node("Sprite").modulate

func movement():
	if(health > 0):
		var motion
		if(hit_stun == 0):
			motion = move_direction.normalized() * speed
		else:
			motion = knock_direction.normalized() * 125
		move_and_slide(motion, Vector2(0, 0))
		if(TYPE == "Player"):
			damage()
	else:
		$AnimationPlayer.play("idle_down")
		
func get_hurt():
	$Tween.interpolate_property($Sprite, "modulate", Color(1, 0, 0, 0.5), default_color, 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	
	$Tween.interpolate_property($Sprite, "scale", Vector2(1, 1), Vector2(0.9, 0.9), .1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	
	yield(get_tree().create_timer(.1), "timeout")	
	$Tween.interpolate_property($Sprite, "scale", Vector2(0.9, 0.9), Vector2(1, 1), .1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
	
func die():
	$Tween.interpolate_property($Sprite, "modulate", default_color, Color(0, 0, 0, 0.1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

	$Tween.interpolate_property($Sprite, "rotation_degrees", 0, 90, .5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

	yield(get_tree().create_timer(1), "timeout")
	queue_free()
	
func set_sprite():
	match move_direction:
		Vector2(-1, 0):
			sprite_direction = "left"
		Vector2(1, 0):
			sprite_direction = "right"
		Vector2(0, -1):
			sprite_direction = "up"
		Vector2(0, 1):
			sprite_direction = "down"
			
func control_animation(animation):
	var new_animation = str(animation + "_", sprite_direction)
	if($AnimationPlayer.current_animation != new_animation):
		$AnimationPlayer.play(new_animation)
		
func rand():
	var d = randi() % 4 + 1
	match d:
		1:
			return Vector2(-1, 0)
		2:
			return Vector2(1, 0)
		3:
			return Vector2(0, -1)
		4:
			return Vector2(0, 1)

func use_item(item):
	var new_item = item.instance()
	new_item.add_to_group(str(new_item.get_name(), self))
	add_child(new_item)
	if(get_tree().get_nodes_group(str(new_item.get_name(), self)).size() > new_item.max_amount):
		new_item.queue_free()
				
func damage():	
	if(hit_stun > 0):
		hit_stun -= 1
	for body in $Area2D.get_overlapping_bodies():
		if(hit_stun == 0 && body.get("DAMAGE") != null && body.get("TYPE") != TYPE):
			health -= body.get("DAMAGE")
			get_hurt()
			hit_stun = 10
			knock_direction = global_transform.origin - body.global_transform.origin
			
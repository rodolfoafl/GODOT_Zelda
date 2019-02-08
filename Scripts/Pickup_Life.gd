extends Area2D

func _ready():
	$AnimationPlayer.play("idle")

func _on_Area2D_body_entered(body):
	if(body.get("TYPE") == "Player" && body.get("health") < 4):
		body.health += 1
		queue_free()
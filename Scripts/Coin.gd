extends Area2D

func _ready():
	$AnimationPlayer.play("idle")

func _on_Coin_body_entered(body):
	if(body.get("TYPE") == "Player" && body.get("coins") < 9):
		body.coins += 1
		queue_free()

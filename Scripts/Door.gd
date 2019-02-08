extends StaticBody2D

func _on_Area2D_body_entered(body):
	if(body.get("TYPE") == "Player" && body.get("coins") > 0):
		body.coins -= 1
		queue_free()

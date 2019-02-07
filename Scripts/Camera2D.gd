extends Camera2D

func _ready():
	$Area2D.connect("body_entered", self, "body_entered")
	$Area2D.connect("body_exited", self, "body_exited")

func _process(delta):
	var position = get_node("../Player").global_position - Vector2(0, 16)
	var x = floor(position.x / 160) * 160
	var y = floor(position.y / 128) * 128
	global_position = Vector2(x, y)
	

func _on_Area2D_body_entered(body):
	if(body.get("TYPE") == "Enemy"):
		body.set_physics_process(true)


func _on_Area2D_body_exited(body):
	if(body.get("TYPE") == "Enemy"):
		body.set_physics_process(false)

extends CanvasLayer

onready var player = get_node("../Player")

const HEART_ROW_SIZE = 4
const HEART_OFFSET = 18

func _ready():
	create_lives_ui()

func _process(delta):
	manage_coins()
	manage_lives()
		
func manage_coins():
	if(player.coins == 0):
		$Coins/Counter.frame = 9
	else:		
		$Coins/Counter.frame = (player.coins) - 1
		
		
func manage_lives():
	for life in $Lives.get_children():
		var index = life.get_index()
		var x = (index % HEART_ROW_SIZE) * HEART_OFFSET
		var y = (index / HEART_ROW_SIZE) * HEART_OFFSET
		life.position = Vector2(x, y)		
		
		var last_life = floor(player.health)
		if(index > last_life):
			print("index > last_life")
			life.frame = 0
		if(index == last_life):
			print("index == last_life")
			life.frame = (player.health - last_life) * 4
		if(index < last_life):
			print("index < last_life")
			life.frame = 4
	
func create_lives_ui():
	for i in player.health:
		var new_heart = Sprite.new()
		new_heart.texture = $Lives.texture
		new_heart.hframes = $Lives.hframes
		$Lives.add_child(new_heart)	

#	$Lives.frame = 4 - (player.health)

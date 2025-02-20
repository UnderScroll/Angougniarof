extends TextureRect

@export var shadows : Array[Texture2D] = []


func random_shadow():
	shadows.shuffle()
	texture = shadows[0]
	
	# scaler helper
	pivot_offset = Vector2(
		texture.get_width()/2,
		texture.get_height()/2
	)

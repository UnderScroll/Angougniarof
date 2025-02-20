extends TextureRect

@export var shadows : Array[Texture2D] = []


func random_shadow():
	shadows.shuffle()
	texture = shadows[0]

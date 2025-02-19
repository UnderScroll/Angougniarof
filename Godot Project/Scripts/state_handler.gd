extends Node
class_name StateHandler

enum States {
	START, PLAY, WAIT, SCORE, ENDSCORE
}

@export var state : States = States.START:
	set(value): state = value; set_state(value);

@export_group("STATE NODES")
@export var start_node : GameState
@export var play_node : GameState
@export var wait_node : GameState
@export var score_node : GameState
@export var endscore_node : GameState

## code helper - easier to use
var ui_nodes : Array[GameState] = []

func _ready() -> void:
	# Oui je sais c'est pas beau ici, mais en bas c'est clean
	# c'est juste une for loop pour tout cacher
	ui_nodes.append(start_node)
	ui_nodes.append(play_node)
	ui_nodes.append(wait_node)
	#ui_nodes.append(score_node)
	#ui_nodes.append(endscore_node)
	for i in ui_nodes:
		i.connect("change_state", set_state)



func set_state(val : States) -> void:
	match val:
		States.START: state_start()
		States.PLAY: state_play()
		States.WAIT: state_wait()
		States.SCORE: state_score()
		States.ENDSCORE: state_endscore()
		_ : print_debug("UNKOWN STATE")


func state_start():
	hide_all()
	start_node.enter_state()

func state_play():
	hide_all()
	play_node.enter_state()

func state_wait():
	#hide_all() # will not work if previous state != PLAY
	wait_node.enter_state()
func state_score():pass
func state_endscore():pass

## Hide all nodes
func hide_all(): 
	for nd in ui_nodes: 
		nd.hide()
	# j'avais prévenu, c'est beau ça

extends Control
class_name GameState

signal change_state

func enter_state() -> void:
	print_debug("enter_state func not overiden")

func exit_state() -> void:
	print_debug("exit_state func not overiden")

func change_state_to(st : StateHandler.States) -> void:
	change_state.emit(st)

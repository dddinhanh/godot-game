extends Node2D

const ScenePrologue: PackedScene = preload(
	"res://scenes/levels/00_prologue/scene_00_prologue.tscn"
)

var transitioning := false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and not transitioning:
		transitioning = true
		$Transition_Screen_00.transition()


func _on_transition_screen_00_transitioned() -> void:
	print("Changing to Prologue")
	get_tree().change_scene_to_packed(ScenePrologue)

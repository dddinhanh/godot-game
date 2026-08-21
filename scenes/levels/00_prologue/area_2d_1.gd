extends Area2D

var entered = false


@onready var tutorial_label = $"../../UI/TimeSkipTutorialLabel"


func _on_body_entered(body: Node2D) -> void:
	print("TORCH TRIGGER HIT BY: ", body.name)
	if body.is_in_group("player"):
		print("TORCH UI ON")
		tutorial_label.show()
		entered = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("TORCH UI OFF")
		tutorial_label.hide()
		entered = false

func _process(delta: float) -> void:
	if entered and Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file(
			"res://scenes/levels/01_border_outskirts/scene_01_border_outskirts.tscn"
		)

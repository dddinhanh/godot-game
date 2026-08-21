extends Area2D

@onready var tutorial_label = $"../../UI/TorchTutorialLabel"


func _on_body_entered(body: Node2D) -> void:
	print("TORCH TRIGGER HIT BY: ", body.name)

	if body.is_in_group("player"):
		print("TORCH UI ON")
		tutorial_label.show()


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("TORCH UI OFF")
		tutorial_label.hide()

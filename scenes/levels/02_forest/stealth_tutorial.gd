extends Area2D

@onready var stealth_tutorial_label: RichTextLabel = $"../../UI/StealthTutorialLabel"

func _ready() -> void:
	stealth_tutorial_label.hide()

func _on_body_entered(body: Node2D) -> void:
	print("STEALTH TUTORIAL TRIGGER HIT BY: ", body.name)

	if body.is_in_group("player"):
		print("STEALTH TUTORIAL LABEL ON")
		stealth_tutorial_label.show()

		await get_tree().create_timer(2.0).timeout

		stealth_tutorial_label.hide()
		print("STEALTH TUTORIAL LABEL AUTO HIDDEN")


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		stealth_tutorial_label.hide()
		print("STEALTH TUTORIAL LABEL HIDDEN ON EXIT")

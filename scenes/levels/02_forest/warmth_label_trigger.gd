extends Area2D


@onready var warmth_label: RichTextLabel = $"../../UI/WarmthLabel"


func _ready() -> void:
	warmth_label.hide()

func _on_body_entered(body: Node2D) -> void:
	print("WARMTH TRIGGER HIT BY: ", body.name)

	if body.is_in_group("player"):
		print("WARMTH UI ON")
		warmth_label.show()

		await get_tree().create_timer(2.0).timeout

		warmth_label.hide()
		print("WARMTH UI AUTO HIDDEN")


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		warmth_label.hide()
		print("WARMTH UI HIDDEN ON EXIT")

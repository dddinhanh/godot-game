extends Area2D

@onready var warmth_label: RichTextLabel = $"../../UI/WarmthLabel"




var triggered := false


func _on_body_entered(body: Node2D) -> void:
	print("WARMTH TRIGGER HIT BY: ", body.name)

	if body.is_in_group("player") and !triggered:
		triggered = true

		print("WARMTH UI ON")
		warmth_label.show()

		print("WAITING 6 SECONDS")
		await get_tree().create_timer(6.0).timeout

		print("CHANGING TO SCENE 02")

		get_tree().change_scene_to_file(
			"res://scenes/levels/02_forest/scene_02_forest.tscn"
		)

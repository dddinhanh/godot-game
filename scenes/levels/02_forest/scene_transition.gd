extends Area2D


var triggered := false


func _on_body_entered(body: Node2D) -> void:
	print("SCENE TRANSITION TRIGGER HIT BY: ", body.name)

	if body.is_in_group("player") and !triggered:
		triggered = true

		print("WAITING 3 SECONDS")
		await get_tree().create_timer(3.0).timeout

		print("CHANGING TO SCENE 03")

		get_tree().change_scene_to_file(
			"res://scenes/levels/03_checkpoint/scene_03_military_checkpoint.tscn"
		)

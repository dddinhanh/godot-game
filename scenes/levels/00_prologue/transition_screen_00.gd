extends CanvasLayer

signal transitioned


func transition() -> void:
	$AnimationPlayer.play("fade_out")
	print("Fading to black")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		print("Fade complete")
		transitioned.emit()

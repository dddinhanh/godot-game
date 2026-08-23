extends CanvasLayer

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		queue_free()

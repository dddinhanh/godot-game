extends PointLight2D

var flicker_timer := 0.0


func _process(delta: float) -> void:
	flicker_timer += delta

	if flicker_timer >= 0.1333:
		flicker_timer = 0.0

		energy = randf_range(0.9, 1.0)
		scale = Vector2.ONE * energy

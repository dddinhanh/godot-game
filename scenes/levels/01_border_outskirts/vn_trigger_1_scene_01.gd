extends Area2D

@export var visual_novel_scene: PackedScene

var triggered := false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	print("ENTERED AREA: ", body.name)

	if triggered:
		return

	if body.is_in_group("player"):
		print("PLAYER DETECTED")

		triggered = true

		var vn = visual_novel_scene.instantiate()
		get_tree().current_scene.add_child(vn)

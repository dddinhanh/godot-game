extends Area2D


@export var visual_novel_scene: PackedScene

var triggered := false


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	print("ENTERED AREA: ", body.name)

	if triggered:
		return

	if not body.is_in_group("player"):
		return

	if visual_novel_scene == null:
		push_error(
			"VNAccidentTrigger chưa được gán Visual Novel Scene."
		)
		return

	print("PLAYER DETECTED")
	triggered = true

	var vn := visual_novel_scene.instantiate()
	get_tree().current_scene.add_child(vn)

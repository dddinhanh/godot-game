extends Area2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node2D) -> void:
	if body.name == "PlayerLilith" \
	or body.is_in_group("player"):
		if body.has_method("set_inside_shelter"):
			body.set_inside_shelter(true)
			print("PLAYER ENTERED BONFIRE WARMTH AREA")


func _on_body_exited(body: Node2D) -> void:
	if body.name == "PlayerLilith" \
	or body.is_in_group("player"):
		if body.has_method("set_inside_shelter"):
			body.set_inside_shelter(false)
			print("PLAYER EXITED BONFIRE WARMTH AREA")

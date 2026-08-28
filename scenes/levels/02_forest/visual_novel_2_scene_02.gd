extends CanvasLayer


@export var vn_images: Array[Texture2D]

@onready var texture_rect: TextureRect = $ColorRect/TextureRect
@onready var dialogue_label: RichTextLabel = \
	$ColorRect/DialogueLabel


var current_frame: int = 0


func _ready() -> void:
	layer = 100
	show_current_frame()




func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled()
		next_frame()


func next_frame() -> void:
	current_frame += 1

	if current_frame >= vn_images.size():
		queue_free()
		return

	show_current_frame()


func show_current_frame() -> void:
	if vn_images.is_empty():
		push_error("Chưa thêm ảnh vào VN Images.")
		return

	texture_rect.texture = vn_images[current_frame]

	match current_frame:
		0:
			show_lilith_dialogue(
				"Trothford cách đây không xa…"
			)

		1:
			show_lilith_dialogue(
				"…mà họ đã chết ngay trên đường tới đó."
			)

		2:
			show_narration(
				"Một tiếng còi lính vang lên từ phía Tây."
			)


func show_lilith_dialogue(line: String) -> void:
	dialogue_label.text = (
		"[center]"
		+ "[color=#f2d84b]"
		+ line
		+ "[/color]"
		+ "[/center]"
	)


func show_narration(line: String) -> void:
	dialogue_label.text = (
		"[center]"
		+ "[color=#ffffff]"
		+ "[i]"
		+ line
		+ "[/i]"
		+ "[/color]"
		+ "[/center]"
	)

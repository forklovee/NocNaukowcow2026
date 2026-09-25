extends Node2D

enum Mode{
	DISABLED,
	MOUSE,
	MOUSE_INVERTED,
	MOUSE_INVERTED_NORMALIZED,
	NORMALIZED_SCALED
}

var mode: Mode
var proca: Node2D

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_f1"):
		mode = Mode.DISABLED if mode > Mode.DISABLED else Mode.MOUSE
	if Input.is_action_just_pressed("ui_left"):
		change_mode(-1)
	if Input.is_action_just_pressed("ui_right"):
		change_mode(1)

func _ready() -> void:
	var scene := get_tree().current_scene
	proca = scene.get_node("Proca")

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	z_index = 128
	if !proca:
		return
	var proca_spawnpoint_pos = proca.get_node("Spawnpoint").global_position
	var mouse_position := get_global_mouse_position()
	var normalized: Vector2 = (mouse_position - proca_spawnpoint_pos).normalized()
	match mode:
		Mode.DISABLED:
			pass
		Mode.MOUSE:
			draw_arrow(proca_spawnpoint_pos, mouse_position, 5.0, Color("f00"), "proca -> mysz")
		Mode.MOUSE_INVERTED:
			var mouse_position_inverted: Vector2 = proca_spawnpoint_pos - normalized * proca_spawnpoint_pos.distance_to(mouse_position)
			draw_arrow(proca_spawnpoint_pos, mouse_position_inverted, 5.0, Color("00f"))
		Mode.MOUSE_INVERTED_NORMALIZED:
			var inverted_normalized: Vector2 = proca_spawnpoint_pos - normalized
			draw_arrow(proca_spawnpoint_pos, inverted_normalized, 5.0, Color("f0f"), "Znormalizowany")
		Mode.NORMALIZED_SCALED:
			var inverted_normalized: Vector2 = proca_spawnpoint_pos - proca.wektor_strzału
			draw_arrow(proca_spawnpoint_pos, inverted_normalized, 5.0, Color("f0f"))

func change_mode(direction: int):
	if mode == Mode.DISABLED:
		return
	mode += direction
	if mode > Mode.NORMALIZED_SCALED:
		mode = Mode.MOUSE
	elif mode < Mode.DISABLED:
		mode = Mode.NORMALIZED_SCALED

func draw_arrow(from: Vector2, to: Vector2, width: float, color: Color, label = ""):
	var angle := deg_to_rad(45.0)
	var right_side: Vector2 = from.direction_to(to).rotated(3.0*angle)
	var left_side: Vector2 = from.direction_to(to).rotated(angle)
	draw_line(from, to, color, width, true)
	draw_line(to, to + right_side * 15.0, color, width, true)
	draw_line(to, to - left_side * 15.0, color, width, true)

	var offset_vector := to - from
	var vec_text: String = str(offset_vector)
	var len_text: String = "długość: " + str(snappedf(offset_vector.length(), 0.01))
	var mid_pos := from + offset_vector * .5
	var black_color := Color("000")
	if label != "":
		draw_string(ThemeDB.fallback_font, mid_pos + Vector2.UP * 55.5, label, 0, -1, 16, black_color)
		draw_string(ThemeDB.fallback_font, mid_pos + Vector2.UP * 55, label, 0, -1, 16, color)
	draw_string(ThemeDB.fallback_font, mid_pos + Vector2.UP * 34.5, vec_text, 0, -1, 16, black_color)
	draw_string(ThemeDB.fallback_font, mid_pos + Vector2.UP * 14.5, len_text, 0, -1, 16, black_color)
	draw_string(ThemeDB.fallback_font, mid_pos + Vector2.UP * 34, vec_text, 0, -1, 16, color)
	draw_string(ThemeDB.fallback_font, mid_pos + Vector2.UP * 14, len_text, 0, -1, 16, color)

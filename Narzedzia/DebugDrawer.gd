extends Node2D

var proca: Node2D

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
	draw_arrow(proca_spawnpoint_pos, mouse_position, 5.0, Color("f00"))
	var normalized: Vector2 = (mouse_position - proca_spawnpoint_pos).normalized()
	var mouse_position_inverted: Vector2 = proca_spawnpoint_pos - normalized * proca_spawnpoint_pos.distance_to(mouse_position)
	var inverted_normalized: Vector2 = proca_spawnpoint_pos - normalized * 100.0
	draw_arrow(proca_spawnpoint_pos, mouse_position_inverted, 5.0, Color("00f"))
	draw_arrow(proca_spawnpoint_pos, inverted_normalized, 5.0, Color("00f"))

func draw_arrow(from: Vector2, to: Vector2, width: float, color: Color):
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
	draw_string(ThemeDB.fallback_font, mid_pos + Vector2.UP * 34.5, vec_text, 0, -1, 16, Color("000"))
	draw_string(ThemeDB.fallback_font, mid_pos + Vector2.UP * 14.5, len_text, 0, -1, 16, Color("000"))
	draw_string(ThemeDB.fallback_font, mid_pos + Vector2.UP * 34, vec_text, 0, -1, 16, color)
	draw_string(ThemeDB.fallback_font, mid_pos + Vector2.UP * 14, len_text, 0, -1, 16, color)

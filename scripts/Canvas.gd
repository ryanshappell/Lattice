extends Node2D

var foregroundPicker: ColorPickerButton
var background: TextureRect
var background_scale: float

var layers := []
var current_layer_index := 0

var size: Vector2
var focus := false

var prev_mouse_pos: Vector2

func _ready() -> void:
	foregroundPicker = find_parent("Main").find_node("Foreground")
	background = get_node("../TransparentBackground")
	background_scale = 10
	
	size = Vector2(16, 16)
	layers.append(Layer.new(size))

func _process(delta) -> void:
	var mouse_pos = get_local_mouse_position()
	var mouse_in_layer := Rect2(Vector2.ZERO, size).has_point(mouse_pos)
	
	# Draw pixels
	if Input.is_action_pressed("tool_primary") && mouse_in_layer:
		layers[current_layer_index].set_pixel(mouse_pos.x, mouse_pos.y, foregroundPicker.color)
	
	# Update layers textures as needed
	for layer in layers:
		layer.update_texture()
	
	# Update prev mouse position
	prev_mouse_pos = mouse_pos

func _draw() -> void:
	# Draw layers
	for layer in layers:
		if layer.show:
			draw_texture(layer.texture, Vector2.ZERO)

# Updates the transparent background grid
func update_background(zoom: Vector2) -> void:
	background.rect_scale = zoom * background_scale
	background.rect_size = size / zoom / background_scale

func _on_ViewportContainer_mouse_entered() -> void:
	focus = true

func _on_ViewportContainer_mouse_exited() -> void:
	focus = false

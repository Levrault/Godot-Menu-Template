tool
class_name CheckboxField, "res://assets/icons/check-square.svg"
extends Field

const CHECKED := "checked"
const UNCHECKED := "unchecked"

var selected_key := ""

onready var checkbox := $CheckBox


func _ready() -> void:
	if Engine.editor_hint:
		return
	yield(owner, "ready")
	if key.empty():
		printerr("%s's key is empty" % get_name())
		return
	revert()

	connect("focus_entered", self, "_on_Focus_entered")
	checkbox.connect("toggled", self, "_on_Toggled")
	checkbox.connect("focus_exited", self, "emit_signal", ["field_focus_exited"])


func reset() -> void:
	selected_key = EngineSettings.data[owner.form.engine_file_section][key].default
	values = EngineSettings.data[owner.form.engine_file_section][key][selected_key]
	checkbox.pressed = values.key
	Config.save_field(owner.form.engine_file_section, key, selected_key)
	apply()


func revert() -> void:
	selected_key = Config.values[owner.form.engine_file_section][key]
	values = EngineSettings.data[owner.form.engine_file_section][key][selected_key]
	checkbox.pressed = values.key
	apply()


func _on_Toggled(button_pressed: bool) -> void:
	selected_key = CHECKED if button_pressed else UNCHECKED
	values = EngineSettings.data[owner.form.engine_file_section][key][selected_key]
	Config.save_field(owner.form.engine_file_section, key, selected_key)
	emit_signal("field_item_selected", button_pressed)


func _on_Focus_entered() -> void:
	checkbox.grab_focus()
	emit_signal("field_focus_entered")
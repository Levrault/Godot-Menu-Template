class_name Updater
extends Node


func _ready() -> void:
	if not get_parent() is Field:
		printerr("Parent %s of %s is not a field" % [get_parent().get_name(), get_name()])
	assert(get_parent() is Field)

	yield(owner, "ready")
	yield(get_tree(), "idle_frame")

	if not get_parent().values.has("properties"):
		printerr(
			(
				"Parent %s of %s has not set his properties inside the values dictionary"
				% [get_parent().get_name(), get_name()]
			)
		)
		return

	apply(get_parent().values.properties, false)


func apply(properties: Dictionary, trigger_callback_action := true) -> void:
	pass
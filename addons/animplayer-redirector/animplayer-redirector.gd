@tool
extends EditorPlugin

# Plugin to help you redirect the paths of nodes referenced by an AnimationPlayer.
# Author: Jeremy Bechen
# 

var button: Button
var selected_player: AnimationPlayer
var active_scene_root: Node
var dialog: Window
const BUTTON_TEXT = "Redirect Animation Node(s)"
@onready var dialog_scene: PackedScene = preload("res://addons/animplayer-redirector/tree_editor.tscn")


func _handles(object: Object) -> bool:
    return object is AnimationPlayer


func _edit(object: Object) -> void:
    if !object:
        return
    selected_player = object
    active_scene_root = get_editor_interface().get_edited_scene_root()


func _make_visible(visible: bool) -> void:
    if visible:
        _add_button()
    else:
        _remove_button()


func recursive_find_toolbar(node: Node, target_text: String) -> HBoxContainer:
    if node is HBoxContainer:
        for child in node.get_children():
            if child is Button and child.text == target_text:
                return node

    for child in node.get_children():
        var result = recursive_find_toolbar(child, target_text)
        if result:
            return result
    return null


func remove_orphaned_buttons():
    var container = recursive_find_toolbar(get_editor_interface().get_base_control(), BUTTON_TEXT)
    if container:
        for button in container.get_children().filter(func(x): return x is Button and x.text == BUTTON_TEXT):
            button.queue_free()


func _add_button() -> void:
    remove_orphaned_buttons()
    button = Button.new()
    button.text = "Redirect Animation Node(s)"
    button.focus_mode = Control.FOCUS_NONE
    button.flat = true
    button.pressed.connect(_on_button_pressed)
    add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, button)


func identify_animated_nodes() -> Dictionary:
    var collector: Dictionary = {} # old_node_path -> { new_node_path, count_animations, count_tracks, is_resolvable }
    for animation_name in selected_player.get_animation_list():
        var animation: Animation = selected_player.get_animation(animation_name)
        var has_counted_animation: bool = false
        for track_idx in animation.get_track_count():
            var track_path: NodePath = animation.track_get_path(track_idx)
            var target_node_path: NodePath = NodePath(track_path.get_concatenated_names())
            if not has_counted_animation:
                var is_resolvable = active_scene_root.get_node_or_null( target_node_path ) != null
                var to_collect: Dictionary = {
                    "new_node_path": target_node_path,
                    "count_animations": 1,
                    "count_tracks": 1,
                    "is_resolvable": is_resolvable
                }
                collector[target_node_path] = to_collect
                has_counted_animation = true
            else:
                collector[target_node_path]["count_tracks"] += 1
    
    return collector


func modify_node_paths(collector: Dictionary) -> void:
    for animation_name in selected_player.get_animation_list():
        var animation: Animation = selected_player.get_animation(animation_name)
        for track_idx in animation.get_track_count():
            var track_path: NodePath = animation.track_get_path(track_idx)
            var old_node_path: String = track_path.get_concatenated_names()
            var property: String = track_path.get_concatenated_subnames()
            var new_node_path: String = collector[old_node_path]["new_node_path"]
            var new_track_path: String = new_node_path + ":" + property
            animation.track_set_path(track_idx, new_track_path)


func _on_button_pressed() -> void:
    var collector: Dictionary = identify_animated_nodes()
    dialog = dialog_scene.instantiate()
    dialog.connect("accept_pressed", _on_dialog_accepted)
    EditorInterface.popup_dialog_centered(dialog, Vector2i(dialog.size.x, dialog.size.y))
    dialog.init(collector, active_scene_root)

func _on_dialog_accepted(collector: Dictionary) -> void:
    modify_node_paths(collector)
    EditorInterface.mark_scene_as_unsaved()




func _remove_button() -> void:
    remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, button)
    button.queue_free()
    button = null
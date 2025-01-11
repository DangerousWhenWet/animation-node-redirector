@tool
extends Window

@onready var tree: Tree = $VBoxContainer/Tree
var active_scene_root: Node
signal accept_pressed

func reset_tree():
    tree.clear()
    var root = tree.create_item()  # Root item for the tree
    tree.hide_root = true
    tree.columns = 5

    tree.columns = 5
    tree.set_column_title(0, "Old Path")
    tree.set_column_expand_ratio(0, 3)
    tree.set_column_expand(0, true)

    tree.set_column_title(1, "✏️ New Path")
    tree.set_column_expand_ratio(1, 3)
    tree.set_column_expand(1, true)

    tree.set_column_title(2, "# Animations")
    tree.set_column_expand_ratio(2, 1)
    tree.set_column_expand(2, true)

    tree.set_column_title(3, "# Tracks")
    tree.set_column_expand_ratio(3, 1)
    tree.set_column_expand(3, true)

    tree.set_column_title(4, "Resolvable")
    tree.set_column_expand_ratio(4, 1)
    tree.set_column_expand(4, true)


    tree.column_titles_visible = true

func populate_tree(collector: Dictionary):
    reset_tree()
    var accent_color: Color = get_theme_color("accent_color", "Editor")
    var root = tree.get_root()  # Ensure we're attaching items to the root
    for old_node_path in collector.keys():
        var entry = collector[old_node_path]
        var item = tree.create_item(root)  # Child items under the root
        item.set_text(0, str(old_node_path))
        item.set_text(1, str(entry["new_node_path"]))
        item.set_custom_color(1, accent_color)
        item.set_text(2, str(entry["count_animations"]))
        item.set_text(3, str(entry["count_tracks"]))
        item.set_text(4, str(entry["is_resolvable"]))
        item.set_custom_color(
            4,
            Color(0, 1, 0) if entry["is_resolvable"] else Color(1, 0, 0)
        )
        item.set_editable(1, true)


func test_all_resolvable() -> void:
    for row in tree.get_root().get_children():
        var new_node_path = row.get_text(1)
        var is_resolvable = active_scene_root.get_node_or_null(new_node_path) != null
        row.set_text(4, str(is_resolvable))
        row.set_custom_color(4, Color(0, 1, 0) if is_resolvable else Color(1, 0, 0))


func collect_tree() -> Dictionary:
    var collector: Dictionary = {}
    for item in tree.get_root().get_children():
        var old_node_path = item.get_text(0)
        var new_node_path = item.get_text(1)
        var count_animations = item.get_text(2)
        var count_tracks = item.get_text(3)
        var is_resolvable = item.get_text(4)
        collector[old_node_path] = {
            "new_node_path": new_node_path,
            "count_animations": count_animations,
            "count_tracks": count_tracks,
            "is_resolvable": is_resolvable
        }

    return collector


func init(collector: Dictionary, active_scene_root: Node) -> void:
    self.active_scene_root = active_scene_root
    reset_tree()
    populate_tree(collector)

func _on_cancel_pressed() -> void:
    queue_free()

func _on_accept_pressed() -> void:
    accept_pressed.emit(collect_tree())
    queue_free()


func _on_close_requested() -> void:
    queue_free()


func _on_tree_item_edited() -> void:
    test_all_resolvable()

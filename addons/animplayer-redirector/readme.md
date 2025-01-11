# **Animation Node Redirector**

**Problem:** Sometimes when you edit the scene tree of a scene that has an AnimationPlayer wired up to it, the AnimationPlayer fails to resolve nodes in the scene whose NodePaths have changed and as a result can no longer play animations.

**Solution:** Use a `@tool` script to edit the NodePaths referenced by the AnimationPlayer so they can be resolved again. This addon provides a basic UI to simplify the process.

<video src="addons/animplayer-redirector/docs/demo-animation-redirector.mp4" controls loop autoplay muted>
</video>

### **Installation**

- Download from the Godot Asset Library, within your Godot Editor.

### **Usage**

- Select an AnimationPlayer in the scene tree in the Scene dock — a button is revealed on the viewport toolbar `[Redirect Animation Node(s)]`.
- Click the button — a popup window appears listing all of the nodes referenced by the AnimationPlayer in a table.
- Edit the *New Node Path* field until all nodes can be resolved again.
- `[Accept]`
- Save your scene.

### **Limitations**

- Tested only in `v4.4.dev7.official [46c8f8c5c]`.
- The addon currently only functions in the Spatial/3D editor viewport. A small update is planned to dynamically support 3D or 2D viewports. But, in the meantime, enabling 2D editor functionality should be a fairly straightforward modification (I haven't tested this):
  - Edit `animplayer-redirector.gd`
    - Edit `func _add_button()`:
      - `EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU` → `EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU`
    - Edit `func _remove_button()`:
      - `EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU` → `EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU`
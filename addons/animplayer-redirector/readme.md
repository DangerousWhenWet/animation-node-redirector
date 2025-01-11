# **Animation Node Redirector**

**Problem:** Sometimes when you edit the scene tree of a scene that has an AnimationPlayer wired up to it, the AnimationPlayer fails to resolve nodes in the scene whose NodePaths have changed and as a result can no longer play animations.

**Solution:** Use a `@tool` script to edit the NodePaths referenced by the AnimationPlayer so they can be resolved again. This addon provides a basic UI to simplify the process.



https://github.com/user-attachments/assets/20eb002a-dd70-4271-b85b-ff4648fc7c6c



### **Installation**

- Download from the Godot Asset Library, within your Godot Editor:
  - **Godot Docs:** [Using the Asset Library → In the editor](https://docs.godotengine.org/en/stable/community/asset_library/using_assetlib.html#in-the-editor)
- Manual installation:
  - **Godot Docs:** [Installing plugins → Installing a plugin](https://docs.godotengine.org/en/stable/tutorials/plugins/editor/installing_plugins.html#installing-a-plugin)

### **Usage**

- Enable the plugin.
  - **Godot Docs:** [Installing plugins → Enabling a plugin](https://docs.godotengine.org/en/stable/tutorials/plugins/editor/installing_plugins.html#enabling-a-plugin)
- Select an AnimationPlayer in the scene tree in the Scene dock — a button is revealed on the viewport toolbar `[Redirect Animation Node(s)]`.
- Click the button — a popup window appears listing all of the nodes referenced by the AnimationPlayer in a table.
- Edit the *New Node Path* field until all nodes can be resolved again.
- `[Accept]`
- Save your scene.

### **Limitations**

- Tested only in `v4.4.dev7.official [46c8f8c5c]` (but I can't think of a reason for it not to work in 4.x)
- The addon currently only functions in the Spatial/3D editor viewport. A small update is planned to dynamically support 3D or 2D viewports. But, in the meantime, enabling 2D editor functionality should be a fairly straightforward modification (I haven't tested this):
  - Edit `animplayer-redirector.gd`
    - Edit `func _add_button()`:
      - `EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU` → `EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU`
    - Edit `func _remove_button()`:
      - `EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU` → `EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU`

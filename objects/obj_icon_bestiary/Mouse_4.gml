// --- Left Pressed Event ---

// 1. Safety Check: Is the mouse blocked by ANY open window?
var _blocked_by_window = false;
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

// Loop through ALL windows to see if we are clicking inside one of them
with (obj_window_parent) {
    // If the window is visible AND the mouse is inside its bounding box
    if (visible && point_in_rectangle(_mx, _my, window_x1, window_y1, window_x2, window_y2)) {
        _blocked_by_window = true;
        break; // Stop checking, we found a blocker
    }
}

// 2. Only open the app if we are NOT blocked
if (!_blocked_by_window) {
	play_ui_click();
    if (!instance_exists(obj_pokedex_manager)) {
        instance_create_layer(0, 0, "Instances", obj_pokedex_manager);
    }
}
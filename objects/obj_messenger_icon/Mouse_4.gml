// --- Left Pressed Event ---

// 1. Safety Check: Is the mouse blocked by ANY open window?
var _blocked_by_window = false;
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

with (obj_window_parent) {
    if (visible && point_in_rectangle(_mx, _my, window_x1, window_y1, window_x2, window_y2)) {
        _blocked_by_window = true;
        break; 
    }
}

// 2. Only open if NOT blocked
if (!_blocked_by_window) {
	play_ui_click();
    if (!instance_exists(obj_messenger_manager)) {
        instance_create_layer(0, 0, "Instances", obj_messenger_manager);
        // Stop blinking logic
        is_blinking = false; 
        blink_timer = 0;
    }
}
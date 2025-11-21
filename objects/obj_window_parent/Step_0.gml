// --- obj_window_parent: Step Event ---

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _click = mouse_check_button_pressed(mb_left);

// ================== ANIMATION LOGIC ==================

// 0: INIT & 1: OPENING (Existing Logic)
if (anim_state == 0) {
    final_x = window_x1;
    final_y = window_y1;
    final_w = window_width;
    final_h = window_height;
    
    start_x = _mx; start_y = _my; start_w = 10; start_h = 10;
    
    window_x1 = start_x; window_y1 = start_y;
    window_width = start_w; window_height = start_h;
    anim_state = 1;
}
else if (anim_state == 1) { // OPENING
    anim_timer++;
    var _t = clamp(anim_timer / anim_duration, 0, 1);
    var _ease = 1 - power(2, -10 * _t);
    
    window_x1 = lerp(start_x, final_x, _ease);
    window_y1 = lerp(start_y, final_y, _ease);
    window_width = lerp(start_w, final_w, _ease);
    window_height = lerp(start_h, final_h, _ease);
    
    if (anim_timer >= anim_duration) {
        window_x1 = final_x; window_y1 = final_y;
        window_width = final_w; window_height = final_h;
        anim_state = 2; // OPEN
    }
}
// --- NEW: MINIMIZING (3) ---
else if (anim_state == 3) {
    anim_timer++;
    var _t = clamp(anim_timer / anim_duration, 0, 1);
    var _ease = 1 - power(2, -10 * _t); // Same ease
    
    // Shrink from Open (final_) to Taskbar (task_)
    window_x1 = lerp(final_x, task_target_x, _ease);
    window_y1 = lerp(final_y, task_target_y, _ease);
    window_width = lerp(final_w, 0, _ease);
    window_height = lerp(final_h, 0, _ease);
    
    if (anim_timer >= anim_duration) {
        is_minimized = true;
        visible = false; // Hide completely once minimized
        // NOTE: We don't destroy it, just hide it.
        // The Hub Manager taskbar button logic needs to un-minimize it.
    }
}
// --- NEW: RESTORING (4) ---
else if (anim_state == 4) {
    visible = true; // Make visible immediately
    is_minimized = false;
    
    anim_timer++;
    var _t = clamp(anim_timer / anim_duration, 0, 1);
    var _ease = 1 - power(2, -10 * _t);
    
    // Grow from Taskbar to Saved Position
    window_x1 = lerp(task_target_x, final_x, _ease);
    window_y1 = lerp(task_target_y, final_y, _ease);
    window_width = lerp(0, final_w, _ease);
    window_height = lerp(0, final_h, _ease);
    
    if (anim_timer >= anim_duration) {
        window_x1 = final_x; window_y1 = final_y;
        window_width = final_w; window_height = final_h;
        anim_state = 2; // Back to OPEN
    }
}
// =====================================================


// 1. Update Coordinates
window_x2 = window_x1 + window_width;
window_y2 = window_y1 + window_height;

// Button Layout
var _btn_size = 22; 
btn_close_x2 = window_x2 - 6;
btn_close_y1 = window_y1 + 6;
btn_close_x1 = btn_close_x2 - _btn_size; 
btn_close_y2 = btn_close_y1 + _btn_size;

// Minimize Button (Left of Close Button)
btn_min_x2 = btn_close_x1 - 4; 
btn_min_x1 = btn_min_x2 - _btn_size;
btn_min_y1 = btn_close_y1;
btn_min_y2 = btn_close_y2;


// 2. Interact Logic (Only when fully OPEN)
if (anim_state == 2) {
    btn_close_hover = point_in_box(_mx, _my, btn_close_x1, btn_close_y1, btn_close_x2, btn_close_y2);
    btn_min_hover = point_in_box(_mx, _my, btn_min_x1, btn_min_y1, btn_min_x2, btn_min_y2);

    if (_click) {
        if (btn_close_hover) {
            instance_destroy();
            exit; 
        }
        // MINIMIZE CLICK
        if (btn_min_hover) {
            anim_state = 3; // Start Minimizing
            anim_timer = 0;
            // Approximate taskbar position (bottom left or derived from object index)
            task_target_x = 100; 
            task_target_y = display_get_gui_height(); 
        }
    }
    
    // Restore logic (Triggered externally usually, but we can add self-restore logic if needed later)
}

// 3. Dragging Logic (Only active if fully open)
if (anim_state == 2) {
    if (mouse_check_button_pressed(mb_left)) {
        if (global.dragged_window == noone) {
            // Check Title Bar (excluding buttons)
            if (point_in_box(_mx, _my, window_x1, window_y1, window_x2, window_y1 + 32) && !btn_close_hover && !btn_min_hover) {
                is_dragging = true;
                global.dragged_window = id; 
                
                drag_dx = window_x1 - _mx;
                drag_dy = window_y1 - _my;
                
                global.top_window_depth -= 1;
                depth = global.top_window_depth;
            }
        }
    }

    if (mouse_check_button_released(mb_left)) {
        is_dragging = false;
        if (global.dragged_window == id) {
            global.dragged_window = noone; 
        }
    }

    if (is_dragging) {
        window_x1 = _mx + drag_dx;
        window_y1 = _my + drag_dy;
        final_x = window_x1; // Update "Restore" position
        final_y = window_y1;
    }
}
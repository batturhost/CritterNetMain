// --- Step Event ---

// 1. INHERIT PARENT
event_inherited();

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _click = mouse_check_button_pressed(mb_left);

// --- PASTE THIS FIX HERE ---
// [FIX] DEPTH CHECK: Is there a window ON TOP of us?
var _is_covered = false;
with (obj_window_parent) {
    if (id != other.id && visible && depth < other.depth) {
        if (point_in_rectangle(_mx, _my, window_x1, window_y1, window_x2, window_y2)) {
            _is_covered = true;
            break;
        }
    }
}
if (_is_covered) _click = false;
// ---------------------------


// 2. Handle Special Closing Logic (Bargain/Trapdoor)
// We assume user clicked 'X' if instance doesn't exist next frame?
// Actually, we need to check if parent is destroying us.
// However, parent Step event runs first. If close clicked, we are dead.
// So we put this logic in the CLEANUP Event or perform the check before inheritance.
// For simplicity, let's re-add a check for the parent's close button hover var.
// Since parent runs first, 'btn_close_hover' is already updated.

if (_click && btn_close_hover) {
    if (global.bargain_offered && !global.trapdoor_unlocked) {
        global.trapdoor_unlocked = true;
    }
    // Parent will destroy us, we just did the logic.
}

// 3. Internal Buttons
btn_send_hover = point_in_box(_mx, _my, btn_send_x1, btn_send_y1, btn_send_x2, btn_send_y2);

if (_click && !is_dragging) {
    // Check Buddy List Click
    if (point_in_box(_mx, _my, buddy_list_x, buddy_list_y, buddy_list_x + buddy_list_w, buddy_list_y + buddy_list_h)) {
        var _rel_y = _my - buddy_list_y;
        var _idx = floor(_rel_y / contact_item_height);
        
        if (_idx >= 0 && _idx < array_length(contact_list)) {
            selected_contact_index = _idx;
            selected_contact_name = contact_list[_idx];
        }
    }
}

// 4. Recalculate UI (Sticky)
toolbar_y1 = window_y1 + 32;

buddy_list_x = window_x1 + 10;
buddy_list_y = toolbar_y1 + toolbar_h + 10;

chat_area_x = buddy_list_x + buddy_list_w + 10;
chat_area_y = buddy_list_y;
chat_area_h = buddy_list_h - 95;

input_area_x = chat_area_x;
input_area_y = chat_area_y + chat_area_h + 10;

btn_send_x1 = input_area_x + input_area_w - btn_send_w;
btn_send_y1 = input_area_y + input_area_h + 5;
btn_send_x2 = btn_send_x1 + btn_send_w;
btn_send_y2 = btn_send_y1 + btn_send_h;
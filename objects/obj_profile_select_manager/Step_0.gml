// --- Step Event ---

// 1. INHERIT PARENT
event_inherited();

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _click = mouse_check_button_pressed(mb_left);

// 2. Recalculate Layout (Sticky Logic for Dragging)
window_x2 = window_x1 + window_width;
window_y2 = window_y1 + window_height;

grid_x1 = window_x1 + 30;
// [FIX] Match Create event position
grid_y1 = window_y1 + 110;

// Footer Buttons
btn_cancel_x1 = window_x2 - 20 - btn_ok_w;
btn_cancel_y1 = window_y2 - 45;
btn_cancel_x2 = btn_cancel_x1 + btn_ok_w;
btn_cancel_y2 = btn_cancel_y1 + btn_ok_h;

btn_ok_x1 = btn_cancel_x1 - 10 - btn_ok_w;
btn_ok_y1 = btn_cancel_y1;
btn_ok_x2 = btn_ok_x1 + btn_ok_w;
btn_ok_y2 = btn_ok_y1 + btn_ok_h;

// Preview Position
preview_x1 = window_x2 - 200;
preview_y1 = grid_y1;
preview_x2 = preview_x1 + preview_box_size;
preview_y2 = preview_y1 + preview_box_size;


// 3. Grid Interaction
hover_index = -1;

if (!is_dragging) {
    // Check Grid Bounds
    if (_mx >= grid_x1 && _mx <= grid_x1 + grid_w && _my >= grid_y1 && _my <= grid_y1 + grid_h) {
        // Calculate Cell
        var _rel_x = _mx - grid_x1;
        var _rel_y = _my - grid_y1;
        
        var _col = floor(_rel_x / (cell_size + grid_padding));
        var _row = floor(_rel_y / (cell_size + grid_padding));
        
        // Check padding gaps
        if (_col >= 0 && _col < grid_cols && _row >= 0 && _row < grid_rows) {
            var _idx = (_row * grid_cols) + _col;
            if (_idx < array_length(avatar_list)) {
                hover_index = _idx;
                
                if (_click) {
                    selected_index = _idx;
                }
            }
        }
    }
    
    // 4. Button Logic
    btn_ok_hover = point_in_rectangle(_mx, _my, btn_ok_x1, btn_ok_y1, btn_ok_x2, btn_ok_y2);
    btn_cancel_hover = point_in_rectangle(_mx, _my, btn_cancel_x1, btn_cancel_y1, btn_cancel_x2, btn_cancel_y2);
    
    if (_click) {
        if (btn_ok_hover) {
            // SAVE & FINISH
            global.PlayerData.profile_pic = avatar_list[selected_index];
            room_goto(rm_hub);
        }
        if (btn_cancel_hover) {
            // CANCEL (Maybe just go to hub without saving, or stay here?)
            // For flow continuity, let's just go to hub with default/previous
            room_goto(rm_hub);
        }
    }
}
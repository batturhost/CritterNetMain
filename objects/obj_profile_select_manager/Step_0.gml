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
    // Note: grid_h is calculated based on grid_rows in Create_0.
    // Since we increased rows to 5, this hit box covers the new uploads.
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
    // Standard Buttons
    btn_ok_hover = point_in_rectangle(_mx, _my, btn_ok_x1, btn_ok_y1, btn_ok_x2, btn_ok_y2);
    btn_cancel_hover = point_in_rectangle(_mx, _my, btn_cancel_x1, btn_cancel_y1, btn_cancel_x2, btn_cancel_y2);
    
    // New Browse Button Logic
    var _browse_x1 = btn_mock_x;
    var _browse_y1 = btn_mock_start_y;
    var _browse_x2 = _browse_x1 + btn_mock_w;
    var _browse_y2 = _browse_y1 + btn_mock_h;
    
    var _btn_browse_hover = point_in_rectangle(_mx, _my, _browse_x1, _browse_y1, _browse_x2, _browse_y2);
    
    if (_click) {
        if (btn_ok_hover) {
            // SAVE & FINISH
			play_ui_click();
            global.PlayerData.profile_pic = avatar_list[selected_index];
            room_goto(rm_hub);
        }
        if (btn_cancel_hover) {
            // CANCEL - Just go to hub
            room_goto(rm_hub);
        }
        
        // --- BROWSE & UPLOAD ---
        if (_btn_browse_hover) {
            
            // [FIX] Limit upload count
            if (uploaded_count < 4) {
                // 1. Open File Dialog
                var _path = get_open_filename("Image Files|*.png;*.jpg;*.jpeg;*.gif", "");
                
                if (_path != "") {
                    // 2. Add Sprite from file
                    // Note: 0,0 origin is used to match the logic in Draw_64
                    var _new_spr = sprite_add(_path, 1, false, false, 0, 0);
                    
                    if (_new_spr != -1) {
                        // 3. Add to list and select it
                        array_push(avatar_list, _new_spr);
                        selected_index = array_length(avatar_list) - 1;
                        uploaded_count++; // Increment count
                    }
                }
            } 
            else {
                // Optional: Feedback if limit reached
                // show_debug_message("Max uploads reached.");
            }
        }
    }
}
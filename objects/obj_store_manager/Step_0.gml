// --- Step Event ---
event_inherited();

if (feedback_timer > 0) feedback_timer--;

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _click = mouse_check_button_pressed(mb_left);

if (!is_dragging) {
    // 1. Store List Selection (Left)
    if (point_in_box(_mx, _my, list_store_x1, list_store_y1, list_store_x2, list_store_y2)) {
        var _rel_y = _my - list_store_y1;
        var _idx = floor(_rel_y / list_item_h) + store_scroll;
        
        if (_click && _idx < array_length(catalog)) {
            selected_item_index = _idx;
            selected_inv_index = -1; // Deselect inventory
            feedback_msg = "";
        }
    }
    
    // 2. Inventory List Selection (Right)
    if (point_in_box(_mx, _my, list_inv_x1, list_inv_y1, list_inv_x2, list_inv_y2)) {
        var _rel_y = _my - list_inv_y1;
        var _idx = floor(_rel_y / list_item_h) + inv_scroll;
        
        if (_click && _idx < array_length(inventory_display_keys)) {
            selected_inv_index = _idx;
            selected_item_index = -1; // Deselect store
            feedback_msg = "";
        }
    }
}

// 3. Buy Button Logic
btn_buy_hover = point_in_box(_mx, _my, btn_buy_x1, btn_buy_y1, btn_buy_x2, btn_buy_y2);

if (_click && btn_buy_hover && selected_item_index != -1 && !is_dragging) {
    var _item = catalog[selected_item_index];
    
    if (global.PlayerData.coins >= _item.price) {
        // Transaction
        global.PlayerData.coins -= _item.price;
        
        // Add to Inventory
        array_push(global.PlayerData.inventory, _item);
        
        // Update the Inventory UI immediately
        refresh_inventory();
        
        feedback_msg = "Purchased!";
        feedback_timer = 60;
    } else {
        feedback_msg = "Too expensive!";
        feedback_timer = 60;
    }
}

// 4. Sticky Layout Recalculation
var _padding = 20;
var _col_width = (window_width - (_padding * 3)) / 2;
var _list_height = 220; // Match Create Event

list_store_x1 = window_x1 + _padding;
// [FIX] Updated to 90 to match Create event
list_store_y1 = window_y1 + 90; 
list_store_x2 = list_store_x1 + _col_width;
list_store_y2 = list_store_y1 + _list_height;

list_inv_x1 = list_store_x2 + _padding;
list_inv_y1 = list_store_y1;
list_inv_x2 = list_inv_x1 + _col_width;
list_inv_y2 = list_inv_y1 + _list_height;

detail_x1 = list_store_x1;
detail_y1 = list_store_y2 + _padding;
detail_x2 = list_inv_x2;
detail_y2 = window_y2 - 20;

btn_buy_x1 = detail_x2 - btn_buy_w - 20;
btn_buy_y1 = detail_y1 + 30;
btn_buy_x2 = btn_buy_x1 + btn_buy_w;
btn_buy_y2 = btn_buy_y1 + btn_buy_h;
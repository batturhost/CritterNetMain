// --- Create Event ---

// 1. INHERIT PARENT
event_inherited();

// [FIX] SAFETY VARIABLES
if (!variable_instance_exists(id, "is_dragging")) is_dragging = false;

// 2. Window Properties
window_width = 700;
window_height = 500;
window_title = "C-Store - V1.1";

// Center
window_x1 = (display_get_gui_width() / 2) - (window_width / 2);
window_y1 = (display_get_gui_height() / 2) - (window_height / 2);
window_x2 = window_x1 + window_width;
window_y2 = window_y1 + window_height;

// 3. Store Data
catalog = global.store_catalog;
selected_item_index = -1;
selected_inv_index = -1;

// 4. Inventory Management
inventory_display_keys = [];
inventory_counts = {};

refresh_inventory = function() {
    inventory_display_keys = [];
    inventory_counts = {};
    
    for (var i = 0; i < array_length(global.PlayerData.inventory); i++) {
        var _item = global.PlayerData.inventory[i];
        var _name = _item.name;
        
        if (variable_struct_exists(inventory_counts, _name)) {
            inventory_counts[$ _name].count++;
        } else {
            inventory_counts[$ _name] = { data: _item, count: 1 };
            array_push(inventory_display_keys, _name);
        }
    }
};
refresh_inventory();


// 5. Layout Definitions
var _padding = 20;
var _col_width = (window_width - (_padding * 3)) / 2;
var _list_height = 220; // Slightly shorter to fit the new spacing

// Store List (Left)
list_store_x1 = window_x1 + _padding;
// [FIX] Moved down from 60 to 90 to prevent text overlap
list_store_y1 = window_y1 + 90; 
list_store_x2 = list_store_x1 + _col_width;
list_store_y2 = list_store_y1 + _list_height;

// Inventory List (Right)
list_inv_x1 = list_store_x2 + _padding;
list_inv_y1 = list_store_y1;
list_inv_x2 = list_inv_x1 + _col_width;
list_inv_y2 = list_inv_y1 + _list_height;

// Detail Panel (Bottom)
detail_x1 = list_store_x1;
detail_y1 = list_store_y2 + _padding;
detail_x2 = list_inv_x2;
detail_y2 = window_y2 - 20;

// Buy Button
btn_buy_w = 140;
btn_buy_h = 40;
btn_buy_x1 = detail_x2 - btn_buy_w - 20;
btn_buy_y1 = detail_y1 + 30;
btn_buy_x2 = btn_buy_x1 + btn_buy_w;
btn_buy_y2 = btn_buy_y1 + btn_buy_h;
btn_buy_hover = false;

// Common List Props
list_item_h = 35;
store_scroll = 0;
inv_scroll = 0;

// Colors
col_list_bg = make_color_rgb(240, 240, 230);
col_detail_bg = make_color_rgb(230, 230, 240);

// Feedback
feedback_msg = "";
feedback_timer = 0;
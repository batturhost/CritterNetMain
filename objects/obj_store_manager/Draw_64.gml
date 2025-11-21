// --- Draw GUI Event ---
draw_set_font(fnt_vga);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

event_inherited(); // Draw Window Frame

// 1. Header Area (Coins)
// [FIX] Set to White as requested
draw_set_color(c_white); 
draw_set_font(fnt_vga_bold);
draw_text(window_x1 + 20, window_y1 + 40, "Wallet: $ " + string(global.PlayerData.coins));

// Titles for Lists
// (These will also be white now, since we set color above)
draw_text(list_store_x1, list_store_y1 - 20, "CATALOG");
draw_text(list_inv_x1, list_inv_y1 - 20, "MY INVENTORY");
draw_set_font(fnt_vga);

// ================== DRAW STORE LIST (LEFT) ==================
draw_set_color(col_list_bg); // Off-white background
draw_set_alpha(1.0); // Ensure opaque
draw_rectangle(list_store_x1, list_store_y1, list_store_x2, list_store_y2, false);
draw_border_95(list_store_x1, list_store_y1, list_store_x2, list_store_y2, "sunken");

gpu_set_scissor(list_store_x1 + 2, list_store_y1 + 2, (list_store_x2 - list_store_x1) - 4, (list_store_y2 - list_store_y1) - 4);
for (var i = store_scroll; i < array_length(catalog); i++) {
    var _item = catalog[i];
    var _dy = list_store_y1 + ((i - store_scroll) * list_item_h);
    
    // Highlight
    if (i == selected_item_index) {
        draw_set_color(c_navy);
        draw_rectangle(list_store_x1 + 2, _dy, list_store_x2 - 2, _dy + list_item_h, false);
        draw_set_color(c_white);
    } else {
        draw_set_color(c_black);
    }
    
    draw_set_valign(fa_middle);
    draw_text(list_store_x1 + 10, _dy + (list_item_h/2), _item.name);
    
    draw_set_halign(fa_right);
    draw_text(list_store_x2 - 10, _dy + (list_item_h/2), "$" + string(_item.price));
    draw_set_halign(fa_left);
    
    // Divider
    if (i != selected_item_index) {
        draw_set_color(c_ltgray);
        draw_line(list_store_x1 + 5, _dy + list_item_h - 1, list_store_x2 - 5, _dy + list_item_h - 1);
    }
}
gpu_set_scissor(0, 0, display_get_gui_width(), display_get_gui_height());


// ================== DRAW INVENTORY LIST (RIGHT) ==================
draw_set_color(col_list_bg); // Off-white
draw_rectangle(list_inv_x1, list_inv_y1, list_inv_x2, list_inv_y2, false);
draw_border_95(list_inv_x1, list_inv_y1, list_inv_x2, list_inv_y2, "sunken");

gpu_set_scissor(list_inv_x1 + 2, list_inv_y1 + 2, (list_inv_x2 - list_inv_x1) - 4, (list_inv_y2 - list_inv_y1) - 4);
for (var i = inv_scroll; i < array_length(inventory_display_keys); i++) {
    var _key = inventory_display_keys[i];
    var _entry = inventory_counts[$ _key]; // { data: item, count: 5 }
    var _dy = list_inv_y1 + ((i - inv_scroll) * list_item_h);
    
    // Highlight
    if (i == selected_inv_index) {
        draw_set_color(c_teal); // Different color for inventory selection
        draw_rectangle(list_inv_x1 + 2, _dy, list_inv_x2 - 2, _dy + list_item_h, false);
        draw_set_color(c_white);
    } else {
        draw_set_color(c_black);
    }
    
    draw_set_valign(fa_middle);
    draw_text(list_inv_x1 + 10, _dy + (list_item_h/2), _key);
    
    draw_set_halign(fa_right);
    draw_text(list_inv_x2 - 10, _dy + (list_item_h/2), "x" + string(_entry.count));
    draw_set_halign(fa_left);
    
    if (i != selected_inv_index) {
        draw_set_color(c_ltgray);
        draw_line(list_inv_x1 + 5, _dy + list_item_h - 1, list_inv_x2 - 5, _dy + list_item_h - 1);
    }
}
gpu_set_scissor(0, 0, display_get_gui_width(), display_get_gui_height());


// ================== DETAIL PANEL (BOTTOM) ==================
draw_set_color(col_detail_bg);
draw_rectangle(detail_x1, detail_y1, detail_x2, detail_y2, false);
draw_border_95(detail_x1, detail_y1, detail_x2, detail_y2, "raised");

// Determine what item to show
var _show_item = noone;
var _is_store_item = false;

if (selected_item_index != -1) {
    _show_item = catalog[selected_item_index];
    _is_store_item = true;
} 
else if (selected_inv_index != -1) {
    var _key = inventory_display_keys[selected_inv_index];
    _show_item = inventory_counts[$ _key].data;
}

if (_show_item != noone) {
    var _cx = detail_x1 + 20;
    var _cy = detail_y1 + 20;
    
    draw_set_color(c_black);
    draw_set_valign(fa_top);
    
    draw_set_font(fnt_vga_bold);
    draw_text(_cx, _cy, _show_item.name);
    
    draw_set_font(fnt_vga);
    draw_text(_cx, _cy + 25, "Effect: " + _show_item.effect_type);
    draw_text(_cx, _cy + 45, _show_item.description);
    
    if (_is_store_item) {
        draw_set_color(c_navy);
        draw_text(_cx, _cy + 70, "Price: $" + string(_show_item.price));
        
        // Draw Buy Button Only if Store Item Selected
        var _btn_state = btn_buy_hover ? "sunken" : "raised";
        
        // Check affordability (Gray out if poor)
        var _can_afford = (global.PlayerData.coins >= _show_item.price);
        var _txt_col = c_black;
        
        if (!_can_afford) {
            draw_set_color(c_gray); // Gray background for disabled
            draw_rectangle(btn_buy_x1, btn_buy_y1, btn_buy_x2, btn_buy_y2, false);
            _btn_state = "raised"; 
            _txt_col = c_dkgray;
        }
        
        draw_rectangle_95(btn_buy_x1, btn_buy_y1, btn_buy_x2, btn_buy_y2, _btn_state);
        
        draw_set_color(_txt_col);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(btn_buy_x1 + (btn_buy_w/2), btn_buy_y1 + (btn_buy_h/2), "BUY ITEM");
        
        // Feedback
        if (feedback_timer > 0) {
            draw_set_color(c_red);
            draw_text(btn_buy_x1 + (btn_buy_w/2), btn_buy_y1 - 15, feedback_msg);
        }
    } else {
        draw_set_color(c_dkgray);
        draw_text(_cx, _cy + 70, "Item owned.");
    }
} else {
    draw_set_color(c_dkgray);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(detail_x1 + (detail_x2 - detail_x1)/2, detail_y1 + (detail_y2 - detail_y1)/2, "Select an item to view details.");
}

// Reset
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
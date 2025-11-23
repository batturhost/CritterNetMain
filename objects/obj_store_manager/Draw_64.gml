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
draw_scrolling_list(
    list_store_x1, list_store_y1, 
    list_store_x2 - list_store_x1, list_store_y2 - list_store_y1, 
    catalog, store_scroll, selected_item_index, list_item_h, col_list_bg
);

// ================== DRAW INVENTORY LIST (RIGHT) ==================
// Note: We pass 'inventory_display_keys' which are just strings.
// The helper script handles strings fine, but won't show the "Count" on the right automatically.
// For the best result, you might want to pass a temporary array of structs or tweak the helper.
// But for basic cleanup, this works immediately:
draw_scrolling_list(
    list_inv_x1, list_inv_y1, 
    list_inv_x2 - list_inv_x1, list_inv_y2 - list_inv_y1, 
    inventory_display_keys, inv_scroll, selected_inv_index, list_item_h, col_list_bg
);


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
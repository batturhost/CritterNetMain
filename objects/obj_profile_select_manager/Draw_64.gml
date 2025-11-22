// --- Draw GUI Event ---

draw_set_font(fnt_vga);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// ================== 1. FULL SCREEN BACKGROUND ==================
// Draw Teal Background & Scanlines over the whole screen
draw_set_color(c_teal);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_scanlines_95(0, 0, display_get_gui_width(), display_get_gui_height());


// ================== 2. WINDOW FRAME ==================
// Draw Window Background (Teal) & Scanlines inside the window area
// We draw this first so the title bar sits ON TOP of it
draw_set_color(col_bg);
draw_rectangle(window_x1, window_y1, window_x2, window_y2, false);
draw_scanlines_95(window_x1, window_y1, window_x2, window_y2);

// Draw Title Bar (Navy)
// Drawn AFTER scanlines to ensure it is solid blue
draw_set_color(col_title_bar_active);
draw_rectangle(window_x1 + 2, window_y1 + 2, window_x2 - 2, window_y1 + 32, false);

// Draw Window Title Text (White)
if (window_width > 50) {
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_font(fnt_vga_bold);
    draw_text(window_x1 + 10, window_y1 + 17, window_title);
    draw_set_font(fnt_vga);
}

// Draw Outer Border (Raised)
draw_border_95(window_x1, window_y1, window_x2, window_y2, "raised");

// ================== 3. CONTENT AREA ==================
var _content_y = window_y1 + 32;
var _margin = 2;

// Draw White Content Box
draw_set_color(c_white);
draw_rectangle(window_x1 + _margin, _content_y, window_x2 - _margin, window_y2 - _margin, false);

// Header Text
var _header_x = window_x1 + 20;
var _header_y = _content_y + 15;

draw_set_font(fnt_vga_bold);
draw_set_color(make_color_rgb(0, 51, 153)); // Dark Blue Title
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text_transformed(_header_x, _header_y, "Select a picture", 1.2, 1.2, 0);

draw_set_font(fnt_vga);
draw_set_color(c_dkgray);
draw_text(_header_x, _header_y + 30, "Choose how you want to appear on CritterNet.");

// ================== 4. AVATAR GRID ==================
for (var i = 0; i < array_length(avatar_list); i++) {
    var _col = i % grid_cols;
    var _row = floor(i / grid_cols);
    
    var _cx = grid_x1 + (_col * (cell_size + grid_padding));
    var _cy = grid_y1 + (_row * (cell_size + grid_padding));

    // Highlight Selection
    if (selected_index == i) {
        draw_set_color(make_color_rgb(200, 220, 255));
        draw_rectangle(_cx - 2, _cy - 2, _cx + cell_size + 2, _cy + cell_size + 2, false);
        draw_set_color(c_navy);
        draw_rectangle(_cx - 2, _cy - 2, _cx + cell_size + 2, _cy + cell_size + 2, true);
    }
    else if (hover_index == i) {
        draw_set_color(make_color_rgb(240, 240, 240));
        draw_rectangle(_cx - 2, _cy - 2, _cx + cell_size + 2, _cy + cell_size + 2, false);
        draw_set_color(c_ltgray);
        draw_rectangle(_cx - 2, _cy - 2, _cx + cell_size + 2, _cy + cell_size + 2, true);
    }
    
    // Draw Image
    var _spr = avatar_list[i];
    var _sw = sprite_get_width(_spr);
    var _sh = sprite_get_height(_spr);
    var _scale = min(cell_size / _sw, cell_size / _sh);

    var _draw_x = _cx + (cell_size/2);
    var _draw_y = _cy + (cell_size/2);
    
    var _x_off = sprite_get_xoffset(_spr);
    var _y_off = sprite_get_yoffset(_spr);

    var _final_x = _draw_x + (_x_off - (_sw/2)) * _scale;
    var _final_y = _draw_y + (_y_off - (_sh/2)) * _scale;

    draw_sprite_ext(_spr, 0, _final_x, _final_y, _scale, _scale, 0, c_white, 1);
}


// ================== 5. RIGHT SIDE (PREVIEW) ==================
// Preview Frame
draw_set_color(c_white);
draw_rectangle(preview_x1, preview_y1, preview_x2, preview_y2, false);
draw_border_95(preview_x1, preview_y1, preview_x2, preview_y2, "sunken");

// Draw Selected Avatar Large
if (selected_index >= 0 && selected_index < array_length(avatar_list)) {
    var _big_spr = avatar_list[selected_index];
    var _bsw = sprite_get_width(_big_spr);
    var _bsh = sprite_get_height(_big_spr);
    var _b_scale = min((preview_box_size - 30) / _bsw, (preview_box_size - 30) / _bsh);

    var _p_center_x = preview_x1 + (preview_box_size / 2);
    var _p_center_y = preview_y1 + (preview_box_size / 2);
    
    var _bx_off = sprite_get_xoffset(_big_spr);
    var _by_off = sprite_get_yoffset(_big_spr);
    var _p_final_x = _p_center_x + (_bx_off - (_bsw/2)) * _b_scale;
    var _p_final_y = _p_center_y + (_by_off - (_bsh/2)) * _b_scale;

    draw_sprite_ext(_big_spr, 0, _p_final_x, _p_final_y, _b_scale, _b_scale, 0, c_white, 1);
}

// --- UPDATED: Single Browse Button (Removed Remove/Modify) ---
var _bx1 = btn_mock_x;
var _by1 = btn_mock_start_y; 
var _bx2 = _bx1 + btn_mock_w;
var _by2 = _by1 + btn_mock_h;

// Determine hover/click state visually
var _browse_state = "raised";
if (point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), _bx1, _by1, _bx2, _by2)) {
     // Check if mouse is held down for "sunken" effect
     _browse_state = mouse_check_button(mb_left) ? "sunken" : "raised";
}

draw_rectangle_95(_bx1, _by1, _bx2, _by2, _browse_state);
draw_set_color(c_black);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(_bx1 + (btn_mock_w/2), _by1 + (btn_mock_h/2), "Browse...");


// ================== 6. FOOTER BUTTONS ==================
// OK Button
var _ok_state = btn_ok_hover ? "sunken" : "raised";
draw_rectangle_95(btn_ok_x1, btn_ok_y1, btn_ok_x2, btn_ok_y2, _ok_state);
draw_set_color(c_black);
draw_set_halign(fa_center); draw_set_valign(fa_middle);
draw_text(btn_ok_x1 + (btn_ok_w/2), btn_ok_y1 + (btn_ok_h/2), "OK");

// Cancel Button
var _cancel_state = btn_cancel_hover ? "sunken" : "raised";
draw_rectangle_95(btn_cancel_x1, btn_cancel_y1, btn_cancel_x2, btn_cancel_y2, _cancel_state);
draw_set_color(c_black);
draw_text(btn_cancel_x1 + (btn_ok_w/2), btn_cancel_y1 + (btn_ok_h/2), "Cancel");

// Reset
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
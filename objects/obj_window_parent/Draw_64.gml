// --- obj_window_parent: Draw GUI Event ---

// If minimized, don't draw anything (not even the frame)
// The animation logic handles visibility, but double check here
if (is_minimized && anim_state != 3 && anim_state != 4) exit;

draw_set_font(fnt_vga);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// 1. Draw Background
if (use_scanlines) {
    draw_set_alpha(0.85);
    draw_set_color(col_bg);
    draw_rectangle(window_x1 + 2, window_y1 + 2, window_x2 - 2, window_y2 - 2, false);
    draw_set_alpha(1.0);
    draw_scanlines_95(window_x1 + 2, window_y1 + 2, window_x2 - 2, window_y2 - 2);
} else {
    draw_set_color(col_bg);
    draw_rectangle(window_x1 + 2, window_y1 + 2, window_x2 - 2, window_y2 - 2, false);
}

// 2. Draw Title Bar
draw_set_alpha(0.85);
draw_set_color(col_title_bar_active);
draw_rectangle(window_x1 + 2, window_y1 + 2, window_x2 - 2, window_y1 + 32, false);
draw_set_alpha(1.0);

// 3. Draw Title Text (Clipped if window is small during anim)
if (window_width > 50) {
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(fnt_vga_bold);
    draw_text(window_x1 + (window_width / 2), window_y1 + 17, window_title);
    draw_set_font(fnt_vga);
}

// 4. Draw Buttons (Only if window is large enough)
if (window_width > 60 && window_height > 40) {
    
    // -- Close Button --
    var _close_state = btn_close_hover ? "sunken" : "raised";
    draw_rectangle_95(btn_close_x1, btn_close_y1, btn_close_x2, btn_close_y2, _close_state);
    draw_set_color(c_black);
    draw_set_font(fnt_vga_bold);
    var _cx = btn_close_x1 + ((btn_close_x2 - btn_close_x1) / 2);
    var _cy = btn_close_y1 + ((btn_close_y2 - btn_close_y1) / 2);
    if (_close_state == "sunken") { _cx++; _cy++; }
    draw_set_halign(fa_center); draw_set_valign(fa_middle);
    draw_text(_cx, _cy, "X");

    // -- Minimize Button --
    var _min_state = btn_min_hover ? "sunken" : "raised";
    draw_rectangle_95(btn_min_x1, btn_min_y1, btn_min_x2, btn_min_y2, _min_state);
    draw_set_color(c_black);
    var _mx = btn_min_x1 + ((btn_min_x2 - btn_min_x1) / 2);
    var _my = btn_min_y1 + ((btn_min_y2 - btn_min_y1) / 2);
    if (_min_state == "sunken") { _mx++; _my++; }
    // Draw underscore
    draw_text(_mx, _my - 3, "_"); 
    draw_set_font(fnt_vga);
}

// 5. Draw Outer Border
draw_border_95(window_x1, window_y1, window_x2, window_y2, "raised");

// Reset
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
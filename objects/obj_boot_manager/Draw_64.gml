// --- Draw GUI Event ---
draw_set_font(fnt_vga);
draw_set_halign(fa_left);
draw_set_color(c_white); 

for (var i = 0; i < current_line; i++) {
    draw_text(20, 20 + (i * 20), text_lines[i]);
}

// Only show the buttons after all text has "typed"
if (current_line >= array_length(text_lines)) {
    
    // --- Draw Debug Button ---
    var _state = btn_hovering ? "sunken" : "raised";
    draw_rectangle_95(btn_x1, btn_y1, btn_x2, btn_y2, _state);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_black);
    draw_text(btn_x1 + (btn_w / 2), btn_y1 + (btn_h / 2), "DEBUG: Skip to Battle");
    
    // --- Draw NEW Continue Button ---
    var _continue_state = btn_continue_hovering ? "sunken" : "raised";
    draw_rectangle_95(btn_continue_x1, btn_continue_y1, btn_continue_x2, btn_continue_y2, _continue_state);
    
    draw_set_color(c_black);
    draw_text(btn_continue_x1 + (btn_continue_w / 2), btn_continue_y1 + (btn_continue_h / 2), "Continue");
    
    // Reset draw settings
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}
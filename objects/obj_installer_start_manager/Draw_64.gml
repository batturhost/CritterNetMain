// --- Draw GUI Event ---

// 1. Draw Background (Teal with Retro Lines)
draw_set_color(c_teal); 
draw_rectangle(0, 0, gui_w, gui_h, false);

draw_set_color(c_black);
draw_set_alpha(0.15); 
for (var i = 0; i < gui_h; i += 4) { 
    draw_line(0, i, gui_w, i);
}
draw_set_alpha(1.0); 

// 2. Setup Text Alignment
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
var _center_x = gui_w / 2;
var _center_y = gui_h / 2;


// --- 3. Draw Header (Above Logo) ---
draw_set_color(c_white);
draw_set_font(fnt_vga_bold);
draw_text_transformed(_center_x, _center_y - 180, "Welcome to CritterNet Setup", 1.5, 1.5, 0);


// --- 4. Draw Logo (Center) ---
var _spr_w = sprite_get_width(spr_logo);
var _spr_h = sprite_get_height(spr_logo);

var _target_width = 500; 
var _scale = _target_width / _spr_w;

draw_sprite_ext(spr_logo, 0, _center_x, _center_y - 10, _scale, _scale, 0, c_white, 1); 

// Version text below the logo
draw_set_color(c_white); 
draw_set_font(fnt_vga);
var _logo_bottom_y = (_center_y - 10) + ((_spr_h * _scale) / 2);
var _text_y = _logo_bottom_y + 20; 
draw_text(_center_x, _text_y, "Version 1.0");


// --- 5. Draw Blinking Prompt (Yellow) ---
if (blink_timer < 30) {
    draw_set_color(c_yellow); 
    // Updated Text
    draw_text(_center_x, gui_h - 100, "Press Enter to Start Installation...");
}

// --- 6. Draw Footer (Copyright Text) ---
draw_set_halign(fa_center);
draw_set_valign(fa_bottom); 
draw_set_color(c_white);
draw_text(_center_x, gui_h - 10, "Copyright (C) 1998 CritterNet Inc. All rights reserved.\nUnauthorized distribution of this software is a federal crime.");

// --- 7. Reset ---
draw_set_color(c_white); 
draw_set_halign(fa_left);
draw_set_valign(fa_top);
// --- Draw GUI Event ---

draw_set_font(fnt_vga);
draw_set_halign(fa_left);

// --- 1. Draw Full-Screen Teal Background ---
draw_set_color(c_teal);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
// Draw Scanlines
draw_scanlines_95(0, 0, display_get_gui_width(), display_get_gui_height());


// --- 2. Draw Main Window ---
draw_rectangle_95(window_x1, window_y1, window_x2, window_y2, "raised");
// Title Bar
draw_set_color(c_navy);
draw_rectangle(window_x1 + 2, window_y1 + 2, window_x2 - 2, window_y1 + 32, false); 
draw_set_color(c_white);
draw_set_halign(fa_center);

// [BOLD] Window Title
draw_set_font(fnt_vga_bold);
draw_text(window_x1 + (window_width / 2), window_y1 + 12, "USER REGISTRATION - CritterNet v1.0");
draw_set_font(fnt_vga); // Reset

draw_set_halign(fa_left);
draw_set_color(c_black);


// --- 3. Name Field ---
// Label Color Logic (White if focused)
if (current_focus == 0) draw_set_color(c_white);
else draw_set_color(c_black);

// [BOLD] Label
draw_set_font(fnt_vga_bold);
draw_text(form_x_left, btn_name_y1 + 5, "Username:");
draw_set_font(fnt_vga); // Reset

// Draw Input Box
draw_rectangle_95(btn_name_x1, btn_name_y1, btn_name_x2, btn_name_y2, "sunken");

// Draw Text inside box (Always Black, Now BOLD)
draw_set_color(c_black); 
var _cursor = (current_focus == 0 && cursor_blink < 30) ? "_" : "";

// [FIX] Bold Input Text
draw_set_font(fnt_vga_bold); 
draw_text(btn_name_x1 + 4, btn_name_y1 + 5, player_name + _cursor);
draw_set_font(fnt_vga); // Reset


// --- 4. Gender Field ---
// [FIX] Label Color Logic (White if focused)
if (current_focus == 1) draw_set_color(c_white);
else draw_set_color(c_black);

// [BOLD] Label
draw_set_font(fnt_vga_bold);
draw_text(form_x_left, btn_gender_y1 + 5, "Avatar:");
draw_set_font(fnt_vga);

// "Male" button
var _male_state = (gender_selection == 0) ? "sunken" : "raised";
draw_rectangle_95(btn_gender_x1, btn_gender_y1, btn_gender_x2, btn_gender_y2, _male_state);

draw_set_color(c_black); // Button text always black
draw_set_halign(fa_center);
// [BOLD] Button Text
draw_set_font(fnt_vga_bold);
draw_text(btn_gender_x1 + 60, btn_gender_y1 + 5, "Male");
draw_set_font(fnt_vga);
draw_set_halign(fa_left);

// "Female" button
var _female_state = (gender_selection == 1) ? "sunken" : "raised";
draw_rectangle_95(btn_gender_x3, btn_gender_y1, btn_gender_x4, btn_gender_y2, _female_state);

draw_set_color(c_black); // Button text always black
draw_set_halign(fa_center);
// [BOLD] Button Text
draw_set_font(fnt_vga_bold);
draw_text(btn_gender_x3 + 60, btn_gender_y1 + 5, "Female");
draw_set_font(fnt_vga);
draw_set_halign(fa_left);


// --- 5. Starter Field ---
draw_set_color(c_white); // Reset to black for header
draw_set_halign(fa_center);
// [BOLD] Header
draw_set_font(fnt_vga_bold);
draw_text(window_x1 + (window_width / 2), starter_label_y, "Select Starter Critter:");
draw_set_font(fnt_vga);
draw_set_halign(fa_left);

var _box_coords = [
    [btn_starter_1_x1, btn_starter_1_y1, btn_starter_1_x2, btn_starter_1_y2],
    [btn_starter_2_x1, btn_starter_2_y1, btn_starter_2_x2, btn_starter_2_y2],
    [btn_starter_3_x1, btn_starter_3_y1, btn_starter_3_x2, btn_starter_3_y2]
];

for (var i = 0; i < 3; i++) {
    var _coords = _box_coords[i];
    var _x1 = _coords[0];
    var _y1 = _coords[1];
    var _x2 = _coords[2];
    var _y2 = _coords[3];

    var _state = (starter_selection == i) ? "sunken" : "raised";
    draw_rectangle_95(_x1, _y1, _x2, _y2, _state);
    
    // Draw Sprite
    var _sprite = starter_critter_sprites[i];
    var _sprite_w = sprite_get_width(_sprite);
    var _sprite_h = sprite_get_height(_sprite);
    var _box_w = (_x2 - _x1) * 0.8; 
    var _box_h = 100;
    var _scale = min(_box_w / _sprite_w, _box_h / _sprite_h);
    
    var _box_center_x = _x1 + ((_x2 - _x1) / 2);
    var _sprite_area_center_y = _y1 + 55; 
    var _sprite_x = _box_center_x;
    var _sprite_y = _sprite_area_center_y + ((_sprite_h / 2) * _scale);

    // Clipping & Drawing
    var _clip_x1 = _x1 + 2;
    var _clip_y1 = _y1 + 2;
    var _clip_w = (_x2 - 2) - _clip_x1;
    var _clip_h = (_y2 - 2) - _clip_y1;
    
    gpu_set_scissor(_clip_x1, _clip_y1, _clip_w, _clip_h);
    
    // Only animate if this is the selected starter
    var _current_frame = 0;
    if (i == starter_selection) {
        _current_frame = animation_frame;
    }
    draw_sprite_ext(_sprite, _current_frame, _sprite_x, _sprite_y, _scale, _scale, 0, c_white, 1);
    
    gpu_set_scissor(0, 0, display_get_gui_width(), display_get_gui_height());
    
    // Draw Text
    // [FIX] White if selected, Black otherwise
    if (i == starter_selection) draw_set_color(c_white);
    else draw_set_color(c_black);

    draw_set_halign(fa_center);
    // [BOLD] Starter Names
    draw_set_font(fnt_vga_bold);
    draw_text(_box_center_x, _y1 + 120, starter_critter_names[i]);
    draw_set_font(fnt_vga);
    draw_set_halign(fa_left);
}


// --- 6. Submit Button ---
var _submit_state = (current_focus == 5) ? "sunken" : "raised";
draw_rectangle_95(btn_submit_x1, btn_submit_y1, btn_submit_x2, btn_submit_y2, _submit_state);
draw_set_halign(fa_center);
draw_set_color(c_white);
// [BOLD] Submit Text
draw_set_font(fnt_vga_bold);
draw_text(btn_submit_x1 + 50, btn_submit_y1 + 7, "SUBMIT");
draw_set_font(fnt_vga);
draw_set_halign(fa_left);

draw_set_color(c_white);
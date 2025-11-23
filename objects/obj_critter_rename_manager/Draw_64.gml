// --- Draw GUI Event ---

draw_set_font(fnt_vga);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// ================== BACKGROUND CODE ==================
// 1. Draw Full-Screen Teal Background
draw_set_color(c_teal);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);

// 2. Draw Scanlines
draw_scanlines_95(0, 0, display_get_gui_width(), display_get_gui_height());
// =====================================================


// --- 3. Draw Main Window ---
draw_rectangle_95(window_x1, window_y1, window_x2, window_y2, "raised");

// Title Bar
draw_set_color(c_navy);
draw_rectangle(window_x1 + 2, window_y1 + 2, window_x2 - 2, window_y1 + 32, false); // Taller title bar
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_font(fnt_vga_bold);
// Note: This window is "Edit Properties", distinct from "File Acquisition"
draw_text(window_x1 + (window_width / 2), window_y1 + 12, "Edit Properties: " + global.PlayerData.starter_key + ".file");
draw_set_halign(fa_left);
draw_set_color(c_black);
draw_set_font(fnt_vga);

// --- 4. Draw the Animated Sprite on the Left ---
var _sprite_w = sprite_get_width(sprite);
var _sprite_h = sprite_get_height(sprite);

// Define a "bounding box" for the sprite
var _box_w = 150;
var _box_h = 150;
var _box_center_x = window_x1 + 85; // Centered on the left half
var _box_center_y = window_y1 + 140; 

// Draw the "sunken" frame
var _frame_x1 = _box_center_x - (_box_w/2) - 2;
var _frame_y1 = _box_center_y - (_box_h/2) - 2;
var _frame_x2 = _box_center_x + (_box_w/2) + 2;
var _frame_y2 = _box_center_y + (_box_h/2) + 2;
draw_rectangle_95(_frame_x1, _frame_y1, _frame_x2, _frame_y2, "sunken");

// Calculate the correct scale
var _scale_x = _box_w / _sprite_w;
var _scale_y = _box_h / _sprite_h;
var _scale = min(_scale_x, _scale_y); 

// Calculate the draw position (using the bottom-center origin fix)
var _sprite_x = _box_center_x;
var _sprite_y = _box_center_y + ((_sprite_h / 2) * _scale);

// Draw the sprite (clipped inside the frame)
gpu_set_scissor(_frame_x1 + 2, _frame_y1 + 2, _frame_x2 - _frame_x1 - 4, _frame_y2 - _frame_y1 - 4);
draw_sprite_ext(sprite, animation_frame, _sprite_x, _sprite_y, 
                _scale, _scale, 0, c_white, 1);
gpu_set_scissor(0, 0, display_get_gui_width(), display_get_gui_height());


// --- 5. Draw the Info on the Right ---

// --- DRAW LABELS (ABOVE the boxes) ---
draw_text(info_x_label, species_y - 20, "Species:");
draw_text(info_x_label, gender_y - 20, "Gender:"); // <-- RESTORED
draw_text(info_x_label, nickname_y - 20, "Nickname:");

// --- DRAW BOXES AND TEXT-IN-BOX ---

// Species (Static)
draw_rectangle_95(info_x_box, species_box_y1, info_x2, species_box_y2, "sunken");
draw_text(info_x_box + 4, species_box_y1 + 4, species_name);

// Gender (Static) - RESTORED
var _gender_string = (critter_gender == 0) ? "Male" : "Female";
draw_rectangle_95(info_x_box, gender_box_y1, info_x2, gender_box_y2, "sunken");
draw_text(info_x_box + 4, gender_box_y1 + 4, _gender_string);

// Nickname (Input)
draw_rectangle_95(info_x_box, input_y1, info_x2, input_y2, "sunken");
var _cursor = (cursor_blink < 30) ? "_" : "";
draw_text(info_x_box + 4, input_y1 + 5, nickname + _cursor);


// --- 6. Draw Blurb and Size (at the bottom) ---
var _blurb_x = window_x1 + 20;
var _blurb_y = window_y1 + 240;
var _blurb_width = window_width - 40; 

draw_text(_blurb_x, _blurb_y, "Size: " + size);
draw_text_ext(_blurb_x, _blurb_y + 30, blurb, 16, _blurb_width);


// --- 7. Draw the [ OK ] Button ---
draw_rectangle_95(btn_ok_x1, btn_ok_y1, btn_ok_x2, btn_ok_y2, "raised");
draw_set_halign(fa_center);
draw_set_valign(fa_middle); // Vertically center the button text
draw_text(btn_ok_x1 + 50, btn_ok_y1 + 14, "OK");


// --- 8. Reset Draw Settings ---
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
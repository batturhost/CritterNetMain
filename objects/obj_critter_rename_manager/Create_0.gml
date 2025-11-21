// --- Create Event ---

// --- 1. Get Data from Global (FIXED) ---
var _data_key = global.PlayerData.starter_key;
var _data = global.bestiary[$ _data_key]; 

// Store the data we need to display
species_name = _data.animal_name;
nickname = _data.animal_name; 
blurb = _data.blurb;
size = _data.size;
sprite = _data.sprite_idle;
critter_gender = irandom_range(0, 1); // <-- FIX: Gender is now created (50/50)

// --- 2. State Variables ---
max_name_length = 16;
cursor_blink = 0;
animation_frame = 0;
animation_speed = 0.2;

// --- 3. Layout (Your Original Layout - CLEANED) ---
window_width = 440;
window_height = 400;
window_x1 = (display_get_gui_width() / 2) - (window_width / 2);
window_y1 = (display_get_gui_height() / 2) - (window_height / 2); 
window_x2 = window_x1 + window_width;
window_y2 = window_y1 + window_height;

var _padding = 20;

// X-coordinates
info_x_label = window_x1 + 180; // X for labels
info_x_box = window_x1 + 250;   // X for boxes
info_x2 = window_x2 - _padding; // Right edge

// Y-coordinates (FIXED LAYOUT)
species_y = window_y1 + 60;
gender_y = window_y1 + 110;
nickname_y = window_y1 + 160;

// Species Box
species_box_y1 = species_y;
species_box_y2 = species_box_y1 + 25;

// Gender Box
gender_box_y1 = gender_y;
gender_box_y2 = gender_box_y1 + 25;

// Nickname Box
input_y1 = nickname_y;
input_y2 = input_y1 + 25;

// OK Button
btn_ok_x1 = window_x1 + (window_width / 2) - 50; // Centered
btn_ok_y1 = window_y2 - 50; // At the bottom
btn_ok_x2 = btn_ok_x1 + 100;
btn_ok_y2 = btn_ok_y1 + 28;
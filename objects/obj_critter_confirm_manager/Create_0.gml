// --- Create Event ---

// --- 1. State Machine ---
// This controls the animation
download_state = "downloading"; // "downloading" or "complete"
download_progress = 0; // 0 to 100
animation_frame = 0;
animation_speed = 0.1;

// --- 2. Get Data from Global (THE CRASH FIX) ---
var _data_key = global.PlayerData.starter_key;
var _data = global.bestiary[$ _data_key]; 

species_name = _data.animal_name;
sprite = _data.sprite_idle;
filename = species_name + ".file";

// --- 3. Layout (Replicating your screenshots) ---
window_width = 440;
window_height = 400;
window_x1 = (display_get_gui_width() / 2) - (window_width / 2);
window_y1 = (display_get_gui_height() / 2) - (window_height / 2); 
window_x2 = window_x1 + window_width;
window_y2 = window_y1 + window_height;

var _padding = 20;

// --- Layout for "Downloading" State ---
progress_bar_w = 300;
progress_bar_h = 30;
progress_bar_x1 = window_x1 + (window_width / 2) - (progress_bar_w / 2);
progress_bar_y1 = window_y1 + (window_height / 2);
progress_bar_x2 = progress_bar_x1 + progress_bar_w;
progress_bar_y2 = progress_bar_y1 + progress_bar_h;

// --- Layout for "Complete" State ---
// Sprite scaling
var _sprite_w = sprite_get_width(sprite);
var _sprite_h = sprite_get_height(sprite);
var _box_w = 250;
var _box_h = 200;
var _scale_x = _box_w / _sprite_w;
var _scale_y = _box_h / _sprite_h;
sprite_scale = min(_scale_x, _scale_y); 
sprite_x = window_x1 + (window_width / 2);
sprite_y = window_y1 + 180 + ((_sprite_h / 2) * sprite_scale); // Center + origin fix

// Submit Button
var _btn_w = 100;
var _btn_h = 28;
btn_submit_x1 = window_x1 + (window_width / 2) - (_btn_w / 2);
btn_submit_y1 = window_y2 - 50; // At the bottom
btn_submit_x2 = btn_submit_x1 + _btn_w;
btn_submit_y2 = btn_submit_y1 + _btn_h;
btn_submit_hover = false;
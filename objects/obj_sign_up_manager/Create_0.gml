// --- Create Event ---
// This sets up all our variables for the form

// --- 1. Form State Variables ---
player_name = "";
max_name_length = 16;
gender_selection = 0; // 0=Male, 1=Female
starter_selection = 0; // 0=Fox, 1=Capybara, 2=Goose <-- THIS LINE FIXES THE CRASH
current_focus = 0; // 0=Name, 1=Gender, 2=Starter Fox, 3=Starter Capy, 4=Starter Goose, 5=Submit
cursor_blink = 0; // Timer for the blinking cursor
animation_frame = 0;
animation_speed = 0.2; // Plays ~12 FPS (0.2 * 60)

// --- 2. Static Data ---
starter_critter_names = ["Arctic Fox", "Capybara", "Goose"];
starter_critter_keys = ["arctic_fox", "capybara", "goose"]; 
starter_critter_sprites = [spr_arctic_fox_idle, spr_capybara_idle, spr_goose_idle];
// We no longer use starter_critter_scales

// --- 3. UI Bounding Box Definitions ---
// Define the window's properties
window_width = 440;
window_height = 400; 
var _padding = 20; 
var _label_width = 130; 

// Calculate the window's "true center" position
window_x1 = (display_get_gui_width() / 2) - (window_width / 2);
window_y1 = (display_get_gui_height() / 2) - (window_height / 2); 
window_x2 = window_x1 + window_width;
window_y2 = window_y1 + window_height;

// Calculate element X-positions based on the window
form_x_left = window_x1 + _padding; // X for labels
form_x_right = window_x1 + _label_width; // X for buttons

// --- Bounding Boxes (Calculated from the new layout) ---
var _current_y = window_y1 + 55; 

// Name field
btn_name_x1 = form_x_right;
btn_name_y1 = _current_y;
btn_name_x2 = window_x2 - _padding;
btn_name_y2 = btn_name_y1 + 25; 

// Gender "Male" button
_current_y += 45; 
btn_gender_x1 = form_x_right;
btn_gender_y1 = _current_y;
btn_gender_x2 = btn_gender_x1 + 120;
btn_gender_y2 = btn_gender_y1 + 25; 

// Gender "Female" button
btn_gender_x3 = form_x_right + 130;
btn_gender_y3 = _current_y;
btn_gender_x4 = btn_gender_x3 + 120;
btn_gender_y4 = btn_gender_y3 + 25; 

// --- 3-BOX STARTER LAYOUT ---
_current_y += 45; 
starter_label_y = _current_y; 
_current_y += 30; 
var _box_width = 120;
var _box_height = 150;
var _box_spacing = 20;

// Starter 1 (Fox)
btn_starter_1_x1 = window_x1 + _padding;
btn_starter_1_y1 = _current_y;
btn_starter_1_x2 = btn_starter_1_x1 + _box_width;
btn_starter_1_y2 = btn_starter_1_y1 + _box_height;

// Starter 2 (Capy)
btn_starter_2_x1 = btn_starter_1_x2 + _box_spacing;
btn_starter_2_y1 = _current_y;
btn_starter_2_x2 = btn_starter_2_x1 + _box_width;
btn_starter_2_y2 = btn_starter_2_y1 + _box_height;

// Starter 3 (Goose)
btn_starter_3_x1 = btn_starter_2_x2 + _box_spacing;
btn_starter_3_y1 = _current_y;
btn_starter_3_x2 = btn_starter_3_x1 + _box_width;
btn_starter_3_y2 = btn_starter_3_y1 + _box_height;

// Submit button
_current_y = window_y2 - 50; 
btn_submit_x1 = window_x1 + (window_width / 2) - 50; 
btn_submit_y1 = _current_y;
btn_submit_x2 = btn_submit_x1 + 100;
btn_submit_y2 = btn_submit_y1 + 28;
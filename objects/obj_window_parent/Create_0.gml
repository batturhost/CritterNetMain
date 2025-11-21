// --- obj_window_parent: Create Event ---

// 1. Default Window Properties (Children can override these)
window_width = 400;
window_height = 300;
window_title = "New Window";

// Position (Center by default)
window_x1 = (display_get_gui_width() / 2) - (window_width / 2);
window_y1 = (display_get_gui_height() / 2) - (window_height / 2);
window_x2 = window_x1 + window_width;
window_y2 = window_y1 + window_height;

// 2. State Variables
is_dragging = false;
drag_dx = 0;
drag_dy = 0;

// 3. UI Elements (Close Button)
btn_close_hover = false;
btn_close_x1 = 0; btn_close_y1 = 0; btn_close_x2 = 0; btn_close_y2 = 0;

// --- NEW: MINIMIZE BUTTON ---
btn_min_hover = false;
btn_min_x1 = 0; btn_min_y1 = 0; btn_min_x2 = 0; btn_min_y2 = 0;
is_minimized = false;
// ----------------------------

// 4. Colors (Aero / XP Style defaults)
col_title_bar_active = c_navy;
col_title_bar_inactive = c_dkgray; 
col_bg = c_teal; 
use_scanlines = true;

// 5. ANIMATION VARIABLES
anim_state = 0; // 0=Init, 1=Opening, 2=Open, 3=Minimizing, 4=Restoring
anim_timer = 0;
anim_duration = 15; 

// Targets (Where the window WANTS to be when OPEN)
final_x = 0;
final_y = 0;
final_w = 0;
final_h = 0;

// Start (For interpolation)
start_x = 0;
start_y = 0;
start_w = 0;
start_h = 0;

// Taskbar Target (Where it shrinks TO)
task_target_x = 0;
task_target_y = display_get_gui_height(); // Bottom of screen
task_target_w = 0;
task_target_h = 0;
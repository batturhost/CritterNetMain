// --- Create Event ---

// 1. INHERIT PARENT (Sets up default dragging, closing, depth)
event_inherited();

// 2. Override Window Properties
window_width = 700;
window_height = 500;
window_title = "Critter Storage System"; // Sets the title bar text

// Recalculate center position based on new width/height
window_x1 = (display_get_gui_width() / 2) - (window_width / 2);
window_y1 = (display_get_gui_height() / 2) - (window_height / 2);
window_x2 = window_x1 + window_width;
window_y2 = window_y1 + window_height;

// 3. Define UI Panels
team_list_w = 250;
team_list_h = 350;
team_item_height = 20; 
team_top_index = 0; 
team_selected_index = -1;

pc_list_w = 250;
pc_list_h = 350;
pc_grid_cols = 4;
pc_grid_padding = 8;

pc_grid_cell_size = (pc_list_w - (pc_grid_padding * (pc_grid_cols + 1))) / pc_grid_cols;
pc_scroll_top = 0;
pc_selected_index = -1;

// 4. Define Buttons
btn_w = 150;
btn_h = 28;
btn_to_team_hover = false;
btn_to_pc_hover = false;

// 5. Preview & Feedback Vars
preview_critter = noone; 
preview_anim_frame = 0;
preview_anim_speed = 0.1;
feedback_message = "";
feedback_message_timer = 0;

// 6. Animation Vars
pc_anim_frame = 0;
pc_anim_speed = 0.1;

// 7. Drag/Drop Vars (Critter Specific)
drag_critter_index = -1;
drag_critter_data = noone;
is_dragging_critter = false; 
drag_start_y = 0;
drag_y_offset = 0;
drop_indicator_y = -1;
held_critter_index = -1;

// 8. Initialize Internal UI Positions
// (We run this once here, and update it in Step so it follows the window)
team_list_x1 = window_x1 + 20;
team_list_y1 = window_y1 + 80;
team_list_x2 = team_list_x1 + team_list_w;
team_list_y2 = team_list_y1 + team_list_h;

pc_list_x1 = window_x1 + window_width - 250 - 20;
pc_list_y1 = window_y1 + 80;
pc_list_x2 = pc_list_x1 + pc_list_w;
pc_list_y2 = pc_list_y1 + pc_list_h;

var _mid_x = window_x1 + (window_width / 2);
btn_to_team_x1 = _mid_x - (btn_w / 2);
btn_to_team_y1 = window_y1 + 350;
btn_to_team_x2 = btn_to_team_x1 + btn_w;
btn_to_team_y2 = btn_to_team_y1 + btn_h;

btn_to_pc_x1 = _mid_x - (btn_w / 2);
btn_to_pc_y1 = btn_to_team_y2 + 10;
btn_to_pc_x2 = btn_to_pc_x1 + btn_w;
btn_to_pc_y2 = btn_to_pc_y1 + btn_h;


// 9. Renaming Variables (NEW)
is_renaming = false;
rename_input = "";
max_name_length = 12;
cursor_timer = 0;
name_area_hover = false;
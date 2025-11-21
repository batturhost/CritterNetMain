// --- Create Event ---

// 1. Window Layout
window_width = 600;
window_height = 500;
window_x1 = (display_get_gui_width() / 2) - (window_width / 2);
window_y1 = (display_get_gui_height() / 2) - (window_height / 2);
window_x2 = window_x1 + window_width;
window_y2 = window_y1 + window_height;

is_dragging = false;
drag_dx = 0; drag_dy = 0;

// 2. Data Lists
critter_list = variable_struct_get_names(global.bestiary);
array_sort(critter_list, true); // Sort alphabetically

player_selected_index = 0;
enemy_selected_index = 0;

// 3. Scroll States
player_scroll_top = 0;
enemy_scroll_top = 0;
list_item_height = 24;

// 4. UI Layout
var _margin = 20;
var _list_w = 200;
var _list_h = 300;

// Left List (Player)
list_p_x1 = window_x1 + _margin;
list_p_y1 = window_y1 + 60;
list_p_x2 = list_p_x1 + _list_w;
list_p_y2 = list_p_y1 + _list_h;

// Right List (Enemy)
list_e_x1 = window_x2 - _margin - _list_w;
list_e_y1 = window_y1 + 60;
list_e_x2 = list_e_x1 + _list_w;
list_e_y2 = list_e_y1 + _list_h;

// Fight Button
btn_fight_w = 140;
btn_fight_h = 40;
btn_fight_x1 = window_x1 + (window_width / 2) - (btn_fight_w / 2);
btn_fight_y1 = list_p_y2 + 30;
btn_fight_x2 = btn_fight_x1 + btn_fight_w;
btn_fight_y2 = btn_fight_y1 + btn_fight_h;
btn_fight_hover = false;

// Close Button
btn_close_x1 = window_x2 - 28; 
btn_close_y1 = window_y1 + 6;
btn_close_x2 = window_x2 - 6; 
btn_close_y2 = window_y1 + 28;
btn_close_hover = false;
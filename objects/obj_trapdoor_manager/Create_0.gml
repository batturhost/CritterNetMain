// --- Create Event ---

// 1. INHERIT PARENT
event_inherited();

// 2. Window Properties
window_width = 440;
window_height = 400;
window_title = "TRAPDOOR.exe";

// Recalculate Position
window_x1 = (display_get_gui_width() / 2) - (window_width / 2);
window_y1 = (display_get_gui_height() / 2) - (window_height / 2);
window_x2 = window_x1 + window_width;
window_y2 = window_y1 + window_height;

// 3. Team Layout
btn_team_layout = [];
var _team_btn_w = 380;
var _team_btn_h = 40;
var _team_btn_x = window_x1 + (window_width / 2) - (_team_btn_w / 2);
var _team_btn_y_start = window_y1 + 80;
var _team_btn_v_space = 45;

for (var i = 0; i < 6; i++) {
    var _btn_y = _team_btn_y_start + (i * _team_btn_v_space);
    array_push(btn_team_layout, [_team_btn_x, _btn_y, _team_btn_x + _team_btn_w, _btn_y + _team_btn_h]);
}

// 4. State
menu_focus = 0;
feedback_message = "";
feedback_message_timer = 0;
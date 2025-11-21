// --- Step Event ---

// 1. INHERIT PARENT
event_inherited();

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _click = mouse_check_button_pressed(mb_left);
var _key_up = keyboard_check_pressed(vk_up);
var _key_down = keyboard_check_pressed(vk_down);
var _key_enter = keyboard_check_pressed(vk_enter);

// 2. Logic
if (feedback_message_timer > 0) {
    feedback_message_timer--;
}

if (_key_up) menu_focus = max(0, menu_focus - 1);
if (_key_down) menu_focus = min(5, menu_focus + 1);

if (_click && !is_dragging) {
    // Click to dismiss message
    if (feedback_message_timer > 0) {
        feedback_message_timer = 0;
    }
    else {
        // Check Team List
        var _team_size = array_length(global.PlayerData.team);
        for (var i = 0; i < _team_size; i++) {
            var _btn = btn_team_layout[i];
            if (point_in_box(_mx, _my, _btn[0], _btn[1], _btn[2], _btn[3])) {
                menu_focus = i;
                _key_enter = true; 
            }
        }
    }
}

// 3. Corruption Logic
if (_key_enter && feedback_message_timer <= 0) {
    if (menu_focus < array_length(global.PlayerData.team)) {
        var _critter = global.PlayerData.team[menu_focus];
        if (variable_struct_exists(_critter, "is_corrupted") && _critter.is_corrupted) {
            feedback_message = "Data for this specimen is already optimized.";
            feedback_message_timer = 120;
        } else {
            // THE CORRUPTION
            var _move_to_replace = -1;
            for (var i = 0; i < array_length(_critter.moves); i++) {
                if (_critter.moves[i] == global.GENERIC_MOVE_AGITATE) {
                    _move_to_replace = i;
                    break;
                }
            }
            if (_move_to_replace == -1) _move_to_replace = 0;
            
            _critter.moves[_move_to_replace] = global.MOVE_SYSTEM_CALL;
            _critter.is_corrupted = true;
            
            feedback_message = "Data for " + _critter.nickname + " has been... optimized.";
            feedback_message_timer = 180;
        }
    }
}

// 4. Close after message
if (feedback_message_timer == 1 && feedback_message != "") {
    instance_destroy();
}

// 5. Recalculate Layout (Sticky)
var _team_btn_w = 380;
var _team_btn_h = 40;
var _team_btn_x = window_x1 + (window_width / 2) - (_team_btn_w / 2);
var _team_btn_y_start = window_y1 + 80;
var _team_btn_v_space = 45;

btn_team_layout = [];
for (var i = 0; i < 6; i++) {
    var _btn_y = _team_btn_y_start + (i * _team_btn_v_space);
    array_push(btn_team_layout, [_team_btn_x, _btn_y, _team_btn_x + _team_btn_w, _btn_y + _team_btn_h]);
}
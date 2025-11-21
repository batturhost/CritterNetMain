// --- Step Event ---
event_inherited();

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _click = mouse_check_button_pressed(mb_left);

if (heal_message_timer > 0) heal_message_timer--;

// BUTTON LOGIC
if (browser_state == "browsing") {
    btn_ranked_hover = point_in_box(_mx, _my, btn_ranked_x1, btn_ranked_y1, btn_ranked_x2, btn_ranked_y2);
    btn_casual_hover = point_in_box(_mx, _my, btn_casual_x1, btn_casual_y1, btn_casual_x2, btn_casual_y2);
    btn_heal_hover = point_in_box(_mx, _my, btn_heal_x1, btn_heal_y1, btn_heal_x2, btn_heal_y2);

    if (_click && !is_dragging) {
        if (btn_ranked_hover) {
            if (instance_exists(obj_battle_manager)) exit;
            if (global.PlayerData.current_opponent_index >= array_length(current_cup.opponents)) {
                heal_message_text = "You've beaten everyone in this cup!";
                heal_message_timer = 120;
            } else {
                browser_state = "searching"; // CHANGE STATE
                search_timer = 120;
            }
        }
        
        if (btn_casual_hover) {
            if (instance_exists(obj_battle_manager)) exit;
            var _cup = global.CupDatabase[global.PlayerData.current_cup_index];
            var _battle_data = { is_casual: true, opponent_data: noone, level_cap: _cup.level_cap };
            instance_create_layer(0, 0, "Instances", obj_battle_manager, _battle_data);
            instance_destroy();
        }
        
        if (btn_heal_hover) {
            for (var i = 0; i < array_length(global.PlayerData.team); i++) {
                var _critter = global.PlayerData.team[i];
                _critter.hp = _critter.max_hp;
                _critter.atk_stage = 0; _critter.def_stage = 0; _critter.spd_stage = 0;
            }
            heal_message_text = "All critters fully restored!";
            heal_message_timer = 120;
        }
    }
}

// STATE MACHINE
if (browser_state == "searching") {
    search_timer--;
    if (search_timer <= 0) {
        browser_state = "match_found";
        match_display_timer = 180;
    }
}
else if (browser_state == "match_found") {
    match_display_timer--;
    if (match_display_timer <= 0) {
        var _opp_data = current_cup.opponents[global.PlayerData.current_opponent_index];
        var _battle_data = { is_casual: false, opponent_data: _opp_data, level_cap: current_level_cap };
        instance_create_layer(0, 0, "Instances", obj_battle_manager, _battle_data);
        instance_destroy();
    }
}

// Recalculate UI positions (Sticky UI)
sidebar_x1 = window_x1 + 2;
sidebar_y1 = window_y1 + 32;
sidebar_x2 = sidebar_x1 + sidebar_w;
sidebar_y2 = window_y2 - 2;
content_x1 = sidebar_x2;
content_y1 = sidebar_y1;
content_x2 = window_x2 - 2;
content_y2 = window_y2 - 2;

var _start_y = sidebar_y1 + 100;
var _btn_h = 60;
var _spacing = 10;

btn_ranked_x1 = sidebar_x1 + 10;
btn_ranked_y1 = _start_y;
btn_ranked_x2 = sidebar_x2 - 10;
btn_ranked_y2 = btn_ranked_y1 + _btn_h;

btn_casual_x1 = sidebar_x1 + 10;
btn_casual_y1 = btn_ranked_y2 + _spacing;
btn_casual_x2 = sidebar_x2 - 10;
btn_casual_y2 = btn_casual_y1 + _btn_h;

btn_heal_x1 = sidebar_x1 + 10;
btn_heal_y1 = btn_casual_y2 + _spacing;
btn_heal_x2 = sidebar_x2 - 10;
btn_heal_y2 = btn_heal_y1 + _btn_h;
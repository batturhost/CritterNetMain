// --- Step Event ---

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _click = mouse_check_button_pressed(mb_left);

// --- 1. Dragging Logic ---
if (mouse_check_button_pressed(mb_left)) {
    if (point_in_box(_mx, _my, window_x1, window_y1, window_x2, window_y1 + 32)) {
        is_dragging = true;
        drag_dx = window_x1 - _mx;
        drag_dy = window_y1 - _my;
    }
}
if (mouse_check_button_released(mb_left)) {
    is_dragging = false;
}
if (is_dragging) {
    window_x1 = _mx + drag_dx;
    window_y1 = _my + drag_dy;
    // Recalculate positions
    window_x2 = window_x1 + window_width;
    window_y2 = window_y1 + window_height;
    
    var _margin = 20;
    var _list_w = 200;
    var _list_h = 300;
    
    list_p_x1 = window_x1 + _margin;
    list_p_y1 = window_y1 + 60;
    list_p_x2 = list_p_x1 + _list_w;
    list_p_y2 = list_p_y1 + _list_h;
    
    list_e_x1 = window_x2 - _margin - _list_w;
    list_e_y1 = window_y1 + 60;
    list_e_x2 = list_e_x1 + _list_w;
    list_e_y2 = list_e_y1 + _list_h;

    btn_fight_x1 = window_x1 + (window_width / 2) - (btn_fight_w / 2);
    btn_fight_y1 = list_p_y2 + 30;
    btn_fight_x2 = btn_fight_x1 + btn_fight_w;
    btn_fight_y2 = btn_fight_y1 + btn_fight_h;
    
    btn_close_x1 = window_x2 - 28; 
    btn_close_y1 = window_y1 + 6;
    btn_close_x2 = window_x2 - 6; 
    btn_close_y2 = window_y1 + 28;
}

// --- 2. Button Logic ---
btn_fight_hover = point_in_box(_mx, _my, btn_fight_x1, btn_fight_y1, btn_fight_x2, btn_fight_y2);
btn_close_hover = point_in_box(_mx, _my, btn_close_x1, btn_close_y1, btn_close_x2, btn_close_y2);

if (_click) {
    if (btn_close_hover) {
        instance_destroy();
        exit;
    }
    
    // --- START BATTLE ---
    if (btn_fight_hover) {
        // Check if battle already exists to prevent stacking
        if (instance_exists(obj_battle_manager)) exit;

        // 1. Set Player Critter (Slot 0)
        var _p_key = critter_list[player_selected_index];
        var _p_data = global.bestiary[$ _p_key];
        
        // Create a fresh instance for the team
        var _new_p = new AnimalData(
            _p_data.animal_name, _p_data.base_hp, _p_data.base_atk, _p_data.base_def, _p_data.base_spd,
            50, // Level 50 for testing
            _p_data.sprite_idle, _p_data.sprite_idle_back, _p_data.sprite_signature_move,
            _p_data.moves, _p_data.blurb, _p_data.size,
            _p_data.element_type 
        );
        _new_p.nickname = "Debug " + _p_data.animal_name;
        recalculate_stats(_new_p);
        
        // Force into slot 0
        global.PlayerData.team = [];
        array_push(global.PlayerData.team, _new_p);
        
        // 2. Prepare Enemy Data
        var _e_key = critter_list[enemy_selected_index];
        var _e_db = global.bestiary[$ _e_key];
        
        var _opp_data = {
            name: "Debug Opponent",
            profile_pic_sprite: spr_1,
            critter_keys: [ _e_key ],
            critter_levels: [ 50 ], // Level 50 for testing
            lose_message: "Debug match ended.",
            is_glitched: false
        };

        // [FIX] Force weather to RAIN since Browser isn't open
        global.weather_condition = "RAIN";

        // 3. Launch Battle
        instance_create_layer(0, 0, "Instances", obj_battle_manager, {
            is_casual: false,
            opponent_data: _opp_data,
            level_cap: 100
        });
    }
    
    // --- LIST SELECTION ---
    if (!is_dragging) {
        // Player List
        if (point_in_box(_mx, _my, list_p_x1, list_p_y1, list_p_x2, list_p_y2)) {
            var _idx = floor((_my - list_p_y1) / list_item_height) + player_scroll_top;
            if (_idx < array_length(critter_list)) player_selected_index = _idx;
        }
        // Enemy List
        if (point_in_box(_mx, _my, list_e_x1, list_e_y1, list_e_x2, list_e_y2)) {
            var _idx = floor((_my - list_e_y1) / list_item_height) + enemy_scroll_top;
            if (_idx < array_length(critter_list)) enemy_selected_index = _idx;
        }
    }
}

// --- 3. Scroll Logic ---
var _scroll = mouse_wheel_down() - mouse_wheel_up();
if (_scroll != 0) {
    if (point_in_box(_mx, _my, list_p_x1, list_p_y1, list_p_x2, list_p_y2)) {
        var _max = max(0, array_length(critter_list) - floor((list_p_y2 - list_p_y1)/list_item_height));
        player_scroll_top = clamp(player_scroll_top + _scroll, 0, _max);
    }
    if (point_in_box(_mx, _my, list_e_x1, list_e_y1, list_e_x2, list_e_y2)) {
        var _max = max(0, array_length(critter_list) - floor((list_e_y2 - list_e_y1)/list_item_height));
        enemy_scroll_top = clamp(enemy_scroll_top + _scroll, 0, _max);
    }
}
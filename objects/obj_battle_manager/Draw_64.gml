// --- Draw GUI Event ---

if (!variable_instance_exists(id, "btn_main_menu")) exit;

draw_set_font(fnt_vga);

// 1. INHERIT PARENT (Draws Main Window Frame/BG/Title/Close)
event_inherited();

// 2. BATTLE VIEWPORT (Teal Background + Scanlines INSIDE the window)
var _inner_x = window_x1 + 2;
var _inner_y = window_y1 + 32;
var _inner_w = window_width - 4;
var _inner_h = window_height - 34;

gpu_set_scissor(_inner_x, _inner_y, _inner_w, _inner_h);

draw_set_color(c_teal); 
draw_rectangle(_inner_x, _inner_y, _inner_x + _inner_w, _inner_y + _inner_h, false);
draw_scanlines_95(_inner_x, _inner_y, _inner_x + _inner_w, _inner_y + _inner_h);

// ================== WEATHER DRAWING START ==================
if (global.weather_condition == "RAIN" || global.weather_condition == "STORM") {
    // 1. Draw Dark Storm Overlay
    if (global.weather_condition == "STORM") {
        draw_set_color(c_black);
        draw_set_alpha(0.3);
        draw_rectangle(_inner_x, _inner_y, _inner_x + _inner_w, _inner_y + _inner_h, false);
    }

    // 2. Draw Raindrops
    draw_set_color(c_aqua); // Cyan for retro rain feel
    draw_set_alpha(0.6);
    
    for (var i = 0; i < array_length(weather_particles); i++) {
        var _p = weather_particles[i];
        
        // Calculate screen position
        var _dx = _inner_x + _p.x;
        var _dy = _inner_y + _p.y;
        
        // Don't draw if outside the box (optimization)
        if (_dx > _inner_x && _dx < _inner_x + _inner_w && _dy > _inner_y && _dy < _inner_y + _inner_h) {
            // Slant lines for storm
            var _slant = (global.weather_condition == "STORM") ? -5 : 0;
            draw_line_width(_dx, _dy, _dx + _slant, _dy + _p.length, _p.width);
        }
    }
    
    // 3. Lightning Flash
    if (weather_flash_alpha > 0) {
        draw_set_color(c_white);
        draw_set_alpha(weather_flash_alpha);
        draw_rectangle(_inner_x, _inner_y, _inner_x + _inner_w, _inner_y + _inner_h, false);
    }
}
else if (global.weather_condition == "SUN") {
    // 1. Draw Warm Glow Overlay (Pulsing)
    var _pulse = (sin(sun_glow_timer / 60) * 0.1) + 0.1; // 0.0 to 0.2 alpha
    draw_set_color(c_orange);
    draw_set_alpha(_pulse);
    draw_rectangle(_inner_x, _inner_y, _inner_x + _inner_w, _inner_y + _inner_h, false);
    
    // 2. Draw Floating "Dust/Pollen"
    draw_set_color(c_yellow);
    for (var i = 0; i < array_length(weather_particles); i++) {
        var _p = weather_particles[i];
        var _dx = _inner_x + _p.x;
        var _dy = _inner_y + _p.y;
        
        draw_set_alpha(_p.alpha);
        draw_circle(_dx, _dy, _p.size, false);
    }
    
    // 3. Draw "Lens Flare" Circle in top-right corner
    draw_set_color(c_white);
    draw_set_alpha(0.1);
    draw_circle(_inner_x + _inner_w - 50, _inner_y + 50, 80, false);
    draw_circle(_inner_x + _inner_w - 50, _inner_y + 50, 60, false);
}
else if (global.weather_condition == "SNOW") {
    // 1. Draw Cold Overlay
    draw_set_color(c_white);
    draw_set_alpha(0.1);
    draw_rectangle(_inner_x, _inner_y, _inner_x + _inner_w, _inner_y + _inner_h, false);
    
    // 2. Draw Snowflakes
    draw_set_alpha(0.8);
    for (var i = 0; i < array_length(weather_particles); i++) {
        var _p = weather_particles[i];
        var _dx = _inner_x + _p.x;
        var _dy = _inner_y + _p.y;
        
        // Only draw if inside bounds
        if (_dx > _inner_x && _dx < _inner_x + _inner_w && _dy > _inner_y && _dy < _inner_y + _inner_h) {
            draw_circle(_dx, _dy, _p.size, false);
        }
    }
}

// Reset Draw Settings
draw_set_alpha(1.0);
draw_set_color(c_white);
// ================== WEATHER DRAWING END ==================


// --- CHECK FOR DOWNLOAD STATE ---
if (current_state == BATTLE_STATE.WIN_DOWNLOAD_PROGRESS || current_state == BATTLE_STATE.WIN_DOWNLOAD_COMPLETE)
{
    // === DRAW MODAL POPUP WINDOW ===
    var _pop_w = 440;
    var _pop_h = 400;
    var _pop_x1 = window_x1 + (window_width - _pop_w) / 2;
    var _pop_y1 = window_y1 + (window_height - _pop_h) / 2;
    var _pop_x2 = _pop_x1 + _pop_w;
    var _pop_y2 = _pop_y1 + _pop_h;
    
    // 1. Draw Window Frame
    draw_rectangle_95(_pop_x1, _pop_y1, _pop_x2, _pop_y2, "raised");

    // 2. Draw Title Bar
    draw_set_color(c_navy);
    draw_rectangle(_pop_x1 + 2, _pop_y1 + 2, _pop_x2 - 2, _pop_y1 + 32, false);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_text(_pop_x1 + 10, _pop_y1 + 17, "File Acquisition");
    
    // 3. Draw Content
    draw_set_halign(fa_center);
    draw_set_color(c_black);

    if (current_state == BATTLE_STATE.WIN_DOWNLOAD_PROGRESS) {
        // -- DOWNLOADING STATE --
        draw_set_valign(fa_top);
        draw_text(_pop_x1 + (_pop_w/2), _pop_y1 + 80, "Downloading Critter-File...");
        draw_text(_pop_x1 + (_pop_w/2), _pop_y1 + 105, download_filename);

        // Progress Bar Logic
        var _bar_w = 300; 
        var _bar_h = 30;
        var _bar_x1 = _pop_x1 + (_pop_w / 2) - (_bar_w / 2);
        var _bar_y1 = _pop_y1 + (_pop_h / 2);
        var _bar_x2 = _bar_x1 + _bar_w;
        var _bar_y2 = _bar_y1 + _bar_h;
        
        draw_rectangle_95(_bar_x1, _bar_y1, _bar_x2, _bar_y2, "sunken");

        var _fill_width = (_bar_w - 4) * (download_current_percent / 100);
        if (_fill_width > 0) {
            draw_set_color(c_navy);
            draw_rectangle(_bar_x1 + 2, _bar_y1 + 2, _bar_x1 + 2 + _fill_width, _bar_y2 - 2, false);
        }
        
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(_bar_x1 + (_bar_w/2), _bar_y1 + (_bar_h/2) + 2, string(floor(download_current_percent)) + "%");
        
        draw_set_valign(fa_top);
        draw_set_color(c_black);
        draw_text(_pop_x1 + (_pop_w/2), _pop_y2 - 40, "[Connecting...]");
    } else {
        // -- COMPLETE STATE --
        draw_set_valign(fa_top);
        draw_text(_pop_x1 + (_pop_w/2), _pop_y1 + 60, "Critter-File Download Complete!");
        
        // Sprite Box
        var _center_x = _pop_x1 + (_pop_w/2);
        var _visual_center_y = _pop_y1 + 175;
        var _max_w = 140; 
        var _max_h = 140;

        // Draw "Sunken" Frame for sprite
        var _box_w = 150;
        var _box_h = 150; 
        draw_rectangle_95(_center_x - _box_w/2, _visual_center_y - _box_h/2, _center_x + _box_w/2, _visual_center_y + _box_h/2, "sunken");

        var _spr_w = sprite_get_width(download_sprite);
        var _spr_h = sprite_get_height(download_sprite);
        var _fit_scale = min(_max_w / _spr_w, _max_h / _spr_h);

        // Draw Sprite Position (Bottom-Center Origin Fix)
        var _draw_y = _visual_center_y + ((_spr_h / 2) * _fit_scale);
        draw_sprite_ext(download_sprite, 0, _center_x, _draw_y, _fit_scale, _fit_scale, 0, c_white, 1);

        draw_set_color(c_black);
        draw_text(_pop_x1 + (_pop_w/2), _pop_y2 - 120, "You acquired data for:");
        draw_set_color(c_yellow);
        draw_text(_pop_x1 + (_pop_w/2), _pop_y2 - 95, enemy_critter_data.animal_name);
    }
}
else 
{
    // --- STANDARD BATTLE DRAWING ---
    
    // 3. Draw Actors
    var sprite_y_offset = -25;
    draw_battle_actor(enemy_actor, enemy_critter_data, sprite_y_offset);
    draw_battle_actor(player_actor, player_critter_data, sprite_y_offset);
    
    // 4. Draw Battle Log Box
    var _log_y1 = window_y1 + (window_height * 0.8);
    var _log_y2 = window_y2 - 5;
    draw_rectangle_95(window_x1 + 5, _log_y1, window_x2 - 5, _log_y2, "sunken");
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_black);
    if (!(current_state == BATTLE_STATE.PLAYER_TURN && (current_menu == MENU.FIGHT || current_menu == MENU.TEAM))) {
        draw_text(window_x1 + 15, _log_y1 + 10, battle_log_text);
    }

    // 5. Info Boxes
    draw_set_color(c_white);

    // Enemy Box
    draw_rectangle_95(info_enemy_x1, info_enemy_y1, info_enemy_x2, info_enemy_y2, "raised");
    draw_set_color(c_black);
    draw_text(info_enemy_x1 + 10, info_enemy_y1 + 8, current_opponent_data.name); 
    draw_set_halign(fa_right);
    draw_text(info_enemy_x2 - 10, info_enemy_y1 + 8, "Lv. " + string(enemy_critter_data.level));
    draw_set_halign(fa_left);

    // --- VISUAL HP BAR UPDATE (ENEMY) ---
    var _e_hp_perc = enemy_visual_hp / enemy_critter_data.max_hp;
    var _e_bar_x1 = info_enemy_x1 + 10; var _e_bar_y1 = info_enemy_y1 + 40;
    var _e_bar_x2 = info_enemy_x2 - 10;
    var _e_bar_y2 = info_enemy_y1 + 60;
    draw_rectangle_95(_e_bar_x1, _e_bar_y1, _e_bar_x2, _e_bar_y2, "sunken");

    // Determine Color (Green > 50%, Yellow > 20%, Red <= 20%)
    var _e_col = c_green;
    if (_e_hp_perc <= 0.5) _e_col = c_yellow;
    
    if (_e_hp_perc <= 0.1) {
        _e_col = c_red;
        // [FIX] Smooth Blink Logic
        if (current_state != BATTLE_STATE.WAIT_FOR_HP_DRAIN) {
            // Use a sine wave for smooth fade: (sin(time) + 1) / 2 gives 0 to 1
            // Multiply time by a small number to slow it down
            var _blink_amt = (sin(current_time / 150) + 1) / 2;
            // Blend between Red and White
            _e_col = merge_color(c_red, c_white, _blink_amt * 0.7);
            // 0.7 keeps it from going purely white
        }
    }
    
    draw_set_color(_e_col);
    var _e_fill_w = (_e_bar_x2 - _e_bar_x1 - 4) * _e_hp_perc;
    if (_e_fill_w > 0) draw_rectangle(_e_bar_x1 + 2, _e_bar_y1 + 2, _e_bar_x1 + 2 + _e_fill_w, _e_bar_y2 - 2, false);

    // Player Box
    draw_set_color(c_white);
    draw_rectangle_95(info_player_x1, info_player_y1, info_player_x2, info_player_y2, "raised");
    draw_set_color(c_black);
    draw_text(info_player_x1 + 10, info_player_y1 + 8, player_critter_data.nickname);
    draw_set_halign(fa_right);
    draw_text(info_player_x2 - 10, info_player_y1 + 8, "Lv. " + string(player_critter_data.level));
    draw_set_halign(fa_left);

    // --- VISUAL HP BAR UPDATE (PLAYER) ---
    var _p_hp_perc = player_visual_hp / player_critter_data.max_hp;
    var _p_bar_x1 = info_player_x1 + 10; var _p_bar_y1 = info_player_y1 + 40;
    var _p_bar_x2 = info_player_x2 - 10;
    var _p_bar_y2 = info_player_y1 + 60;
    draw_rectangle_95(_p_bar_x1, _p_bar_y1, _p_bar_x2, _p_bar_y2, "sunken");

    // Determine Color
    var _p_col = c_green;
    if (_p_hp_perc <= 0.5) _p_col = c_yellow;
    if (_p_hp_perc <= 0.2) {
        _p_col = c_red;
        // [FIX] Smooth Blink Logic
        if (current_state != BATTLE_STATE.WAIT_FOR_HP_DRAIN) {
            // Use a sine wave for smooth fade: (sin(time) + 1) / 2 gives 0 to 1
            var _blink_amt = (sin(current_time / 150) + 1) / 2;
            // Blend between Red and White
            _p_col = merge_color(c_red, c_white, _blink_amt * 0.7);
        }
    }
    
    draw_set_color(_p_col);
    var _p_fill_w = (_p_bar_x2 - _p_bar_x1 - 4) * _p_hp_perc;
    if (_p_fill_w > 0) draw_rectangle(_p_bar_x1 + 2, _p_bar_y1 + 2, _p_bar_x1 + 2 + _p_fill_w, _p_bar_y2 - 2, false);

    // --- XP BAR ---
    var _xp_perc = 0;
    if (player_critter_data.next_level_xp > 0) {
        _xp_perc = player_critter_data.xp / player_critter_data.next_level_xp;
    }
    _xp_perc = clamp(_xp_perc, 0, 1);

    var _xp_bar_y1 = _p_bar_y2 + 4;
    var _xp_bar_y2 = _xp_bar_y1 + 6; 
    
    // Draw Background (Dark Gray)
    draw_set_color(c_dkgray);
    draw_rectangle(_p_bar_x1, _xp_bar_y1, _p_bar_x2, _xp_bar_y2, false);
    
    // Draw Fill (Cyan/Blue)
    if (_xp_perc > 0) {
        draw_set_color(c_aqua);
        draw_rectangle(_p_bar_x1, _xp_bar_y1, _p_bar_x1 + ((_p_bar_x2 - _p_bar_x1) * _xp_perc), _xp_bar_y2, false);
    }
    // -------------------

    // 6. Battle Buttons
    draw_set_color(c_white);
    if (current_state == BATTLE_STATE.PLAYER_TURN) {
        switch (current_menu) {
            case MENU.MAIN:
                draw_battle_menu_buttons(btn_main_menu, menu_focus);
                break;
                
            case MENU.FIGHT:
                draw_battle_menu_buttons(btn_move_menu, menu_focus, player_critter_data.move_pp);
                if (menu_focus >= 0 && menu_focus < array_length(player_critter_data.moves) && menu_focus != 3) {
                    var _move = player_critter_data.moves[menu_focus];
                    var _cur_pp = player_critter_data.move_pp[menu_focus];
                    var _info_w = 250; var _info_h = 80;
                    var _info_x1 = window_x1 + 25;
                    var _info_y1 = _log_y1 + 15;
                    draw_move_info_panel(_info_x1, _info_y1, _info_w, _info_h, _move, _cur_pp);
                }
                break;

            case MENU.TEAM:
                // Draw over the log box area
                draw_rectangle_95(window_x1 + 5, _log_y1, window_x2 - 5, window_y2 - 5, "raised");
                var _team_size = array_length(global.PlayerData.team);
                for (var i = 0; i < 6; i++) {
                    var _btn = btn_team_layout[i];
                    var _state = (menu_focus == i) ? "sunken" : "raised";
                    draw_rectangle_95(_btn[0], _btn[1], _btn[2], _btn[3], _state);
                    if (i < _team_size) {
                        var _critter = global.PlayerData.team[i];
                        if (_critter.hp <= 0 || _critter == player_critter_data) draw_set_color(c_dkgray);
                        else draw_set_color(c_black);
                        
                        draw_set_halign(fa_left); draw_set_valign(fa_top);
                        var _sprite = _critter.sprite_idle;
                        var _frame_w = 64; var _frame_h = 64;
                        var _frame_x1 = _btn[0] + 10; var _frame_y1 = _btn[1] + 8;
                        var _frame_x2 = _frame_x1 + _frame_w; var _frame_y2 = _frame_y1 + _frame_h;
                        
                        draw_rectangle_95(_frame_x1, _frame_y1, _frame_x2, _frame_y2, "sunken");
                        var _scale = min((_frame_w - 8) / sprite_get_width(_sprite), (_frame_h - 8) / sprite_get_height(_sprite));
                        var _icon_x = _frame_x1 + (_frame_w / 2);
                        var _icon_y_center = _frame_y1 + (_frame_h / 2);
                        var _icon_draw_y = _icon_y_center + ((sprite_get_height(_sprite)/2) * _scale);
                        
                        gpu_set_scissor(_frame_x1 + 2, _frame_y1 + 2, _frame_w - 4, _frame_h - 4);
                        draw_sprite_ext(_sprite, 0, _icon_x, _icon_draw_y, _scale, _scale, 0, c_white, 1);
                        gpu_set_scissor(_inner_x, _inner_y, _inner_w, _inner_h);
                        // Restore main scissor
                        
                        var _text_x = _frame_x2 + 10;
                        draw_text(_text_x, _btn[1] + 10, _critter.nickname);
                        draw_text(_text_x, _btn[1] + 30, "Lv. " + string(_critter.level));
                        
                        var _hp_perc = _critter.hp / _critter.max_hp;
                        var _hp_bar_x1 = _text_x; var _hp_bar_y1 = _btn[1] + 55; var _hp_bar_w = 100; var _hp_bar_h = 10;
                        draw_rectangle_95(_hp_bar_x1, _hp_bar_y1, _hp_bar_x1 + _hp_bar_w, _hp_bar_y1 + _hp_bar_h, "sunken");
                        
                        // COLOR LOGIC ALSO FOR TEAM LIST
                        var _team_col = c_green;
                        if (_hp_perc <= 0.5) _team_col = c_yellow;
                        if (_hp_perc <= 0.2) _team_col = c_red;
                        
                        draw_set_color(_team_col);
                        draw_rectangle(_hp_bar_x1 + 2, _hp_bar_y1 + 2, _hp_bar_x1 + 2 + ((_hp_bar_w - 4) * _hp_perc), _hp_bar_y1 + _hp_bar_h - 2, false);
                        draw_set_color(c_black);
                        draw_set_halign(fa_right);
                        draw_text(_btn[2] - 10, _btn[1] + 55, string(_critter.hp) + "/" + string(_critter.max_hp));
                    }
                }
                var _cancel_btn = btn_team_layout[6];
                var _cancel_state = (menu_focus == 6) ? "sunken" : "raised";
                draw_rectangle_95(_cancel_btn[0], _cancel_btn[1], _cancel_btn[2], _cancel_btn[3], _cancel_state);
                draw_set_color(c_black);
                draw_set_halign(fa_center); draw_set_valign(fa_middle);
                var _cancel_w = _cancel_btn[2] - _cancel_btn[0]; var _cancel_h = _cancel_btn[3] - _cancel_btn[1];
                draw_text(_cancel_btn[0] + (_cancel_w / 2), _cancel_btn[1] + (_cancel_h / 2), "CANCEL");
                break;
        }
    }
}

gpu_set_scissor(0, 0, display_get_gui_width(), display_get_gui_height());
// Reset
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
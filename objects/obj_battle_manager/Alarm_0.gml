// --- Alarm 0: Battle State Timer ---

switch (current_state) {
    
    // --- STARTUP SEQUENCE ---
    case BATTLE_STATE.WAIT_FOR_START:
        // [CHANGE] Go to Player Intro instead of straight to Turn
        current_state = BATTLE_STATE.INTRO_PLAYER;
        break;

    // [NEW] Handle the delay after Player sends out critter
    case BATTLE_STATE.WAIT_FOR_PLAYER_INTRO:
        current_state = BATTLE_STATE.PLAYER_TURN;
        current_menu = MENU.MAIN;
        menu_focus = 0;
        break;

    // --- STANDARD BATTLE LOOP ---
    case BATTLE_STATE.WAIT_FOR_PLAYER_MOVE:
        if (enemy_critter_data.hp <= 0) {
            current_state = BATTLE_STATE.ENEMY_FAINT;
            alarm[0] = 60;
        } else {
            current_state = BATTLE_STATE.PLAYER_POST_TURN_DAMAGE;
            event_user(0); 
            if (player_critter_data.glitch_timer > 0) {
                 player_critter_data.glitch_timer--;
                 current_state = BATTLE_STATE.PLAYER_POST_TURN_DAMAGE;
            } else {
                 current_state = BATTLE_STATE.ENEMY_TURN;
            }
        }
        break;
        
    case BATTLE_STATE.WAIT_FOR_ENEMY_MOVE:
        if (player_critter_data.hp <= 0) {
            current_state = BATTLE_STATE.PLAYER_FAINT;
            alarm[0] = 60;
        } else {
            current_state = BATTLE_STATE.ENEMY_POST_TURN_DAMAGE;
            if (enemy_critter_data.glitch_timer > 0) {
                 enemy_critter_data.glitch_timer--;
                 current_state = BATTLE_STATE.ENEMY_POST_TURN_DAMAGE;
            } else {
                 current_state = BATTLE_STATE.PLAYER_TURN;
            }
        }
        break;
        
    case BATTLE_STATE.WAIT_FOR_FAINT:
        if (enemy_critter_data.hp <= 0) {
            if (is_casual) {
                download_start_percent = 0;
                download_end_percent = 100; 
                download_current_percent = 0;
                download_filename = enemy_critter_data.animal_name + ".critter";
                download_sprite = enemy_critter_data.sprite_idle;
                current_state = BATTLE_STATE.WIN_DOWNLOAD_PROGRESS;
            } else {
                current_state = BATTLE_STATE.WIN_XP_GAIN;
                alarm[0] = 30;
            }
        } else {
            if (player_has_healthy_critters()) {
                is_force_swapping = true;
                current_state = BATTLE_STATE.PLAYER_TURN;
                current_menu = MENU.TEAM; 
                battle_log_text = "Choose your next critter!";
            } else {
                current_state = BATTLE_STATE.LOSE;
            }
        }
        break;

    // --- SWAP LOGIC ---
    case BATTLE_STATE.PLAYER_SWAP_IN:
        var _new_critter = global.PlayerData.team[swap_target_index];
        instance_destroy(player_actor);
        
        player_critter_data = _new_critter;
        player_visual_hp = player_critter_data.hp;
        
        var _btn_w = 175; var _btn_h = 30;
        var _btn_gutter = 10;
        var _log_y1 = window_y1 + (window_height * 0.8);
        var _btn_base_x = window_x2 - (_btn_w * 2) - (_btn_gutter * 2);
        var _btn_base_y = _log_y1 + 15;
        
        btn_move_menu = [
            [_btn_base_x, _btn_base_y, _btn_base_x + _btn_w, _btn_base_y + _btn_h, player_critter_data.moves[0].move_name],
            [_btn_base_x + _btn_w + _btn_gutter, _btn_base_y, _btn_base_x + _btn_w * 2 + _btn_gutter, _btn_base_y + _btn_h, player_critter_data.moves[1].move_name], 
            [_btn_base_x, _btn_base_y + _btn_h + _btn_gutter, _btn_base_x + _btn_w, _btn_base_y + _btn_h * 2 + _btn_gutter, player_critter_data.moves[2].move_name],
            [_btn_base_x + _btn_w + _btn_gutter, _btn_base_y + _btn_h + _btn_gutter, _btn_base_x + _btn_w * 2 + _btn_gutter, _btn_base_y + _btn_h * 2 + _btn_gutter, "BACK"]
        ];
        
        var _layer_id = layer_get_id("Instances");
        var _px = window_x1 + (window_width * 0.3);
        var _py = window_y1 + (window_height * 0.7);
        
        player_actor = instance_create_layer(_px, _py, _layer_id, obj_player_critter);
        init_animal(player_actor, player_critter_data, player_critter_data.sprite_idle_back);
        var _p_scale_mult = get_critter_scale_config(player_critter_data.animal_name, true);
        player_actor.my_scale = 0.33 * 1.30 * _p_scale_mult;
        
        battle_log_text = "Go! " + player_critter_data.nickname + "!";
        
        // [SOUND] Play Cry on Swap
        play_critter_cry(player_critter_data);
        
        // Check if swap ends turn
        if (variable_instance_exists(id, "swap_ends_turn") && swap_ends_turn) {
             current_state = BATTLE_STATE.ENEMY_TURN;
        } else {
             current_state = BATTLE_STATE.PLAYER_TURN;
        }
        current_menu = MENU.MAIN;
        break;

    // --- WIN SEQUENCE ---
    case BATTLE_STATE.WIN_DOWNLOAD_COMPLETE:
        current_state = BATTLE_STATE.WIN_XP_GAIN;
        alarm[0] = 60;
        break;
        
    case BATTLE_STATE.WIN_XP_GAIN:
        var _b_hp = enemy_critter_data.base_hp;
        var _b_atk = enemy_critter_data.base_atk;
        var _b_def = enemy_critter_data.base_def;
        var _b_spd = enemy_critter_data.base_spd;
        var _base_yield = (_b_hp + _b_atk + _b_def + _b_spd) / 4;
        var _trainer_bonus = is_casual ? 1.0 : 1.5;
        var _val = (_base_yield * enemy_critter_data.level * _trainer_bonus) / 7;
        var _xp_gain = floor(_val);
        player_critter_data.xp += _xp_gain;
        battle_log_text = player_critter_data.nickname + " gained " + string(_xp_gain) + " XP!";
        alarm[0] = 120; 
        current_state = BATTLE_STATE.WIN_CHECK_LEVEL; 
        break;

    case BATTLE_STATE.WIN_CHECK_LEVEL:
        if (player_critter_data.level < 100 && player_critter_data.xp >= player_critter_data.next_level_xp) {
             player_critter_data.level += 1;
             player_critter_data.xp -= player_critter_data.next_level_xp;
             player_critter_data.next_level_xp = power(player_critter_data.level, 3);
             recalculate_stats(player_critter_data);
             battle_log_text = player_critter_data.nickname + " grew to Level " + string(player_critter_data.level) + "!";
             current_state = BATTLE_STATE.WIN_LEVEL_UP_MSG;
             alarm[0] = 120;
        } else {
            current_state = BATTLE_STATE.WIN_COIN_GAIN;
            alarm[0] = 10;
        }
        break;
        
    case BATTLE_STATE.WIN_LEVEL_UP_MSG:
        if (player_critter_data.level < 100 && player_critter_data.xp >= player_critter_data.next_level_xp) {
            current_state = BATTLE_STATE.WIN_CHECK_LEVEL;
            alarm[0] = 10;
        } else {
            current_state = BATTLE_STATE.WIN_COIN_GAIN;
            alarm[0] = 30;
        }
        break;
        
    case BATTLE_STATE.WIN_COIN_GAIN:
        var _coin_base = enemy_critter_data.level;
        var _coin_mult = is_casual ? 5 : 20;
        var _gain = floor(_coin_base * _coin_mult);
        if (!variable_struct_exists(global.PlayerData, "coins")) global.PlayerData.coins = 0;
        global.PlayerData.coins += _gain;
        battle_log_text = "You found " + string(_gain) + " C-Net Coins!";
        current_state = BATTLE_STATE.WIN_COIN_WAIT;
        alarm[0] = 120; 
        break;
        
    case BATTLE_STATE.WIN_COIN_WAIT:
        battle_log_text = "You won the battle! Click to continue.";
        current_state = BATTLE_STATE.WIN_END;
        break;
        
    // --- END TURN EFFECTS ---
    case BATTLE_STATE.PLAYER_POST_TURN_DAMAGE:
         current_state = BATTLE_STATE.ENEMY_TURN;
         break;
    case BATTLE_STATE.ENEMY_POST_TURN_DAMAGE:
         current_state = BATTLE_STATE.PLAYER_TURN;
         break;
}
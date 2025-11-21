// --- Alarm 0: Battle State Timer ---

switch (current_state) {
    case BATTLE_STATE.WAIT_FOR_START:
        current_state = BATTLE_STATE.PLAYER_TURN;
        current_menu = MENU.MAIN;
        menu_focus = 0;
        break;
        
    case BATTLE_STATE.WAIT_FOR_PLAYER_MOVE:
        // Check for fainted enemy
        if (enemy_critter_data.hp <= 0) {
            current_state = BATTLE_STATE.ENEMY_FAINT;
            alarm[0] = 60;
        } else {
            // Trigger passive damage or proceed
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
        // Check for fainted player
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
            // YOU WIN
            if (is_casual) {
                download_start_percent = 0;
                download_end_percent = 100; 
                download_current_percent = 0;
                download_filename = enemy_critter_data.animal_name + ".critter";
                download_sprite = enemy_critter_data.sprite_idle;
                current_state = BATTLE_STATE.WIN_DOWNLOAD_PROGRESS;
            } else {
                // Ranked -> Go to XP Gain
                current_state = BATTLE_STATE.WIN_XP_GAIN;
                alarm[0] = 30;
            }
        } else {
            // YOU LOSE (or Swap)
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
    case BATTLE_STATE.PLAYER_SWAP_IN:
        var _new_critter = global.PlayerData.team[swap_target_index];
        instance_destroy(player_actor);
        player_critter_data = _new_critter;
        // Update UI
        var _btn_w = 175; var _btn_h = 30;
        var _btn_gutter = 10;
        var _log_y1 = window_y1 + (window_height * 0.8);
        var _btn_base_x = window_x2 - (_btn_w * 2) - (_btn_gutter * 2);
        var _btn_base_y = _log_y1 + 15;
        btn_move_menu = [
            [_btn_base_x, _btn_base_y, _btn_base_x + _btn_w, _btn_base_y + _btn_h, player_critter_data.moves[0].move_name],
            [_btn_base_x + _btn_w + _btn_gutter, _btn_base_y, _btn_base_x + _btn_w * 2 + _btn_gutter, _btn_base_y + _btn_h, player_critter_data.moves[1].move_name], 
            [_btn_base_x, _btn_base_y + _btn_h + _btn_gutter, _btn_base_x + _btn_w, _btn_base_y + _btn_h * 2 + _btn_gutter, player_critter_data.moves[2].move_name],
            [_btn_base_x + _btn_w + _btn_gutter, _btn_base_y + _btn_h + 
            _btn_gutter, _btn_base_x + _btn_w * 2 + _btn_gutter, _btn_base_y + _btn_h * 2 + _btn_gutter, "BACK"]
        ];
        var _layer_id = layer_get_id("Instances");
        var _px = window_x1 + (window_width * 0.3);
        var _py = window_y1 + (window_height * 0.7);
        player_actor = instance_create_layer(_px, _py, _layer_id, obj_player_critter);
        init_animal(player_actor, player_critter_data, player_critter_data.sprite_idle_back);
        
        // ================== NEW SCALING LOGIC ==================
        var _p_scale_mult = get_critter_scale_config(player_critter_data.animal_name, true); // Pass TRUE for player
        player_actor.my_scale = 0.33 * 1.30 * _p_scale_mult;
        // ========================================================
        
        battle_log_text = "Go! " + player_critter_data.nickname + "!";
        current_state = BATTLE_STATE.PLAYER_TURN;
        current_menu = MENU.MAIN;
        break;
        
    case BATTLE_STATE.WIN_DOWNLOAD_COMPLETE:
        // If we finished downloading, give XP
        current_state = BATTLE_STATE.WIN_XP_GAIN;
        alarm[0] = 60;
        break;

    // --- CORRECTED XP FORMULA ---
    case BATTLE_STATE.WIN_XP_GAIN:
        // 1. Calculate Base Yield (Average of base stats)
        var _b_hp = enemy_critter_data.base_hp;
        var _b_atk = enemy_critter_data.base_atk;
        var _b_def = enemy_critter_data.base_def;
        var _b_spd = enemy_critter_data.base_spd;
        var _base_yield = (_b_hp + _b_atk + _b_def + _b_spd) / 4;
        // 2. Determine Trainer Bonus (1.5x for Ranked, 1.0x for Casual)
        var _trainer_bonus = is_casual ?
        1.0 : 1.5;
        
        // 3. Formula: (Yield * Level * Bonus) / 7
        var _val = (_base_yield * enemy_critter_data.level * _trainer_bonus) / 7;
        var _xp_gain = floor(_val);
        
        // 4. Apply XP
        player_critter_data.xp += _xp_gain;
        battle_log_text = player_critter_data.nickname + " gained " + string(_xp_gain) + " XP!";
        
        alarm[0] = 120; 
        current_state = BATTLE_STATE.WIN_CHECK_LEVEL; 
        break;
    case BATTLE_STATE.WIN_CHECK_LEVEL:
        // [FIX] Added Level Cap Check
        if (player_critter_data.level < 100 && player_critter_data.xp >= player_critter_data.next_level_xp) {
             
             player_critter_data.level += 1;
             player_critter_data.xp -= player_critter_data.next_level_xp;
             
             // Calculate next threshold
             player_critter_data.next_level_xp = power(player_critter_data.level, 3);
             recalculate_stats(player_critter_data);
             
             battle_log_text = player_critter_data.nickname + " grew to Level " + string(player_critter_data.level) + "!";
             current_state = BATTLE_STATE.WIN_LEVEL_UP_MSG;
             alarm[0] = 120;
        } else {
            // Cap reached or not enough XP
            current_state = BATTLE_STATE.WIN_END;
            alarm[0] = 30;
        }
        break;
    case BATTLE_STATE.WIN_LEVEL_UP_MSG:
        // Check again if we leveled up multiple times
        // [FIX] Added Level Cap Check here too
        if (player_critter_data.level < 100 && player_critter_data.xp >= player_critter_data.next_level_xp) {
            current_state = BATTLE_STATE.WIN_CHECK_LEVEL;
            alarm[0] = 10;
        } else {
            current_state = BATTLE_STATE.WIN_END;
            alarm[0] = 30;
        }
        break;
    case BATTLE_STATE.PLAYER_POST_TURN_DAMAGE:
         current_state = BATTLE_STATE.ENEMY_TURN;
         break;
    case BATTLE_STATE.ENEMY_POST_TURN_DAMAGE:
         current_state = BATTLE_STATE.PLAYER_TURN;
         break;
}
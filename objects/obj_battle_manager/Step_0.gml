// --- Step Event ---

// 1. INHERIT PARENT
event_inherited();

// [FIX] RE-CALCULATE BOUNDS IMMEDIATELY
window_x2 = window_x1 + window_width;
window_y2 = window_y1 + window_height;

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _click = mouse_check_button_pressed(mb_left);

// --- 2. RECALCULATE UI POSITIONS (Sticky UI) ---
// Actor Home Positions
player_actor.home_x = window_x1 + (window_width * 0.3);
player_actor.home_y = window_y1 + (window_height * 0.7);
enemy_actor.home_x = window_x1 + (window_width * 0.75);
enemy_actor.home_y = window_y1 + (window_height * 0.30);

// Logic to update actual Actor positions (if not doing a move)
if (player_actor.vfx_type == "none" && player_actor.lunge_state == 0 && player_actor.shake_timer == 0) {
    player_actor.x = player_actor.home_x;
    player_actor.y = player_actor.home_y;
}
if (enemy_actor.vfx_type == "none" && enemy_actor.lunge_state == 0 && enemy_actor.shake_timer == 0) {
    enemy_actor.x = enemy_actor.home_x;
    enemy_actor.y = enemy_actor.home_y;
}

// Layout Constants
var _log_y1 = window_y1 + (window_height * 0.8);

info_enemy_x1 = window_x1 + 20;
info_enemy_y1 = window_y1 + 40;
info_enemy_x2 = info_enemy_x1 + info_box_width; 
info_enemy_y2 = info_enemy_y1 + info_box_height;

info_player_x1 = window_x2 - info_box_width - 20;
info_player_y1 = _log_y1 - info_box_height - 10; 
info_player_x2 = info_player_x1 + info_box_width;
info_player_y2 = info_player_y1 + info_box_height;

// Main Menu Buttons
var _btn_w = 175; var _btn_h = 30; var _btn_gutter = 10;
var _btn_base_x = window_x2 - (_btn_w * 2) - (_btn_gutter * 2);
var _btn_base_y = _log_y1 + 15;

btn_main_menu = [
    [_btn_base_x, _btn_base_y, _btn_base_x + _btn_w, _btn_base_y + _btn_h, "FIGHT"],
    [_btn_base_x + _btn_w + _btn_gutter, _btn_base_y, _btn_base_x + _btn_w * 2 + _btn_gutter, _btn_base_y + _btn_h, "TEAM"],
    [_btn_base_x, _btn_base_y + _btn_h + _btn_gutter, _btn_base_x + _btn_w, _btn_base_y + _btn_h * 2 + _btn_gutter, "ITEM"],
    [_btn_base_x + _btn_w + _btn_gutter, _btn_base_y + _btn_h + _btn_gutter, _btn_base_x + _btn_w * 2 + _btn_gutter, _btn_base_y + _btn_h * 2 + _btn_gutter, "RUN"]
];

// Team Layout
btn_team_layout = [];
var _team_btn_w = 400; var _team_btn_h = 100; var _team_box_padding = 10;
var _team_box_x_start = window_x1 + 40; 
var _team_box_y_start = window_y1 + 40;

for (var i = 0; i < 3; i++) { 
    for (var j = 0; j < 2; j++) { 
        var _x1 = _team_box_x_start + (j * (_team_btn_w + _team_box_padding));
        var _y1 = _team_box_y_start + (i * (_team_btn_h + _team_box_padding)); 
        array_push(btn_team_layout, [_x1, _y1, _x1 + _team_btn_w, _y1 + _team_btn_h]);
    } 
}
var _cancel_x = window_x2 - 120 - 20; 
var _cancel_y = window_y2 - 40 - 20;
array_push(btn_team_layout, [_cancel_x, _cancel_y, _cancel_x + 120, _cancel_y + 40]);

// Download Bar
download_bar_x1 = window_x1 + (window_width / 2) - (download_bar_w / 2);
download_bar_y1 = window_y1 + (window_height / 2);


// --- 3. Refresh Move Buttons (Dynamic) ---
if (current_state == BATTLE_STATE.PLAYER_TURN && current_menu == MENU.FIGHT) {
    btn_move_menu = [];
    for(var i=0; i<array_length(player_critter_data.moves); i++) {
         var _col = i % 2;
         var _row = floor(i / 2);
         var _bx1 = _btn_base_x + (_col * (_btn_w + _btn_gutter));
         var _by1 = _btn_base_y + (_row * (_btn_h + _btn_gutter));
         array_push(btn_move_menu, [_bx1, _by1, _bx1 + _btn_w, _by1 + _btn_h, player_critter_data.moves[i].move_name]);
    }
    // Back Button
    var _back_bx1 = _btn_base_x + (1 * (_btn_w + _btn_gutter));
    var _back_by1 = _btn_base_y + (1 * (_btn_h + _btn_gutter));
    btn_move_menu[3] = [_back_bx1, _back_by1, _back_bx1 + _btn_w, _back_by1 + _btn_h, "BACK"];
}

// ================== UPDATED: SLOWER BLINK TIMER ==================
// Increased cycle from 20 to 60 frames (1 second cycle at 60fps)
hp_blink_timer = (hp_blink_timer + 1) % 60; 
// ================================================================

// --- 4. Battle State Machine ---
if (is_dragging) _click = false;

switch (current_state) {
    case BATTLE_STATE.START:
        battle_log_text = current_opponent_data.name + " sent out " + enemy_critter_data.nickname + "!";
        alarm[0] = 120;
        current_state = BATTLE_STATE.WAIT_FOR_START;
        break;

    case BATTLE_STATE.PLAYER_TURN:
        if (is_force_swapping) { battle_log_text = player_critter_data.nickname + " fainted! Choose a new critter.";
        } 
        else { battle_log_text = "What will " + player_critter_data.nickname + " do?";
        }
        
        var _key_enter = keyboard_check_pressed(vk_enter);
        var _up = keyboard_check_pressed(vk_up); var _down = keyboard_check_pressed(vk_down);
        var _left = keyboard_check_pressed(vk_left); var _right = keyboard_check_pressed(vk_right);

        if (current_menu == MENU.MAIN || current_menu == MENU.FIGHT) {
            if (_up) menu_focus = max(0, menu_focus - 2);
            if (_down) menu_focus = min(3, menu_focus + 2);
            if (_left) { if (menu_focus == 1) menu_focus = 0;
                         if (menu_focus == 3) menu_focus = 2; }
            if (_right) { if (menu_focus == 0) menu_focus = 1;
                          if (menu_focus == 2) menu_focus = 3; }
        } else if (current_menu == MENU.TEAM) {
             if (_up) { if (menu_focus == 6) menu_focus = 4;
                        else menu_focus = max(0, menu_focus - 2); }
             if (_down) { if (menu_focus >= 4) menu_focus = 6;
                          else menu_focus = min(5, menu_focus + 2); }
             if (_left) { if (menu_focus % 2 == 1) menu_focus--;
             }
             if (_right) { if (menu_focus % 2 == 0 && menu_focus < 6) menu_focus++;
             }
        }
        
        switch (current_menu) {
            case MENU.MAIN:
                for (var i = 0; i < 4; i++) { 
                    var _btn = btn_main_menu[i];
                    if (point_in_box(_mx, _my, _btn[0], _btn[1], _btn[2], _btn[3])) { menu_focus = i; if (_click) _key_enter = true;
                    } 
                }
                if (_key_enter) {
                    if (is_force_swapping && menu_focus != 1) { battle_log_text = "You must choose a critter from your TEAM!";
                    break; }
                    switch (menu_focus) {
                        case 0: current_menu = MENU.FIGHT;
                                menu_focus = 0; break;
                        case 1: current_menu = MENU.TEAM; menu_focus = 0; break;
                        case 2: battle_log_text = "Item select not implemented yet!"; break;
                        case 3: if (is_casual) { battle_log_text = "You fled from the casual battle!"; current_state = BATTLE_STATE.LOSE;
                                } else { battle_log_text = "You can't run from a ranked match!"; } break;
                    }
                }
                break;

            case MENU.FIGHT:
                for (var i = 0; i < 4; i++) { 
                    if (i >= array_length(btn_move_menu)) break;
                    var _btn = btn_move_menu[i]; 
                    if (point_in_box(_mx, _my, _btn[0], _btn[1], _btn[2], _btn[3])) { menu_focus = i; if (_click) _key_enter = true;
                    } 
                }
                
                if (_key_enter) {
                    if (menu_focus == 3) { current_menu = MENU.MAIN;
                                           menu_focus = 0; }
                    else if (menu_focus < array_length(player_critter_data.moves)) {
                        if (player_critter_data.move_pp[menu_focus] > 0) {
                            player_chosen_move_index = menu_focus;
                            current_state = BATTLE_STATE.PLAYER_MOVE_RUN; 
                            current_menu = MENU.MAIN; menu_focus = 0;
                        } else {
                            battle_log_text = "No PP left for this move!";
                        }
                    }
                }
                break;

            case MENU.TEAM:
                var _team_size = array_length(global.PlayerData.team);
                for (var i = 0; i < _team_size; i++) { var _btn = btn_team_layout[i];
                    if (point_in_box(_mx, _my, _btn[0], _btn[1], _btn[2], _btn[3])) { menu_focus = i; if (_click) _key_enter = true;
                    } }
                var _cancel_btn = btn_team_layout[6];
                if (point_in_box(_mx, _my, _cancel_btn[0], _cancel_btn[1], _cancel_btn[2], _cancel_btn[3])) { menu_focus = 6; if (_click) _key_enter = true;
                }
                
                if (_key_enter) {
                    if (menu_focus == 6) {
                        if (is_force_swapping) { battle_log_text = "You must choose a critter to continue!";
                        } else { current_menu = MENU.MAIN; menu_focus = 0; }
                    } else if (menu_focus < _team_size) {
                        var _target_critter = global.PlayerData.team[menu_focus];
                        if (_target_critter == player_critter_data) { battle_log_text = _target_critter.nickname + " is already in battle!";
                        }
                        else if (_target_critter.hp <= 0) { battle_log_text = _target_critter.nickname + " is fainted!";
                        }
                        else { 
                            swap_target_index = menu_focus;
                            current_state = BATTLE_STATE.PLAYER_SWAP_OUT; 
                            current_menu = MENU.MAIN; menu_focus = 0; is_force_swapping = false;
                        }
                    }
                }
                break;
        }
        break;
        
    case BATTLE_STATE.PLAYER_MOVE_RUN: 
        perform_turn_logic(player_actor, enemy_actor, player_critter_data, enemy_critter_data, player_chosen_move_index);
        next_state_after_drain = BATTLE_STATE.WAIT_FOR_PLAYER_MOVE;
        current_state = BATTLE_STATE.WAIT_FOR_HP_DRAIN;
        break;
        
    case BATTLE_STATE.ENEMY_TURN:
        var _valid_moves = [];
        for (var m = 0; m < array_length(enemy_critter_data.moves); m++) { if (enemy_critter_data.move_pp[m] > 0) array_push(_valid_moves, m);
        }
        if (array_length(_valid_moves) > 0) {
            var _pick = irandom(array_length(_valid_moves) - 1);
            enemy_chosen_move_index = _valid_moves[_pick];
            current_state = BATTLE_STATE.ENEMY_MOVE_RUN; 
        } else {
            battle_log_text = enemy_critter_data.nickname + " has no moves left!";
            current_state = BATTLE_STATE.WAIT_FOR_ENEMY_MOVE; alarm[0] = 60;
        }
        break;

    case BATTLE_STATE.ENEMY_MOVE_RUN:
        perform_turn_logic(enemy_actor, player_actor, enemy_critter_data, player_critter_data, enemy_chosen_move_index);
        next_state_after_drain = BATTLE_STATE.WAIT_FOR_ENEMY_MOVE;
        current_state = BATTLE_STATE.WAIT_FOR_HP_DRAIN;
        break;
        
    case BATTLE_STATE.PLAYER_FAINT:
        battle_log_text = player_critter_data.nickname + " fainted!"; player_actor.is_fainting = true;
        alarm[0] = 120; current_state = BATTLE_STATE.WAIT_FOR_FAINT; break;

    case BATTLE_STATE.ENEMY_FAINT:
        battle_log_text = enemy_critter_data.nickname + " fainted!";
        enemy_actor.is_fainting = true;
        alarm[0] = 120; current_state = BATTLE_STATE.WAIT_FOR_FAINT; break;

    case BATTLE_STATE.PLAYER_SWAP_OUT:
        battle_log_text = player_critter_data.nickname + ", come back!"; player_actor.is_fainting = true;
        alarm[0] = 90; current_state = BATTLE_STATE.PLAYER_SWAP_IN; break;
    case BATTLE_STATE.PLAYER_SWAP_IN: break;

    case BATTLE_STATE.WIN_DOWNLOAD_PROGRESS:
        if (download_current_percent < download_end_percent) { download_current_percent += 0.25;
        } 
        else {
            download_current_percent = download_end_percent;
            current_state = BATTLE_STATE.WIN_DOWNLOAD_COMPLETE; alarm[0] = 120; 
            if (download_current_percent >= 100) {
                var _key = current_opponent_data.critter_keys[0];
                var _data = global.bestiary[$ _key]; var _level = enemy_critter_data.level;
                var _new_critter = new AnimalData(_data.animal_name, _data.base_hp, _data.base_atk, _data.base_def, _data.base_spd, _level, _data.sprite_idle, _data.sprite_idle_back, _data.sprite_signature_move, _data.moves, _data.blurb, _data.size);
                _new_critter.nickname = _data.animal_name; _new_critter.gender = irandom(1); recalculate_stats(_new_critter);
                array_push(global.PlayerData.pc_box, _new_critter); global.PlayerData.collection_progress[$ _key] = 0;
            }
        }
        break;
        
    case BATTLE_STATE.WIN_DOWNLOAD_COMPLETE: break;

    case BATTLE_STATE.WIN_END:
        battle_log_text = "You won the battle! Click to continue.";
        if (mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_enter)) {
            if (is_casual == false) { global.PlayerData.team[0] = player_critter_data;
                global.PlayerData.current_opponent_index++; } 
            else { global.PlayerData.team[0] = player_critter_data;
            }
            instance_destroy(player_actor); instance_destroy(enemy_actor); instance_destroy();
        }
        break;

    case BATTLE_STATE.LOSE:
        battle_log_text = "You lost the battle... Click to continue.";
        if (is_casual == false && !global.bargain_offered) {
            if (current_opponent_data.name == "BronzeMod") { global.bargain_offered = true;
                array_push(global.unread_messages, { from: "???", message: "...you cannot win." }); }
        }
        if (mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_enter)) {
            global.PlayerData.team[0] = player_critter_data;
            instance_destroy(player_actor); instance_destroy(enemy_actor); instance_destroy();
        }
        break;

    case BATTLE_STATE.PLAYER_POST_TURN_DAMAGE:
        battle_log_text = player_critter_data.nickname + " is damaged by the corruption!";
        var _passive_dmg = floor(player_critter_data.max_hp * 0.1); player_critter_data.hp = max(0, player_critter_data.hp - _passive_dmg);
        effect_play_hurt(player_actor); alarm[0] = 90; current_state = BATTLE_STATE.ENEMY_TURN; break;

    case BATTLE_STATE.ENEMY_POST_TURN_DAMAGE:
        battle_log_text = enemy_critter_data.nickname + " is damaged by the corruption!";
        var _passive_dmg = floor(enemy_critter_data.max_hp * 0.1); enemy_critter_data.hp = max(0, enemy_critter_data.hp - _passive_dmg);
        effect_play_hurt(enemy_actor); alarm[0] = 90; current_state = BATTLE_STATE.PLAYER_TURN; break;
        
    // === HP DRAIN STATE ===
    case BATTLE_STATE.WAIT_FOR_HP_DRAIN:
        var _p_diff = abs(player_visual_hp - player_critter_data.hp);
        var _e_diff = abs(enemy_visual_hp - enemy_critter_data.hp);
        
        var _p_speed = max(0.2, _p_diff / 15); // Slower drain
        var _e_speed = max(0.2, _e_diff / 15);
        
        if (player_visual_hp > player_critter_data.hp) player_visual_hp = max(player_critter_data.hp, player_visual_hp - _p_speed);
        else if (player_visual_hp < player_critter_data.hp) player_visual_hp = min(player_critter_data.hp, player_visual_hp + _p_speed);
        
        if (enemy_visual_hp > enemy_critter_data.hp) enemy_visual_hp = max(enemy_critter_data.hp, enemy_visual_hp - _e_speed);
        else if (enemy_visual_hp < enemy_critter_data.hp) enemy_visual_hp = min(enemy_critter_data.hp, enemy_visual_hp + _e_speed);
        
        if (abs(player_visual_hp - player_critter_data.hp) < 0.5 && abs(enemy_visual_hp - enemy_critter_data.hp) < 0.5) {
            player_visual_hp = player_critter_data.hp;
            enemy_visual_hp = enemy_critter_data.hp;
            current_state = next_state_after_drain;
            alarm[0] = 120;
        }
        break;
}
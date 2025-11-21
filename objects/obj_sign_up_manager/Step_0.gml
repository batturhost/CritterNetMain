// --- Step Event ---
// This handles all player input (Keyboard AND Mouse) every frame

// Increment the animation frame manually
var _sprite = starter_critter_sprites[starter_selection];
animation_frame = (animation_frame + animation_speed) % sprite_get_number(_sprite);

// Update the blinking cursor timer (loops 0-59)
cursor_blink = (cursor_blink + 1) % 60;

// --- 1. Get All Inputs Once ---
var _key_enter = keyboard_check_pressed(vk_enter);
var _up = keyboard_check_pressed(vk_up);
var _down = keyboard_check_pressed(vk_down);
var _left = keyboard_check_pressed(vk_left);
var _right = keyboard_check_pressed(vk_right);

var _mx = mouse_x; // Get mouse X position
var _my = mouse_y; // Get mouse Y position

// --- 2. Handle Mouse Clicks ---
if (mouse_check_button_pressed(mb_left)) {
    
    if (point_in_box(_mx, _my, btn_name_x1, btn_name_y1, btn_name_x2, btn_name_y2)) {
        current_focus = 0; // Focus Name
    }
    else if (point_in_box(_mx, _my, btn_gender_x1, btn_gender_y1, btn_gender_x2, btn_gender_y2)) {
        current_focus = 1; // Focus Gender
        gender_selection = 0; // Select Male
    }
    else if (point_in_box(_mx, _my, btn_gender_x3, btn_gender_y3, btn_gender_x4, btn_gender_y4)) {
        current_focus = 1; // Focus Gender
        gender_selection = 1; // Select Female
    }
    else if (point_in_box(_mx, _my, btn_starter_1_x1, btn_starter_1_y1, btn_starter_1_x2, btn_starter_1_y2)) {
        current_focus = 2; // Focus Starter 1
        starter_selection = 0;
    }
    else if (point_in_box(_mx, _my, btn_starter_2_x1, btn_starter_2_y1, btn_starter_2_x2, btn_starter_2_y2)) {
        current_focus = 3; // Focus Starter 2
        starter_selection = 1;
    }
    else if (point_in_box(_mx, _my, btn_starter_3_x1, btn_starter_3_y1, btn_starter_3_x2, btn_starter_3_y2)) {
        current_focus = 4; // Focus Starter 3
        starter_selection = 2;
    }
    else if (point_in_box(_mx, _my, btn_submit_x1, btn_submit_y1, btn_submit_x2, btn_submit_y2)) {
        current_focus = 5; // Focus Submit
        _key_enter = true; // Pretend we also hit Enter
    }
}

// --- 3. Handle Keyboard Navigation ---
if (_up) { current_focus = max(0, current_focus - 1); }
if (_down) { current_focus = min(5, current_focus + 1); } 

// --- 4. Handle Keyboard Input (based on what's focused) ---
switch (current_focus) {
    
    case 0: // --- NAME ---
        var _char = keyboard_lastchar; 
        if (_char != "") { 
            if (string_length(player_name) < max_name_length) {
                player_name += _char;
            }
            keyboard_lastchar = ""; 
        }
        if (keyboard_check_pressed(vk_backspace)) {
            player_name = string_delete(player_name, string_length(player_name), 1);
        }
        break;
    
    case 1: // --- GENDER ---
        if (_left) { gender_selection = 0; }
        if (_right) { gender_selection = 1; }
        break;
        
    case 2: // Focused on Fox
        starter_selection = 0;
        if (_right) { current_focus = 3; } // Go to Capy
        break;
        
    case 3: // Focused on Capy
        starter_selection = 1;
        if (_left) { current_focus = 2; } // Go to Fox
        if (_right) { current_focus = 4; } // Go to Goose
        break;
        
    case 4: // Focused on Goose
        starter_selection = 2;
        if (_left) { current_focus = 3; } // Go to Capy
        break;
        
    case 5: // --- SUBMIT ---
        if (_key_enter) {
            if (string_length(player_name) == 0) { player_name = "User98"; }
            
            global.PlayerData = {
                name: player_name,
                gender: gender_selection,
                profile_pic: spr_1, 
                current_cup_index: 0,
                current_opponent_index: 0,
                team: [], 
                pc_box: [],
                collection_progress: {}, // <-- THIS IS THE NEW LINE
                starter_key: starter_critter_keys[starter_selection],
                starter_name: starter_critter_names[starter_selection]
            };
            
            // (The 5 test critters are still added here)
            var _all_keys = variable_struct_get_names(global.bestiary);
            for (var i = 0; i < 5; i++) {
                var _random_key = _all_keys[irandom(array_length(_all_keys) - 1)];
                var _data = global.bestiary[$ _random_key];
                var _level = irandom_range(3, 7);
                var _critter = new AnimalData(
                    _data.animal_name, _data.base_hp, _data.base_atk, _data.base_def, _data.base_spd,
                    _level, _data.sprite_idle, _data.sprite_idle_back, _data.sprite_signature_move,
                    _data.moves, _data.blurb, _data.size
                );
                _critter.nickname = _data.animal_name;
                _critter.gender = irandom(1);
                recalculate_stats(_critter);
                array_push(global.PlayerData.pc_box, _critter);
            }
            
            room_goto(rm_critter_confirm); 
        }
        break;
}
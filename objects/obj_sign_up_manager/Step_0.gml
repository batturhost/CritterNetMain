// --- Step Event ---

// 1. Track previous selection (To reset animation if we switch)
var _old_selection = starter_selection;

// 2. Handle Interactions (Mouse & Sound via helper)
if (check_button_click(btn_name_x1, btn_name_y1, btn_name_x2, btn_name_y2)) {
    current_focus = 0;
}
else if (check_button_click(btn_gender_x1, btn_gender_y1, btn_gender_x2, btn_gender_y2)) {
    current_focus = 1;
    gender_selection = 0;
}
else if (check_button_click(btn_gender_x3, btn_gender_y3, btn_gender_x4, btn_gender_y4)) {
    current_focus = 1;
    gender_selection = 1;
}
else if (check_button_click(btn_starter_1_x1, btn_starter_1_y1, btn_starter_1_x2, btn_starter_1_y2)) {
    current_focus = 2;
    starter_selection = 0;
}
else if (check_button_click(btn_starter_2_x1, btn_starter_2_y1, btn_starter_2_x2, btn_starter_2_y2)) {
    current_focus = 3;
    starter_selection = 1;
}
else if (check_button_click(btn_starter_3_x1, btn_starter_3_y1, btn_starter_3_x2, btn_starter_3_y2)) {
    current_focus = 4;
    starter_selection = 2;
}
else if (check_button_click(btn_submit_x1, btn_submit_y1, btn_submit_x2, btn_submit_y2)) {
    current_focus = 5;
    // Simulate Enter key for submission logic below
    keyboard_key_press(vk_enter); 
    keyboard_key_release(vk_enter);
}

// 3. Keyboard Navigation
var _up = keyboard_check_pressed(vk_up);
var _down = keyboard_check_pressed(vk_down);
var _left = keyboard_check_pressed(vk_left);
var _right = keyboard_check_pressed(vk_right);
var _key_enter = keyboard_check_pressed(vk_enter);

if (_up) current_focus = max(0, current_focus - 1);
if (_down) current_focus = min(5, current_focus + 1); 

// 4. Animation Logic (The Fix)
// If selection changed, reset frame to 0. Otherwise, animate.
if (starter_selection != _old_selection) {
    animation_frame = 0;
} else {
    var _sprite = starter_critter_sprites[starter_selection];
    animation_frame = (animation_frame + animation_speed) % sprite_get_number(_sprite);
}

// Cursor Blink
cursor_blink = (cursor_blink + 1) % 60;

// 5. Logic per Focus State
switch (current_focus) {
    case 0: // Name
        var _char = keyboard_lastchar;
        if (_char != "") { 
            if (string_length(player_name) < max_name_length && ord(_char) >= 32) {
                player_name += _char;
            }
            keyboard_lastchar = "";
        }
        if (keyboard_check_pressed(vk_backspace)) {
            player_name = string_delete(player_name, string_length(player_name), 1);
        }
        break;
    
    case 1: // Gender
        if (_left) gender_selection = 0;
        if (_right) gender_selection = 1;
        break;
        
    case 2: // Fox
        starter_selection = 0;
        if (_right) current_focus = 3;
        break;
    case 3: // Capy
        starter_selection = 1;
        if (_left) current_focus = 2;
        if (_right) current_focus = 4;
        break;
    case 4: // Goose
        starter_selection = 2;
        if (_left) current_focus = 3;
        break;
        
    case 5: // Submit
        if (_key_enter) {
            if (string_length(player_name) == 0) player_name = "User98";
            
            // Setup Global Data
            global.PlayerData = {
                name: player_name,
                gender: gender_selection,
                profile_pic: spr_1, 
                current_cup_index: 0,
                current_opponent_index: 0,
                team: [], 
                pc_box: [],
                collection_progress: {},
                starter_key: starter_critter_keys[starter_selection],
                starter_name: starter_critter_names[starter_selection],
                coins: 0, // Initialize coins
                inventory: [] // Initialize inventory
            };
            
            // Add 5 random test critters to PC
            if (variable_global_exists("bestiary")) {
                var _all_keys = variable_struct_get_names(global.bestiary);
                for (var i = 0; i < 5; i++) {
                    var _random_key = _all_keys[irandom(array_length(_all_keys) - 1)];
                    var _data = global.bestiary[$ _random_key];
                    
                    // Create Critter Data (Updated with correct arguments)
                    var _critter = new AnimalData(
                        _data.animal_name, _data.base_hp, _data.base_atk, _data.base_def, _data.base_spd,
                        irandom_range(3, 7), _data.sprite_idle, _data.sprite_idle_back, _data.sprite_signature_move,
                        _data.moves, _data.blurb, _data.size, _data.element_type
                    );
                    _critter.nickname = _data.animal_name;
                    _critter.gender = irandom(1);
                    recalculate_stats(_critter);
                    array_push(global.PlayerData.pc_box, _critter);
                }
            }
            
            room_goto(rm_critter_confirm);
        }
        break;
}
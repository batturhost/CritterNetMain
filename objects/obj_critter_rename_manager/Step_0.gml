// --- Step Event ---

// Animate the sprite
animation_frame = (animation_frame + animation_speed) % sprite_get_number(sprite);

// Update the blinking cursor timer
cursor_blink = (cursor_blink + 1) % 60;

// --- 1. Get Inputs ---
var _key_enter = keyboard_check_pressed(vk_enter);
var _mx = mouse_x;
var _my = mouse_y;

// --- 2. Handle Text Input ---
var _char = keyboard_lastchar; 
if (_char != "") { 
    if (string_length(nickname) < max_name_length) {
        nickname += _char;
    }
    keyboard_lastchar = ""; 
}
if (keyboard_check_pressed(vk_backspace)) {
    nickname = string_delete(nickname, string_length(nickname), 1);
}

// --- 3. Handle Submit ---
if (_key_enter || mouse_check_button_pressed(mb_left)) {
	play_ui_click(); 
    // We are now calling the GLOBAL 'point_in_box' function
    if (point_in_box(_mx, _my, btn_ok_x1, btn_ok_y1, btn_ok_x2, btn_ok_y2) || _key_enter)
    {
        // Save the chosen nickname
        if (string_length(nickname) == 0) {
            nickname = species_name; // Default back to species name if empty
        }
        global.PlayerData.starter_nickname = nickname;

        // ================== ADD STARTER TO TEAM (FIXED) ==================
        
        // 1. Create the starter critter's data
        var _starter_key = global.PlayerData.starter_key;
        var _data = global.bestiary[$ _starter_key];
        var _level = 5;

        // [FIX] Added _data.element_type as the final argument
        var _starter_critter = new AnimalData(
            _data.animal_name,
            _data.base_hp, _data.base_atk, _data.base_def, _data.base_spd,
            _level,
            _data.sprite_idle, _data.sprite_idle_back, _data.sprite_signature_move,
            _data.moves, _data.blurb, _data.size,
            _data.element_type 
        );

        // 2. Set its nickname, gender, and calculate stats
        _starter_critter.nickname = nickname;
        _starter_critter.gender = critter_gender; 
        recalculate_stats(_starter_critter); // This also sets its HP to max
        
        // 3. Add this new critter to the player's team
        array_push(global.PlayerData.team, _starter_critter);
        // ================== END OF NEW CODE ========================
        
        // Go to Profile Selection
        room_goto(rm_profile_select);
    }
}
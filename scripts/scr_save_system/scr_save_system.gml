function save_game() {
    // 1. Safety Check
    if (global.ENABLE_SAVE_SYSTEM == false) {
        show_debug_message("Save System Disabled: Game NOT saved.");
        return false;
    }

    // 2. Wrap all persistent data into one struct
    var _save_data = {
        player_data: global.PlayerData,
        trapdoor_unlocked: variable_global_exists("trapdoor_unlocked") ? global.trapdoor_unlocked : false,
        bargain_offered: variable_global_exists("bargain_offered") ? global.bargain_offered : false,
        tutorial_complete: variable_global_exists("tutorial_complete") ? global.tutorial_complete : false,
        unread_messages: variable_global_exists("unread_messages") ? global.unread_messages : []
    };
    
    // 3. Convert to JSON String & Save
    var _string = json_stringify(_save_data);
    var _filename = "cnet_save.json";
    var _buffer = buffer_create(string_byte_length(_string) + 1, buffer_fixed, 1);
    buffer_write(_buffer, buffer_string, _string);
    buffer_save(_buffer, _filename);
    buffer_delete(_buffer);
    
    show_debug_message("Game Saved Successfully!");
    return true;
}

function load_game() {
    // 1. Safety Check
    if (global.ENABLE_SAVE_SYSTEM == false) {
        return false; // Pretend save doesn't exist
    }

    var _filename = "cnet_save.json";
    
    if (file_exists(_filename)) {
        try {
            var _buffer = buffer_load(_filename);
            var _string = buffer_read(_buffer, buffer_string);
            buffer_delete(_buffer);
            
            var _load_data = json_parse(_string);
            
            // Apply Data
            global.PlayerData = _load_data.player_data;
            
            if (variable_struct_exists(_load_data, "trapdoor_unlocked")) global.trapdoor_unlocked = _load_data.trapdoor_unlocked;
            if (variable_struct_exists(_load_data, "bargain_offered")) global.bargain_offered = _load_data.bargain_offered;
            if (variable_struct_exists(_load_data, "tutorial_complete")) global.tutorial_complete = _load_data.tutorial_complete;
            if (variable_struct_exists(_load_data, "unread_messages")) global.unread_messages = _load_data.unread_messages;
            
            show_debug_message("Game Loaded Successfully!");
            return true;
        } catch(_e) {
            show_debug_message("Save file corrupted: " + string(_e));
            return false;
        }
    }
    
    return false;
}
// --- Step Event ---

// We only want the buttons to work after the text is finished
if (current_line < array_length(text_lines)) {
    btn_hovering = false;
    btn_continue_hovering = false;
    exit;
}

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

// Check for button hover (DEBUG)
btn_hovering = point_in_box(_mx, _my, btn_x1, btn_y1, btn_x2, btn_y2);

// Check for button hover (CONTINUE)
btn_continue_hovering = point_in_box(_mx, _my, btn_continue_x1, btn_continue_y1, btn_continue_x2, btn_continue_y2);

// Check for button click (DEBUG)
if (btn_hovering && mouse_check_button_pressed(mb_left)) {
    room_goto(rm_hub);
}

// Check for button click (CONTINUE)
if (btn_continue_hovering && mouse_check_button_pressed(mb_left)) {
    
    var _loaded = false;
    
    // Only try to load if the system is enabled
    if (global.ENABLE_SAVE_SYSTEM) {
        _loaded = load_game();
    }
    
    if (_loaded) {
        // Save found & System Enabled -> Go to Hub
        room_goto(rm_hub);
    } else {
        // System Disabled OR No Save -> Go to Installer
        room_goto(rm_installer_start);
    }
}

// --- NEW: SPACEBAR SHORTCUT (FIXED) ---
if (keyboard_check_pressed(vk_space)) {
    // 1. Set a global flag telling the Hub to open the debugger
    global.open_debug_battle = true;
    
    // 2. Go to the hub
    room_goto(rm_hub);
}
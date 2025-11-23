/// @function play_ui_click()
/// @desc Plays the standard UI click sound.
function play_ui_click() {
    // You can change the sound ID or settings here in one place!
    audio_play_sound(snd_ui_click, 10, false);
}

/// @function check_button_click(_x1, _y1, _x2, _y2)
/// @desc Checks if the mouse clicked inside a specific box. If yes, PLAYS SOUND and returns true.
function check_button_click(_x1, _y1, _x2, _y2) {
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    
    // Check hover
    if (point_in_rectangle(_mx, _my, _x1, _y1, _x2, _y2)) {
        // Check click
        if (mouse_check_button_pressed(mb_left)) {
            play_ui_click(); // <--- Auto-play sound
            return true;
        }
    }
    return false;
}
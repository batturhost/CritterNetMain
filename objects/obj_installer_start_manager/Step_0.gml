// --- Step Event ---

// 1. Update Blink Timer
blink_timer = (blink_timer + 1) % 60;

// 2. Count down the delay
if (start_delay > 0) {
    start_delay--;
} 
else {
    // 3. Check for Enter Key (Instead of Click)
    if (keyboard_check_pressed(vk_enter)) {
		audio_play_sound(snd_ui_enter, 10, false);
        room_goto(rm_sign_up);
    }
}
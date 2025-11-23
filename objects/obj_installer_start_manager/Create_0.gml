// --- Create Event ---

// Blinking text timer
blink_timer = 0;

// Full screen layout
gui_w = display_get_gui_width();
gui_h = display_get_gui_height();

// Input delay (Set to 0 as requested)
start_delay = 0;
audio_play_sound(snd_ui_chime, 10, false);
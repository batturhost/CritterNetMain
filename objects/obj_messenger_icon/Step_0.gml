// --- Step Event ---
hovering = position_meeting(mouse_x, mouse_y, id);

// This object is controlled by obj_hub_manager
// But we can update its own blink timer
if (is_blinking) {
    blink_timer = (blink_timer + 1) % 60; // Loop the timer
}
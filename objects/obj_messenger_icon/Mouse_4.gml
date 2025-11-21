// --- Left Pressed Event ---

// This opens the messenger window
if (!instance_exists(obj_messenger_manager)) {
    instance_create_layer(0, 0, "Instances", obj_messenger_manager);
    
    // Stop blinking once we've opened it
    is_blinking = false; 
    blink_timer = 0;
}
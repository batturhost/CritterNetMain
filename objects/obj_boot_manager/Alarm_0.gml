// --- Alarm 0 Event ---
current_line++;

if (current_line < array_length(text_lines)) {
    alarm[0] = text_speed; 
} else {
    // alarm[1] = text_speed; // <-- REMOVED
    // We no longer automatically go to the next room.
    // The user must click a button.
}
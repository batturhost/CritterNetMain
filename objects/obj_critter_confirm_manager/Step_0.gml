// --- Step Event ---

// Animate the critter sprite (for the "complete" screen)
var _num_frames = sprite_get_number(sprite);
if (_num_frames > 1) {
    animation_frame = (animation_frame + animation_speed) % _num_frames;
}

// Get mouse inputs
var _mx = mouse_x;
var _my = mouse_y;
var _click = mouse_check_button_pressed(mb_left);

// --- State Machine Logic ---
switch (download_state) {
    
    case "downloading":
        // Increment the progress bar
        if (download_progress < 100) {
            download_progress += 0.5; // Controls download speed
        } else {
            // --- THIS BLOCK RUNS ONLY ONCE ---
            download_progress = 100;
            download_state = "complete"; 
            
            audio_play_sound(snd_ui_download, 10, false); 
        }
        break;
        
    case "complete":
        btn_submit_hover = point_in_box(_mx, _my, btn_submit_x1, btn_submit_y1, btn_submit_x2, btn_submit_y2);
        
        if (_click && btn_submit_hover) {
            play_ui_click();
            room_goto(rm_critter_rename);
        }
        break;
}
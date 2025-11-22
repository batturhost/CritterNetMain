// --- Step Event ---

// 1. INHERIT PARENT (Handles window dragging and close button)
event_inherited();

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _click = mouse_check_button_pressed(mb_left);
var _held = mouse_check_button(mb_left);
var _release = mouse_check_button_released(mb_left);

// --- PASTE THIS FIX HERE ---
// [FIX] DEPTH CHECK: Is there a window ON TOP of us?
var _is_covered = false;
with (obj_window_parent) {
    if (id != other.id && visible && depth < other.depth) {
        if (point_in_rectangle(_mx, _my, window_x1, window_y1, window_x2, window_y2)) {
            _is_covered = true;
            break;
        }
    }
}
if (_is_covered) {
    _click = false;
    _held = false;    // Also disable holding/releasing for the PC manager
    _release = false; // to prevent accidental drag-drops
}

// [FIX] BATTLE LOCK: Disable input if battle is active
if (instance_exists(obj_battle_manager)) {
    _click = false;
    _held = false;
    _release = false;
    is_renaming = false; // Cancel renaming if active
    held_critter_index = -1; // Drop any held critter
}

// --- 2. Update Timers ---
if (feedback_message_timer > 0) {
    feedback_message_timer--;
}
if (preview_critter != noone) {
    var _sprite = preview_critter.sprite_idle;
    var _num_frames = sprite_get_number(_sprite);
    if (_num_frames > 1) {
        preview_anim_frame = (preview_anim_frame + preview_anim_speed) % _num_frames;
    }
}

// Update PC Box Animation
pc_anim_frame += pc_anim_speed;


// ================== NEW: RENAMING LOGIC ==================
// Calculate Text Area Bounds (Must match Draw Event)
var _mid_x = window_x1 + (window_width / 2);
var _text_y = window_y1 + 80 + 100 + 15; // panel_y + frame_h + padding
var _text_w = 120; // Approximate clickable width
var _text_h = 20;

name_area_hover = false;
if (preview_critter != noone) {
    if (point_in_rectangle(_mx, _my, _mid_x - (_text_w/2), _text_y, _mid_x + (_text_w/2), _text_y + _text_h)) {
        name_area_hover = true;
    }
}

// 1. Click to Start Renaming
// We check !is_dragging to ensure we aren't dragging the window
if (_click && name_area_hover && !is_renaming && preview_critter != noone && !is_dragging) {
    is_renaming = true;
    rename_input = preview_critter.nickname;
    keyboard_lastchar = "";
}

// 2. Handle Renaming Input
if (is_renaming) {
    cursor_timer++;
    
    // Confirm (Enter) or Click Outside
    // We check !name_area_hover to see if they clicked away
    if (keyboard_check_pressed(vk_enter) || (_click && !name_area_hover)) {
        if (rename_input != "") {
            preview_critter.nickname = rename_input;
        }
        is_renaming = false;
    }
    // Cancel (Escape)
    else if (keyboard_check_pressed(vk_escape)) {
        is_renaming = false;
    }
    // Typing
    else {
        var _char = keyboard_lastchar;
        if (_char != "") {
            if (string_length(rename_input) < max_name_length) {
                // Allow alphanumeric and space (ASCII 32+)
                if (ord(_char) >= 32) rename_input += _char;
            }
            keyboard_lastchar = "";
        }
        if (keyboard_check_pressed(vk_backspace)) {
            rename_input = string_delete(rename_input, string_length(rename_input), 1);
        }
    }
}
// =========================================================


// --- 3. Button Hover Logic ---
// (Note: Parent handles btn_close_hover, we only handle internal buttons)
btn_to_team_hover = point_in_box(_mx, _my, btn_to_team_x1, btn_to_team_y1, btn_to_team_x2, btn_to_team_y2);
btn_to_pc_hover = point_in_box(_mx, _my, btn_to_pc_x1, btn_to_pc_y1, btn_to_pc_x2, btn_to_pc_y2);

// --- 4. CRITTER DRAG & DROP LOGIC ---
var _is_in_team_list = point_in_box(_mx, _my, team_list_x1, team_list_y1, team_list_x2, team_list_y2);

// 4a. CLICK: Start Holding
if (_click && !is_dragging && _is_in_team_list && feedback_message_timer <= 0) {
    var _click_index = floor((_my - team_list_y1) / team_item_height) + team_top_index;
    if (_click_index < array_length(global.PlayerData.team)) {
        held_critter_index = _click_index;
        drag_start_y = _my;
        is_dragging_critter = false; 
    }
}

// 4b. HOLD: Detect Drag Threshold
if (_held && held_critter_index != -1 && !is_dragging_critter) {
    if (abs(_my - drag_start_y) > 5) {
        is_dragging_critter = true;
        drag_critter_data = global.PlayerData.team[held_critter_index];
        drag_y_offset = (_my - (team_list_y1 + 2 + ((held_critter_index - team_top_index) * team_item_height)));
        
        // Clear selections & stop renaming
        team_selected_index = -1;
        pc_selected_index = -1;
        preview_critter = noone;
        is_renaming = false; // <--- RESET
    }
}

// 4c. RELEASE: Drop OR Select
if (_release) {
    if (is_dragging_critter) {
        // DROP
        if (_is_in_team_list) {
            var _critter_to_move = drag_critter_data;
            array_delete(global.PlayerData.team, held_critter_index, 1);
            var _drop_index = floor((_my - team_list_y1) / team_item_height) + team_top_index;
            _drop_index = clamp(_drop_index, 0, array_length(global.PlayerData.team));
            array_insert(global.PlayerData.team, _drop_index, _critter_to_move);
        }
    } 
    else if (held_critter_index != -1) {
        // SELECT (Click without drag)
        team_selected_index = held_critter_index;
        pc_selected_index = -1;
        preview_critter = global.PlayerData.team[held_critter_index];
        preview_anim_frame = 0;
        is_renaming = false; // <--- RESET
    }
    
    // Reset
    held_critter_index = -1;
    drag_critter_data = noone;
    is_dragging_critter = false;
    drop_indicator_y = -1;
}

// 4d. Update Drop Indicator
if (is_dragging_critter) {
    if (_is_in_team_list) {
        var _relative_y = _my - team_list_y1;
        var _hover_index = floor(_relative_y / team_item_height) + team_top_index;
        var _hover_y = team_list_y1 + 2 + ((_hover_index - team_top_index) * team_item_height);
        if (_my > _hover_y + (team_item_height / 2)) _hover_index++;
        _hover_index = clamp(_hover_index, 0, array_length(global.PlayerData.team));
        drop_indicator_y = team_list_y1 + 2 + ((_hover_index - team_top_index) * team_item_height);
    } else {
        drop_indicator_y = -1;
    }
} else {
    drop_indicator_y = -1;
}


// --- 5. Normal Click Logic (PC Box & Buttons) ---
if (_click) {
    // Close button handled by parent
    if (feedback_message_timer > 0) {
        feedback_message_timer = 0;
    }
    else if (!is_dragging && held_critter_index == -1 && !is_renaming) { // Don't process buttons if renaming 
        
        // Click in PC List
        if (point_in_box(_mx, _my, pc_list_x1, pc_list_y1, pc_list_x2, pc_list_y2)) {
            var _mx_rel = _mx - (pc_list_x1 + pc_grid_padding);
            var _my_rel = _my - (pc_list_y1 + pc_grid_padding);
            
            var _col = floor(_mx_rel / (pc_grid_cell_size + pc_grid_padding));
            var _row = floor(_my_rel / (pc_grid_cell_size + pc_grid_padding)) + pc_scroll_top;
            
            if (_col >= 0 && _col < pc_grid_cols) {
                var _click_index = (_row * pc_grid_cols) + _col;
                if (_click_index < array_length(global.PlayerData.pc_box)) {
                    pc_selected_index = _click_index;
                    team_selected_index = -1;
                    preview_critter = global.PlayerData.pc_box[_click_index];
                    preview_anim_frame = 0;
                    is_renaming = false; // <--- RESET
                }
            }
        }
        
        // Click [Add to Team]
        if (btn_to_team_hover && pc_selected_index != -1) {
            if (array_length(global.PlayerData.team) < 6) {
                var _critter = global.PlayerData.pc_box[pc_selected_index];
                array_delete(global.PlayerData.pc_box, pc_selected_index, 1);
                array_push(global.PlayerData.team, _critter);
                pc_selected_index = -1;
                preview_critter = noone;
                is_renaming = false; // <--- RESET
            } else {
                feedback_message = "Your team is full! (Max 6)";
                feedback_message_timer = 120;
            }
        }
        
        // Click [Remove from Team]
        if (btn_to_pc_hover && team_selected_index != -1) {
            if (array_length(global.PlayerData.team) > 1) {
                var _critter = global.PlayerData.team[team_selected_index];
                array_delete(global.PlayerData.team, team_selected_index, 1);
                array_push(global.PlayerData.pc_box, _critter);
                team_selected_index = -1;
                preview_critter = noone;
                is_renaming = false; // <--- RESET
            } else {
                feedback_message = "You must have at least one critter in your team!";
                feedback_message_timer = 120;
            }
        }
    }
}

// --- 6. Scrolling Logic ---
var _scroll = mouse_wheel_down() - mouse_wheel_up();
if (_scroll != 0 && feedback_message_timer <= 0 && !is_dragging_critter) {
    if (_is_in_team_list) {
        var _max_scroll = max(0, array_length(global.PlayerData.team) - floor(team_list_h / team_item_height));
        team_top_index = clamp(team_top_index + _scroll, 0, _max_scroll);
    }
    if (point_in_box(_mx, _my, pc_list_x1, pc_list_y1, pc_list_x2, pc_list_y2)) {
        var _total_rows = ceil(array_length(global.PlayerData.pc_box) / pc_grid_cols);
        var _visible_rows = floor(pc_list_h / (pc_grid_cell_size + pc_grid_padding));
        var _max_scroll = max(0, _total_rows - _visible_rows);
        pc_scroll_top = clamp(pc_scroll_top + _scroll, 0, _max_scroll);
    }
}

// --- 7. RECALCULATE UI POSITIONS (Follow the Window) ---
team_list_x1 = window_x1 + 20;
team_list_y1 = window_y1 + 80;
team_list_x2 = team_list_x1 + team_list_w;
team_list_y2 = team_list_y1 + team_list_h;

pc_list_x1 = window_x1 + window_width - 250 - 20;
pc_list_y1 = window_y1 + 80;
pc_list_x2 = pc_list_x1 + pc_list_w;
pc_list_y2 = pc_list_y1 + pc_list_h;

var _mid_x = window_x1 + (window_width / 2);
btn_to_team_x1 = _mid_x - (btn_w / 2);
btn_to_team_y1 = window_y1 + 350;
btn_to_team_x2 = btn_to_team_x1 + btn_w;
btn_to_team_y2 = btn_to_team_y1 + btn_h;

btn_to_pc_x1 = _mid_x - (btn_w / 2);
btn_to_pc_y1 = btn_to_team_y2 + 10;
btn_to_pc_x2 = btn_to_pc_x1 + btn_w;
btn_to_pc_y2 = btn_to_pc_y1 + btn_h;
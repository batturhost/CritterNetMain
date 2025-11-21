// --- Step Event ---

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _click = mouse_check_button_pressed(mb_left);

// --- 1. Update Icons (Messenger/Trapdoor) ---
if (instance_exists(obj_messenger_icon)) {
    if (array_length(global.unread_messages) > 0) {
        if (!obj_messenger_icon.visible || !obj_messenger_icon.is_blinking) {
            obj_messenger_icon.visible = true;
            obj_messenger_icon.is_blinking = true;
        }
    }
}

if (instance_exists(obj_trapdoor_icon)) {
    if (global.trapdoor_unlocked && !obj_trapdoor_icon.visible) {
        obj_trapdoor_icon.visible = true;
    }
}


// ================== START MENU & TASKBAR LOGIC ==================

// 1. Define Button Area (for click detection)
var _gui_h = display_get_gui_height();
var _btn_x1 = 4;
var _btn_y1 = _gui_h - 28; 
var _btn_x2 = _btn_x1 + 80;
var _btn_y2 = _gui_h - 4;
var _start_clicked = point_in_box(_mx, _my, _btn_x1, _btn_y1, _btn_x2, _btn_y2) && _click;

// --- 2. TASKBAR BUTTON LOGIC (BRING TO FRONT & RESTORE) ---
if (_click && !start_menu_open) {
    var _task_x = _btn_x2 + 10;
    var _task_w = 120;
    var _task_h = 24;
    var _task_y = _btn_y1; 

    for (var i = 0; i < array_length(applications_list); i++) {
        var _obj = applications_list[i][0];
        
        if (instance_exists(_obj)) {
            if (point_in_box(_mx, _my, _task_x, _task_y, _task_x + _task_w, _task_y + _task_h)) {
                // HIT! 
                with (_obj) {
                    // --- NEW LOGIC: RESTORE IF MINIMIZED ---
                    if (variable_instance_exists(id, "is_minimized") && is_minimized) {
                        anim_state = 4; // RESTORE Animation
                        anim_timer = 0;
                        // Set task_target to this button's position for cool effect
                        task_target_x = _task_x;
                        task_target_y = _task_y;
                    }
                    // ---------------------------------------
                    
                    global.top_window_depth -= 1; 
                    depth = global.top_window_depth; 
                }
            }
            _task_x += _task_w + 4;
        }
    }
}

// 3. Define Menu Area
var _menu_x1 = 2;
var _menu_y2 = _gui_h - 32; 
var _menu_y1 = _menu_y2 - menu_h;
var _menu_x2 = _menu_x1 + menu_w;

// 4. Handle Logic
if (_start_clicked) {
    // Toggle menu
    start_menu_open = !start_menu_open;
} 
else if (start_menu_open) {
    
    // Check Hover
    start_hover_index = -1;
    
    var _list_x1 = _menu_x1 + 30; 
    if (point_in_box(_mx, _my, _list_x1, _menu_y1, _menu_x2, _menu_y2)) {
        var _list_start_y = _menu_y1 + 10;
        var _mouse_rel_y = _my - _list_start_y;
        
        if (_mouse_rel_y >= 0) {
            var _idx = floor(_mouse_rel_y / menu_item_h);
            if (_idx < array_length(menu_items)) {
                start_hover_index = _idx;
            }
        }
    }
    
    // Handle Clicks inside Menu
    if (_click) {
        if (start_hover_index != -1) {
            // CLICKED AN ITEM!
            var _action = menu_items[start_hover_index][1];
            
            switch (_action) {
                case "browser":
                    if (!instance_exists(obj_browser_manager)) instance_create_layer(0, 0, "Instances", obj_browser_manager);
                    else with(obj_browser_manager) { global.top_window_depth--; depth = global.top_window_depth; }
                    break;
                case "pokedex":
                    if (!instance_exists(obj_pokedex_manager)) instance_create_layer(0, 0, "Instances", obj_pokedex_manager);
                    else with(obj_pokedex_manager) { global.top_window_depth--; depth = global.top_window_depth; }
                    break;
                case "pc":
                    if (!instance_exists(obj_pc_manager)) instance_create_layer(0, 0, "Instances", obj_pc_manager);
                    else with(obj_pc_manager) { global.top_window_depth--; depth = global.top_window_depth; }
                    break;
                case "messenger":
                    if (!instance_exists(obj_messenger_manager)) instance_create_layer(0, 0, "Instances", obj_messenger_manager);
                    else with(obj_messenger_manager) { global.top_window_depth--; depth = global.top_window_depth; }
                    if (instance_exists(obj_messenger_icon)) { obj_messenger_icon.is_blinking = false; obj_messenger_icon.blink_timer = 0; }
                    break;
			    case "save":
                    save_game();
                    // Optional: You could play a sound or show a popup here
                    start_menu_open = false;
                    break;
                case "shutdown":
                    game_end();
                    break;
            }
            start_menu_open = false; // Close after click
        } 
        else {
            // Clicked outside menu (and not on start button) -> Close
            start_menu_open = false;
        }
    }
}
// --- Create Event ---

// 1. INHERIT PARENT
event_inherited();

// 2. Window Properties
window_width = 650;
window_height = 500;
window_title = "CNet Messenger - " + global.PlayerData.name;

// Custom XP Style colors
col_title_bar_active = make_color_rgb(0, 80, 180); // XP Dark Blue
col_bg = make_color_rgb(235, 240, 250); // XP Light Blue BG
use_scanlines = false; // XP style usually is clean

// Recalculate Position
window_x1 = (display_get_gui_width() / 2) - (window_width / 2);
window_y1 = (display_get_gui_height() / 2) - (window_height / 2);
window_x2 = window_x1 + window_width;
window_y2 = window_y1 + window_height;

// 3. Internal Layout
toolbar_y1 = window_y1 + 32; 
toolbar_h = 25;

buddy_list_x = window_x1 + 10;
buddy_list_y = toolbar_y1 + toolbar_h + 10; 
buddy_list_w = 180;
buddy_list_h = window_height - (buddy_list_y - window_y1) - 20; 

chat_area_x = buddy_list_x + buddy_list_w + 10;
chat_area_y = buddy_list_y; 
chat_area_w = (window_x2 - 10) - chat_area_x;
chat_area_h = buddy_list_h - 95;

input_area_x = chat_area_x;
input_area_y = chat_area_y + chat_area_h + 10;
input_area_w = chat_area_w;
input_area_h = 50;

btn_send_w = 70;
btn_send_h = 25;
btn_send_x1 = input_area_x + input_area_w - btn_send_w;
btn_send_y1 = input_area_y + input_area_h + 5; 
btn_send_x2 = btn_send_x1 + btn_send_w;
btn_send_y2 = btn_send_y1 + btn_send_h;
btn_send_hover = false;

// 4. Chat Data
chat_logs = {}; 
contact_list = []; 

array_push(contact_list, "System");
chat_logs[$ "System"] = ["Welcome to CNet Messenger.", "No new alerts."];

array_push(contact_list, "NetUser_01");
chat_logs[$ "NetUser_01"] = [
    "Yo! You're the new user right?", 
    "I saw your match in the casual lobby.", 
    "Your starter looks pretty strong!",
    "Watch out for BronzeMod though. I heard his team is hacked."
];

for (var i = 0; i < array_length(global.unread_messages); i++) {
    var _msg_obj = global.unread_messages[i];
    var _sender = _msg_obj.from;
    var _message = _msg_obj.message;
    
    if (!variable_struct_exists(chat_logs, _sender)) {
        chat_logs[$ _sender] = [];
        array_push(contact_list, _sender);
    }
    array_push(chat_logs[$ _sender], _message);
}
global.unread_messages = [];

selected_contact_index = 0;
selected_contact_name = contact_list[0];
contact_item_height = 24; 
msg_line_height = 20;
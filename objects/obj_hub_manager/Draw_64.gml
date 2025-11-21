// --- Draw GUI Event ---
var _gui_width = display_get_gui_width();
var _gui_height = display_get_gui_height();

draw_set_font(fnt_vga);

// --- 1. Draw Main Taskbar ---
var _bar_height = 32;
var _bar_y1 = _gui_height - _bar_height;
draw_rectangle_95(0, _bar_y1, _gui_width, _gui_height, "raised");

// --- 2. Draw "Start" Button (NO LOGO) ---
var _start_btn_width = 80;
var _start_btn_x1 = 4;
var _start_btn_y1 = _bar_y1 + 4;
var _start_btn_x2 = _start_btn_x1 + _start_btn_width;
var _start_btn_y2 = _gui_height - 4;

// If menu is open, button looks "sunken" (pressed in)
var _start_state = start_menu_open ? "sunken" : "raised";
draw_rectangle_95(_start_btn_x1, _start_btn_y1, _start_btn_x2, _start_btn_y2, _start_state);

// Draw Bold Start Text (Centered)
draw_set_font(fnt_vga_bold);
draw_set_halign(fa_center); 
draw_set_valign(fa_middle);
draw_set_color(c_black);
var _text_x = _start_btn_x1 + (_start_btn_width / 2);
var _text_y = _start_btn_y1 + (_bar_height / 2) - 4;

if (start_menu_open) { _text_x += 1; _text_y += 1; } // Press effect

draw_text(_text_x, _text_y, "Start"); 
draw_set_font(fnt_vga);


// --- 3. Draw "Active Window" Buttons (The Task List) ---
var _task_x = _start_btn_x2 + 10;
var _task_w = 120;
var _task_h = 24;
var _task_y = _start_btn_y1;

// Use the list we defined in Create Event
for (var i = 0; i < array_length(applications_list); i++) {
    var _obj = applications_list[i][0];
    var _label = applications_list[i][1];
    
    if (instance_exists(_obj)) {
        // Draw a "sunken" button
        draw_rectangle_95(_task_x, _task_y, _task_x + _task_w, _task_y + _task_h, "sunken");
        
        // Draw Label
        draw_set_color(c_black);
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        
        // Active indicator (Navy Square)
        draw_set_color(c_navy);
        draw_rectangle(_task_x + 4, _task_y + 4, _task_x + 8, _task_y + 8, false);
        
        draw_set_color(c_black);
        draw_text(_task_x + 15, _task_y + 12, _label);
        
        // Move X for next button
        _task_x += _task_w + 4;
    }
}

// --- 4. Draw Coin Tray (NEW) ---
var _tray_width = 130; 
var _tray_x1 = _gui_width - _tray_width - 4;
var _tray_y1 = _bar_y1 + 4;
var _tray_x2 = _gui_width - 4;
var _tray_y2 = _gui_height - 4;

// Calculate Coin Tray Position (Left of Clock)
var _coin_w = 100;
var _coin_x2 = _tray_x1 - 4;
var _coin_x1 = _coin_x2 - _coin_w;
var _coin_y1 = _tray_y1;
var _coin_y2 = _tray_y2;

// Draw Coin Tray Background
draw_rectangle_95(_coin_x1, _coin_y1, _coin_x2, _coin_y2, "sunken");

// Draw Coins
draw_set_font(fnt_vga);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_black);
var _coin_center_y = _coin_y1 + ((_coin_y2 - _coin_y1) / 2);
var _current_coins = variable_struct_exists(global.PlayerData, "coins") ? global.PlayerData.coins : 0;
draw_text(_coin_x1 + (_coin_w / 2), _coin_center_y, "$ " + string(_current_coins));


// --- 4. Draw Clock Tray ---
var _tray_width = 130; 
var _tray_x1 = _gui_width - _tray_width - 4;
var _tray_y1 = _bar_y1 + 4;
var _tray_x2 = _gui_width - 4;
var _tray_y2 = _gui_height - 4;

draw_rectangle_95(_tray_x1, _tray_y1, _tray_x2, _tray_y2, "sunken");

draw_set_font(fnt_vga); 
draw_set_halign(fa_center);
draw_set_valign(fa_middle); 
var _tray_center_y = _tray_y1 + ((_tray_y2 - _tray_y1) / 2);
draw_text(_tray_x1 + (_tray_width / 2), _tray_center_y, time_string);


// ================== START MENU DRAW ==================
if (start_menu_open) {
    
    var _menu_x1 = 2;
    var _menu_y2 = _bar_y1; // Touches top of taskbar
    var _menu_y1 = _menu_y2 - menu_h;
    var _menu_x2 = _menu_x1 + menu_w;
    
    // A. Draw Main Box
    draw_rectangle_95(_menu_x1, _menu_y1, _menu_x2, _menu_y2, "raised");
    
    // B. Draw Side Branding Bar (Navy Blue)
    var _side_w = 30;
    draw_set_color(c_navy);
    draw_rectangle(_menu_x1 + 2, _menu_y1 + 2, _menu_x1 + _side_w, _menu_y2 - 2, false);
    
    // Vertical "CritterNet" text
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_font(fnt_vga_bold);
    var _v_text = "CNET98";
    for(var j=0; j<string_length(_v_text); j++) {
        draw_text(_menu_x1 + (_side_w/2), _menu_y2 - 120 + (j*18), string_char_at(_v_text, j+1));
    }
    
    // C. Draw Menu Items
    draw_set_font(fnt_vga);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    
    var _item_x = _menu_x1 + _side_w + 10;
    var _item_start_y = _menu_y1 + 10;
    
    for (var i = 0; i < array_length(menu_items); i++) {
        var _label = menu_items[i][0];
        var _item_y = _item_start_y + (i * menu_item_h);
        
        // Highlight if hovering
        if (i == start_hover_index) {
            draw_set_color(c_navy);
            draw_rectangle(_menu_x1 + _side_w + 2, _item_y - 2, _menu_x2 - 4, _item_y + 20, false);
            draw_set_color(c_white); 
        } else {
            draw_set_color(c_black); 
        }
        
        draw_text(_item_x, _item_y, _label);
    }
}
// ================== END OF START MENU ==================


// Reset draw settings
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_font(fnt_vga);
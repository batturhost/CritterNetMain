// --- Draw GUI Event ---

draw_set_font(fnt_vga);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// 1. Window
draw_rectangle_95(window_x1, window_y1, window_x2, window_y2, "raised");
draw_set_color(c_navy);
draw_rectangle(window_x1 + 2, window_y1 + 2, window_x2 - 2, window_y1 + 32, false);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(window_x1 + (window_width/2), window_y1 + 17, "DEBUG BATTLE SETUP");

// 2. Close Button
var _c_state = btn_close_hover ? "sunken" : "raised";
draw_rectangle_95(btn_close_x1, btn_close_y1, btn_close_x2, btn_close_y2, _c_state);
draw_set_color(c_black);
draw_text(btn_close_x1 + 11, btn_close_y1 + 11, "X");

// 3. Headers
draw_set_color(c_black);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(list_p_x1, list_p_y1 - 20, "PLAYER CRITTER");
draw_text(list_e_x1, list_e_y1 - 20, "ENEMY CRITTER");

// 4. Player List
draw_rectangle_95(list_p_x1, list_p_y1, list_p_x2, list_p_y2, "sunken");
gpu_set_scissor(list_p_x1 + 2, list_p_y1 + 2, (list_p_x2 - list_p_x1) - 4, (list_p_y2 - list_p_y1) - 4);
for (var i = player_scroll_top; i < array_length(critter_list); i++) {
    var _y = list_p_y1 + 2 + ((i - player_scroll_top) * list_item_height);
    if (_y > list_p_y2) break;
    
    if (i == player_selected_index) {
        draw_set_color(c_navy);
        draw_rectangle(list_p_x1 + 2, _y, list_p_x2 - 2, _y + list_item_height, false);
        draw_set_color(c_white);
    } else {
        draw_set_color(c_black);
    }
    draw_text(list_p_x1 + 5, _y + 2, critter_list[i]);
}
gpu_set_scissor(0, 0, display_get_gui_width(), display_get_gui_height());

// 5. Enemy List
draw_rectangle_95(list_e_x1, list_e_y1, list_e_x2, list_e_y2, "sunken");
gpu_set_scissor(list_e_x1 + 2, list_e_y1 + 2, (list_e_x2 - list_e_x1) - 4, (list_e_y2 - list_e_y1) - 4);
for (var i = enemy_scroll_top; i < array_length(critter_list); i++) {
    var _y = list_e_y1 + 2 + ((i - enemy_scroll_top) * list_item_height);
    if (_y > list_e_y2) break;
    
    if (i == enemy_selected_index) {
        draw_set_color(c_maroon);
        draw_rectangle(list_e_x1 + 2, _y, list_e_x2 - 2, _y + list_item_height, false);
        draw_set_color(c_white);
    } else {
        draw_set_color(c_black);
    }
    draw_text(list_e_x1 + 5, _y + 2, critter_list[i]);
}
gpu_set_scissor(0, 0, display_get_gui_width(), display_get_gui_height());

// 6. FIGHT Button
var _f_state = btn_fight_hover ? "sunken" : "raised";
draw_rectangle_95(btn_fight_x1, btn_fight_y1, btn_fight_x2, btn_fight_y2, _f_state);
draw_set_color(c_black);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(btn_fight_x1 + (btn_fight_w/2), btn_fight_y1 + (btn_fight_h/2), "FIGHT!");

// Reset
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
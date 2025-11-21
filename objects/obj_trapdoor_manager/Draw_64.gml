// --- Draw GUI Event ---

// 1. INHERIT PARENT
event_inherited();

draw_set_font(fnt_vga);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// 2. Draw Content
draw_set_color(c_black);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_text(window_x1 + 20, window_y1 + 50, "Select a specimen to optimize:");

var _team_size = array_length(global.PlayerData.team);
for (var i = 0; i < 6; i++) {
    var _btn = btn_team_layout[i];
    var _state = (menu_focus == i) ? "sunken" : "raised";
    draw_rectangle_95(_btn[0], _btn[1], _btn[2], _btn[3], _state);
    
    if (i < _team_size) {
        var _critter = global.PlayerData.team[i];
        if (variable_struct_exists(_critter, "is_corrupted") && _critter.is_corrupted) {
            draw_set_color(c_red);
        } else {
            draw_set_color(c_black);
        }
        
        draw_text(_btn[0] + 10, _btn[1] + 20, _critter.nickname);
        draw_set_halign(fa_right);
        if (variable_struct_exists(_critter, "is_corrupted") && _critter.is_corrupted) {
            draw_text(_btn[2] - 10, _btn[1] + 20, "[CORRUPTED]");
        } else {
            draw_text(_btn[2] - 10, _btn[1] + 20, "Lv. " + string(_critter.level));
        }
        draw_set_halign(fa_left);
    }
}

// 3. Draw Feedback Message
if (feedback_message_timer > 0) {
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(window_x1 + 2, window_y1 + 32, window_x2 - 2, window_y2 - 2, false);
    draw_set_alpha(1.0);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_ext(window_x1 + (window_width / 2), window_y1 + (window_height / 2), feedback_message, 20, window_width - 40);
}

// Reset
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
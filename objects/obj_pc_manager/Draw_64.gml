// --- Draw GUI Event ---

draw_set_font(fnt_vga);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// 1. INHERIT PARENT (Draws Window Background, Title Bar, Close Button, Border)
event_inherited();

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

// --- 2. Draw Panel Titles ---
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_font(fnt_vga_bold);
draw_text(team_list_x1 + (team_list_w / 2), window_y1 + 50, "CURRENT TEAM");
draw_text(pc_list_x1 + (pc_list_w / 2), window_y1 + 50, "PC STORAGE BOX");
draw_set_font(fnt_vga);

// --- 3. Draw [Move] Buttons ---
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_black);

var _to_team_state = (pc_selected_index != -1 && array_length(global.PlayerData.team) < 6) ? "raised" : "sunken";
draw_rectangle_95(btn_to_team_x1, btn_to_team_y1, btn_to_team_x2, btn_to_team_y2, _to_team_state);
draw_text(btn_to_team_x1 + 75, btn_to_team_y1 + 14, "<- Add"); 

var _to_pc_state = (team_selected_index != -1 && array_length(global.PlayerData.team) > 1) ? "raised" : "sunken";
draw_rectangle_95(btn_to_pc_x1, btn_to_pc_y1, btn_to_pc_x2, btn_to_pc_y2, _to_pc_state);
draw_text(btn_to_pc_x1 + 75, btn_to_pc_y1 + 14, "-> Store");

// --- 4. Draw Team List (Left) ---
draw_set_alpha(0.8); 
draw_set_color(c_white);
draw_rectangle(team_list_x1, team_list_y1, team_list_x2, team_list_y2, false);
draw_set_alpha(1.0);
draw_border_95(team_list_x1, team_list_y1, team_list_x2, team_list_y2, "sunken");

gpu_set_scissor(team_list_x1 + 2, team_list_y1 + 2, team_list_w - 4, team_list_h - 4);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

for (var i = team_top_index; i < array_length(global.PlayerData.team); i++) {
    // Skip if dragging this specific item
    if (i == held_critter_index && is_dragging_critter) continue;

    var _draw_y = team_list_y1 + 2 + ((i - team_top_index) * team_item_height);
    if (_draw_y > team_list_y2 - team_item_height) break;

    var _critter = global.PlayerData.team[i];
    if (i == team_selected_index) {
        draw_set_color(c_navy);
        draw_rectangle(team_list_x1 + 2, _draw_y, team_list_x2 - 2, _draw_y + team_item_height, false);
        draw_set_color(c_white);
    } else {
        draw_set_color(c_black);
    }
    
    draw_text(team_list_x1 + 5, _draw_y + 2, _critter.nickname);
    draw_set_halign(fa_right);
    draw_text(team_list_x2 - 5, _draw_y + 2, "Lv. " + string(_critter.level));
    draw_set_halign(fa_left);
}

if (drop_indicator_y != -1 && is_dragging_critter) {
    draw_set_color(c_red);
    draw_line_width(team_list_x1 + 2, drop_indicator_y, team_list_x2 - 2, drop_indicator_y, 2);
}
gpu_set_scissor(0, 0, display_get_gui_width(), display_get_gui_height());


// --- 5. Draw PC Box List (Right) ---
draw_set_alpha(0.8); 
draw_set_color(c_white);
draw_rectangle(pc_list_x1, pc_list_y1, pc_list_x2, pc_list_y2, false);
draw_set_alpha(1.0);
draw_border_95(pc_list_x1, pc_list_y1, pc_list_x2, pc_list_y2, "sunken");

gpu_set_scissor(pc_list_x1 + 2, pc_list_y1 + 2, pc_list_w - 4, pc_list_h - 4);
draw_set_valign(fa_middle);

var _critter_count = array_length(global.PlayerData.pc_box);
var _max_rows = ceil(_critter_count / pc_grid_cols);

for (var i = pc_scroll_top; i < _max_rows; i++) {
    var _row_y_pos = pc_list_y1 + pc_grid_padding + ((i - pc_scroll_top) * (pc_grid_cell_size + pc_grid_padding));
    if (_row_y_pos > pc_list_y2 - pc_grid_cell_size) break;
    
    for (var j = 0; j < pc_grid_cols; j++) {
        var _index = (i * pc_grid_cols) + j;
        if (_index >= _critter_count) break;
        
        var _cell_x1 = pc_list_x1 + pc_grid_padding + (j * (pc_grid_cell_size + pc_grid_padding));
        var _cell_y1 = _row_y_pos;
        
        if (_index == pc_selected_index) {
             draw_rectangle_95(_cell_x1, _cell_y1, _cell_x1 + pc_grid_cell_size, _cell_y1 + pc_grid_cell_size, "sunken");
        }
        
        var _critter = global.PlayerData.pc_box[_index];
        var _sprite = _critter.sprite_idle;
        var _sprite_w = sprite_get_width(_sprite);
        var _sprite_h = sprite_get_height(_sprite);
        
        var _scale = min((pc_grid_cell_size - 10) / _sprite_w, (pc_grid_cell_size - 10) / _sprite_h);
        
        var _cell_center_x = _cell_x1 + (pc_grid_cell_size / 2);
        var _cell_center_y = _cell_y1 + (pc_grid_cell_size / 2);
        var _draw_y = _cell_center_y + ((_sprite_h / 2) * _scale);
        
        var _frame = pc_anim_frame % sprite_get_number(_sprite);
        
        draw_sprite_ext(_sprite, _frame, _cell_center_x, _draw_y, _scale, _scale, 0, c_white, 1);
    }
}
gpu_set_scissor(0, 0, display_get_gui_width(), display_get_gui_height());

// --- 6. PREVIEW PANEL (Middle) ---
if (preview_critter != noone) {
    var _mid_x = window_x1 + (window_width / 2);
    var _panel_w = 150;
    var _panel_x1 = _mid_x - (_panel_w / 2);
    var _panel_y1 = window_y1 + 80;
    
    var _frame_w = _panel_w - 20;
    var _frame_h = 100;
    var _frame_x1 = _mid_x - (_frame_w / 2);
    var _frame_y1 = _panel_y1;
    var _frame_x2 = _frame_x1 + _frame_w;
    var _frame_y2 = _frame_y1 + _frame_h;
    
    var _col_dark_teal = make_color_rgb(0, 60, 60);
    draw_set_alpha(0.8);
    draw_set_color(_col_dark_teal);
    draw_rectangle(_frame_x1, _frame_y1, _frame_x2, _frame_y2, false);
    draw_set_alpha(1.0);
    draw_border_95(_frame_x1, _frame_y1, _frame_x2, _frame_y2, "sunken");
    
    var _sprite = preview_critter.sprite_idle;
    var _sprite_w = sprite_get_width(_sprite);
    var _sprite_h = sprite_get_height(_sprite);
    var _box_w = _frame_w - 8;
    var _box_h = _frame_h - 8;
    var _scale = min(_box_w / _sprite_w, _box_h / _sprite_h);
    
    var _sprite_x = _mid_x;
    var _draw_y = (_frame_y1 + (_frame_h / 2)) + ((_sprite_h / 2) * _scale);
    
    gpu_set_scissor(_frame_x1 + 2, _frame_y1 + 2, _frame_x2 - _frame_x1 - 4, _frame_y2 - _frame_y1 - 4);
    draw_sprite_ext(_sprite, preview_anim_frame, _sprite_x, _draw_y, _scale, _scale, 0, c_white, 1);
    gpu_set_scissor(0, 0, display_get_gui_width(), display_get_gui_height());
    
    var _text_y_start = _frame_y2 + 15;
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    
    // --- RENAMING DRAW LOGIC ---
    if (is_renaming) {
        // Draw Input Box
        var _in_w = 130;
        var _in_h = 24;
        draw_set_color(c_white);
        draw_rectangle(_mid_x - _in_w/2, _text_y_start - 2, _mid_x + _in_w/2, _text_y_start + _in_h - 2, false);
        draw_border_95(_mid_x - _in_w/2, _text_y_start - 2, _mid_x + _in_w/2, _text_y_start + _in_h - 2, "sunken");
        
        // Draw Text + Cursor
        draw_set_color(c_black);
        draw_set_font(fnt_vga_bold);
        var _cursor = ((cursor_timer div 30) % 2 == 0) ? "_" : "";
        draw_text(_mid_x, _text_y_start, rename_input + _cursor);
    } 
    else {
        // Standard Drawing
        if (name_area_hover) {
            // Hover visual cue (Yellow box)
            draw_set_color(c_dkgray);
            draw_set_alpha(0.5);
            draw_roundrect(_mid_x - 65, _text_y_start - 2, _mid_x + 65, _text_y_start + 20, false);
            draw_set_alpha(1.0);
            draw_set_color(c_yellow); // Text turns yellow on hover
        } else {
            draw_set_color(c_white);
        }
        
        draw_set_font(fnt_vga_bold);
        draw_text(_mid_x, _text_y_start, preview_critter.nickname);
    }
    // ---------------------------

    draw_set_font(fnt_vga);
    draw_set_color(c_white);
    draw_text(_mid_x, _text_y_start + 20, "Lv. " + string(preview_critter.level));
    
    // --- XP BAR IN PC ---
    var _xp_w = 100;
    var _xp_h = 6;
    var _xp_x1 = _mid_x - (_xp_w / 2);
    // [FIX] Lowered XP bar position (+5 pixels)
    var _xp_y1 = _text_y_start + 45; 
    var _xp_x2 = _xp_x1 + _xp_w;
    var _xp_y2 = _xp_y1 + _xp_h;
    
    var _pc_xp_perc = 0;
    if (preview_critter.next_level_xp > 0) {
        _pc_xp_perc = preview_critter.xp / preview_critter.next_level_xp;
    }
    _pc_xp_perc = clamp(_pc_xp_perc, 0, 1);

    // Draw Background
    draw_set_color(c_dkgray);
    draw_rectangle(_xp_x1, _xp_y1, _xp_x2, _xp_y2, false);
    
    // Draw Fill
    if (_pc_xp_perc > 0) {
        draw_set_color(c_aqua);
        draw_rectangle(_xp_x1, _xp_y1, _xp_x1 + (_xp_w * _pc_xp_perc), _xp_y2, false);
    }
    // -------------------------
    
    draw_set_halign(fa_left);
    // [FIX] Set Text Color to White for Stats
    draw_set_color(c_white);
    
    var _stats_x = _panel_x1 + 10;
    var _stats_y = _text_y_start + 55; // Lowered stats text slightly to accommodate new XP bar pos
    draw_text(_stats_x, _stats_y, "HP: " + string(preview_critter.max_hp));
    draw_text(_stats_x, _stats_y + 20, "ATK: " + string(preview_critter.atk));
    draw_text(_stats_x, _stats_y + 40, "DEF: " + string(preview_critter.defense));
    draw_text(_stats_x, _stats_y + 60, "SPD: " + string(preview_critter.speed));
}

// --- 7. Draw Feedback Message ---
if (feedback_message_timer > 0) {
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(window_x1 + 2, window_y1 + 32, window_x2 - 2, window_y2 - 2, false);
    draw_set_alpha(1.0);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(fnt_vga_bold);
    draw_text_ext(window_x1 + (window_width / 2), window_y1 + (window_height / 2), feedback_message, 20, window_width - 80);
}

// --- 8. DRAW THE DRAGGED CRITTER ---
if (is_dragging_critter) { 
    var _name = drag_critter_data.nickname;
    var _level = "Lv. " + string(drag_critter_data.level);
    var _draw_x = _mx - (team_list_w / 2);
    var _draw_y = _my - drag_y_offset;
    
    draw_set_color(c_white);
    draw_set_alpha(0.7);
    draw_rectangle(_draw_x, _draw_y, _draw_x + team_list_w, _draw_y + team_item_height, false);
    draw_set_alpha(1.0);
    
    draw_set_color(c_black);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(fnt_vga); 
    draw_text(_draw_x + 5, _draw_y + 2, _name);
    draw_set_halign(fa_right);
    draw_text(_draw_x + team_list_w - 5, _draw_y + 2, _level);
}

// --- 9. Reset ---
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(fnt_vga);
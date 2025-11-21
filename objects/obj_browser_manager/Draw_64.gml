// --- Draw GUI Event ---

draw_set_font(fnt_vga);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// 1. INHERIT PARENT
event_inherited();

// --- DRAW BASED ON STATE ---

if (browser_state == "browsing") {
    // ================== BROWSING VIEW (Existing Code) ==================
    
    // 2. Draw Left Sidebar
    draw_set_alpha(0.85); 
    draw_set_color(c_teal);
    draw_rectangle(sidebar_x1, sidebar_y1, sidebar_x2, sidebar_y2, false);
    draw_set_alpha(1.0);

    // Add scanlines
    draw_scanlines_95(sidebar_x1, sidebar_y1, sidebar_x2, sidebar_y2);

    // Logo Area
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_font(fnt_vga_bold);
    draw_text(sidebar_x1 + (sidebar_w/2), sidebar_y1 + 30, "CritterNet");
    draw_text(sidebar_x1 + (sidebar_w/2), sidebar_y1 + 50, "Online");
    draw_set_font(fnt_vga);

    // 3. Draw Sidebar Buttons
    draw_set_valign(fa_middle);
    draw_set_color(c_black);
    draw_set_font(fnt_vga_bold); 

    // Ranked
    var _ranked_state = btn_ranked_hover ? "sunken" : "raised";
    draw_rectangle_95(btn_ranked_x1, btn_ranked_y1, btn_ranked_x2, btn_ranked_y2, _ranked_state);
    draw_text(btn_ranked_x1 + (sidebar_w/2) - 10, btn_ranked_y1 + 30, "Ranked Cup");

    // Casual
    var _casual_state = btn_casual_hover ? "sunken" : "raised";
    draw_rectangle_95(btn_casual_x1, btn_casual_y1, btn_casual_x2, btn_casual_y2, _casual_state);
    draw_text(btn_casual_x1 + (sidebar_w/2) - 10, btn_casual_y1 + 30, "Casual Match");

    // Heal
    var _heal_state = btn_heal_hover ? "sunken" : "raised";
    draw_rectangle_95(btn_heal_x1, btn_heal_y1, btn_heal_x2, btn_heal_y2, _heal_state);
    draw_text(btn_heal_x1 + (sidebar_w/2) - 10, btn_heal_y1 + 30, "Critter Center");

    draw_set_font(fnt_vga);

    // 4. Draw Main Content Area
    draw_set_color(c_white);
    draw_rectangle(content_x1, content_y1, content_x2, content_y2, false);
    gpu_set_scissor(content_x1, content_y1, content_x2 - content_x1, content_y2 - content_y1);

    var _margin_x = content_x1 + 20;
    var _curr_y = content_y1 + 20;
    var _page_w = (content_x2 - content_x1) - 40;

    // -- Header --
    draw_set_color(c_black);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(fnt_vga_bold); 
    draw_text(_margin_x, _curr_y, "CRITTERNET TODAY");
    draw_set_font(fnt_vga);
    _curr_y += 30;

    // Date
    var _date_str = string(current_month) + "/" + string(current_day) + "/1998";
    draw_text(_margin_x, _curr_y, _date_str);
    _curr_y += 30;

    // -- Separator --
    draw_set_color(c_gray);
    draw_line(_margin_x, _curr_y, _margin_x + _page_w, _curr_y);
    _curr_y += 20;

    // -- Weather --
    draw_set_color(c_navy);
    draw_set_font(fnt_vga_bold);
    draw_text(_margin_x, _curr_y, "Your Weather");
    draw_set_font(fnt_vga);
    _curr_y += 25;

    draw_set_color(c_black);
    if (sprite_exists(asset_get_index("spr_weather_icons"))) {
        var _w_sprite = spr_weather_icons;
        var _w_spr_w = sprite_get_width(_w_sprite);
        var _w_spr_h = sprite_get_height(_w_sprite);
        var _max_icon_size = 48;
        var _w_scale = min(_max_icon_size / _w_spr_w, _max_icon_size / _w_spr_h);
        draw_sprite_ext(_w_sprite, weather_icon_idx, _margin_x + 25, _curr_y + 25, _w_scale, _w_scale, 0, c_white, 1);
    } else {
        draw_circle(_margin_x + 25, _curr_y + 25, 15, true);
    }
    draw_text(_margin_x + 60, _curr_y + 5, weather_desc);
    draw_text(_margin_x + 60, _curr_y + 25, weather_string);
    var _temp_width = string_width(weather_string);
    draw_circle(_margin_x + 60 + _temp_width + 3, _curr_y + 25 + 3, 2, true);
    draw_text(_margin_x + 60 + _temp_width + 8, _curr_y + 25, "C");
    _curr_y += 60; 

    // -- News --
    draw_set_color(c_navy);
    draw_set_font(fnt_vga_bold);
    draw_text(_margin_x, _curr_y, "Top News Story");
    draw_set_font(fnt_vga);
    _curr_y += 20;
    draw_set_color(c_black);
    draw_text_ext(_margin_x + 20, _curr_y, current_news, 20, _page_w - 20);
    _curr_y += 60;

    // -- Daily Deal --
    draw_set_color(c_teal); 
    draw_set_font(fnt_vga_bold); 
    draw_text(_margin_x, _curr_y, "Earth's Best Deal:");
    draw_set_font(fnt_vga);
    _curr_y += 20;
    draw_set_color(c_black);
    draw_text_ext(_margin_x + 20, _curr_y, current_deal, 20, _page_w - 20);
    _curr_y += 60;

    // -- Did You Know? --
    draw_set_color(c_maroon); 
    draw_set_font(fnt_vga_bold);
    draw_text(_margin_x, _curr_y, "Did You Know?");
    draw_set_font(fnt_vga);
    _curr_y += 20;
    draw_set_color(c_black);
    draw_text_ext(_margin_x + 20, _curr_y, current_fact, 20, _page_w - 20);
    gpu_set_scissor(0, 0, display_get_gui_width(), display_get_gui_height());

    // Draw Heal Feedback
    if (heal_message_timer > 0) {
        draw_set_color(c_black);
        draw_set_alpha(0.7);
        draw_rectangle(window_x1 + 2, window_y1 + 32, window_x2 - 2, window_y2 - 2, false);
        draw_set_alpha(1.0);
        draw_set_color(c_white);
        draw_set_font(fnt_vga_bold);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(window_x1 + (window_width/2), window_y1 + (window_height/2), heal_message_text);
    }
}
else if (browser_state == "searching") {
    // ================== SEARCHING VIEW ==================
    
    // Fill window with teal (like a loading screen)
    draw_set_color(c_teal);
    draw_rectangle(window_x1 + 2, window_y1 + 32, window_x2 - 2, window_y2 - 2, false);
    draw_scanlines_95(window_x1 + 2, window_y1 + 32, window_x2 - 2, window_y2 - 2);
    
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(fnt_vga_bold);
    
    var _dots = "";
    var _t = (120 - search_timer) div 15;
    if (_t % 4 == 0) _dots = "";
    if (_t % 4 == 1) _dots = ".";
    if (_t % 4 == 2) _dots = "..";
    if (_t % 4 == 3) _dots = "...";
    
    draw_text(window_x1 + (window_width/2), window_y1 + (window_height/2), "SEARCHING FOR OPPONENT" + _dots);
}
else if (browser_state == "match_found") {
    // ================== MATCH FOUND VIEW ==================
    
    // 1. Fill window with Dark Grey (instead of Black)
    draw_set_color(c_teal);
    draw_rectangle(window_x1 + 2, window_y1 + 32, window_x2 - 2, window_y2 - 2, false);
    
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    var _center_x = window_x1 + (window_width/2);
    var _center_y = window_y1 + (window_height/2);
    
    // VS Text
    draw_set_font(fnt_vga_bold);
    draw_text_transformed(_center_x, _center_y, "VS", 2, 2, 0);
    
    // --- FRAME SETTINGS ---
    var _frame_size = 120; 
    var _frame_y_center = _center_y - 20; 
    
    
    // ================== PLAYER INFO (Left) ==================
    var _p_x = _center_x - 200;
    
    // Name
    draw_set_font(fnt_vga_bold);
    draw_text(_p_x, _frame_y_center + (_frame_size/2) + 25, player_name);
    
    // Frame
    var _p_x1 = _p_x - (_frame_size / 2);
    var _p_y1 = _frame_y_center - (_frame_size / 2);
    var _p_x2 = _p_x + (_frame_size / 2);
    var _p_y2 = _frame_y_center + (_frame_size / 2);
    draw_rectangle_95(_p_x1, _p_y1, _p_x2, _p_y2, "sunken");
    
    // Sprite (Centered & Scaled)
    var _ps_w = sprite_get_width(player_pfp);
    var _ps_h = sprite_get_height(player_pfp);
    var _p_scale = min((_frame_size - 10) / _ps_w, (_frame_size - 10) / _ps_h);
    
    // [FIX] Calculate Draw Position based on Origin
    var _px_off = sprite_get_xoffset(player_pfp);
    var _py_off = sprite_get_yoffset(player_pfp);
    
    var _p_draw_x = _p_x + (_px_off - (_ps_w / 2)) * _p_scale;
    var _p_draw_y = _frame_y_center + (_py_off - (_ps_h / 2)) * _p_scale;
    
    draw_sprite_ext(player_pfp, 0, _p_draw_x, _p_draw_y, _p_scale, _p_scale, 0, c_white, 1);
    
    
    // ================== OPPONENT INFO (Right) ==================
    var _o_x = _center_x + 200;
    
    // Name
    draw_text(_o_x, _frame_y_center + (_frame_size/2) + 25, next_opponent_name);
    
    // Frame
    var _o_x1 = _o_x - (_frame_size / 2);
    var _o_y1 = _frame_y_center - (_frame_size / 2);
    var _o_x2 = _o_x + (_frame_size / 2);
    var _o_y2 = _frame_y_center + (_frame_size / 2);
    draw_rectangle_95(_o_x1, _o_y1, _o_x2, _o_y2, "sunken");
    
    // Sprite (Centered & Scaled)
    var _os_w = sprite_get_width(next_opponent_pfp);
    var _os_h = sprite_get_height(next_opponent_pfp);
    var _o_scale = min((_frame_size - 10) / _os_w, (_frame_size - 10) / _os_h);
    
    // [FIX] Calculate Draw Position based on Origin
    var _ox_off = sprite_get_xoffset(next_opponent_pfp);
    var _oy_off = sprite_get_yoffset(next_opponent_pfp);
    
    var _o_draw_x = _o_x + (_ox_off - (_os_w / 2)) * _o_scale;
    var _o_draw_y = _frame_y_center + (_oy_off - (_os_h / 2)) * _o_scale;
    
    draw_sprite_ext(next_opponent_pfp, 0, _o_draw_x, _o_draw_y, _o_scale, _o_scale, 0, c_white, 1);
    
    
    // ================== FOOTER TEXT ==================
    draw_set_font(fnt_vga);
    draw_text(_center_x, _center_y + 150, "MATCH FOUND!");
}

// Reset
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(fnt_vga);
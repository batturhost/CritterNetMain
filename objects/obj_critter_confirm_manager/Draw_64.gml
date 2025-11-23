// --- Draw GUI Event ---

draw_set_font(fnt_vga);
draw_set_halign(fa_center);
draw_set_valign(fa_top);

// ================== BACKGROUND CODE ==================
draw_set_color(c_teal);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_scanlines_95(0, 0, display_get_gui_width(), display_get_gui_height());
// =====================================================


// --- 3. Draw Main Window ---
draw_rectangle_95(window_x1, window_y1, window_x2, window_y2, "raised");

// Title Bar
draw_set_color(c_navy);
draw_rectangle(window_x1 + 2, window_y1 + 2, window_x2 - 2, window_y1 + 32, false); 
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_font(fnt_vga_bold);
draw_text(window_x1 + 10, window_y1 + 12, "File Acquisition");
draw_set_font(fnt_vga);

// --- 4. Draw Contents Based on State ---
switch (download_state) {
    
    case "downloading":
        draw_set_halign(fa_center);
        draw_set_color(c_black);
        
        // Header Text
        draw_text(window_x1 + (window_width/2), window_y1 + 80, "Downloading Critter-File...");
        draw_text(window_x1 + (window_width/2), window_y1 + 105, filename);
        
        // --- PROGRESS BAR ---
        draw_rectangle_95(progress_bar_x1, progress_bar_y1, progress_bar_x2, progress_bar_y2, "sunken");
        
        var _fill_width = (progress_bar_w - 4) * (download_progress / 100);
        if (_fill_width > 0) {
            draw_set_color(c_navy);
            draw_rectangle(progress_bar_x1 + 2, progress_bar_y1 + 2, progress_bar_x1 + 2 + _fill_width, progress_bar_y2 - 2, false);
        }
        
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(progress_bar_x1 + (progress_bar_w/2), progress_bar_y1 + (progress_bar_h/2) + 2, string(floor(download_progress)) + "%");
        
        // Footer Text
        draw_set_valign(fa_top);
        draw_set_color(c_black);
        draw_text(window_x1 + (window_width/2), window_y2 - 40, "[Connecting...]");
        break;
        
    case "complete":
        draw_set_halign(fa_center);
        draw_set_color(c_black);
        
        // Header
        draw_text(window_x1 + (window_width/2), window_y1 + 60, "Critter-File Download Complete!");
        
        // --- SPRITE DRAWING (POSITION FIX) ---
        var _center_x = window_x1 + (window_width/2);
        
        // FIX: Moved this down from 150 to 175 to close the gap
        var _visual_center_y = window_y1 + 175; 
        
        var _max_w = 200;
        var _max_h = 130; 
        
        var _spr_w = sprite_get_width(sprite);
        var _spr_h = sprite_get_height(sprite);
        
        // Calculate scale to fit INSIDE the box
        var _fit_scale = min(_max_w / _spr_w, _max_h / _spr_h);
        
        // Draw position
        var _draw_y = _visual_center_y + ((_spr_h / 2) * _fit_scale);
        
        draw_sprite_ext(sprite, animation_frame, _center_x, _draw_y, _fit_scale, _fit_scale, 0, c_white, 1);
        // --------------------------------------
        
        // "You acquired" text
        draw_text(window_x1 + (window_width/2), window_y2 - 120, "You acquired:");
        
        // Critter Name (Yellow)
        draw_set_color(c_yellow); 
        draw_text(window_x1 + (window_width/2), window_y2 - 95, species_name);
        
        // [SUBMIT] Button
        var _btn_state = btn_submit_hover ? "sunken" : "raised";
        draw_rectangle_95(btn_submit_x1, btn_submit_y1, btn_submit_x2, btn_submit_y2, _btn_state);
        
        draw_set_color(c_black);
        draw_set_valign(fa_middle);
        draw_text(btn_submit_x1 + (btn_submit_x2 - btn_submit_x1)/2, btn_submit_y1 + (btn_submit_y2 - btn_submit_y1)/2 + 2, "SUBMIT");
        break;
}

// --- 5. Reset ---
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
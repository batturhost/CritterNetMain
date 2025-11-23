// --- scr_draw_helpers.gml ---
// This is a global script to hold all our helper functions

// --- 90s-STYLE WINDOW (ORIGINAL) ---
// This function draws the BACKGROUND AND the border
function draw_rectangle_95(_x1, _y1, _x2, _y2, _state) {
    
    // Draw the main body color
    draw_set_color(c_gray);
    draw_rectangle(_x1, _y1, _x2, _y2, false);
    
    if (_state == "raised") {
        // Raised (like a button)
        draw_set_color(c_white);
        draw_line(_x1, _y1, _x2 - 1, _y1); // Top
        draw_line(_x1, _y1, _x1, _y2 - 1); // Left
        draw_set_color(c_black);
        draw_line(_x2, _y1, _x2, _y2); // Right
        draw_line(_x1, _y2, _x2, _y2); // Bottom
        draw_set_color(c_dkgray);
        draw_line(_x2 - 1, _y1 + 1, _x2 - 1, _y2 - 1); // Inner Right
        draw_line(_x1 + 1, _y2 - 1, _x2 - 1, _y2 - 1); // Inner Bottom
    }
    else if (_state == "sunken") {
        // Sunken (like a text field)
        draw_set_color(c_dkgray);
        draw_line(_x1, _y1, _x2 - 1, _y1); // Top
        draw_line(_x1, _y1, _x1, _y2 - 1); // Left
        draw_set_color(c_black);
        draw_line(_x1 + 1, _y1 + 1, _x2 - 2, _y1 + 1); // Inner Top
        draw_line(_x1 + 1, _y1 + 1, _x1 + 1, _y2 - 2); // Inner Left
        draw_set_color(c_white);
        draw_line(_x2, _y1, _x2, _y2); // Right
        draw_line(_x1, _y2, _x2, _y2); // Bottom
    }
    
    draw_set_color(c_white); // Reset color
}


// ================== NEW FUNCTION ==================
// --- 90s-STYLE BORDER (NEW) ---
// This function draws ONLY THE BORDER, no background
function draw_border_95(_x1, _y1, _x2, _y2, _state) {
    
    // This function assumes the background is already drawn!
    
    if (_state == "raised") {
        // Raised (like a button)
        draw_set_color(c_white);
        draw_line(_x1, _y1, _x2 - 1, _y1); // Top
        draw_line(_x1, _y1, _x1, _y2 - 1); // Left
        draw_set_color(c_black);
        draw_line(_x2, _y1, _x2, _y2); // Right
        draw_line(_x1, _y2, _x2, _y2); // Bottom
        draw_set_color(c_dkgray);
        draw_line(_x2 - 1, _y1 + 1, _x2 - 1, _y2 - 1); // Inner Right
        draw_line(_x1 + 1, _y2 - 1, _x2 - 1, _y2 - 1); // Inner Bottom
    }
    else if (_state == "sunken") {
        // Sunken (like a text field)
        draw_set_color(c_dkgray);
        draw_line(_x1, _y1, _x2 - 1, _y1); // Top
        draw_line(_x1, _y1, _x1, _y2 - 1); // Left
        draw_set_color(c_black);
        draw_line(_x1 + 1, _y1 + 1, _x2 - 2, _y1 + 1); // Inner Top
        draw_line(_x1 + 1, _y1 + 1, _x1 + 1, _y2 - 2); // Inner Left
        draw_set_color(c_white);
        draw_line(_x2, _y1, _x2, _y2); // Right
        draw_line(_x1, _y2, _x2, _y2); // Bottom
    }
    
    draw_set_color(c_white); // Reset color
}
// ================== END OF NEW FUNCTION ==================


// --- MOUSE CLICK HELPER FUNCTION ---
function point_in_box(_x, _y, _x1, _y1, _x2, _y2) {
    return (_x > _x1 && _x < _x2 && _y > _y1 && _y < _y2);
}

// --- DRAW RETRO SCANLINES ---
function draw_scanlines_95(_x1, _y1, _x2, _y2) {
    draw_set_color(c_black);
    draw_set_alpha(0.15); // Subtle darkening
    
    // Draw a line every 4 pixels
    for (var i = _y1; i < _y2; i += 4) {
        draw_line(_x1, i, _x2, i);
    }
    
    draw_set_alpha(1.0); // Reset alpha
}

/// @function draw_scrolling_list(_x, _y, _w, _h, _list_data, _scroll_index, _selected_index, _row_height, _draw_color)
/// @desc Draws a generic scrolling list with 90s style borders and clipping
function draw_scrolling_list(_x, _y, _w, _h, _list_data, _scroll_index, _selected_index, _row_height, _draw_color) {
    
    // 1. Draw Background & Border
    draw_set_color(c_white);
    // Use a slightly off-white if desired, passed via _draw_color usually
    if (_draw_color != c_white) draw_set_color(_draw_color); 
    
    draw_rectangle(_x, _y, _x + _w, _y + _h, false);
    draw_border_95(_x, _y, _x + _w, _y + _h, "sunken");

    // 2. Setup Clipping
    gpu_set_scissor(_x + 2, _y + 2, _w - 4, _h - 4);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);

    // 3. Iterate & Draw Items
    var _count = array_length(_list_data);
    
    for (var i = _scroll_index; i < _count; i++) {
        var _draw_y = _y + 2 + ((i - _scroll_index) * _row_height);
        
        // Stop if we go past the bottom
        if (_draw_y > _y + _h - _row_height) break;
        
        // Highlight Selection
        if (i == _selected_index) {
            draw_set_color(c_navy);
            draw_rectangle(_x + 2, _draw_y, _x + _w - 2, _draw_y + _row_height, false);
            draw_set_color(c_white);
        } else {
            draw_set_color(c_black);
        }
        
        // Draw Text (Handle structs vs strings)
        var _text = _list_data[i];
        var _text_right = "";
        
        // If data is a struct, try to find common display properties
        if (is_struct(_text)) {
            if (variable_struct_exists(_text, "price")) _text_right = "$" + string(_text.price);
            if (variable_struct_exists(_text, "name")) _text = _text.name;
        }
        
        draw_text(_x + 5, _draw_y + (_row_height/2), _text);
        
        if (_text_right != "") {
            draw_set_halign(fa_right);
            draw_text(_x + _w - 10, _draw_y + (_row_height/2), _text_right);
            draw_set_halign(fa_left);
        }
        
        // Draw Divider
        if (i != _selected_index) {
            draw_set_color(c_ltgray);
            draw_line(_x + 5, _draw_y + _row_height - 1, _x + _w - 5, _draw_y + _row_height - 1);
        }
    }

    // 4. Reset
    gpu_set_scissor(0, 0, display_get_gui_width(), display_get_gui_height());
}
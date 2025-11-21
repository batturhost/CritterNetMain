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
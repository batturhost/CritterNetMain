// --- Draw Event ---

// Don't draw at all if not visible
if (!visible) {
    exit;
}

// --- 1. Draw the Icon (with blink and scale fix) ---
var _draw_icon = true;
if (is_blinking) {
    _draw_icon = (blink_timer < 30);
}

// ================== ICON SCALE FIX ==================
// This draws the sprite at a 1x pixel scale, assuming a 64x64 icon size
var _draw_w = 64;
var _draw_h = 64;

if (_draw_icon) {
    draw_sprite_ext(sprite_index, 0, x, y, _draw_w / sprite_width, _draw_h / sprite_height, 0, c_white, 1);
}
// ================== END OF FIX ===================


// --- 2. Draw the text label ---
draw_set_font(fnt_vga); 
draw_set_halign(fa_center);
draw_set_valign(fa_top);

if (hovering) {
    draw_set_color(c_white);
} else {
    draw_set_color(c_black);
}

// The label is always visible (doesn't blink)
// We use the new _draw_w and _draw_h to position the text
draw_text(x + (_draw_w / 2), y + _draw_h + 4, label_text);

// Reset
draw_set_halign(fa_left);
draw_set_color(c_white);
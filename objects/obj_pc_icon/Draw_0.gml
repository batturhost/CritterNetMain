// --- Draw Event ---
// draw_self(); // <-- We replace this

// ================== NEW SCALED DRAWING ==================
// This draws the sprite at a 1x pixel scale, ignoring its original size
// This assumes your other icons are 64x64. If they are 32x32, change 64 to 32.
var _draw_w = 64;
var _draw_h = 64;
draw_sprite_ext(sprite_index, 0, x, y, _draw_w / sprite_width, _draw_h / sprite_height, 0, c_white, 1);
// ================== END OF NEW CODE ===================

// --- 2. Draw the text label ---
draw_set_font(fnt_vga); 
draw_set_halign(fa_center);
draw_set_valign(fa_top);

if (hovering) {
    draw_set_color(c_white);
} else {
    draw_set_color(c_black);
}

// We use the new _draw_w and _draw_h to position the text
draw_text(x + (_draw_w / 2), y + _draw_h + 4, label_text);

// Reset
draw_set_halign(fa_left);
draw_set_color(c_white);
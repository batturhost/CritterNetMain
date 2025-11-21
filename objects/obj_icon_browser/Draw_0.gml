// --- Draw Event ---

// 1. Draw the icon sprite itself
draw_self();

// 2. Draw the text label *under* the sprite
draw_set_font(fnt_vga);
draw_set_halign(fa_center);
draw_set_valign(fa_top);

// ** THE FIX IS HERE **
// If we are hovering, set the text color to white
if (hovering) {
    draw_set_color(c_white);
} else {
    // Otherwise, set it to black
    draw_set_color(c_black);
}
// ** The blue rectangle draw call is GONE **

draw_text(x + (sprite_width / 2), y + sprite_height + 4, label_text);

// Reset draw settings
draw_set_halign(fa_left);
draw_set_color(c_white);
// --- scr_battle_view.gml ---
// Contains helper functions to clean up the Battle Manager Draw Event

/// @function draw_critter_vfx(_actor, _y_offset)
function draw_critter_vfx(_actor, _y_offset) {
    var _px, _py, _alpha, _size, _p;
    var _base_y = _actor.y - _y_offset;

    if (_actor.vfx_type == "ice") {
        for (var i = 0; i < array_length(_actor.vfx_particles); i++) {
            _p = _actor.vfx_particles[i];
            _px = _actor.x + _p.x; _py = _base_y + _p.y;
            draw_set_alpha(_p.life / _p.max_life);
            draw_set_color(make_color_rgb(170, 255, 255));
            _size = 6 * _p.scale;
            draw_line_width(_px - _size, _py, _px + _size, _py, 3);
            draw_line_width(_px, _py - _size, _px, _py + _size, 3);
        }
        draw_set_alpha(1.0);
    }
    else if (_actor.vfx_type == "snow") {
        for (var i = 0; i < array_length(_actor.vfx_particles); i++) {
            _p = _actor.vfx_particles[i];
            _px = _actor.x + _p.x; _py = _base_y + _p.y;
            draw_set_alpha(_p.life / _p.max_life);
            draw_set_color(c_white);
            draw_circle(_px, _py, 3 * _p.scale, false);
        }
        draw_set_alpha(1.0);
    }
    else if (_actor.vfx_type == "sleep") { 
        draw_set_font(fnt_vga_bold);
        draw_set_color(c_white);
        for (var i = 0; i < array_length(_actor.vfx_particles); i++) {
            _p = _actor.vfx_particles[i];
            _px = _actor.x + _p.x; _py = _base_y + _p.y;
            draw_set_alpha(_p.life / _p.max_life);
            draw_text_transformed(_px, _py, "Z", _p.scale, _p.scale, 0);
        }
        draw_set_alpha(1.0); draw_set_font(fnt_vga);
    }
    else if (_actor.vfx_type == "water") { 
        for (var i = 0; i < array_length(_actor.vfx_particles); i++) {
            _p = _actor.vfx_particles[i];
            _px = _actor.x + _p.x; _py = _base_y + _p.y;
            draw_set_color(c_aqua); draw_set_alpha(1.0);
            draw_circle(_px, _py, 4 * _p.scale, false);
        }
        draw_set_alpha(1.0);
    }
    else if (_actor.vfx_type == "zen") { 
        if (array_length(_actor.vfx_particles) > 0) {
            _p = _actor.vfx_particles[0];
            _px = _actor.x + _p.x; _py = _base_y + _p.y;
            draw_set_alpha(_p.life / _p.max_life);
            draw_set_color(c_white);
            draw_circle(_px, _py, 100 * _p.scale, true);
            draw_circle(_px, _py, 95 * _p.scale, true);
        }
        draw_set_alpha(1.0);
    }
    else if (_actor.vfx_type == "soundwave") { 
        for (var i = 0; i < array_length(_actor.vfx_particles); i++) {
            _p = _actor.vfx_particles[i];
            _px = _actor.x + _p.x; _py = _base_y + _p.y;
            draw_set_alpha(_p.life / _p.max_life);
            draw_set_color(c_white);
            draw_circle(_px, _py, 100 * _p.scale, true);
        }
        draw_set_alpha(1.0);
    }
    else if (_actor.vfx_type == "feathers") { 
        for (var i = 0; i < array_length(_actor.vfx_particles); i++) {
            _p = _actor.vfx_particles[i];
            _px = _actor.x + _p.x; _py = _base_y + _p.y;
            draw_set_alpha(_p.life / _p.max_life);
            draw_set_color(c_white);
            draw_ellipse(_px - 3, _py - 5, _px + 3, _py + 5, false);
        }
        draw_set_alpha(1.0);
    }
    else if (_actor.vfx_type == "angry") { 
        draw_set_font(fnt_vga_bold);
        draw_set_color(c_red);
        for (var i = 0; i < array_length(_actor.vfx_particles); i++) {
            _p = _actor.vfx_particles[i];
            _px = _actor.x + _p.x; _py = _base_y + _p.y;
            draw_text(_px, _py, "#!@");
        }
        draw_set_font(fnt_vga); draw_set_color(c_white);
    }
    else if (_actor.vfx_type == "tongue") { 
        if (array_length(_actor.vfx_particles) > 0) {
            _p = _actor.vfx_particles[0];
            _px = _actor.x + _p.x; _py = _base_y + _p.y;
            draw_set_color(c_fuchsia); 
            draw_line_width(_px, _py, _px + _p.length, _py, 4);
        }
        draw_set_color(c_white);
    }
    else if (_actor.vfx_type == "up_arrow") { 
        draw_set_font(fnt_vga_bold);
        draw_set_color(c_lime);
        for (var i = 0; i < array_length(_actor.vfx_particles); i++) {
            _p = _actor.vfx_particles[i];
            _px = _actor.x + _p.x; _py = _base_y + _p.y;
            draw_text(_px, _py, "^");
        }
        draw_set_font(fnt_vga); draw_set_color(c_white);
    }
    else if (_actor.vfx_type == "tail_shed") { 
         if (array_length(_actor.vfx_particles) > 0) {
            _p = _actor.vfx_particles[0];
            _px = _actor.x + _p.x; _py = _base_y + _p.y;
            draw_set_color(c_gray);
            draw_rectangle_95(_px - 5, _py - 5, _px + 5, _py + 5, "raised"); 
            draw_set_color(c_white);
        }
    }
    else if (_actor.vfx_type == "shield") { 
         var _h = sprite_get_height(_actor.sprite_index) * _actor.my_scale;
         var _w = sprite_get_width(_actor.sprite_index) * _actor.my_scale;
         draw_set_color(c_aqua); draw_set_alpha(0.4);
         draw_roundrect(_actor.x - _w/2 - 10, _actor.y - _h - 10, _actor.x + _w/2 + 10, _actor.y + 10, false);
         draw_set_alpha(1.0); draw_set_color(c_white);
         draw_roundrect(_actor.x - _w/2 - 10, _actor.y - _h - 10, _actor.x + _w/2 + 10, _actor.y + 10, true);
    }
    else if (_actor.vfx_type == "shockwave") { 
        if (array_length(_actor.vfx_particles) > 0) {
            _p = _actor.vfx_particles[0];
            _px = _actor.x + _p.x; _py = _base_y + _p.y;
            draw_set_color(c_white);
            draw_circle(_px, _py, 150 * _p.scale, true);
            draw_circle(_px, _py, 140 * _p.scale, true);
        }
    }
    else if (_actor.vfx_type == "bite") { 
        var _h = sprite_get_height(_actor.sprite_index) * _actor.my_scale;
        _px = _actor.x; _py = _base_y - (_h/2);
        draw_set_color(c_white);
        draw_triangle(_px - 20, _py - 20, _px, _py, _px - 10, _py - 20, false);
        draw_triangle(_px + 20, _py + 20, _px, _py, _px + 10, _py + 20, false);
    }
    else if (_actor.vfx_type == "hearts") { 
        for (var i = 0; i < array_length(_actor.vfx_particles); i++) {
            _p = _actor.vfx_particles[i];
            _px = _actor.x + _p.x; _py = _base_y + _p.y;
            draw_set_color(c_fuchsia);
            var _s = _p.scale * 10;
            draw_circle(_px - _s/2, _py, _s/2, false);
            draw_circle(_px + _s/2, _py, _s/2, false);
            draw_triangle(_px - _s, _py, _px + _s, _py, _px, _py + _s*1.5, false);
        }
        draw_set_color(c_white);
    }
    else if (_actor.vfx_type == "mud") { 
        draw_set_color(make_color_rgb(101, 67, 33));
        for (var i = 0; i < array_length(_actor.vfx_particles); i++) {
            _p = _actor.vfx_particles[i];
            _px = _actor.x + _p.x; _py = _base_y + _p.y;
            draw_circle(_px, _py, 6 * _p.scale, false);
        }
        draw_set_color(c_white);
    }
    else if (_actor.vfx_type == "slap") { 
        var _h = sprite_get_height(_actor.sprite_index) * _actor.my_scale;
        _px = _actor.x; _py = _base_y - (_h/2);
        draw_set_color(c_fuchsia); draw_set_alpha(0.6);
        draw_ellipse(_px - 30, _py - 10, _px + 30, _py + 10, false);
        draw_set_alpha(1.0); draw_set_color(c_white);
    }
    else if (_actor.vfx_type == "yap") {
        draw_set_color(c_orange);
        for (var i = 0; i < array_length(_actor.vfx_particles); i++) {
            _p = _actor.vfx_particles[i];
            _px = _actor.x + _p.x; _py = _base_y + _p.y;
            var _r = 50 * _p.scale;
            draw_line(_px - _r, _py - _r, _px + _r, _py + _r);
            draw_line(_px - _r, _py + _r, _px + _r, _py - _r);
        }
        draw_set_color(c_white);
    }
    else if (_actor.vfx_type == "zoomies") {
        draw_set_color(c_white);
        draw_set_alpha(0.7);
        for (var i = 0; i < array_length(_actor.vfx_particles); i++) {
            _p = _actor.vfx_particles[i];
            _px = _actor.x + _p.x; _py = _base_y + _p.y;
            draw_line_width(_px, _py, _px - 50, _py, 2);
        }
        draw_set_alpha(1.0);
    }
    else if (_actor.vfx_type == "puff") {
        draw_set_color(c_white);
        for (var i = 0; i < array_length(_actor.vfx_particles); i++) {
            _p = _actor.vfx_particles[i];
            _px = _actor.x + _p.x; _py = _base_y + _p.y;
            draw_circle(_px, _py, 10 * _p.scale, false);
            draw_circle(_px+5, _py+5, 8 * _p.scale, false);
            draw_circle(_px-5, _py+5, 8 * _p.scale, false);
        }
        draw_set_color(c_white);
    }
    
    // === BAMBOO DRAW ===
    else if (_actor.vfx_type == "bamboo") {
        draw_set_alpha(1.0);
        draw_set_color(c_lime);
        
        for (var i = 0; i < array_length(_actor.vfx_particles); i++) {
            _p = _actor.vfx_particles[i];
            // Calculate pos
            _px = _actor.x + _p.x;
            _py = _base_y + _p.y;
            
            // Force default angle if undefined
            var _ang = 0;
            if (variable_struct_exists(_p, "angle")) _ang = _p.angle;
            
            var _len = 30;
            var _dx = lengthdir_x(_len, _ang);
            var _dy = lengthdir_y(_len, _ang);
            // Draw
            draw_line_width(_px - _dx, _py - _dy, _px + _dx, _py + _dy, 6);
        }
        draw_set_color(c_white);
    }
    // =====================
    
    else if (_actor.vfx_type == "lazy") {
        draw_set_font(fnt_vga_bold);
        draw_set_color(c_blue);
        for (var i = 0; i < array_length(_actor.vfx_particles); i++) {
            _p = _actor.vfx_particles[i];
            _px = _actor.x + _p.x; _py = _base_y + _p.y;
            draw_text_transformed(_px, _py, "Z", _p.scale, _p.scale, 0);
        }
        draw_set_color(c_white); draw_set_font(fnt_vga);
    }
}


/// @function draw_battle_actor(_actor, _data, _y_offset)
function draw_battle_actor(_actor, _data, _y_offset) {
    if (!instance_exists(_actor)) return;
    
    var _sprite = _actor.sprite_index;
    var _scale = _actor.my_scale;
    var _x = _actor.x; var _y = _actor.y; 
    var _frame = _actor.animation_frame; var _alpha = _actor.faint_alpha;
    var _y_scale = _actor.faint_scale_y;
    
    // --- REVERTED: Removed blinking logic to keep opacity 100% ---
    // -----------------------------------------------------------
    
    // Logic: Withdraw Fade
    if (_actor.vfx_type == "shield") _alpha *= 0.2;
    // Logic: Shadow
    draw_set_color(c_black); draw_set_alpha(0.3 * _alpha);
    var _shadow_w = sprite_get_width(_sprite) * _scale * 0.5;
    var _shadow_h = _shadow_w * 0.3;
    draw_ellipse(_x - _shadow_w, _y - _shadow_h, _x + _shadow_w, _y + _shadow_h, false);
    draw_set_alpha(1.0);
    // Logic: Glitch vs Normal
    if (_data.glitch_timer > 0) {
        var _shake_x = random_range(-2, 2);
        draw_sprite_ext(_sprite, _frame, _x - 3 + _shake_x, _y - _y_offset, _scale, _scale * _y_scale, 0, c_red, 0.5);
        draw_sprite_ext(_sprite, _frame, _x + 3 + _shake_x, _y - _y_offset, _scale, _scale * _y_scale, 0, c_aqua, 0.5);
        draw_sprite_ext(_sprite, _frame, _x + _shake_x, _y - _y_offset, _scale, _scale * _y_scale, 0, c_white, _alpha);
    } else {
        var _rot = 0;
        if (_actor.vfx_type == "roll") {
            var _rot_dir = (_actor.object_index == obj_player_critter) ?
            -20 : 20;
            _rot = _actor.vfx_timer * _rot_dir;
        }
        draw_sprite_ext(_sprite, _frame, _x, _y - _y_offset, _scale, _scale * _y_scale, _rot, c_white, _alpha);
    }

    // Logic: VFX
    draw_critter_vfx(_actor, _y_offset);

    // Logic: Flash
    gpu_set_blendmode(bm_add);
    draw_sprite_ext(_sprite, _frame, _x, _y - _y_offset, _scale, _scale * _y_scale, 0, _actor.flash_color, _actor.flash_alpha * _alpha);
    gpu_set_blendmode(bm_normal);
}


/// @function draw_battle_menu_buttons(_buttons, _focus_index, _pp_array)
function draw_battle_menu_buttons(_buttons, _focus_index, _pp_array = undefined) {
    draw_set_halign(fa_center); 
    draw_set_valign(fa_middle);
    for (var i = 0; i < array_length(_buttons); i++) { 
        var _btn = _buttons[i];
        var _state = (_focus_index == i) ? "sunken" : "raised"; 
        draw_rectangle_95(_btn[0], _btn[1], _btn[2], _btn[3], _state); 
        draw_set_color(c_black);
        // Check for disabled state (0 PP)
        // We skip the "BACK" button which is typically the last one or labeled "BACK"
        if (!is_undefined(_pp_array) && i < array_length(_pp_array)) {
             if (_btn[4] != "BACK" && _pp_array[i] <= 0) {
                 draw_set_color(c_gray);
            }
        }
        
        var _btn_w = _btn[2] - _btn[0];
        var _btn_h = _btn[3] - _btn[1];
        draw_text(_btn[0] + (_btn_w / 2), _btn[1] + (_btn_h / 2), _btn[4]);
    }
}

/// @function draw_move_info_panel(_x1, _y1, _w, _h, _move, _current_pp)
function draw_move_info_panel(_x1, _y1, _w, _h, _move, _current_pp) {
    var _x2 = _x1 + _w;
    var _y2 = _y1 + _h;
    
    // Box Background
    var _ui_gray = make_color_rgb(192, 192, 192);
    draw_set_color(_ui_gray);
    draw_rectangle(_x1, _y1, _x2, _y2, false);
    draw_border_95(_x1, _y1, _x2, _y2, "raised");
    // Line 1: Type (Colored)
    var _type_col = c_black;
    if (_move.element == "HYDRO") _type_col = c_blue;
    if (_move.element == "NATURE") _type_col = c_green;
    if (_move.element == "TOXIC") _type_col = c_purple;
    if (_move.element == "AERO") _type_col = c_aqua;
    if (_move.element == "BEAST") _type_col = make_color_rgb(150, 75, 0);
    // Brown
    
    draw_set_color(_type_col);
    draw_set_halign(fa_left); draw_set_valign(fa_top);
    draw_set_font(fnt_vga_bold);
    draw_text(_x1 + 10, _y1 + 8, _move.element);
    // Line 1: PP (Right aligned)
    draw_set_halign(fa_right);
    draw_set_color(c_black);
    draw_text(_x2 - 10, _y1 + 8, "PP: " + string(_current_pp) + "/" + string(_move.max_pp));
    // Line 2: Category
    draw_set_halign(fa_left);
    draw_set_font(fnt_vga);
    var _cat = "Physical";
    if (_move.move_type == MOVE_TYPE.HEAL) _cat = "Status";
    if (_move.move_type == MOVE_TYPE.STAT_BUFF) _cat = "Status";
    if (_move.move_type == MOVE_TYPE.STAT_DEBUFF) _cat = "Status";
    draw_text(_x1 + 10, _y1 + 28, "Type: " + _cat);
    // Line 3: Description
    draw_text_ext(_x1 + 10, _y1 + 48, _move.description, 16, _w - 20);
}

/// @function create_button_grid(_x, _y, _w, _h, _gutter, _rows, _cols, _labels)
function create_button_grid(_x, _y, _w, _h, _gutter, _rows, _cols, _labels) {
    var _buttons = [];
    var _count = 0;
    for (var r = 0; r < _rows; r++) {
        for (var c = 0; c < _cols; c++) {
            if (_count >= array_length(_labels)) break;
            var _bx1 = _x + (c * (_w + _gutter));
            var _by1 = _y + (r * (_h + _gutter));
            var _bx2 = _bx1 + _w;
            var _by2 = _by1 + _h;
            
            array_push(_buttons, [_bx1, _by1, _bx2, _by2, _labels[_count]]);
            _count++;
        }
    }
    return _buttons;
}
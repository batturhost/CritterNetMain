// --- Step Event ---

// 1. Animation Logic
var _num_frames = sprite_get_number(sprite_index);

if (_num_frames > 1) {
    // Determine style based on the critter's name AND if it is the player
    var _style = "LOOP"; // Default
    var _is_player = (object_index == obj_player_critter);
    
    if (variable_instance_exists(id, "my_data") && is_struct(my_data)) {
        _style = get_critter_anim_style(my_data.animal_name, _is_player);
    }
    
    // --- OPTION A: PING PONG (Bounce Back and Forth) ---
    if (_style == "PINGPONG") {
        // Ensure direction variable exists (safety)
        if (!variable_instance_exists(id, "anim_direction")) anim_direction = 1;
        
        animation_frame += animation_speed * anim_direction;

        // Hit the End -> Reverse
        if (animation_frame >= _num_frames - 1) {
            animation_frame = _num_frames - 1; 
            anim_direction = -1; 
        }
        // Hit the Start -> Forward
        if (animation_frame <= 0) {
            animation_frame = 0; 
            anim_direction = 1;  
        }
    }
    
    // --- OPTION B: LOOP (Standard Cycle) ---
    else {
        animation_frame = (animation_frame + animation_speed) % _num_frames;
    }
}

// 2. Handle Hurt Fade
if (flash_alpha > 0) flash_alpha -= 0.05;

// ================== VFX SPAWNING LOGIC ==================
var _h = sprite_get_height(sprite_index) * my_scale;
switch (vfx_type) {
    case "ice":
        if (vfx_timer > 0) {
            for (var k = 0; k < 4; k++) {
                array_push(vfx_particles, {
                    x: random_range(-40, 40), y: random_range(-_h * 0.8, 10),
                    speed_x: random_range(-1.5, 1.5), speed_y: random_range(-3.5, -1.5),
                    life: irandom_range(40, 60), max_life: 60, scale: random_range(1.0, 2.5)
                });
            }
        }
        break;
    case "snow":
        if (vfx_timer > 0) {
            for (var k = 0; k < 10; k++) {
                array_push(vfx_particles, {
                    x: random_range(-20, 120), y: random_range(-_h * 1.5, -_h * 0.5),
                    speed_x: random_range(-3.0, -1.0), speed_y: random_range(2.0, 4.0),
                    life: irandom_range(40, 70), max_life: 70, scale: random_range(0.5, 2.0)
                });
            }
        }
        break;
    case "sleep":
        if (vfx_timer % 15 == 0 && vfx_timer > 0) {
            array_push(vfx_particles, {
                x: random_range(-10, 10), y: -_h * 0.8,
                speed_x: 1.5, speed_y: -1.0,
                life: 60, max_life: 60, scale: 1.0, scale_speed: 0.01
            });
        }
        break;
    case "lazy":
        if (vfx_timer % 20 == 0 && vfx_timer > 0) {
            array_push(vfx_particles, {
                x: random_range(-10, 10), y: -_h * 0.8,
                speed_x: 0.5, speed_y: -0.5,
                life: 60, max_life: 60, scale: 1.0, scale_speed: 0.005
            });
        }
        break;
    case "water":
        if (vfx_timer == 45) {
            for (var k = 0; k < 20; k++) {
                var _angle = random_range(0, 360);
                var _spd = random_range(4, 9);
                array_push(vfx_particles, {
                    x: 0, y: -_h * 0.7,
                    speed_x: lengthdir_x(_spd, _angle), speed_y: lengthdir_y(_spd, _angle),
                    gravity: 0.4, life: irandom_range(20, 35), max_life: 35, scale: random_range(0.6, 1.2)
                });
            }
        }
        break;
    case "mud":
        if (vfx_timer == 30) {
            for (var k = 0; k < 3; k++) {
                array_push(vfx_particles, {
                    x: 0, y: -20,
                    speed_x: (vfx_target_dx / 20) + random_range(-1, 1),
                    speed_y: (vfx_target_dy / 20) - 5 + random_range(-1, 1),
                    gravity: 0.5, life: 20, max_life: 20, scale: random_range(0.8, 1.2)
                });
            }
        }
        break;
    case "zen":
        if (vfx_timer == 60) {
            array_push(vfx_particles, { x: 0, y: -_h * 0.5, scale: 0.1, scale_speed: 0.05, life: 60, max_life: 60 });
        }
        break;
    case "soundwave":
        if (vfx_timer % 20 == 0 && vfx_timer > 0) {
            array_push(vfx_particles, { x: 0, y: -_h * 0.8, scale: 0.1, scale_speed: 0.05, life: 60, max_life: 60 });
        }
        break;
    case "yap":
        if (vfx_timer % 10 == 0 && vfx_timer > 0) {
            array_push(vfx_particles, { x: 20, y: -_h * 0.6, scale: 0.5, scale_speed: 0.1, life: 30, max_life: 30 });
        }
        break;
    case "puff":
        if (vfx_timer % 5 == 0 && vfx_timer > 0) {
            for(var k=0; k<3; k++) array_push(vfx_particles, { x: random_range(-30, 30), y: random_range(-_h*0.8, -_h*0.2), scale: 0.2, scale_speed: 0.05, life: 20, max_life: 20 });
        }
        break;
    case "shockwave":
        if (vfx_timer == 45) {
             array_push(vfx_particles, { x: 0, y: -_h * 0.5, scale: 0.1, scale_speed: 0.05, life: 45, max_life: 45 });
        }
        break;
    case "feathers":
        if (vfx_timer == 45) {
            for (var k = 0; k < 10; k++) {
                array_push(vfx_particles, {
                    x: random_range(-20, 20), y: random_range(-_h, -_h * 0.5),
                    speed_x: random_range(-2.0, 2.0), speed_y: random_range(-1.0, 1.0), gravity: 0.1,
                    life: irandom_range(40, 60), max_life: 60,
                    angle: random(360), spin: random_range(-5, 5)
                });
            }
        }
        break;
    case "bamboo":
        if (vfx_timer > 0 && array_length(vfx_particles) == 0) {
            for (var k = 0; k < 8; k++) {
                array_push(vfx_particles, {
                    x: random_range(-50, 50), 
                    y: random_range(-150, -50),
                    speed_y: random_range(6, 10),
                    life: 40,
                    max_life: 40,
                    angle: irandom(360), 
                    rot_speed: random_range(-8, 8)
                });
            }
        }
        break;
    case "angry":
        if (vfx_timer == 60) {
            array_push(vfx_particles, { x: 20, y: -_h * 0.9, speed_y: -0.5, life: 60, max_life: 60, scale: 1.0 });
        }
        break;
    case "up_arrow":
        if (vfx_timer % 10 == 0 && vfx_timer > 0) {
             array_push(vfx_particles, { x: random_range(-20, 20), y: random_range(-_h, -_h/2), speed_y: -2, life: 40, max_life: 40 });
        }
        break;
    case "hearts":
        if (vfx_timer % 10 == 0 && vfx_timer > 0) {
            array_push(vfx_particles, { x: random_range(-20, 20), y: -_h * 0.5, speed_y: -1.5, life: 50, max_life: 50, scale: 0.5 });
        }
        break;
    case "tail_shed":
        if (vfx_timer == 60) {
             array_push(vfx_particles, { x: -30, y: -20, speed_y: 0, gravity: 0.5, angle: 0, spin: 5, life: 60, max_life: 60 });
        }
        break;
    case "tongue":
        if (vfx_timer == 30) {
            array_push(vfx_particles, { x: 0, y: -_h * 0.5, length: 0, max_length: 100, retracting: false, life: 30, max_life: 30 });
        }
        break;
    case "zoomies":
        if (vfx_timer > 0) {
            var _shake = (sin(vfx_timer) * 30);
            x = home_x + _shake;
            if (vfx_timer % 5 == 0) {
                array_push(vfx_particles, { x: random_range(-30, 30), y: random_range(-_h, 0), speed_x: -10, life: 10, max_life: 10 });
            }
        } else { x = home_x;
        }
        break;
    case "dive":
        switch (vfx_state) {
            case 0: y -= 15;
                if (y < home_y - 300) { vfx_state = 1; vfx_timer = 15; } break;
            case 1: if (vfx_timer > 0) vfx_timer--; else {
                    var _dir = point_direction(x, y, vfx_target_x, vfx_target_y);
                    var _dist = point_distance(x, y, vfx_target_x, vfx_target_y);
                    var _spd = 40; x += lengthdir_x(_spd, _dir); y += lengthdir_y(_spd, _dir);
                    if (_dist < _spd) { vfx_state = 2; vfx_timer = 30;
                    }
                } break;
            case 2: x = home_x; y = home_y; vfx_type = "none"; break;
        }
        break;
    case "roll":
        vfx_timer++;
        if (lunge_state == 0) { vfx_type = "none"; vfx_timer = 0; }
        break;
    case "shield": case "bite": case "slap": 
        break;
}

// ================== MASTER VFX UPDATE LOOP ==================
if (array_length(vfx_particles) > 0) {
    for (var i = array_length(vfx_particles) - 1; i >= 0; i--) {
        var _p = vfx_particles[i];
        // 1. Physics (Position)
        if (variable_struct_exists(_p, "speed_x")) _p.x += _p.speed_x;
        if (variable_struct_exists(_p, "speed_y")) _p.y += _p.speed_y;
        if (variable_struct_exists(_p, "gravity")) _p.speed_y += _p.gravity;
        // 2. Physics (Rotation)
        if (variable_struct_exists(_p, "rot_speed")) {
             if (!variable_struct_exists(_p, "angle")) _p.angle = 0;
             _p.angle += _p.rot_speed;
        }
        else if (variable_struct_exists(_p, "spin")) {
             if (!variable_struct_exists(_p, "angle")) _p.angle = 0;
             _p.angle += _p.spin;
        }
        // 3. Scaling
        if (variable_struct_exists(_p, "scale_speed")) _p.scale += _p.scale_speed;
        if (vfx_type == "ice") _p.scale = (_p.life / _p.max_life) * (_p[$ "scale"] ?? 1.0);
        // 4. Special: Tongue Logic
        if (vfx_type == "tongue" && variable_struct_exists(_p, "length")) {
             if (!_p.retracting) {
                _p.length = lerp(_p.length, _p.max_length, 0.3);
                if (_p.length > _p.max_length * 0.9) _p.retracting = true;
            } else {
                _p.length = lerp(_p.length, 0, 0.3);
            }
        }
        // 5. Life Cycle
        _p.life -= 1;
        if (_p.life <= 0) array_delete(vfx_particles, i, 1);
    }
}

// Decrement Main Timer
if (vfx_type != "none" && vfx_type != "dive" && vfx_type != "zoomies" && vfx_type != "roll") {
    vfx_timer--;
    if (vfx_timer <= 0 && array_length(vfx_particles) == 0) vfx_type = "none";
}

// Handle movement & Fainting
if (is_fainting) {
    if (faint_scale_y > 0) { faint_scale_y -= 0.02;
        faint_alpha -= 0.02;
    } 
    else { faint_scale_y = 0; faint_alpha = 0;
    }
} 
// Shake Logic
else if (shake_timer > 0) {
    shake_timer--;
    x = home_x + random_range(-4, 4);
    y = home_y + random_range(-4, 4);
} 
// Lunge Logic
else {
    if (!variable_instance_exists(id, "lunge_speed")) lunge_speed = 0.1;
    if (vfx_type != "dive" && vfx_type != "zoomies") {
        switch (lunge_state) {
            case 1: // Lunging OUT
                lunge_current_x = lerp(lunge_current_x, lunge_target_x - home_x, lunge_speed);
                lunge_current_y = lerp(lunge_current_y, lunge_target_y - home_y, lunge_speed); 
                if (abs(lunge_current_x - (lunge_target_x - home_x)) < 5) lunge_state = 2;
                break;
            case 2: // Returning HOME
                lunge_current_x = lerp(lunge_current_x, 0, 0.1);
                lunge_current_y = lerp(lunge_current_y, 0, 0.1); 
                if (abs(lunge_current_x) < 1 && abs(lunge_current_y) < 1) {
                    lunge_current_x = 0;
                    lunge_current_y = 0; lunge_state = 0; lunge_speed = 0.1;
                }
                break;
            default: 
                lunge_current_x = 0;
                lunge_current_y = 0; 
                break;
        }
        
        x = home_x + lunge_current_x;
        y = home_y + lunge_current_y;
    }
}
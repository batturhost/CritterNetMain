// --- Create Event ---

// 1. INHERIT PARENT (Handles window setup)
event_inherited();

// 2. Window Properties
window_width = 800;
window_height = 600;
window_title = "CNet_Battle_Sys.exe - [ACTIVE]";

// Recalculate Center
window_x1 = (display_get_gui_width() / 2) - (window_width / 2);
window_y1 = (display_get_gui_height() / 2) - (window_height / 2) - 20; 
window_x2 = window_x1 + window_width;
window_y2 = window_y1 + window_height;

// 3. Get Battle Type & Data
current_level_cap = level_cap;
if (is_casual == false) {
    current_opponent_data = opponent_data; 
    opponent_lose_message = current_opponent_data.lose_message;
} else {
    opponent_lose_message = ""; 
    var _all_keys = variable_struct_get_names(global.bestiary);
    var _player_key = global.PlayerData.team[0].animal_name;
    var _enemy_key = _all_keys[irandom(array_length(_all_keys) - 1)];
    while (_enemy_key == _player_key) {
        _enemy_key = _all_keys[irandom(array_length(_all_keys) - 1)];
    }
    var _enemy_db = global.bestiary[$ _enemy_key];
    var _player_level = global.PlayerData.team[0].level;
    current_opponent_data = {
        name: "Wild " + _enemy_db.animal_name,
        profile_pic_sprite: _enemy_db.sprite_idle,
        critter_keys: [ _enemy_key ],
        critter_levels: [ clamp(irandom_range(_player_level - 1, _player_level + 1), 1, current_level_cap) ]
    };
}

// 4. Define States
enum BATTLE_STATE {
    START, WAIT_FOR_START, 
    INTRO_PLAYER, WAIT_FOR_PLAYER_INTRO, // <--- ADD THESE TWO
    PLAYER_TURN, PLAYER_MOVE_RUN,
    WAIT_FOR_PLAYER_MOVE, ENEMY_TURN, ENEMY_MOVE_RUN, WAIT_FOR_ENEMY_MOVE,
    PLAYER_POST_TURN_DAMAGE, ENEMY_POST_TURN_DAMAGE,
    PLAYER_FAINT, ENEMY_FAINT, WAIT_FOR_FAINT,
    PLAYER_SWAP_OUT, PLAYER_SWAP_IN,
    WIN_DOWNLOAD_PROGRESS, WIN_DOWNLOAD_COMPLETE,
    WIN_XP_GAIN, WIN_CHECK_LEVEL, WIN_LEVEL_UP_MSG, 
    WIN_COIN_GAIN, 
    WIN_COIN_WAIT,
    WIN_END, LOSE,
    WAIT_FOR_HP_DRAIN
}
current_state = BATTLE_STATE.START;

// 5. Menu States
enum MENU { MAIN, FIGHT, TEAM }
current_menu = MENU.MAIN;
menu_focus = 0;

// 6. UI & Actors Setup
info_box_width = 300; 
info_box_height = 80;

player_critter_data = global.PlayerData.team[0];
swap_target_index = 0;

var _enemy_key = current_opponent_data.critter_keys[0]; 
var _enemy_level = current_opponent_data.critter_levels[0];
var _enemy_db = global.bestiary[$ _enemy_key];

enemy_critter_data = new AnimalData(
    _enemy_db.animal_name, _enemy_db.base_hp, _enemy_db.base_atk,
    _enemy_db.base_def, _enemy_db.base_spd, _enemy_level, 
    _enemy_db.sprite_idle, _enemy_db.sprite_idle_back, 
    _enemy_db.sprite_signature_move, _enemy_db.moves, 
    _enemy_db.blurb, _enemy_db.size, _enemy_db.element_type 
);
enemy_critter_data.nickname = _enemy_db.animal_name; 

// Spawn Actors
var _layer_id = layer_get_id("Instances");

// --- INITIALIZE UI VARIABLES ---
var _log_y1 = window_y1 + (window_height * 0.8);

info_enemy_x1 = window_x1 + 20; 
info_enemy_y1 = window_y1 + 40;
info_enemy_x2 = info_enemy_x1 + info_box_width; 
info_enemy_y2 = info_enemy_y1 + info_box_height;

info_player_x1 = window_x2 - info_box_width - 20;
info_player_y1 = _log_y1 - info_box_height - 10; 
info_player_x2 = info_player_x1 + info_box_width;
info_player_y2 = info_player_y1 + info_box_height;

var _btn_w = 175; var _btn_h = 30; var _btn_gutter = 10;
var _btn_base_x = window_x2 - (_btn_w * 2) - (_btn_gutter * 2);
var _btn_base_y = _log_y1 + 15;

btn_main_menu = [
    [_btn_base_x, _btn_base_y, _btn_base_x + _btn_w, _btn_base_y + _btn_h, "FIGHT"],
    [_btn_base_x + _btn_w + _btn_gutter, _btn_base_y, _btn_base_x + _btn_w * 2 + _btn_gutter, _btn_base_y + _btn_h, "TEAM"],
    [_btn_base_x, _btn_base_y + _btn_h + _btn_gutter, _btn_base_x + _btn_w, _btn_base_y + _btn_h * 2 + _btn_gutter, "ITEM"],
    [_btn_base_x + _btn_w + _btn_gutter, _btn_base_y + _btn_h + _btn_gutter, _btn_base_x + _btn_w * 2 + _btn_gutter, _btn_base_y + _btn_h * 2 + _btn_gutter, "RUN"]
];

btn_team_layout = [];
var _team_btn_w = 400; var _team_btn_h = 100; var _team_box_padding = 10;
var _team_box_x_start = window_x1 + 40; 
var _team_box_y_start = window_y1 + 40;

for (var i = 0; i < 3; i++) { 
    for (var j = 0; j < 2; j++) { 
        var _x1 = _team_box_x_start + (j * (_team_btn_w + _team_box_padding));
        var _y1 = _team_box_y_start + (i * (_team_btn_h + _team_box_padding)); 
        array_push(btn_team_layout, [_x1, _y1, _x1 + _team_btn_w, _y1 + _team_btn_h]);
    } 
}
var _cancel_x = window_x2 - 120 - 20; 
var _cancel_y = window_y2 - 40 - 20;
array_push(btn_team_layout, [_cancel_x, _cancel_y, _cancel_x + 120, _cancel_y + 40]);

player_actor = instance_create_layer(0, 0, _layer_id, obj_player_critter);
enemy_actor = instance_create_layer(0, 0, _layer_id, obj_enemy_critter);

init_animal(player_actor, player_critter_data, player_critter_data.sprite_idle_back);
init_animal(enemy_actor, enemy_critter_data, enemy_critter_data.sprite_idle);
recalculate_stats(player_critter_data);
recalculate_stats(enemy_critter_data);
player_critter_data.hp = global.PlayerData.team[0].hp;

// ================== SCALING SYSTEM ==================
var _p_scale_mult = get_critter_scale_config(player_critter_data.animal_name, true); // TRUE for Player
var _e_scale_mult = get_critter_scale_config(enemy_critter_data.animal_name, false);

player_actor.my_scale = 0.33 * 1.30 * _p_scale_mult;
enemy_actor.my_scale = 0.33 * _e_scale_mult;

// 7. Misc
battle_log_text = "The battle begins!";
player_chosen_move_index = -1; 
enemy_chosen_move_index = -1;
is_force_swapping = false; 
btn_move_menu = [];
download_start_percent = 0;
download_end_percent = 0;
download_current_percent = 0;
download_bar_w = 400;
download_bar_h = 30;
download_filename = "";
download_sprite = noone;
download_bar_x1 = window_x1 + (window_width / 2) - (download_bar_w / 2);
download_bar_y1 = window_y1 + (window_height / 2);

// ================== HP SLIDE VARIABLES ==================
player_visual_hp = player_critter_data.hp;
enemy_visual_hp = enemy_critter_data.hp;
hp_drain_speed = 0.5; 
next_state_after_drain = BATTLE_STATE.WAIT_FOR_PLAYER_MOVE; 
hp_blink_timer = 0;

// ================== CORE BATTLE LOGIC ==================
perform_turn_logic = function(_user_actor, _target_actor, _user_data, _target_data, _move_index) {
    var _move = _user_data.moves[_move_index];
    if (_user_data.move_pp[_move_index] > 0) {
        _user_data.move_pp[_move_index]--;
    }
    
    battle_log_text = _user_data.nickname + " used " + _move.move_name + "!";
    
    switch (_move.move_type) {
        case MOVE_TYPE.DAMAGE:
            // Visuals
            if (_move.move_name == "Snap" || _move.move_name == "Poison Bite" || _move.move_name == "Bamboo Bite") {
                effect_play_bite_lunge(_user_actor, _target_actor);
                effect_play_bite(_target_actor);
            } 
            else if (_move.move_name == "Dive") { 
                effect_play_dive(_user_actor, _target_actor);
                effect_play_lunge(_user_actor, _target_actor); 
            }
            else if (_move.move_name == "Playful Roll") {
                effect_play_roll(_user_actor, _target_actor);
            }
            else {
                effect_play_lunge(_user_actor, _target_actor);
                if (_move.move_name == "Ice Pounce") effect_play_ice(_user_actor);
                if (_move.move_name == "Hydro Headbutt") effect_play_water(_user_actor);
                if (_move.move_name == "Wing Smack") effect_play_feathers(_user_actor);
                if (_move.move_name == "Sticky Tongue") effect_play_tongue(_user_actor);
                if (_move.move_name == "Shell Bash") effect_play_shockwave(_user_actor);
                if (_move.move_name == "Gill Slap") effect_play_slap(_target_actor);
                if (_move.move_name == "Mud Shot") effect_play_mud(_user_actor, _target_actor);
                if (_move.move_name == "Pom-Pom Strike") effect_play_puff(_target_actor);
                if (_move.move_name == "Scratch" || _move.move_name == "Fur Swipe") effect_play_scratch(_target_actor); 
                if (_move.move_name == "Pounce") effect_play_lunge(_user_actor, _target_actor);
                if (_move.move_name == "Bamboo Bite") effect_play_bamboo(_target_actor); 
            }
            
            // Damage Calc
            var _atk_mult = get_stat_multiplier(_user_data.atk_stage);
            var _def_mult = get_stat_multiplier(_target_data.def_stage);
            var _type_mult = 1.0;
            if (variable_struct_exists(_move, "element") && variable_struct_exists(_target_data, "element_type")) {
                _type_mult = get_type_effectiveness(_move.element, _target_data.element_type);
            }
            
            var L = _user_data.level;
            var A = _user_data.atk * _atk_mult; 
            var D = _target_data.defense * _def_mult;
            var P = _move.atk;
            // Damage Formula
            var _damage = floor( ( ( ( (2 * L / 5) + 2 ) * P * (A / D) ) / 35 ) + 2 );
            _damage = floor(_damage * _type_mult);
            
            _target_data.hp = max(0, _target_data.hp - _damage);
            effect_play_hurt(_target_actor);
            if (_type_mult > 1.0) battle_log_text += " It's super effective!";
            if (_type_mult < 1.0) battle_log_text += " It's not very effective...";
            if (_move.move_name == "Mud Shot") {
                _target_data.spd_stage = clamp(_target_data.spd_stage - 1, -6, 6);
                battle_log_text = "Mud Shot hit! Speed fell!"; 
            }
            if (_move.move_name == "Poison Bite") {
                effect_play_poison(_target_actor);
            }
            break;
            
        case MOVE_TYPE.HEAL:
            var _heal_amount = _move.effect_power;
            if (is_string(_heal_amount)) _heal_amount = real(_heal_amount); 
            _user_data.hp = min(_user_data.hp + _heal_amount, _user_data.max_hp);
            if (_move.move_name == "Take a Nap") effect_play_sleep(_user_actor);
            else if (_move.move_name == "Regenerate") effect_play_hearts(_user_actor); 
            else effect_play_heal_flash(_user_actor);
            battle_log_text = _user_data.nickname + " healed!"; 
            break;
            
        case MOVE_TYPE.STAT_DEBUFF:
            if (_move.move_name == "Hiss") { 
                 effect_play_angry(_user_actor);
                 _target_data.atk_stage = clamp(_target_data.atk_stage - 1, -6, 6);
                 battle_log_text = _target_data.nickname + "'s attack fell!";
                 effect_play_stat_flash(_target_actor, "debuff");
            } 
            else if (_move.move_name == "HONK" || _move.move_name == "Squawk") {
                 effect_play_soundwave(_user_actor);
                 _target_data.def_stage = clamp(_target_data.def_stage - 1, -6, 6);
                 battle_log_text = _target_data.nickname + "'s defense fell!";
                 effect_play_stat_flash(_target_actor, "debuff");
            }
            else if (_move.move_name == "Yap") { 
                 effect_play_yap(_user_actor);
                 _target_data.atk_stage = clamp(_target_data.atk_stage - 1, -6, 6);
                 battle_log_text = _target_data.nickname + "'s attack fell!";
                 effect_play_stat_flash(_target_actor, "debuff");
            }
            else {
                _target_data.def_stage = clamp(_target_data.def_stage - 1, -6, 6);
                effect_play_stat_flash(_target_actor, "debuff"); 
                battle_log_text = _target_data.nickname + "'s defense fell!";
            }
            break;
            
        case MOVE_TYPE.STAT_BUFF:
            if (_move == global.MOVE_SYSTEM_CALL) {
                _target_data.glitch_timer = 3;
                battle_log_text = _target_data.nickname + " is corrupting data!";
                effect_play_hurt(_target_actor); 
            }
            else if (_move.move_name == "Snow Cloak") { effect_play_snow(_user_actor);
                battle_log_text = _user_data.nickname + " hid in the snow!"; } 
            else if (_move.move_name == "Zen Barrier") { effect_play_zen(_user_actor);
                battle_log_text = _user_data.nickname + " meditated! Defense rose!"; } 
            else if (_move.move_name == "Wall Climb") { effect_play_up_arrow(_user_actor);
                _user_data.spd_stage += 1; battle_log_text = _user_data.nickname + " climbed up! Speed rose!";
            } 
            else if (_move.move_name == "Tail Shed") { effect_play_tail_shed(_user_actor);
                _user_data.def_stage += 2; battle_log_text = _user_data.nickname + " shed its tail! Defense rose sharply!";
            } 
            else if (_move.move_name == "Withdraw") { effect_play_shield(_user_actor);
                _user_data.def_stage += 2; battle_log_text = _user_data.nickname + " withdrew! Defense rose sharply!";
            } 
            else if (_move.move_name == "Zoomies") { effect_play_zoomies(_user_actor);
                _user_data.spd_stage += 2; battle_log_text = _user_data.nickname + " got the zoomies! Speed rose sharply!";
            }
            else if (_move.move_name == "Fluff Puff") { effect_play_puff(_user_actor);
                _user_data.def_stage += 1; battle_log_text = _user_data.nickname + " puffed up! Defense rose!";
            }
            else if (_move.move_name == "Dust Bath") { effect_play_dust(_user_actor);
                _user_data.def_stage += 1; battle_log_text = _user_data.nickname + " rolled in dust! Defense rose!";
            }
            else if (_move.move_name == "Coil") { effect_play_coil(_user_actor);
                _user_data.atk_stage += 1; battle_log_text = _user_data.nickname + " coiled up! Attack rose!";
            }
            else if (_move.move_name == "Lazy Stance") { effect_play_lazy(_user_actor);
                _user_data.def_stage += 1; battle_log_text = _user_data.nickname + " is slacking off! Defense rose!";
            }
            else { battle_log_text = _user_data.nickname + "'s stats rose!";
            }
            break;
    }
};

// ================== NEW: WEATHER VISUALS SETUP ==================
weather_particles = [];
weather_flash_alpha = 0; // For lightning
sun_glow_timer = 0;      // For pulsing sun effect

// [FIX] Capture dimensions in local variables to prevent struct scope issues
var _win_w = window_width;
var _win_h = window_height;

// 1. Generate Rain/Storm Particles
if (global.weather_condition == "RAIN" || global.weather_condition == "STORM") {
    var _count = (global.weather_condition == "STORM") ? 100 : 60;
    
    for (var i = 0; i < _count; i++) {
        array_push(weather_particles, {
            x: irandom(_win_w),
            y: irandom(_win_h),
            speed: irandom_range(8, 12),     // Fast falling
            length: irandom_range(10, 20),   // Raindrop length
            width: irandom_range(1, 2)       // Raindrop thickness
        });
    }
}

// 2. Generate Sun "Glare" Particles (Floating dust/pollen)
if (global.weather_condition == "SUN") {
    for (var i = 0; i < 20; i++) {
        array_push(weather_particles, {
            x: irandom(_win_w),
            y: irandom(_win_h),
            speed_y: random_range(-0.2, -0.5), // Float UP slightly
            speed_x: random_range(-0.2, 0.2),  // Drift side-to-side
            size: random_range(2, 5),
            alpha: random_range(0.2, 0.6)
        });
    }
}

// 3. Generate Snow Particles (NEW)
if (global.weather_condition == "SNOW") {
    for (var i = 0; i < 50; i++) {
        array_push(weather_particles, {
            x: irandom(_win_w),
            y: irandom(_win_h),
            speed: random_range(1, 3),       // Slow fall
            size: random_range(2, 4),      
            sway_offset: random(2 * pi)      // Random start for horizontal sway
        });
    }
}
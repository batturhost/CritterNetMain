// --- scr_animal_helpers ---
// This script holds our "actor" functions

function init_animal(_animal_object, _data, _sprite_to_use) {
    _animal_object.my_data = _data;
    _animal_object.sprite_index = _sprite_to_use;
    _animal_object.home_x = _animal_object.x; _animal_object.home_y = _animal_object.y;
}

// --- REVERTED: HURT EFFECT (White Flash + Shake) ---
function effect_play_hurt(_actor_object) { 
    _actor_object.flash_alpha = 1.0; 
    _actor_object.flash_color = c_white; 
    _actor_object.shake_timer = 15; 
	
	// [SOUND] Play generic damage sound
    // We use a random pitch (0.9 to 1.1) so it doesn't sound robotic on multi-hits
    if (audio_exists(snd_damage_default)) {
        var _pitch = random_range(0.8, 1.2);
        var _snd = audio_play_sound(snd_damage_default, 10, false);
        audio_sound_pitch(_snd, _pitch);
    }
}
// --------------------------------------------------

function effect_play_lunge(_actor_object, _target_actor) {
    _actor_object.lunge_state = 1;
    _actor_object.lunge_target_x = _actor_object.home_x + ((_target_actor.x - _actor_object.x) * 0.66);
    _actor_object.lunge_target_y = _actor_object.home_y + ((_target_actor.y - _actor_object.y) * 0.66);
    _actor_object.lunge_speed = 0.1; 
}
function effect_play_bite_lunge(_actor_object, _target_actor) {
    _actor_object.lunge_state = 1;
    _actor_object.lunge_target_x = _actor_object.home_x + ((_target_actor.x - _actor_object.x) * 0.85);
    _actor_object.lunge_target_y = _actor_object.home_y + ((_target_actor.y - _actor_object.y) * 0.85);
    _actor_object.lunge_speed = 0.25; 
}
function effect_play_heal_flash(_actor_object) { _actor_object.flash_alpha = 1.0; _actor_object.flash_color = c_lime; _actor_object.shake_timer = 0;
}
function effect_play_stat_flash(_actor_object, _type = "debuff") {
    _actor_object.flash_alpha = 1.0; _actor_object.shake_timer = 0;
    if (_type == "debuff") _actor_object.flash_color = c_red; else _actor_object.flash_color = c_aqua;
}
function player_has_healthy_critters() {
    for (var i = 0; i < array_length(global.PlayerData.team); i++) { if (global.PlayerData.team[i].hp > 0) return true;
    } return false;
}

// --- HELPER TO REDUCE CODE ---
function _effect_start(_a, _type, _time) { _a.vfx_type = _type; _a.vfx_particles = [];
    _a.vfx_timer = _time; }

// --- VFX DEFINITIONS ---
function effect_play_ice(_a) { 
    _effect_start(_a, "ice", 45); 
    // [SOUND] Ice Pounce
    if (audio_exists(snd_ice_pounce)) {
        audio_play_sound(snd_ice_pounce, 10, false);
    }
}
function effect_play_snow(_a) { 
    _effect_start(_a, "snow", 90); 
    // [SOUND] Snow Cloak
    if (audio_exists(snd_snow_cloak)) {
        audio_play_sound(snd_snow_cloak, 10, false);
    }
}
function effect_play_sleep(_a) { 
    _effect_start(_a, "sleep", 60); 
    
    // [SOUND] Play Sleep Sound
    if (audio_exists(snd_sleep)) {
        audio_play_sound(snd_sleep, 10, false);
    }
}
function effect_play_water(_a) { 
    _effect_start(_a, "water", 45); 
    
    // [SOUND] Play Water Splash
    if (audio_exists(snd_water)) {
        // Randomize pitch slightly for liquid variance
        var _pitch = random_range(0.9, 1.1);
        var _snd = audio_play_sound(snd_water, 10, false);
        audio_sound_pitch(_snd, _pitch);
    }
}
function effect_play_zen(_a) { 
    _effect_start(_a, "zen", 60); 
    
    // [SOUND] Play Zen Chime
    if (audio_exists(snd_zen_meditate)) {
        // Lower pitch slightly for a "deeper" meditation feel
        var _pitch = random_range(0.95, 1.0);
        var _snd = audio_play_sound(snd_zen_meditate, 10, false);
        audio_sound_pitch(_snd, _pitch);
    }
}
function effect_play_soundwave(_a) { _effect_start(_a, "soundwave", 60); }
function effect_play_feathers(_a) { _effect_start(_a, "feathers", 45); }
function effect_play_angry(_a) { _effect_start(_a, "angry", 60);
}
function effect_play_tongue(_a) { _effect_start(_a, "tongue", 30); }
function effect_play_up_arrow(_a) { _effect_start(_a, "up_arrow", 60); }
function effect_play_tail_shed(_a) { _effect_start(_a, "tail_shed", 60);
}
function effect_play_shield(_a) { _effect_start(_a, "shield", 60); }
function effect_play_shockwave(_a) { _effect_start(_a, "shockwave", 45); }
function effect_play_bite(_a) { _effect_start(_a, "bite", 20);
}
function effect_play_hearts(_a) { _effect_start(_a, "hearts", 60); }
function effect_play_slap(_a) { _effect_start(_a, "slap", 15); }
function effect_play_yap(_a) { _effect_start(_a, "yap", 45);
}
function effect_play_zoomies(_a) { _effect_start(_a, "zoomies", 60); }
function effect_play_puff(_a) { _effect_start(_a, "puff", 60); }
function effect_play_bamboo(_a) { _effect_start(_a, "bamboo", 45);
}
function effect_play_lazy(_a) { _effect_start(_a, "lazy", 60); }

// Complex ones needing extra params
function effect_play_mud(_a, _t) { _effect_start(_a, "mud", 30);
    _a.vfx_target_dx = _t.x - _a.x; _a.vfx_target_dy = _t.y - _a.y; }
function effect_play_dive(_a, _t) { _effect_start(_a, "dive", 0); _a.vfx_state = 0;
    _a.vfx_target_x = _t.x; _a.vfx_target_y = _t.y; }
function effect_play_roll(_a, _t) { effect_play_lunge(_a, _t); _effect_start(_a, "roll", 0);
}

// Aliases
function effect_play_scratch(_a) { effect_play_lunge(_a, _a); _a.flash_alpha=1.0; _a.flash_color = c_white; }
function effect_play_dust(_a) { effect_play_puff(_a); } 
function effect_play_poison(_a) { effect_play_bite(_a);
    _a.flash_color = c_purple; }
function effect_play_coil(_a) { _a.flash_alpha=1.0; _a.flash_color = c_yellow; }


/// @function play_critter_cry(_animal_data)
/// @desc Plays the cry sound for the given animal struct if the sound exists.
function play_critter_cry(_animal_data) {
    if (!is_struct(_animal_data)) return;
    
    // 1. Convert name to snake_case format (e.g., "Arctic Fox" -> "arctic_fox")
    var _name = string_lower(_animal_data.animal_name);
    _name = string_replace_all(_name, " ", "_");
    _name = string_replace_all(_name, "-", "_"); // Handle "Snub-Nosed"
    
    // 2. Construct the expected asset name
    var _sound_name = "snd_cry_" + _name;
    
    // 3. Find and play
    var _snd = asset_get_index(_sound_name);
    if (_snd > -1) {
        audio_play_sound(_snd, 10, false);
    } else {
        // Optional: Play a generic fallback if specific cry is missing
        // if (audio_exists(snd_cry_generic)) audio_play_sound(snd_cry_generic, 10, false);
    }
}
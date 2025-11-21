// --- AnimalData Script ---
// Constructor for critter data

function AnimalData(_name, _hp, _atk, _def, _spd, _lvl, _spr_idle, _spr_back, _spr_move, _moves, _blurb, _size, _type = "BEAST") constructor {
    animal_name = _name;
    base_hp = _hp;
    base_atk = _atk;
    base_def = _def;
    base_spd = _spd;
    level = _lvl;
    
    // Sprites
    sprite_idle = _spr_idle;
    sprite_idle_back = _spr_back;
    sprite_signature_move = _spr_move;
    
    // Data
    moves = _moves;
    blurb = _blurb;
    size = _size;
    element_type = _type; // BEAST, NATURE, HYDRO, AERO, TOXIC
    
    // Battle Stats (Calculated)
    max_hp = 0;
    hp = 0;
    atk = 0;
    defense = 0;
    speed = 0;
    xp = 0;
    next_level_xp = 100;
    
    // Battle State
    atk_stage = 0;
    def_stage = 0;
    spd_stage = 0;
    glitch_timer = 0;
    
    // Metadata
    nickname = _name;
    gender = 0; // 0: M, 1: F
    
    // ================== NEW: PP TRACKING ==================
    // Create an array to track current PP for each move
    // Default to max_pp when created
    move_pp = array_create(array_length(moves), 0);
    for (var i = 0; i < array_length(moves); i++) {
        move_pp[i] = moves[i].max_pp;
    }
    // ======================================================
}

function recalculate_stats(_animal) {
    // Simple Stat Formula: (Base * 2 * Level / 100) + 10 + Level
    _animal.max_hp = floor((_animal.base_hp * 2 * _animal.level / 100) + 10 + _animal.level);
    _animal.atk = floor((_animal.base_atk * 2 * _animal.level / 100) + 5);
    _animal.defense = floor((_animal.base_def * 2 * _animal.level / 100) + 5);
    _animal.speed = floor((_animal.base_spd * 2 * _animal.level / 100) + 5);
    
    // Full heal on recalc (optional, useful for leveling up)
    if (_animal.hp == 0) _animal.hp = _animal.max_hp; 
}

function get_stat_multiplier(_stage) {
    if (_stage >= 0) return (2 + _stage) / 2;
    else return 2 / (2 + abs(_stage));
}
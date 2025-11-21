// --- MoveData Script ---
// Constructor for moves

// UPDATED: Added _pp argument explicitly in the correct order
function MoveData(_name, _atk, _acc, _desc, _effect_desc, _type, _element = "BEAST", _pp = 20, _effect_power = 0) constructor {
    move_name = _name;
    atk = _atk;
    accuracy = _acc;
    description = _desc;
    effect_description = _effect_desc;
    move_type = _type;     // DAMAGE, HEAL, STAT_BUFF, STAT_DEBUFF
    element = _element;    // BEAST, NATURE, HYDRO, AERO, TOXIC
    
    // PP System
    max_pp = _pp;
    
    effect_power = _effect_power;
}

// Enum for Move Types
enum MOVE_TYPE {
    DAMAGE,
    HEAL,
    STAT_BUFF,
    STAT_DEBUFF
}
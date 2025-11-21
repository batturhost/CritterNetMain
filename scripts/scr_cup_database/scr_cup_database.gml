// --- Cup Database Script ---
// This file defines the "story mode" progression

/// @function OpponentData(_name, _pfp_sprite, _team_keys, _team_levels, _lose_message, _is_glitched = false)
function OpponentData(_name, _pfp_sprite, _team_keys, _team_levels, _lose_message, _is_glitched = false) constructor {
    name = _name;
    profile_pic_sprite = _pfp_sprite;
    critter_keys = _team_keys;
    critter_levels = _team_levels;
    lose_message = _lose_message;
    is_glitched = _is_glitched; // Is this an "unfair" glitched opponent?
}

/// @function CupData(_name, _level_cap, _opponents)
function CupData(_name, _level_cap, _opponents) constructor {
    cup_name = _name;
    level_cap = _level_cap;
    opponents = _opponents; 
}


/// @function init_cup_database()
/// @desc Creates all Cups and stores them in a global variable
function init_cup_database() {
    
    global.CupDatabase = []; // This array will hold all our cups in order

    // --- 1. BRONZE CUP (Cup Index 0) ---
    var _bronze_opponents = [
        
        // Opponent 0 (Easy)
        // WAS: spr_avatar_user_01
        new OpponentData( "RabbitLuvr", spr_1, [ "rabbit" ], [ 8 ], "U got lucky... my rabbit is usually way faster." ),
        
        // Opponent 1 (Easy)
        // WAS: spr_avatar_user_02
        new OpponentData( "GeckoGamer", spr_2, [ "gecko" ], [ 10 ], "My connection must be lagging." ),
        
        // Opponent 2 (Medium)
        // WAS: spr_avatar_user_03
        new OpponentData( "CatAttack", spr_3, [ "cat", "chinchilla" ], [ 10, 11 ], "lol whatever. my chinchilla was bugged. reported." ),
        
        // Opponent 3 (Medium)
        // WAS: spr_avatar_user_01
        new OpponentData( "SqueakSquad", spr_4, [ "pomeranian", "raccoon" ], [ 12, 12 ], "My critters didn't listen to me! Unfair!" ),
        
        // Opponent 4 ("THE WALL" / BOSS)
        // WAS: spr_avatar_user_03
        new OpponentData(
            "BronzeMod",
            spr_5, // Using a different one for the boss
            [ "hedgehog", "koala", "snake" ], 
            [ 14, 14, 16 ], 
            "...Protocol violation detected. Account flagged.",
            true 
        )
    ];
    
    var _bronze_cup = new CupData( "Bronze Cup", 15, _bronze_opponents );
    array_push(global.CupDatabase, _bronze_cup);
}
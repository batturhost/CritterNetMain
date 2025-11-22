// --- Clean Up Event ---
// This runs when the battle ends, the window closes, or the room changes.

// 1. Reset Stat Stages for the entire team
// This prevents "infinite buff" exploits.
if (variable_global_exists("PlayerData") && variable_struct_exists(global.PlayerData, "team")) {
    for (var i = 0; i < array_length(global.PlayerData.team); i++) {
        var _critter = global.PlayerData.team[i];
        
        // Reset Battle Stages
        _critter.atk_stage = 0;
        _critter.def_stage = 0;
        _critter.spd_stage = 0;
        
        // Clear Status Effects
        _critter.glitch_timer = 0;
    }
}

// 2. Ensure Actors are destroyed (Garbage Collection)
// Just in case they weren't destroyed by the Step event logic
if (variable_instance_exists(id, "player_actor") && instance_exists(player_actor)) {
    instance_destroy(player_actor);
}
if (variable_instance_exists(id, "enemy_actor") && instance_exists(enemy_actor)) {
    instance_destroy(enemy_actor);
}	
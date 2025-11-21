// --- scr_level_helpers ---
// Helper scripts for level and XP management

// Function to calculate XP needed for next level
function get_xp_for_next_level(_level) {
    // Simple formula: Level^3 (standard RPG curve)
    return power(_level, 3);
}

// Function to add XP and handle level ups
function add_xp(_critter, _amount) {
    _critter.xp += _amount;
    
    // Check for level up
    var _xp_needed = get_xp_for_next_level(_critter.level + 1);
    
    while (_critter.xp >= _xp_needed) {
        _critter.level += 1;
        _critter.xp -= _xp_needed; // Carry over excess XP
        
        // Recalculate stats on level up
        // NOTE: recalculate_stats is defined in AnimalData.gml
        recalculate_stats(_critter);
        
        // Calculate next threshold
        _xp_needed = get_xp_for_next_level(_critter.level + 1);
        _critter.next_level_xp = _xp_needed;
    }
}

// --- THAT'S IT! DUPLICATES REMOVED ---
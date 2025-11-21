// --- scr_critter_config.gml ---
// Returns a multiplier (e.g., 1.0 = normal, 0.5 = half size, 2.0 = double size)
// Now accepts _is_player (boolean) to distinguish between Back and Front sprites.

function get_critter_scale_config(_animal_name, _is_player) {
    switch (_animal_name) {
        
        // --- BIG CRITTERS (Scale Down) ---
        case "Capybara":
            if (_is_player) return 0.8; // Back Sprite scale
            else return 0.8;            // Front Sprite scale
            
        case "Pomeranian":
            if (_is_player) return 0.8;
            else return 0.8;
            
		case "Goose":
            if (_is_player) return 0.7;
            else return 0.7;
        
        // --- SMALL CRITTERS (Scale Down/Up) ---
        case "Rabbit":      
            if (_is_player) return 0.7;
            else return 0.7;
		case "Axolotl":
			if (_is_player) return 0.7;
			else return 1.0;
        
        // Example of differing scales:
        // case "Dragon": 
        //     if (_is_player) return 1.2; // Make back sprite huge
        //     else return 0.8;            // Make front sprite smaller to fit
        
        // --- DEFAULT (Everyone else) ---
        default: return 1.0;
    }
}
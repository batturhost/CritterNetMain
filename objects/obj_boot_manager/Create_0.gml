// --- Create Event ---

// =================================================================
// DEV TOGGLE: SAVE SYSTEM
// Set to FALSE to force the game to always start at the Installer.
// Set to TRUE for normal gameplay (Load save if exists).
global.ENABLE_SAVE_SYSTEM = false; 
// =================================================================

init_database(); 
init_cup_database(); 
randomize();

// ... (Rest of your existing Create Event code) ...

// --- Create Event ---
init_database(); 
init_cup_database(); 
randomize();

// --- GLOBAL VARS ---
global.bargain_offered = false; 
global.unread_messages = []; 
global.trapdoor_unlocked = false;

// ================== NEW GLOBAL LOCK ==================
global.dragged_window = noone; // Stores the ID of the window currently being dragged
// =====================================================

draw_set_font(fnt_vga); 
current_line = 0; 
text_speed = 45; 

text_lines = [
    "CritterNet OS v1.0 (c) 1998, CNet Inc.",
    "System Memory Check: 128 MB OK",
    "Initializing Hardware I/O...",
    "Loading 'CNet_Kernel.dll'...",
    "Loading 'VMM.vxd'...",
    "Connecting to ARPANET backbone...",
    "Initializing virtual modem...",
    "** MODEM HANDSHKE SOUND PLAYS HERE **",
    "Connection Established. Welcome to the Net.",
    "Ready."
];

alarm[0] = text_speed; 

// --- BUTTONS ---
btn_x1 = 20;
btn_y1 = 20 + (array_length(text_lines) * 20) + 20;
btn_w = 220;
btn_h = 30;
btn_x2 = btn_x1 + btn_w;
btn_y2 = btn_y1 + btn_h;
btn_hovering = false;

btn_continue_x1 = btn_x2 + 10;
btn_continue_y1 = btn_y1;
btn_continue_w = 120;
btn_continue_h = 30;
btn_continue_x2 = btn_continue_x1 + btn_continue_w;
btn_continue_y2 = btn_continue_y1 + btn_continue_h;
btn_continue_hovering = false;
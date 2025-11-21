// --- Create Event ---

// ** THIS IS THE "CRASH-PROOF" DEBUG CHECK **
// 1. Check if the "save file" exists.
if (!variable_global_exists("PlayerData")) {
    // DEBUG MODE SETUP
    if (!variable_global_exists("bestiary")) init_database();
    if (!variable_global_exists("CupDatabase")) init_cup_database();
    global.PlayerData = {
        name: "DEBUG_USER", gender: 0,
        profile_pic: spr_1, 
        current_cup_index: 0, current_opponent_index: 0,
        team: [], pc_box: [], collection_progress: {},
        starter_key: "arctic_fox", starter_name: "Arctic Fox", starter_nickname: "Debug Fox"
    };
    var _starter_critter = new AnimalData(
        global.bestiary.arctic_fox.animal_name,
        global.bestiary.arctic_fox.base_hp, global.bestiary.arctic_fox.base_atk,
        global.bestiary.arctic_fox.base_def, global.bestiary.arctic_fox.base_spd,
        100, 
        global.bestiary.arctic_fox.sprite_idle, global.bestiary.arctic_fox.sprite_idle_back,
        global.bestiary.arctic_fox.sprite_signature_move, global.bestiary.arctic_fox.moves,
        global.bestiary.arctic_fox.blurb, global.bestiary.arctic_fox.size
    );
    _starter_critter.nickname = "Debug Fox";
    recalculate_stats(_starter_critter);
    array_push(global.PlayerData.team, _starter_critter);
    
    // Add test PC critters
    var _all_keys = variable_struct_get_names(global.bestiary);
    for (var i = 0; i < 5; i++) {
        var _key = _all_keys[irandom(array_length(_all_keys)-1)];
        var _db = global.bestiary[$ _key];
        var _c = new AnimalData(_db.animal_name, _db.base_hp, _db.base_atk, _db.base_def, _db.base_spd, irandom_range(3,7), _db.sprite_idle, _db.sprite_idle_back, _db.sprite_signature_move, _db.moves, _db.blurb, _db.size);
        _c.nickname = _db.animal_name; _c.gender = irandom(1);
        recalculate_stats(_c);
        array_push(global.PlayerData.pc_box, _c);
    }
    
    global.tutorial_complete = true;
}

if (!variable_global_exists("tutorial_complete")) {
    global.tutorial_complete = false;
}

// 2. Clock Setup
time_string = "";
alarm[0] = 60;
// ================== START MENU & TASKBAR VARS ==================
start_menu_open = false;
start_hover_index = -1;

// Menu Layout
menu_w = 280;
menu_h = 260; 
menu_item_h = 35;

// Menu Items Array: [ "Label", "Action_String" ]
menu_items = [
    ["CritterNet Browser", "browser"],
    ["Bestiary", "pokedex"],
    ["Storage System", "pc"],
    ["Messenger", "messenger"],
    ["Save Game", "save"],    // <--- NEW ITEM
    ["Shut Down...", "shutdown"]
];

// (Also increase menu_h slightly if needed to fit the new item)
menu_h = 295; // Increased from 260 to fit one more item
// Define list of apps to check for the Taskbar
// [Object, Label]
applications_list = [
    [obj_browser_manager, "Browser"],
    [obj_pokedex_manager, "Bestiary"],
    [obj_pc_manager, "Storage"],
    [obj_messenger_manager, "Messenger"],
    [obj_trapdoor_manager, "TRAPDOOR"],
    [obj_battle_manager, "Battle"]
];
// Depth Manager: Used to bring windows to front
global.top_window_depth = -100;

// ================== NEW: CHECK FOR DEBUG BATTLE FLAG ==================
if (variable_global_exists("open_debug_battle") && global.open_debug_battle) {
    global.open_debug_battle = false; // Reset flag so it doesn't open every time we visit Hub
    
    if (!instance_exists(obj_debug_battle_setup)) {
        instance_create_layer(0, 0, "Instances", obj_debug_battle_setup);
    }
}
// ======================================================================
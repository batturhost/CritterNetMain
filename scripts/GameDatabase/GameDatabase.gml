// --- GameDatabase Script ---
// This function builds the entire Bestiary and Moveset

function init_database() {
    
    // ========================================================================
    // 0. DATA CLASS CONSTANTS
    // ========================================================================
    global.TYPE_BEAST   = "BEAST";  // .exe
    global.TYPE_NATURE  = "NATURE"; // .bio
    global.TYPE_HYDRO   = "HYDRO";  // .liq
    global.TYPE_AERO    = "AERO";   // .net
    global.TYPE_TOXIC   = "TOXIC";  // .bin
    global.TYPE_NONE    = "NONE";   

    // ========================================================================
    // 1. DEFINE MOVES (FIXED ARGUMENT ORDER)
    // Constructor: (_name, _atk, _acc, _desc, _eff_desc, _type, _ELEMENT, _PP, _EFF_POWER)
    // ========================================================================
    
    // --- BEAST ---
    global.GENERIC_MOVE_LUNGE = new MoveData("Lunge", 30, 100, "Basic lunge.", "Simple hit.", MOVE_TYPE.DAMAGE, global.TYPE_BEAST, 20, 0);
    global.GENERIC_MOVE_AGITATE = new MoveData("Agitate", 0, 100, "Agitate.", "Lowers Def.", MOVE_TYPE.STAT_DEBUFF, global.TYPE_BEAST, 15, -1);
    
    var m_tackle    = new MoveData("Tackle", 35, 100, "Slam.", "Physical dmg.", MOVE_TYPE.DAMAGE, global.TYPE_BEAST, 20, 0);
    var m_scratch   = new MoveData("Scratch", 40, 100, "Scratch.", "Fast hit.", MOVE_TYPE.DAMAGE, global.TYPE_BEAST, 20, 0);
    var m_pounce    = new MoveData("Pounce", 45, 90, "Pounce.", "Strong hit.", MOVE_TYPE.DAMAGE, global.TYPE_BEAST, 15, 0);
    var m_roll      = new MoveData("Playful Roll", 40, 100, "Roll.", "Physical.", MOVE_TYPE.DAMAGE, global.TYPE_BEAST, 15, 0);
    var m_yap       = new MoveData("Yap", 0, 100, "Bark.", "Lowers Atk.", MOVE_TYPE.STAT_DEBUFF, global.TYPE_BEAST, 15, -1);
    var m_growl     = new MoveData("Growl", 0, 100, "Growl.", "Lowers Atk.", MOVE_TYPE.STAT_DEBUFF, global.TYPE_BEAST, 20, -1);
    var m_fluff     = new MoveData("Fluff Puff", 0, 100, "Puff up.", "Raises Def.", MOVE_TYPE.STAT_BUFF, global.TYPE_BEAST, 10, 1);
    var m_snatch    = new MoveData("Snatch", 40, 100, "Steal.", "Fast hit.", MOVE_TYPE.DAMAGE, global.TYPE_BEAST, 15, 0);
    var m_fur_swipe = new MoveData("Fur Swipe", 40, 100, "Swipe.", "Fast hit.", MOVE_TYPE.DAMAGE, global.TYPE_BEAST, 15, 0);
    var m_pom_strike = new MoveData("Pom-Pom Strike", 50, 100, "Barrage.", "Strong hit.", MOVE_TYPE.DAMAGE, global.TYPE_BEAST, 5, 0);
    var m_snap      = new MoveData("Snap", 40, 100, "Bite.", "Fast hit.", MOVE_TYPE.DAMAGE, global.TYPE_BEAST, 15, 0); 

    // --- HYDRO ---
    var m_hydro     = new MoveData("Hydro Headbutt", 45, 100, "Wet headbutt.", "Water dmg.", MOVE_TYPE.DAMAGE, global.TYPE_HYDRO, 15, 0);
    var m_ice_pounce = new MoveData("Ice Pounce", 55, 95, "Freezing leap.", "Massive dmg.", MOVE_TYPE.DAMAGE, global.TYPE_HYDRO, 10, 0);
    var m_snow_cloak = new MoveData("Snow Cloak", 0, 100, "Hide in snow.", "Raises Def.", MOVE_TYPE.STAT_BUFF, global.TYPE_HYDRO, 10, 1);
    var m_gill      = new MoveData("Gill Slap", 40, 100, "Squishy slap.", "Fast hit.", MOVE_TYPE.DAMAGE, global.TYPE_HYDRO, 15, 0);
    var m_ice_slide = new MoveData("Ice Slide", 40, 100, "Slide.", "Ice hit.", MOVE_TYPE.DAMAGE, global.TYPE_HYDRO, 15, 0);
    var m_water_jet = new MoveData("Water Jet", 40, 100, "Jet.", "Water hit.", MOVE_TYPE.DAMAGE, global.TYPE_HYDRO, 15, 0);
    var m_belly     = new MoveData("Belly Slide", 40, 100, "Slide.", "Ice hit.", MOVE_TYPE.DAMAGE, global.TYPE_HYDRO, 15, 0);

    // --- NATURE ---
    var m_bamboo    = new MoveData("Bamboo Bite", 45, 100, "Chomp.", "Strong bite.", MOVE_TYPE.DAMAGE, global.TYPE_NATURE, 10, 0);
    var m_mud       = new MoveData("Mud Shot", 20, 95, "Mud.", "Dmg + Slow.", MOVE_TYPE.DAMAGE, global.TYPE_NATURE, 15, 0);
    var m_dust      = new MoveData("Dust Bath", 0, 100, "Ash roll.", "Raises Def.", MOVE_TYPE.STAT_BUFF, global.TYPE_NATURE, 10, 1);
    var m_dig       = new MoveData("Dig", 40, 100, "Dig.", "Ground hit.", MOVE_TYPE.DAMAGE, global.TYPE_NATURE, 10, 0);
    var m_shell     = new MoveData("Shell Bash", 50, 100, "Ram.", "Heavy hit.", MOVE_TYPE.DAMAGE, global.TYPE_NATURE, 10, 0);
    var m_withdraw  = new MoveData("Withdraw", 0, 100, "Retract.", "Raises Def++.", MOVE_TYPE.STAT_BUFF, global.TYPE_NATURE, 10, 2);
    var m_tongue    = new MoveData("Sticky Tongue", 40, 100, "Lash.", "Fast hit.", MOVE_TYPE.DAMAGE, global.TYPE_NATURE, 20, 0);
    var m_climb     = new MoveData("Wall Climb", 0, 100, "Climb.", "Raises Spd.", MOVE_TYPE.STAT_BUFF, global.TYPE_NATURE, 10, 1);
    var m_nap       = new MoveData("Take a Nap", 0, 100, "Sleep.", "Heals 50.", MOVE_TYPE.HEAL, global.TYPE_NATURE, 5, 50);
    var m_regen     = new MoveData("Regenerate", 0, 100, "Regrow.", "Heals 50.", MOVE_TYPE.HEAL, global.TYPE_NATURE, 5, 50);
    var m_zen       = new MoveData("Zen Barrier", 0, 100, "Meditate.", "Raises Def.", MOVE_TYPE.STAT_BUFF, global.TYPE_NATURE, 10, 1);
    var m_lazy      = new MoveData("Lazy Stance", 0, 100, "Slack off.", "Raises Def.", MOVE_TYPE.STAT_BUFF, global.TYPE_NATURE, 10, 1);
    var m_euc       = new MoveData("Eucalyptus Eat", 0, 100, "Eat leaves.", "Heals 40.", MOVE_TYPE.HEAL, global.TYPE_NATURE, 5, 40);
    var m_shed      = new MoveData("Tail Shed", 0, 100, "Drop tail.", "Raises Def++.", MOVE_TYPE.STAT_BUFF, global.TYPE_NATURE, 5, 2);
    var m_snap      = new MoveData("Snap", 40, 100, "Bite.", "Fast hit.", MOVE_TYPE.DAMAGE, global.TYPE_BEAST, 15, 0); 
    var m_spiky     = new MoveData("Spiky Shield", 0, 100, "Curl.", "Raises Def.", MOVE_TYPE.STAT_BUFF, global.TYPE_NATURE, 10, 1);

    // --- AERO ---
    var m_honk      = new MoveData("HONK", 0, 100, "Noise.", "Lowers Def.", MOVE_TYPE.STAT_DEBUFF, global.TYPE_AERO, 10, -1);
    var m_squawk    = new MoveData("Squawk", 0, 100, "Cry.", "Lowers Def.", MOVE_TYPE.STAT_DEBUFF, global.TYPE_AERO, 15, -1);
    var m_wing      = new MoveData("Wing Smack", 45, 100, "Flap.", "Wing hit.", MOVE_TYPE.DAMAGE, global.TYPE_AERO, 15, 0);
    var m_dive      = new MoveData("Dive", 50, 90, "Aerial strike.", "Heavy hit.", MOVE_TYPE.DAMAGE, global.TYPE_AERO, 5, 0);
    var m_zoom      = new MoveData("Zoomies", 0, 100, "Run circles.", "Raises Spd++.", MOVE_TYPE.STAT_BUFF, global.TYPE_AERO, 5, 2); 
    var m_glide     = new MoveData("Glide", 40, 100, "Glide.", "Aerial hit.", MOVE_TYPE.DAMAGE, global.TYPE_AERO, 15, 0);
    var m_whap      = new MoveData("Branch Whap", 40, 100, "Thwack.", "Physical hit.", MOVE_TYPE.DAMAGE, global.TYPE_AERO, 15, 0);
    var m_hop       = new MoveData("Quick Hop", 40, 100, "Hop.", "Fast hit.", MOVE_TYPE.DAMAGE, global.TYPE_AERO, 15, 0);

    // --- TOXIC ---
    var m_poison    = new MoveData("Poison Bite", 45, 100, "Venom.", "Toxic hit.", MOVE_TYPE.DAMAGE, global.TYPE_TOXIC, 10, 0);
    var m_coil      = new MoveData("Coil", 0, 100, "Tighten.", "Raises Atk.", MOVE_TYPE.STAT_BUFF, global.TYPE_TOXIC, 10, 1); 
    var m_hiss      = new MoveData("Hiss", 0, 100, "Hiss.", "Lowers Atk.", MOVE_TYPE.STAT_DEBUFF, global.TYPE_TOXIC, 15, -1);
    global.MOVE_SYSTEM_CALL = new MoveData("System_Call", 0, 100, "Corrupt.", "Glitched status.", MOVE_TYPE.STAT_BUFF, global.TYPE_TOXIC, 5, 99);


    // ========================================================================
    // 2. DEFINE THE BESTIARY
    // ========================================================================
    global.bestiary = {};

    // --- HYDRO ---
    global.bestiary.arctic_fox = new AnimalData("Arctic Fox", 75, 115, 60, 145, 5, spr_arctic_fox_idle, spr_arctic_fox_idle_back, spr_arctic_fox_idle, [ global.GENERIC_MOVE_LUNGE, m_snow_cloak, m_ice_pounce ], "Native to the Arctic.", "Avg. Size: 3.5 kg", global.TYPE_HYDRO);
    global.bestiary.capybara = new AnimalData("Capybara", 190, 10, 140, 20, 5, spr_capybara_idle, spr_capybara_idle_back, spr_capybara_idle, [ m_hydro, m_zen, m_nap ], "Large, calm semi-aquatic rodent.", "Avg. Size: 45 kg", global.TYPE_HYDRO);
    global.bestiary.axolotl = new AnimalData("Axolotl", 150, 50, 100, 40, 5, spr_axolotl_idle, spr_axolotl_idle_back, spr_axolotl_idle, [ m_mud, m_regen, m_gill ], "Regenerates limbs.", "Avg. Size: 0.2 kg", global.TYPE_HYDRO);
    global.bestiary.harp_seal = new AnimalData("Harp Seal", 170, 70, 110, 60, 5, spr_harp_seal_idle, spr_harp_seal_idle_back, spr_harp_seal_idle, [ m_ice_slide, m_nap, m_tackle ], "Earless seal.", "Avg. Size: 140 kg", global.TYPE_HYDRO);
    global.bestiary.otter = new AnimalData("Otter", 90, 100, 80, 140, 5, spr_otter_idle, spr_otter_idle_back, spr_otter_idle, [ m_water_jet, m_tackle, global.GENERIC_MOVE_AGITATE ], "Semiaquatic mammal.", "Avg. Size: 10 kg", global.TYPE_HYDRO);
    global.bestiary.penguin = new AnimalData("Penguin", 140, 80, 110, 80, 5, spr_penguin_idle, spr_penguin_idle_back, spr_penguin_idle, [ m_belly, m_ice_slide, m_nap ], "Flightless bird.", "Avg. Size: 15 kg", global.TYPE_HYDRO);

    // --- NATURE ---
    global.bestiary.panda = new AnimalData("Panda", 160, 90, 120, 40, 5, spr_panda_idle, spr_panda_idle_back, spr_panda_idle, [ m_roll, m_bamboo, m_lazy ], "Large bear native to China.", "Avg. Size: 100 kg", global.TYPE_NATURE);
    global.bestiary.box_turtle = new AnimalData("Box Turtle", 120, 40, 200, 20, 5, spr_box_turtle_idle, spr_box_turtle_idle_back, spr_box_turtle_idle, [ m_shell, m_withdraw, m_snap ], "Turtle with a hinged domed shell.", "Avg. Size: 0.5 kg", global.TYPE_NATURE);
    global.bestiary.gecko = new AnimalData("Gecko", 80, 70, 70, 160, 5, spr_gecko_idle, spr_gecko_idle_back, spr_gecko_idle, [ m_tongue, m_climb, m_shed ], "Lizard with sticky toe pads.", "Avg. Size: 0.05 kg", global.TYPE_NATURE);
    global.bestiary.koala = new AnimalData("Koala", 160, 60, 110, 30, 5, spr_koala_idle, spr_koala_idle_back, spr_koala_idle, [ m_euc, global.GENERIC_MOVE_AGITATE, m_tackle ], "Arboreal marsupial.", "Avg. Size: 9 kg", global.TYPE_NATURE);
    global.bestiary.hedgehog = new AnimalData("Hedgehog", 120, 70, 150, 60, 5, spr_hedgehog_idle, spr_hedgehog_idle_back, spr_hedgehog_idle, [ m_tackle, m_spiky, global.GENERIC_MOVE_AGITATE ], "Spiny mammal.", "Avg. Size: 0.8 kg", global.TYPE_NATURE);
    global.bestiary.desert_rain_frog = new AnimalData("Desert Rain Frog", 100, 40, 80, 30, 5, spr_desert_rain_frog_idle, spr_desert_rain_frog_idle_back, spr_desert_rain_frog_idle, [ m_tackle, global.GENERIC_MOVE_AGITATE, m_growl ], "Small burrowing frog.", "Avg. Size: 0.01 kg", global.TYPE_NATURE);
    global.bestiary.chinchilla = new AnimalData("Chinchilla", 70, 60, 80, 190, 5, spr_chinchilla_idle, spr_chinchilla_idle_back, spr_chinchilla_idle, [ global.GENERIC_MOVE_LUNGE, m_dust, global.GENERIC_MOVE_AGITATE ], "Rodent with incredibly soft fur.", "Avg. Size: 0.6 kg", global.TYPE_NATURE);

    // --- AERO ---
    global.bestiary.goose = new AnimalData("Goose", 100, 70, 70, 70, 5, spr_goose_idle, spr_goose_idle_back, spr_goose_idle, [ m_wing, m_hiss, m_honk ], "Aggressive waterfowl.", "Avg. Size: 4.0 kg", global.TYPE_AERO);
    global.bestiary.seagull = new AnimalData("Seagull", 90, 120, 70, 150, 5, spr_seagull_idle, spr_seagull_idle_back, spr_seagull_idle, [ m_dive, m_wing, m_squawk ], "Coastal bird.", "Avg. Size: 1.0 kg", global.TYPE_AERO);
    global.bestiary.sugar_glider = new AnimalData("Sugar Glider", 70, 80, 60, 190, 5, spr_sugar_glider_idle, spr_sugar_glider_idle_back, spr_sugar_glider_idle, [ m_tackle, m_glide, global.GENERIC_MOVE_AGITATE ], "Nocturnal possum.", "Avg. Size: 0.12 kg", global.TYPE_AERO);
    global.bestiary.rabbit = new AnimalData("Rabbit", 70, 70, 60, 200, 5, spr_rabbit_idle, spr_rabbit_idle_back, spr_rabbit_idle, [ m_tackle, m_hop, global.GENERIC_MOVE_AGITATE ], "Small mammal with long ears.", "Avg. Size: 1.5 kg", global.TYPE_AERO);
    global.bestiary.snub_nosed_monkey = new AnimalData("Snub-Nosed Monkey", 100, 110, 80, 130, 5, spr_snub_nosed_monkey_idle, spr_snub_nosed_monkey_idle_back, spr_snub_nosed_monkey_idle, [ m_whap, global.GENERIC_MOVE_AGITATE, m_scratch ], "Old World monkey.", "Avg. Size: 10 kg", global.TYPE_AERO);

    // --- BEAST ---
    global.bestiary.pomeranian = new AnimalData("Pomeranian", 70, 90, 60, 170, 5, spr_pomeranian_idle, spr_pomeranian_idle_back, spr_pomeranian_idle, [ m_yap, m_zoom, m_fluff ], "Small dog with a fluffy coat.", "Avg. Size: 2.5 kg", global.TYPE_BEAST);
    global.bestiary.cat = new AnimalData("Cat", 90, 110, 80, 160, 5, spr_cat_idle, spr_cat_idle_back, spr_cat_idle, [ global.GENERIC_MOVE_LUNGE, global.GENERIC_MOVE_AGITATE, m_scratch ], "Small carnivorous mammal.", "Avg. Size: 4.5 kg", global.TYPE_BEAST);
    global.bestiary.meerkat = new AnimalData("Meerkat", 70, 120, 60, 160, 5, spr_meerkat_idle, spr_meerkat_idle_back, spr_meerkat_idle, [ m_tackle, m_dig, m_scratch ], "Small mongoose.", "Avg. Size: 0.7 kg", global.TYPE_BEAST);
    global.bestiary.red_panda = new AnimalData("Red Panda", 110, 90, 80, 120, 5, spr_red_panda_idle, spr_red_panda_idle_back, spr_red_panda_idle, [ m_tackle, m_bamboo, m_growl ], "Arboreal mammal.", "Avg.Size: 5 kg", global.TYPE_BEAST);
    global.bestiary.sable = new AnimalData("Sable", 80, 110, 70, 170, 5, spr_sable_idle, spr_sable_idle_back, spr_sable_idle, [ m_tackle, m_fur_swipe, global.GENERIC_MOVE_AGITATE ], "Prized for fur.", "Avg. Size: 1.3 kg", global.TYPE_BEAST);

    // --- TOXIC ---
    global.bestiary.snake = new AnimalData("Snake", 80, 140, 70, 140, 5, spr_snake_idle, spr_snake_idle_back, spr_snake_idle, [ m_hiss, m_coil, m_poison ], "Legless carnivorous reptile.", "Avg. Size: Varies", global.TYPE_TOXIC);
    global.bestiary.raccoon = new AnimalData("Raccoon", 100, 100, 100, 100, 5, spr_raccoon_idle, spr_raccoon_idle_back, spr_raccoon_idle, [ m_snatch, m_scratch, m_tackle ], "Dexterous mammal.", "Avg. Size: 7 kg", global.TYPE_TOXIC);
}

// ========================================================================
// 3. HELPER FUNCTION: GET TYPE EFFECTIVENESS MULTIPLIER
// ========================================================================
function get_type_effectiveness(_atk, _def) {
    if (_atk == global.TYPE_NONE || _def == global.TYPE_NONE) return 1.0;
    
    // Super Effective (2.0x)
    if (_atk == global.TYPE_HYDRO && _def == global.TYPE_BEAST) return 2.0;
    if (_atk == global.TYPE_BEAST && _def == global.TYPE_NATURE) return 2.0;
    if (_atk == global.TYPE_NATURE && _def == global.TYPE_AERO) return 2.0;
    if (_atk == global.TYPE_AERO && _def == global.TYPE_TOXIC) return 2.0;
    if (_atk == global.TYPE_TOXIC && _def == global.TYPE_HYDRO) return 2.0;
    
    // Not Very Effective (0.5x)
    if (_atk == global.TYPE_BEAST && _def == global.TYPE_HYDRO) return 0.5;
    if (_atk == global.TYPE_NATURE && _def == global.TYPE_BEAST) return 0.5;
    if (_atk == global.TYPE_AERO && _def == global.TYPE_NATURE) return 0.5;
    if (_atk == global.TYPE_TOXIC && _def == global.TYPE_AERO) return 0.5;
    if (_atk == global.TYPE_HYDRO && _def == global.TYPE_TOXIC) return 0.5;
    
    return 1.0;
}
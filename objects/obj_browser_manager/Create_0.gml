// --- Create Event ---
event_inherited();

// Window Setup
window_width = 800;
window_height = 500;
window_title = "CritterNet Browser";
window_x1 = (display_get_gui_width() / 2) - (window_width / 2);
window_y1 = (display_get_gui_height() / 2) - (window_height / 2);
window_x2 = window_x1 + window_width;
window_y2 = window_y1 + window_height;

// Player Data
var _cup_index = global.PlayerData.current_cup_index;
var _opp_index = global.PlayerData.current_opponent_index;
current_cup = global.CupDatabase[_cup_index];
current_level_cap = current_cup.level_cap;
current_cup_name = current_cup.cup_name;

if (_opp_index >= array_length(current_cup.opponents)) {
    next_opponent_name = "---";
    next_opponent_pfp = spr_avatar_user_default;
} else {
    var _next_opp = current_cup.opponents[_opp_index];
    next_opponent_name = _next_opp.name;
    next_opponent_pfp = _next_opp.profile_pic_sprite;
}

player_name = global.PlayerData.name;
player_pfp = global.PlayerData.profile_pic;

// --- STATE MACHINE (Only define these HERE) ---
browser_state = "browsing"; 
search_timer = 0;
match_display_timer = 0;

// --- RANDOMIZATION (Only run THIS here) ---
var _w_data = [
    ["Clear Skies", 0, 15, 25], ["Sunny", 0, 20, 32], ["Heatwave", 0, 30, 40],
    ["Partly Cloudy", 1, 12, 22], ["Overcast", 1, 8, 18], ["Foggy", 1, 5, 15],
    ["Light Rain", 2, 10, 18], ["Heavy Rain", 2, 8, 16],
    ["Thunderstorm", 3, 12, 24], ["Severe Storm", 3, 10, 20]
];
var _pick = _w_data[irandom(array_length(_w_data) - 1)];
weather_desc = _pick[0];
weather_icon_idx = _pick[1]; 
weather_temp = irandom_range(_pick[2], _pick[3]);
weather_string = string(weather_temp);

var _news_headlines = [
    "Bronze Cup Finals: Who will win?",
    "Market Watch: Potion prices stable.",
    "New patch v1.02 fixes connection bugs.",
    "Interview: The Champion speaks out.",
    "Critter conservation efforts increase.",
    "Local user finds rare critter in backyard."
];
current_news = _news_headlines[irandom(array_length(_news_headlines) - 1)];

var _daily_deals = [
    "Free month of CritterNet dial-up!",
    "Upgrade your RAM to 64MB today!",
    "New mousepads in stock at the Shop.",
    "Norton Anti-Virus: 50% off."
];
current_deal = _daily_deals[irandom(array_length(_daily_deals) - 1)];

var _facts = [
    "Sea otters hold hands while sleeping so they don't drift apart.",
    "A group of flamingos is called a 'flamboyance'.",
    "Octopuses have three hearts.",
    "Cows have best friends and get stressed when separated.",
    "Goats have rectangular pupils to see 320 degrees around them.",
    "Sloths can hold their breath longer than dolphins.",
    "Tigers have striped skin, not just striped fur.",
    "A snail can sleep for three years.",
    "Elephants are the only animal that can't jump."
];
current_fact = _facts[irandom(array_length(_facts) - 1)];

// Layout Vars
sidebar_w = 180;
sidebar_x1 = window_x1 + 2;
sidebar_y1 = window_y1 + 32;
sidebar_x2 = sidebar_x1 + sidebar_w;
sidebar_y2 = window_y2 - 2;

content_x1 = sidebar_x2;
content_y1 = sidebar_y1;
content_x2 = window_x2 - 2;
content_y2 = window_y2 - 2;

var _start_y = sidebar_y1 + 100;
var _btn_h = 60;
var _spacing = 10;

btn_ranked_x1 = sidebar_x1 + 10;
btn_ranked_y1 = _start_y;
btn_ranked_x2 = sidebar_x2 - 10;
btn_ranked_y2 = btn_ranked_y1 + _btn_h;
btn_ranked_hover = false;

btn_casual_x1 = sidebar_x1 + 10;
btn_casual_y1 = btn_ranked_y2 + _spacing;
btn_casual_x2 = sidebar_x2 - 10;
btn_casual_y2 = btn_casual_y1 + _btn_h;
btn_casual_hover = false;

btn_heal_x1 = sidebar_x1 + 10;
btn_heal_y1 = btn_casual_y2 + _spacing;
btn_heal_x2 = sidebar_x2 - 10;
btn_heal_y2 = btn_heal_y1 + _btn_h;
btn_heal_hover = false;

heal_message_text = "";
heal_message_timer = 0;
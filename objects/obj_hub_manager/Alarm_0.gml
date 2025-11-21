// --- Alarm 0 Event ---
var _time = date_current_datetime();
var _hour = date_get_hour(_time);
var _min_val = date_get_minute(_time);
var _ampm = "AM";

// 12-Hour Clock Logic
if (_hour >= 12) {
    _ampm = "PM";
    if (_hour > 12) { _hour -= 12; }
}
if (_hour == 0) { _hour = 12; }

// --- LEADING ZERO FIX ---
var _min_str = string(_min_val);
if (_min_val < 10) {
    _min_str = "0" + _min_str;
}
// -----------------------

time_string = string(_hour) + ":" + _min_str + " " + _ampm;

alarm[0] = 60; // Update every second (or 60 steps)
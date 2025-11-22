// --- Create Event ---

// 1. INHERIT PARENT
event_inherited();

if (!variable_instance_exists(id, "is_dragging")) {
    is_dragging = false;
}

// Initialize color variables explicitly
if (!variable_instance_exists(id, "col_bg")) col_bg = c_teal;
if (!variable_instance_exists(id, "col_title_bar_active")) col_title_bar_active = c_navy;
if (!variable_instance_exists(id, "col_title_bar_inactive")) col_title_bar_inactive = c_dkgray;

// 2. Window Properties
window_width = 600;
window_height = 480; // Adjusted height
window_title = "Picture";

// Recalculate Position
window_x1 = (display_get_gui_width() / 2) - (window_width / 2);
window_y1 = (display_get_gui_height() / 2) - (window_height / 2);
window_x2 = window_x1 + window_width;
window_y2 = window_y1 + window_height;

// 3. Avatar List (UPDATED)
// Now using spr_1 through spr_8
// We repeat them to fill the 4x4 grid (16 slots)
avatar_list = [
    spr_1, spr_2, spr_3, spr_4,
    spr_5, spr_6, spr_7, spr_8,
    spr_1, spr_2, spr_3, spr_4,
    spr_5, spr_6, spr_7, spr_8
];

// --- NEW: Upload Counter ---
uploaded_count = 0;

// 4. Grid Layout (Left Side)
cell_size = 60; 
grid_padding = 8;
grid_cols = 4; 
// [FIX] Increased rows to 5 to allow space/selection for uploaded images
grid_rows = 5; 

grid_w = (grid_cols * cell_size) + ((grid_cols - 1) * grid_padding);
grid_h = (grid_rows * cell_size) + ((grid_rows - 1) * grid_padding);

grid_x1 = window_x1 + 30;
grid_y1 = window_y1 + 110; 

// 5. Preview Layout (Right Side)
preview_box_size = 140;
preview_x1 = window_x2 - 200; // Right aligned
preview_y1 = grid_y1;
preview_x2 = preview_x1 + preview_box_size;
preview_y2 = preview_y1 + preview_box_size;

// 6. Buttons (Right Side & Bottom)
// Mock buttons
btn_mock_w = 140;
btn_mock_h = 24;
btn_mock_x = preview_x1;
btn_mock_start_y = preview_y2 + 20;

// Real OK/Cancel buttons (Bottom Right)
btn_ok_w = 80;
btn_ok_h = 26;
// Position at bottom right corner
btn_cancel_x1 = window_x2 - 20 - btn_ok_w;
btn_cancel_y1 = window_y2 - 45;
btn_cancel_x2 = btn_cancel_x1 + btn_ok_w;
btn_cancel_y2 = btn_cancel_y1 + btn_ok_h;
btn_cancel_hover = false;

btn_ok_x1 = btn_cancel_x1 - 10 - btn_ok_w;
btn_ok_y1 = btn_cancel_y1;
btn_ok_x2 = btn_ok_x1 + btn_ok_w;
btn_ok_y2 = btn_ok_y1 + btn_ok_h;
btn_ok_hover = false;

// 7. State
selected_index = 0;
hover_index = -1;
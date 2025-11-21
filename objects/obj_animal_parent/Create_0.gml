// --- Create Event ---

visible = false; 

my_data = noone; 
my_scale = 1.0; 
animation_frame = 0;
animation_speed = 0.2; 

// --- "GAME FEEL" VARIABLES ---
home_x = x; 
home_y = y;

// Lunge effect
lunge_state = 0; 
lunge_speed = 8;
lunge_target_x = x;
lunge_current_x = 0; 

// Y-axis variables
lunge_target_y = y;
lunge_current_y = 0; 

// Hurt effect
flash_alpha = 0; 
flash_color = c_white; 
shake_timer = 0; 

// Fainting variables
is_fainting = false;
faint_scale_y = 1.0; 
faint_alpha = 1.0;   

// ================== VFX VARIABLES ==================
vfx_type = "none"; 
vfx_particles = []; 
vfx_timer = 0; // Initialized to 0
// ===================================================
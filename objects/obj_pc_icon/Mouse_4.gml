// --- Left Pressed Event ---

// This check prevents multiple PC windows
if (!instance_exists(obj_pc_manager)) {
    instance_create_layer(0, 0, "Instances", obj_pc_manager);
}
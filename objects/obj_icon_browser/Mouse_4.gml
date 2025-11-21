// --- Left Pressed Event ---

// This check prevents the user from opening 100 browser windows
// We no longer check for tutorial_complete
if (!instance_exists(obj_browser_manager)) {
    instance_create_layer(0, 0, "Instances", obj_browser_manager);
}
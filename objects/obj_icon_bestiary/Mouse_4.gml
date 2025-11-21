// --- Left Pressed Event ---

// This check prevents the user from opening 100 Pokedex windows
if (!instance_exists(obj_pokedex_manager)) {
    instance_create_layer(0, 0, "Instances", obj_pokedex_manager);
}
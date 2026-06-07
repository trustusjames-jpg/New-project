/// @description Loads items.json from Included Files into global.item_data at game start.
///              Call once from the first room's Create Event or a persistent controller object.
///              Access items via: global.item_data[$ "item_id"]

function scr_items_load() {
    global.item_data = {};

    var _path = working_directory + "items.json";

    if (!file_exists(_path)) {
        show_debug_message("[ITEMS] ERROR: items.json not found at path: " + _path);
        return;
    }

    // Read the full file into a single string line by line.
    var _file = file_text_open_read(_path);
    var _raw  = "";
    while (!file_text_eof(_file)) {
        _raw += file_text_readln(_file);
    }
    file_text_close(_file);

    // json_parse returns a struct mirroring the JSON structure.
    var _parsed = json_parse(_raw);

    if (!variable_struct_exists(_parsed, "items")) {
        show_debug_message("[ITEMS] ERROR: items.json is missing top-level 'items' key.");
        return;
    }

    // Flatten each named entry into global.item_data keyed by item id string.
    var _ids   = variable_struct_get_names(_parsed.items);
    var _count = array_length(_ids);

    for (var _i = 0; _i < _count; _i++) {
        var _id = _ids[_i];
        global.item_data[$ _id] = _parsed.items[$ _id];
    }

    show_debug_message("[ITEMS] Loaded " + string(_count) + " item(s) from items.json.");
}

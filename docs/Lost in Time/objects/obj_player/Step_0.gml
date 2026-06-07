// =============================================================
// obj_player — Step Event
// =============================================================
// All logic runs through a single switch(state).  Only one
// block executes per frame, so states never bleed into each
// other.  Tuning values (speeds, durations) live in
// scr_player_macros so they can be changed in one place.
// =============================================================


// --- 1. READ INPUT -------------------------------------------
// Supports both arrow keys and WASD simultaneously.
// Subtracting the "opposite" key means two opposing keys cancel
// to 0, and a single key gives either -1 or +1.

var _dx = (keyboard_check(vk_right) || keyboard_check(ord("D")))
        - (keyboard_check(vk_left)  || keyboard_check(ord("A")));

var _dy = (keyboard_check(vk_down)  || keyboard_check(ord("S")))
        - (keyboard_check(vk_up)    || keyboard_check(ord("W")));

// True when at least one directional key is held this frame.
var _has_input = (_dx != 0 || _dy != 0);


// --- 2. STATE MACHINE ----------------------------------------

switch (state) {

    // =========================================================
    case STATE_IDLE:
    // =========================================================
    // Standing still.  Wait for a direction key or a dash press.

        // As soon as the player touches a direction, enter MOVE.
        if (_has_input) {
            state = STATE_MOVE;
            break;
        }

        // Allow dashing from idle — fires in the last-faced direction.
        // Requires the cooldown to have expired.
        if (keyboard_check_pressed(vk_space) && dash_cooldown <= 0) {
            dash_timer = DASH_DURATION;
            state      = STATE_DASH;
        }
    break;

    // =========================================================
    case STATE_MOVE:
    // =========================================================
    // Walking.  Build an 8-directional velocity vector and apply
    // it with per-axis collision so the player slides along walls.

        // If all direction keys were released this frame, go idle.
        if (!_has_input) {
            state = STATE_IDLE;
            break;
        }

        // point_direction(0, 0, dx, dy) converts our -1/0/+1 grid
        // inputs into a GameMaker angle (0° = right, 90° = up).
        //
        // lengthdir_x/y(speed, angle) turns that angle back into
        // X and Y components.  The key benefit: diagonal inputs
        // come out at the same total speed as cardinal inputs
        // because point_direction normalises the vector for us.
        var _angle = point_direction(0, 0, _dx, _dy);
        var _vx    = lengthdir_x(MOVE_SPEED, _angle);
        var _vy    = lengthdir_y(MOVE_SPEED, _angle);

        // Remember this angle so a dash later fires in this direction.
        face_dir = _angle;

        // Move one axis at a time.  If X movement would collide, skip it
        // but still try Y.  This lets the player slide along wall edges
        // rather than stopping dead when touching at a corner.
        if (!place_meeting(x + _vx, y, obj_wall)) { x += _vx; }
        if (!place_meeting(x, y + _vy, obj_wall)) { y += _vy; }

        // Begin a dash if Space is pressed and the cooldown has cleared.
        if (keyboard_check_pressed(vk_space) && dash_cooldown <= 0) {
            dash_timer = DASH_DURATION;
            state      = STATE_DASH;
        }
    break;

    // =========================================================
    case STATE_DASH:
    // =========================================================
    // Mid-dash.  Move at DASH_SPEED in the stored face_dir for
    // DASH_DURATION frames, then return to the appropriate state.
    // The dash respects wall collision — it is not a phase-through.

        var _dvx = lengthdir_x(DASH_SPEED, face_dir);
        var _dvy = lengthdir_y(DASH_SPEED, face_dir);

        if (!place_meeting(x + _dvx, y, obj_wall)) { x += _dvx; }
        if (!place_meeting(x, y + _dvy, obj_wall)) { y += _dvy; }

        // Count down the dash duration.
        dash_timer--;

        if (dash_timer <= 0) {
            // Start the cooldown so the player can't instantly chain dashes.
            dash_cooldown = DASH_COOLDOWN;

            // Return to whichever state matches the current input.
            state = _has_input ? STATE_MOVE : STATE_IDLE;
        }
    break;
}


// --- 3. TICK COOLDOWN ----------------------------------------
// This runs every frame regardless of which state is active,
// so the cooldown winds down even while the player is dashing.

if (dash_cooldown > 0) { dash_cooldown--; }

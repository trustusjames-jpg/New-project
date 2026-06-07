// =============================================================
// obj_player — Create Event
// =============================================================
// Initialise every variable the Step Event will read.
// All tuning numbers live in scr_player_macros, not here.
// =============================================================

state         = STATE_IDLE;  // start standing still

// The angle (in degrees) the player last moved in.
// Stored so a dash fired from STATE_IDLE has a direction.
face_dir      = 0;

// Counts DOWN each frame while the player is dashing.
// The dash ends when this reaches 0.
dash_timer    = 0;

// Counts DOWN each frame after a dash ends.
// The player cannot dash again until this reaches 0.
dash_cooldown = 0;

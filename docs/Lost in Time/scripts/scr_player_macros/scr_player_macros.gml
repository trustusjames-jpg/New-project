// =============================================================
// scr_player_macros
// =============================================================
// Global constants for obj_player.
// Change the values here to tune the feel without hunting
// through object events.
// =============================================================

// --- States ---
#macro STATE_IDLE  0   // standing still, waiting for input
#macro STATE_MOVE  1   // walking in any of 8 directions
#macro STATE_DASH  2   // mid-dash burst of movement

// --- Movement tuning ---
#macro MOVE_SPEED    3   // pixels per frame while walking
#macro DASH_SPEED   10   // pixels per frame during the dash burst
#macro DASH_DURATION 8   // how many frames the dash lasts
#macro DASH_COOLDOWN 45  // frames before the player can dash again (~0.75 s at 60 fps)

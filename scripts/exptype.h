//** EXPtype.h -- Explosion Type information for scripts
//** Copyright 1997 Cavedog Entertainment
//        Well, not really much Cavedog stuff here anymore...

 
#ifndef EXPTYPE_H
#define EXPTYPE_H
 
#define SHATTER   1                // The piece will shatter instead of remaining whole
#define EXPLODE_ON_HIT    2  // The piece will occassionally explode when it hits the ground and it'll cause 20 damage to everything it touches
#define FALL            4      // The piece will fall due to gravity instead of just flying off
#define SMOKE         8    // A smoke trail will follow the piece through the air
#define FIRE            16    // A fire trail will follow the piece through the air
#define BITMAPONLY      32
#define BITMAP1 0                //Spring ignores these anyway
#define BITMAP2 0
#define BITMAP3 0
#define BITMAP4 0
#define BITMAP5 0
#define BITMAP_NUKE 0
 
 
// Indices for set/get value
#define ACTIVATION                  1     // set or get
#define STANDINGMOVEORDERS      2     // set or get
#define STANDINGFIREORDERS      3     // set or get
#define HEALTH        4 // get (0-100%)

#define INBUILDSTANCE      5  // set or get
#define BUSY                6   // set or get (used by misc. special case missions like transport ships)
#define PIECE_XZ                        7       // get
#define PIECE_Y    8        // get
#define UNIT_XZ    9        // get
#define UNIT_Y            10 // get
#define UNIT_HEIGHT               11   // get
#define XZ_ATAN    12       // get atan of packed x,z coords
#define XZ_HYPOT                        13      // get hypot of packed x,z coords
#define ATAN                14  // get ordinary two-parameter atan
#define HYPOT            15 // get ordinary two-parameter hypot
#define GROUND_HEIGHT      16 // get
#define BUILD_PERCENT_LEFT      17    // get 0 = unit is built and ready, 1-100 = How much is left to build
#define YARD_OPEN                     18     // set or get (change which plots we occupy when building opens and closes)
#define BUGGER_OFF                  19    // set or get (ask other units to clear the area)
#define ARMORED    20       // set or get
// Spring only uses these out of the TA:K stuff
#define IN_WATER            28  //not sure this is implemented
#define CURRENT_SPEED       29
#define VETERAN_LEVEL      32
#define ON_ROAD             34  //always false
 
//Spring-only vars
#define MAX_ID      70
#define MY_ID       71
#define UNIT_TEAM              72
#define UNIT_BUILD_PERCENT_LEFT 73
#define UNIT_ALLIED          74
#define MAX_SPEED              75
#define CLOAKED   76
#define WANT_CLOAK            77
#define GROUND_WATER_HEIGHT     78
#define UPRIGHT   79
#define POW                    80
#define PRINT         81
#define HEADING                 82
#define TARGET_ID              83
#define LAST_ATTACKER_ID        84
#define LOS_RADIUS            85
#define AIR_LOS_RADIUS  86
#define RADAR_RADIUS    87
#define JAMMER_RADIUS   88
#define SONAR_RADIUS    89
#define SONAR_JAM_RADIUS        90
#define SEISMIC_RADIUS  91
#define DO_SEISMIC_PING 92
#define CURRENT_FUEL    93
#define TRANSPORT_ID    94
#define SHIELD_POWER    95
#define STEALTH         96
#define CRASHING        97
#define CHANGE_TARGET   98
#define CEG_DAMAGE      99
#define COB_ID                   100 // get
#define PLAY_SOUND                         101 // get, so multiple args can be passed
#define KILL_UNIT                102 // get KILL_UNIT(unitId, SelfDestruct=true, Reclaimed=false)
#define ALPHA_THRESHOLD          103 // set or get
#define SET_WEAPON_UNIT_TARGET   106 // get (fake set)
#define SET_WEAPON_GROUND_TARGET 107 // get (fake set)
 
#define LUA0            110
#define LUA1            111
#define LUA2            112
#define LUA3            113
#define LUA4            114
#define LUA5            115
#define LUA6            116
#define LUA7            117
#define LUA8            118
#define LUA9            119
 
#define FLANK_B_MODE             120 // set or get
#define FLANK_B_DIR              121 // set or get, set is through get for multiple args
#define FLANK_B_MOBILITY_ADD     122 // set or get
#define FLANK_B_MAX_DAMAGE       123 // set or get
#define FLANK_B_MIN_DAMAGE       124 // set or get
 
#define WEAPON_RELOADSTATE       125 // get (with fake set)
#define WEAPON_RELOADTIME        126 // get (with fake set)
#define WEAPON_ACCURACY          127 // get (with fake set)
#define WEAPON_SPRAY             128 // get (with fake set)
#define WEAPON_RANGE             129 // get (with fake set)
#define WEAPON_PROJECTILE_SPEED  130 // get (with fake set)
 
#define UNIT_VAR                1024    //8 vars
#define TEAM_VAR                2048    //64 vars
#define ALLY_VAR                3072    //64 vars
#define GLOBAL_VAR            4096  //1024 vars
 
#endif // EXPTYPE_H
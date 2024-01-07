//? Tool Behaviours - make these human readable!

//* Engineering
#define TOOL_CROWBAR 		"crowbar"
#define TOOL_MULTITOOL 		"multitool"
#define TOOL_SCREWDRIVER 	"screwdriver"
#define TOOL_WIRECUTTER 	"wirecutter"
#define TOOL_WRENCH 		"wrench"
#define TOOL_WELDER 		"welder"
#define TOOL_ANALYZER		"analyzer"
//* Mining
#define TOOL_MINING			"mining"
#define TOOL_SHOVEL			"shovel"
//* Surgery
#define TOOL_RETRACTOR	 	"retractor"
#define TOOL_HEMOSTAT 		"hemostat"
#define TOOL_CAUTERY 		"cautery"
#define TOOL_DRILL			"drill"
#define TOOL_SCALPEL		"scalpel"
#define TOOL_SAW			"saw"
//* Glassworking
#define TOOL_BLOW			"blowing_rod"
#define TOOL_GLASS_CUT		"glasskit"
#define TOOL_BONESET		"bonesetter"

/// Yes, this is a real global. No, you shouldn't touch this for no reason.
/// Add tools to this when they get states in the default icon file for:
/// - neutral (no append)
/// - forwards (append _up)
/// - backwards (append _down)
GLOBAL_REAL_VAR(_dyntool_image_states) = list(
	null = "unknown",
	TOOL_CROWBAR = "crowbar",
	TOOL_SCREWDRIVER = "screwdriver"
)

//? Tool usage flags

/// repairing
#define TOOL_USAGE_REPAIR (1<<0)
/// initial construction
#define TOOL_USAGE_CONSTRUCT (1<<1)
/// deconstruct
#define TOOL_USAGE_DECONSTRUCT (1<<2)
/// superstructure, making / breaking turfs, etc
#define TOOL_USAGE_BUILDING_SUPERSTRUCTURE (1<<3)
/// making railings, catwalks, wires, etc
#define TOOL_USAGE_BUILDING_FRAMEWORK (1<<4)
/// making tables, detailed furnishings, etc
#define TOOL_USAGE_BUILDING_FURNISHINGS (1<<5)
//doing weird stuff that is possibly dangerous and definitely not regulation
#define TOOL_USAGE_INADVISABLE (1<<6)
//doing cooking
#define TOOL_USAGE_COOKING (1<<7)

//? tool_locked var

/// unlocked - use dynamic tool system
#define TOOL_LOCKING_DYNAMIC 1
/// use static behavior
#define TOOL_LOCKING_STATIC 2
/// automatically, if we only have one dynamic behavior, use that
#define TOOL_LOCKING_AUTO 3

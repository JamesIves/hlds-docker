#include <amxmodx>
#include <amxmisc>
#include <hamsandwich>
#include <fakemeta_util>

#define PLUGIN "AMX Log"
#define VERSION "0.0.1"
#define AUTHOR "spezifanta"

public plugin_init()
{
	register_plugin( PLUGIN, VERSION, AUTHOR )

	register_concmd( "amx_log", "log_user", ADMIN_KICK, "<name or #userid>" )

    RegisterHam(Ham_Touch,"trigger_multiple","block_door_fix3",0)



	register_cvar( "amx_log_version", VERSION, FCVAR_SERVER|FCVAR_EXTDLL|FCVAR_UNLOGGED|FCVAR_SPONLY )
}



public block_door_fix3(ent,other){
	new class[32]
	new name2[32]
	pev(ent,pev_target,class,31)
	pev(other,pev_classname,name2,31)



	static szLogData[ 200 ]
	formatex( szLogData, sizeof szLogData - 1, "button event touched %s by: %s", class, name2 )

	console_print( 0, szLogData )

	if (equal(name2, "player")) {
		if (equal(class, "strike_mm")) {
			console_print(0, "A nuklear air strike was called")
		}
	}



}

public log_user( id, level, cid )
{
	static szLogData[ 200 ]
	formatex( szLogData, sizeof szLogData - 1, "weeee! custom log entry" )
	console_print( 0, szLogData )
	log_message(szLogData)

	return PLUGIN_HANDLED
}

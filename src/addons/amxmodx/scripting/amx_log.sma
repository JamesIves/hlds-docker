#include <amxmodx>
#include <amxmisc>
#include <hamsandwich>
#include <fakemeta_util>
#include <engine>

#define PLUGIN "AMX Log"
#define VERSION "0.0.1"
#define AUTHOR "spezifanta"

public plugin_init()
{
	register_plugin( PLUGIN, VERSION, AUTHOR )
	register_concmd( "amx_log", "log_user", ADMIN_KICK, "<name or #userid>" )

	//RegisterHam(Ham_Touch,"trigger_multiple","block_door_fix3", 0)
	register_touch( "trigger_multiple", "player", "touch_trigger" )
	register_cvar( "amx_log_version", VERSION, FCVAR_SERVER|FCVAR_EXTDLL|FCVAR_UNLOGGED|FCVAR_SPONLY )
}

public block_door_fix3(ent,other){
	new class[32]
	new name2[32]
	pev(ent,pev_target,class,31)
	pev(other,pev_classname,name2,31)

	static szLogData[ 200 ]
	formatex( szLogData, sizeof szLogData - 1, "button event touched %s by: %s", class, name2 )

	//console_print( 0, szLogData )

	if (equal(name2, "player")) {
		if (equal(class, "strike_mm")) {
			console_print(0, "A nuklear air strike was called")
			return PLUGIN_HANDLED
		}
	}

	return PLUGIN_CONTINUE
}




public touch_trigger( trigger_ent, id )
{
	static target      [  32  ];
	static nextGameTime[  32  ];

	if( !pev_valid( trigger_ent ) )
	{
		return;
	}

	new Float:currentGameTime = get_gametime();

	if( currentGameTime < nextGameTime[ id ]   )
	{
		return;
	}

	nextGameTime[ id ] = currentGameTime + 1.0;
	entity_get_string( trigger_ent, EV_SZ_target, target, charsmax( target ) );

	client_print( id, print_chat, "ent: %d id: %d target: %s", trigger_ent, id, target );
	console_print( 0, "nuke" )
}

public log_user( id, level, cid )
{
	static szLogData[ 200 ]
	formatex( szLogData, sizeof szLogData - 1, "weeee! custom log entry" )
	console_print( 0, szLogData )
	log_message(szLogData)

	return PLUGIN_HANDLED
}

/*  AMX Mod X script.
 
    Crossfire Siren Fix Plugin
    
    (c) Copyright 2007, Simon Logic (slspam@land.ru)
    This file is provided as is (no warranties).

	Info:
		Plugin fixes siren spontaneous activating on round restart if running 
		Crossfire map (or any other map with similar airstrike mechanism) 
		under CS/CZ.

	Requirements:
		* CS/CZ mod
		* AMX/X 1.7x or higher
		* Fakemeta module

	History:
	1.0.0 [2007-02-15]
	* added entity filtering by classname to increase compatibility
	* notification if running under invalid mod
	0.0.1 [2007-02-05]
	* first public alpha release
*/

#include <amxmodx>
#include <amxmisc>
#include <fakemeta_stocks>

#define MY_PLUGIN_NAME    "Crossfire Siren Fix"
#define MY_PLUGIN_VERSION "1.0.0"
#define MY_PLUGIN_AUTHOR  "Simon Logic"


new const 
	g_sTargetnameField[] = "targetname",
	g_sTargetName[] = "strike_siren",
	g_sClassType[] = "ambient_" // full: ambient_generic
//-----------------------------------------------------------------------------
public plugin_init()
{
	register_plugin(MY_PLUGIN_NAME, MY_PLUGIN_VERSION, MY_PLUGIN_AUTHOR)

	if(cstrike_running())
		register_event("HLTV", "onNewRound", "a", "1=0", "2=0")
	else
		log_amx("plugin disabled due to wrong mod detection")
}
//-----------------------------------------------------------------------------
public onNewRound()
{
	set_task(0.1, "task")
}
//-----------------------------------------------------------------------------
public task()
{
	new id, iCount, iLen = sizeof(g_sClassType) - 1
	new sTemp[sizeof(g_sClassType)]
	
	while((id = EF_FindEntityByString(id, g_sTargetnameField, g_sTargetName)) > 0)
	{
		pev(id, pev_classname, sTemp, iLen)
		if(equal(sTemp, g_sClassType))
		{
			DF_Use(id, 0)
			iCount++
		}
	}

	if(iCount)
		log_amx("Turned off %d siren source%s", iCount, iCount > 1 ? "s": "")
}
//-----------------------------------------------------------------------------

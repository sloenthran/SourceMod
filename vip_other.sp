#include <sourcemod>

int HP = 100;
int VipHP = 100;

public Plugin myinfo = 
{ 
	name = "VIP Other [v0.1]", 
	author = "Sloenthran", 
	description = "Remove armor and set player HP", 
	url = "sloenthran.pl" 
};

public void OnPluginStart()
{
	HookEvent("player_spawn", PlayerSpawn, EventHookMode_Post);
}

public Action PlayerSpawn(Handle Data, char[] Name, bool NoTransmite)
{
	int User = GetClientOfUserId(GetEventInt(Data, "userid"));
	
	if(IsVIP(User)){ SetEntityHealth(User, VipHP); SetEntProp(User, Prop_Send, "m_ArmorValue", 100, 1); }
	else { SetEntityHealth(User, HP); SetEntProp(User, Prop_Send, "m_ArmorValue", 0, 1); }
}

stock IsVIP(User)
{
	if (!CheckCommandAccess(User, "sm_vip", 0, true)) { return false; }
	else { return true; }
}
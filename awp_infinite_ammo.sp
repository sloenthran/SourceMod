#include <sourcemod>

public Plugin myinfo = 
{ 
	name = "AWP Infinite Ammo [v0.1]", 
	author = "Sloenthran", 
	description = "Add infinite ammo in AWP weapon", 
	url = "sloenthran.pl" 
};

public void OnPluginStart()
{
	HookEvent("weapon_fire", CheckReload);
}

public Action CheckReload(Handle Data, char[] Name, bool NoTransmite)
{
	int User = GetClientOfUserId(GetEventInt(Data, "userid"));
	int Weapon = GetEntPropEnt(User, Prop_Data, "m_hActiveWeapon");

	char WeaponName[64];
	
	GetEntityClassname(Weapon, WeaponName, 64);
	
	if(StrEqual(WeaponName, "weapon_awp"))
	{
		SetEntProp(Weapon, Prop_Data, "m_iClip1", 10);
	}
}
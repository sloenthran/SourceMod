#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = 
{ 
	name = "Block Knife Damage [v1.0]", 
	author = "Sloenthran", 
	description = "Block Knife Damage", 
	url = "sloenthran.pl" 
};

public void OnClientPutInServer(int User) 
{
	SDKHook(User, SDKHook_OnTakeDamage, OnTakeDamage);
}

public Action OnTakeDamage(int User, int &Enemy, int &Inflictor, float &Damage, int &DamageType)
{
	if(Enemy)
	{
		int Weapon = GetEntPropEnt(Enemy, Prop_Data, "m_hActiveWeapon");

		char WeaponName[64];
	
		GetEntityClassname(Weapon, WeaponName, 64);
	
		if(StrEqual(WeaponName, "weapon_knife"))
		{
			Damage = 0.0;
			return Plugin_Changed;
		}
	}
	
	return Plugin_Continue;
}
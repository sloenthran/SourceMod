#include <cstrike>
#include <sdkhooks>

bool HideCT[64 + 1];

public Plugin myinfo = 
{ 
	name = "DR Hide CT [v1.0]", 
	author = "Sloenthran", 
	description = "DR Hide CT", 
	url = "sloenthran.pl" 
};

public OnPluginStart()
{
    RegConsoleCmd("sm_hide", ChangeHide);
}

public void OnClientPutInServer(int User) 
{
	SDKHook(User, SDKHook_SetTransmit, SetTransmit);
	HideCT[User] = false;
}

public void OnClientDisconnect(int User)
{
	HideCT[User] = false;
}

public Action SetTransmit(int Entity, int Client)
{
	if(Client != Entity && (0 < Entity <= MaxClients) && IsClientInGame(Client) && HideCT[Client] && (GetClientTeam(Entity) == 3))
	{
		return Plugin_Handled;
	}
	return Plugin_Continue;
}
	
public Action ChangeHide(int User, int Arg)
{
	if(!HideCT[User])
	{
		HideCT[User] = true;
	}
	else
	{
		HideCT[User] = false;
	}
	
	return Plugin_Handled;
}
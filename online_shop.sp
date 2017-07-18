#include <sourcemod>
#include <SteamWorks>

#pragma semicolon 1

Handle DB = INVALID_HANDLE;

int ServerPort = 0; 
int ServerID = 0;
int PlayerBuy[64 + 1];
int PlayerBuyCache[64 + 1];

char TextSMS[64]; 
char ServerIP[64]; 
char ShopURL[64];

public Plugin myinfo = 
{ 
	name = "Online Shop [v0.7]", 
	author = "Sloenthran", 
	description = "Online Shop", 
	url = "sloenthran.pl" 
};

public void OnPluginStart()
{
	char Error[256]; 
	char Query[256];

	CreateConVar("onlineshop_url", "sklep.myserv.pl", "Online Shop WEB URL");
	
	AutoExecConfig(true, "OnlineShop");
	
	ServerPort = GetConVarInt(FindConVar("hostport"));
	
 	GetConVarString(FindConVar("ip"), ServerIP, sizeof(ServerIP));
 	GetConVarString(FindConVar("onlineshop_url"), ShopURL, sizeof(ShopURL));
	
	RegConsoleCmd("sm_sklepsms", TwoMenu); 
	RegConsoleCmd("say", CheckSay); 
	RegConsoleCmd("team_say", CheckSay);
	
	DB = SQL_Connect("OnlineShop", true, Error, sizeof(Error)); 
	
	if(DB == INVALID_HANDLE) 
	{ 
		LogToFile("addons/sourcemod/logs/OnlineShop.txt", "[MySQL]: %s", Error); 
		SetFailState("Not connect to MySQL server"); 
	}
	
	Format(Query, sizeof(Query), "SELECT `id` FROM `servers` WHERE `ip`='%s' AND `port`='%i' LIMIT 1", ServerIP, ServerPort); 
	
	Handle QueryDB = SQL_Query(DB, Query);
	
	if(QueryDB != INVALID_HANDLE) 
	{ 
		if(SQL_FetchRow(QueryDB)) 
		{ 
			ServerID = SQL_FetchInt(QueryDB, 0); 
		} 
	} else { SQL_GetError(DB, Error, sizeof(Error)); LogToFile("addons/sourcemod/logs/OnlineShop.txt", "[MySQL] %s", Error); }
		
	Format(Query, sizeof(Query), "SELECT `value` FROM `settings` WHERE `name`='text_sms' LIMIT 1"); 
	
	QueryDB = SQL_Query(DB, Query);
	
	if(QueryDB != INVALID_HANDLE) 
	{ 
		if(SQL_FetchRow(QueryDB)) 
		{ 
			SQL_FetchString(QueryDB, 0, TextSMS, sizeof(TextSMS)); 
		} 
	} else { SQL_GetError(DB, Error, sizeof(Error)); LogToFile("addons/sourcemod/logs/OnlineShop.txt", "[MySQL] %s", Error); }
}

public void OnClientPutInServer(User) 
{ 
	PlayerBuy[User] = false; 
	PlayerBuyCache[User] = 0;
	GiveFlag(User);
}

public void OneMenu(int User, int Arg)
{
	char Query[256];
	
	Handle ShopOneMenu = CreateMenu(OneMenuHandle);
	
	SetMenuTitle(ShopOneMenu, "*Online Shop by Sloenthran*\nWybierz usługę");
	
	Format(Query, sizeof(Query), "SELECT `id`, `name` FROM `buy` WHERE `server`='%i' OR `server`='0'", ServerID); 
	
	Handle QueryDB = SQL_Query(DB, Query);
	
	if(QueryDB != INVALID_HANDLE)
	{
		while(SQL_FetchRow(QueryDB))
		{		
			char Name[64]; 
			char PremiumName[128]; 
			char PremiumID[16];
			
			int ID = SQL_FetchInt(QueryDB, 0); 
			
			SQL_FetchString(QueryDB, 1, Name, sizeof(Name));
			
			Format(PremiumName, sizeof(PremiumName), "%s", Name); 
			Format(PremiumID, sizeof(PremiumID), "%i", ID);
			
			AddMenuItem(ShopOneMenu, PremiumID, PremiumName);
		}
	} else { char Error[256]; SQL_GetError(DB, Error, sizeof(Error)); LogToFile("addons/sourcemod/logs/OnlineShop.txt", "[MySQL] %s", Error); }

	AddMenuItem(ShopOneMenu, "back", "Powrót");
	SetMenuPagination(ShopOneMenu, 7);
	SetMenuExitButton(ShopOneMenu, true);
	DisplayMenu(ShopOneMenu, User, 250);
}

public int OneMenuHandle(Handle MenuID, MenuAction Data, int User, int Info)
{
	if(Data == MenuAction_Select)
	{
		char Item[16]; 
		char Error[256];
		char Query[256];
		char BuyID[16];

		GetMenuItem(MenuID, Info, Item, sizeof(Item));
		
		Format(BuyID, sizeof(BuyID), "%i", Info);
		
		if(StrEqual(Item, "back")) 
		{ 
			TwoMenu(User, 0); 
		}
		else {
			Handle ShopFourMenu = CreateMenu(FourMenuHandle);
	
			SetMenuTitle(ShopFourMenu, "*Online Shop by Sloenthran*\nWybierz ilość dni");
			
			Format(Query, sizeof(Query), "SELECT `id`, `days` FROM `service` WHERE `buy_id`='%s'", Item); Handle QueryDB = SQL_Query(DB, Query);
			
			if(QueryDB != INVALID_HANDLE)
			{
				while(SQL_FetchRow(QueryDB))
				{	
					char PremiumName[128]; 
					char PremiumID[16];
			
					int ID = SQL_FetchInt(QueryDB, 0); 
					int Days = SQL_FetchInt(QueryDB, 1);
			
					Format(PremiumName, sizeof(PremiumName), "%i", Days); 
					Format(PremiumID, sizeof(PremiumID), "%i", ID);
			
					AddMenuItem(ShopFourMenu, PremiumID, PremiumName);
				}
			} else { SQL_GetError(DB, Error, sizeof(Error)); LogToFile("addons/sourcemod/logs/OnlineShop.txt", "[MySQL] %s", Error); }
			
			SetMenuPagination(ShopFourMenu, 7);
			SetMenuExitButton(ShopFourMenu, true);
			AddMenuItem(ShopFourMenu, "back", "Powrót");
			DisplayMenu(ShopFourMenu, User, 250);
		}
	} else if(Data == MenuAction_End) { CloseHandle(MenuID); }
}

public int FourMenuHandle(Handle MenuID, MenuAction Data, int User, int Info)
{
	if(Data == MenuAction_Select)
	{
		char Item[16]; 
		char Error[256];
		char Query[256];

		GetMenuItem(MenuID, Info, Item, sizeof(Item));
		
		if(StrEqual(Item, "back")) 
		{ 
			OneMenu(User, 0); 
		}
		else {
			PlayerBuyCache[User] = StringToInt(Item);
			
			Format(Query, sizeof(Query), "SELECT `price_id`, `days`, `buy_id` FROM `service` WHERE `id`='%s'", Item); Handle QueryDB = SQL_Query(DB, Query);
			
			if(QueryDB != INVALID_HANDLE)
			{
				if(SQL_FetchRow(QueryDB))
				{
					char Name[64];
					
					int Price = SQL_FetchInt(QueryDB, 0); int Days = SQL_FetchInt(QueryDB, 1); int BuyID = SQL_FetchInt(QueryDB, 2);
			
					SQL_FetchString(QueryDB, 1, Name, sizeof(Name));
					
					Format(Query, sizeof(Query), "SELECT `vat`, `number` FROM `price` WHERE `id`='%i'", Price); QueryDB = SQL_Query(DB, Query);
			
					if(QueryDB != INVALID_HANDLE)
					{
						if(SQL_FetchRow(QueryDB))
						{
							char VAT[16];
					
							SQL_FetchString(QueryDB, 0, VAT, sizeof(VAT));
					
							int Number = SQL_FetchInt(QueryDB, 1);
							
							Format(Query, sizeof(Query), "SELECT `name` FROM `buy` WHERE `id`='%i'", BuyID); QueryDB = SQL_Query(DB, Query);
							
							if(QueryDB != INVALID_HANDLE)
							{
								if(SQL_FetchRow(QueryDB))
								{
									SQL_FetchString(QueryDB, 0, Name, sizeof(Name));
									
									Format(Query, sizeof(Query), "*Online Shop by Sloenthran*\n Aby zakupić %s [%i dni] wyślij SMS-a o treści %s na numer %i\nNastępnie naciśnij na OK i podaj kod zwrotny w wiadomości na czacie.\nCałkowity koszt SMS-a wynosi %s", Name, Days, TextSMS, Number, VAT);
							
									Handle ShopThreeMenu = CreateMenu(ThreeMenuHandle);
									SetMenuTitle(ShopThreeMenu, Query);
									AddMenuItem(ShopThreeMenu, "ok", "OK");
									SetMenuPagination(ShopThreeMenu, 7);
									SetMenuExitButton(ShopThreeMenu, true);
									AddMenuItem(ShopThreeMenu, "back", "Powrót");
									DisplayMenu(ShopThreeMenu, User, 250);
								}
							} else { SQL_GetError(DB, Error, sizeof(Error)); LogToFile("addons/sourcemod/logs/OnlineShop.txt", "[MySQL] %s", Error); }
						}
					} else { SQL_GetError(DB, Error, sizeof(Error)); LogToFile("addons/sourcemod/logs/OnlineShop.txt", "[MySQL] %s", Error); }
				}
			} else { SQL_GetError(DB, Error, sizeof(Error)); LogToFile("addons/sourcemod/logs/OnlineShop.txt", "[MySQL] %s", Error); }
		}
	} else if(Data == MenuAction_End) { CloseHandle(MenuID); }
}

public Action TwoMenu(int User, int Arg)
{
	Handle ShopTwoMenu = CreateMenu(TwoMenuHandle);
	SetMenuTitle(ShopTwoMenu, "*Online Shop by Sloenthran*");
	AddMenuItem(ShopTwoMenu, "1", "Zakup usługę");
	AddMenuItem(ShopTwoMenu, "2", "Moje usługi");
	SetMenuPagination(ShopTwoMenu, 7);
	SetMenuExitButton(ShopTwoMenu, true);
	DisplayMenu(ShopTwoMenu, User, 250);
}

public int TwoMenuHandle(Handle MenuID, MenuAction Data, int User, int Info)
{
	if(Data == MenuAction_Select)
	{
		char Item[16];

		GetMenuItem(MenuID, Info, Item, sizeof(Item));
		
		if(StrEqual(Item, "1")) { OneMenu(User, 0); }
		else if(StrEqual(Item, "2")) { MyServiceMenu(User, 0); }
	} else if(Data == MenuAction_End) { CloseHandle(MenuID); }
}

public int ThreeMenuHandle(Handle MenuID, MenuAction Data, int User, int Info)
{
	if(Data == MenuAction_Select)
	{
		char Item[16];

		GetMenuItem(MenuID, Info, Item, sizeof(Item));
		
		if(StrEqual(Item, "ok")) { PlayerBuy[User] = true; }
		else { OneMenu(User, 0); }
	} else if(Data == MenuAction_End) { CloseHandle(MenuID); }
}

//////////////////////////////////////////////// My Services ////////////////////////////////////////////////

public Action MyServiceMenu(int User, int Arg)
{
	char SID[64];
	char Error[256];
	char Query[256];
				
	GetClientAuthId(User, AuthId_Engine, SID, sizeof(SID));
	
	Format(Query, sizeof(Query), "SELECT `time`, `premium_id`, `id` FROM `premium_cache` WHERE `nick`='%s' AND `server`='%i'", SID, ServerID); Handle QueryDB = SQL_Query(DB, Query);
	
	if(QueryDB != INVALID_HANDLE)
	{

		while(SQL_FetchRow(QueryDB))
		{
			int Time = SQL_FetchInt(QueryDB, 0); int PremiumID = SQL_FetchInt(QueryDB, 1); int ID = SQL_FetchInt(QueryDB, 2);
			
			Format(Query, sizeof(Query), "SELECT `name` FROM `buy` WHERE `id`='%i'", PremiumID); Handle QueryDB = SQL_Query(DB, Query);
			
			if(QueryDB != INVALID_HANDLE)
			{
				
			} else { SQL_GetError(DB, Error, sizeof(Error)); LogToFile("addons/sourcemod/logs/OnlineShop.txt", "[MySQL] %s", Error); }
		}
	} else { SQL_GetError(DB, Error, sizeof(Error)); LogToFile("addons/sourcemod/logs/OnlineShop.txt", "[MySQL] %s", Error); }
	
}

public int HandleMyServiceMenu(Handle MenuID, MenuAction Data, int User, int Info)
{
	if(Data == MenuAction_Select)
	{
		char Item[16];

		GetMenuItem(MenuID, Info, Item, sizeof(Item));
	} else if(Data == MenuAction_End) { CloseHandle(MenuID); }
}

////////////////////////////////////////////// End My Services //////////////////////////////////////////////

public Action CheckSay(User, Arg)
{	
	if(PlayerBuy[User])
	{
		char Code[32]; 
		char URL[256];
		char SID[64];
		char PremiumID[64];
	
		Format(PremiumID, sizeof(PremiumID), "%i", PlayerBuyCache[User]);
		
		GetCmdArgString(Code, sizeof(Code));
		GetClientAuthId(User, AuthId_Engine, SID, sizeof(SID));
		
		PlayerBuy[User] = false;
		
		Format(URL, sizeof(URL), "http://%s/index.php?pages=server_buy&sid=%s&premium=%s&serverid=%i", ShopURL, SID, PremiumID, ServerID);
		
		Handle HTTPRequest = SteamWorks_CreateHTTPRequest(k_EHTTPMethodGET, URL);
		SteamWorks_SetHTTPRequestNetworkActivityTimeout(HTTPRequest, 10);
		SteamWorks_SetHTTPRequestGetOrPostParameter(HTTPRequest, "code", Code);
		SteamWorks_SetHTTPRequestHeaderValue(HTTPRequest, "Online Shop", "Sloenthran");
		SteamWorks_SetHTTPRequestContextValue(HTTPRequest, 10);
		SteamWorks_SetHTTPCallbacks(HTTPRequest, ReturnQueryHTTP);

 		if (!SteamWorks_SendHTTPRequest(HTTPRequest)) { CloseHandle(HTTPRequest); LogToFile("addons/sourcemod/logs/OnlineShop.txt", "[SteamWorks] Cannot send HTTP request!"); return Plugin_Handled; }

	  	SteamWorks_PrioritizeHTTPRequest(HTTPRequest);
		
		return Plugin_Handled;	
	}
	return Plugin_Continue;
}

public int ReturnQueryHTTP(Handle Request, bool Fail, bool CheckSucess, EHTTPStatusCode Status, any Data) 
{
	if(!CheckSucess) { LogToFile("addons/sourcemod/logs/OnlineShop.txt", "[SteamWorks] HTTP request error!"); CloseHandle(Request); return; }
	
	if(Status == k_EHTTPStatusCode200OK) {
		int BodySize; 
		char BodyBuffer[10000];
		
		if(!SteamWorks_GetHTTPResponseBodySize(Request, BodySize)) { LogToFile("addons/sourcemod/logs/OnlineShop.txt", "[SteamWorks] Not get response size!"); CloseHandle(Request); return; }
		if(BodySize > 10000) { LogToFile("addons/sourcemod/logs/OnlineShop.txt", "[SteamWorks] Response size is to big!"); CloseHandle(Request); return; }
		if(!SteamWorks_GetHTTPResponseBodyData(Request, BodyBuffer, BodySize)) { LogToFile("addons/sourcemod/logs/OnlineShop.txt", "[SteamWorks] Not get response data!"); CloseHandle(Request); return; }

		char StringBreak[2][64];
		ExplodeString(BodyBuffer, "|", StringBreak, sizeof(StringBreak), sizeof(StringBreak[]));
		
		int PlayerNumber = GetMaxClients();
		
		for (int Number = 1; Number <= PlayerNumber; Number++)
		{
			if(IsClientInGame(Number))
			{
				char SID[64];
				
				GetClientAuthId(Number, AuthId_Engine, SID, sizeof(SID));
				
				if(StrEqual(SID, StringBreak[1])) 
				{
					if(StrEqual(StringBreak[0], "ok"))
					{
						
						GiveFlag(Number);
						
						PrintToChat(Number, "[OnlineShop] Podany przez Ciebie kod jest poprawny!");
					}
					else if(StrEqual(StringBreak[0], "extension")){ PrintToChat(Number, "[OnlineShop] Posiadałeś już tą usługę na tym serwerze, więc została ona przedłużona!"); }
					else { PrintToChat(Number, "[OnlineShop] Kod zwrotny, który podałeś jest błędny!"); }
					
					PlayerBuyCache[Number] = 0;
					break;
				}
			}
		}
		
		CloseHandle(Request);
	} else { LogToFile("addons/sourcemod/logs/OnlineShop.txt", "[SteamWorks] Bad status code (%d)!", Status); CloseHandle(Request); return; }
}

public void GiveFlag(int User)
{
	char Error[256];
	
	if(IsClientInGame(User))
	{
		char SID[64];
		char Query[256];
		
		GetClientAuthId(User, AuthId_Engine, SID, sizeof(SID));
		
		Format(Query, sizeof(Query), "SELECT `flags` FROM `premium` WHERE `server`='%i' AND `nick`='%s'", ServerID, SID); Handle QueryDB = SQL_Query(DB, Query);
			
		if(QueryDB != INVALID_HANDLE)
		{
			if(SQL_FetchRow(QueryDB))
			{
				char Flags[64];
				
				SQL_FetchString(QueryDB, 0, Flags, sizeof(Flags));
				
				int FlagsInt = ReadFlagString(Flags);
				
				SetUserFlagBits(User, FlagsInt);	
			}
		}
	} else { SQL_GetError(DB, Error, sizeof(Error)); LogToFile("addons/sourcemod/logs/OnlineShop.txt", "[MySQL] %s", Error); }
}
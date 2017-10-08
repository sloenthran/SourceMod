#include <sourcemod>
#include <sdktools>
#include <string>

#pragma semicolon 1
#pragma newdecls required

char CheckWords[100][128];

public Plugin myinfo = 
{ 
	name = "Auto Name Changer [v0.9]", 
	author = "Sloenthran", 
	description = "Auto Name Changer", 
	url = "sloenthran.pl" 
};

public void OnPluginStart() 
{
	Format(CheckWords[0], sizeof(CheckWords[]), "pijemy-rozrabiamy.pl");
	Format(CheckWords[1], sizeof(CheckWords[]), "cs-placzabaw.pl");
	Format(CheckWords[2], sizeof(CheckWords[]), "brygadagraczy.pl");
	Format(CheckWords[3], sizeof(CheckWords[]), "csgopolygon.com");
	Format(CheckWords[4], sizeof(CheckWords[]), "csgoexclusive.com");
	Format(CheckWords[5], sizeof(CheckWords[]), "csgofast.com");
	Format(CheckWords[6], sizeof(CheckWords[]), "skinup.gg");
	Format(CheckWords[7], sizeof(CheckWords[]), "drakewing.com");
	Format(CheckWords[8], sizeof(CheckWords[]), "csgobounty.com");
	Format(CheckWords[9], sizeof(CheckWords[]), "csgowitch.com");
	Format(CheckWords[10], sizeof(CheckWords[]), "csgoboss.com");
	Format(CheckWords[11], sizeof(CheckWords[]), "csgofp.com");
	Format(CheckWords[12], sizeof(CheckWords[]), "csgomax.net");
	Format(CheckWords[13], sizeof(CheckWords[]), "csgomiami.com");
	Format(CheckWords[14], sizeof(CheckWords[]), "bets.gg");
	Format(CheckWords[15], sizeof(CheckWords[]), "csgocasino.com");
	Format(CheckWords[16], sizeof(CheckWords[]), "csgoempire.com");
	Format(CheckWords[17], sizeof(CheckWords[]), "csgo500.com");
	Format(CheckWords[18], sizeof(CheckWords[]), "csgowheel.com");
	Format(CheckWords[19], sizeof(CheckWords[]), "csgospeed.com");
	Format(CheckWords[20], sizeof(CheckWords[]), "csgoroll.com");
	Format(CheckWords[21], sizeof(CheckWords[]), "csgotrinity.com");
	Format(CheckWords[22], sizeof(CheckWords[]), "csgomassive.com");
	Format(CheckWords[23], sizeof(CheckWords[]), "csgohype.com");
	Format(CheckWords[24], sizeof(CheckWords[]), "csgotips.com");
	Format(CheckWords[25], sizeof(CheckWords[]), "skinamp.com");
	Format(CheckWords[26], sizeof(CheckWords[]), "csgocrafter.com");
	Format(CheckWords[27], sizeof(CheckWords[]), "upgrade.gg");
	Format(CheckWords[28], sizeof(CheckWords[]), "skinsproject.pl");
	Format(CheckWords[29], sizeof(CheckWords[]), "csgo-case.com");
	Format(CheckWords[30], sizeof(CheckWords[]), "drakemoon.com");
	Format(CheckWords[31], sizeof(CheckWords[]), "hellcase.com");
	Format(CheckWords[32], sizeof(CheckWords[]), "wildcase.com");
	Format(CheckWords[33], sizeof(CheckWords[]), "csgolive.com");
	Format(CheckWords[34], sizeof(CheckWords[]), "farmskins.com");
	Format(CheckWords[35], sizeof(CheckWords[]), "csgoatse.com");
	Format(CheckWords[36], sizeof(CheckWords[]), "csgobig.com");
	Format(CheckWords[37], sizeof(CheckWords[]), "drakelounge.com");
	Format(CheckWords[38], sizeof(CheckWords[]), "csgoblackjack.com");
	Format(CheckWords[39], sizeof(CheckWords[]), "society.gg");
	Format(CheckWords[40], sizeof(CheckWords[]), "csgostrong.com");
	Format(CheckWords[41], sizeof(CheckWords[]), "csgo-skins.pl");
	Format(CheckWords[42], sizeof(CheckWords[]), "csgo-skins.com");
	Format(CheckWords[43], sizeof(CheckWords[]), "pvpro.com");
	Format(CheckWords[44], sizeof(CheckWords[]), "skinsmash.com");
	Format(CheckWords[45], sizeof(CheckWords[]), "csbetgo.com");
	Format(CheckWords[46], sizeof(CheckWords[]), "projektspark.pl");
	Format(CheckWords[47], sizeof(CheckWords[]), "cs-ultraskill.pl");
	Format(CheckWords[48], sizeof(CheckWords[]), "cs-soplica.com");
	Format(CheckWords[49], sizeof(CheckWords[]), "1shot2kill.pl");
	Format(CheckWords[50], sizeof(CheckWords[]), "fraguj.com");
	Format(CheckWords[51], sizeof(CheckWords[]), "zabijambolubie.pl");
	Format(CheckWords[52], sizeof(CheckWords[]), "sloneczny-dust.pl");
	Format(CheckWords[53], sizeof(CheckWords[]), "uwujka.pl");
	Format(CheckWords[54], sizeof(CheckWords[]), "cs-ultra.pl");
	Format(CheckWords[55], sizeof(CheckWords[]), "cs-jump.pl");
	Format(CheckWords[56], sizeof(CheckWords[]), "csone.eu");
	Format(CheckWords[57], sizeof(CheckWords[]), "cskatowice.com");
	Format(CheckWords[58], sizeof(CheckWords[]), "multi-head.pl");
	Format(CheckWords[59], sizeof(CheckWords[]), "fragujemy.com");
	Format(CheckWords[60], sizeof(CheckWords[]), "cs-reload.pl");
	Format(CheckWords[61], sizeof(CheckWords[]), "cswild.pl");
	Format(CheckWords[62], sizeof(CheckWords[]), "ggwp.pl");
	Format(CheckWords[63], sizeof(CheckWords[]), "csgosell.com");
	Format(CheckWords[64], sizeof(CheckWords[]), "skinsjar.com");
	Format(CheckWords[65], sizeof(CheckWords[]), "dotax2.com");
	Format(CheckWords[66], sizeof(CheckWords[]), "dogry.pl");
	Format(CheckWords[67], sizeof(CheckWords[]), "cs.money");
	Format(CheckWords[68], sizeof(CheckWords[]), "skin.trade");
	Format(CheckWords[69], sizeof(CheckWords[]), "csgoblocks.com");
	Format(CheckWords[70], sizeof(CheckWords[]), "csgowobble.com");
	Format(CheckWords[71], sizeof(CheckWords[]), "gamdom.com");
	Format(CheckWords[72], sizeof(CheckWords[]), "g2a.com");
	Format(CheckWords[73], sizeof(CheckWords[]), "emerald.gg");
	Format(CheckWords[74], sizeof(CheckWords[]), "gamers-x.net");
	Format(CheckWords[75], sizeof(CheckWords[]), "redpot.pro");
	Format(CheckWords[76], sizeof(CheckWords[]), "casejar.com");
	Format(CheckWords[77], sizeof(CheckWords[]), "sklep-skiny.pl");
	Format(CheckWords[78], sizeof(CheckWords[]), "cebulomat.pl");
	Format(CheckWords[79], sizeof(CheckWords[]), "gimbomat.pl");
	Format(CheckWords[80], sizeof(CheckWords[]), "skinboost.gg");
	Format(CheckWords[81], sizeof(CheckWords[]), "cs-4frags.pl");
	Format(CheckWords[82], sizeof(CheckWords[]), "csgobestpot.com");
	Format(CheckWords[83], sizeof(CheckWords[]), "zgame.pl");
	Format(CheckWords[84], sizeof(CheckWords[]), "csgoreaper.com");
	Format(CheckWords[85], sizeof(CheckWords[]), "csgoswap.com");
	Format(CheckWords[86], sizeof(CheckWords[]), "csgofliper.com");
	Format(CheckWords[87], sizeof(CheckWords[]), "csgopotion.com");
	Format(CheckWords[88], sizeof(CheckWords[]), "bananki.pl");
	Format(CheckWords[89], sizeof(CheckWords[]), "casedrop.eu");
	Format(CheckWords[90], sizeof(CheckWords[]), "csgoloto.com");
	Format(CheckWords[91], sizeof(CheckWords[]), "csgofliper.com");
	Format(CheckWords[92], sizeof(CheckWords[]), "csgohunt.com");
	Format(CheckWords[93], sizeof(CheckWords[]), "csgonecro.com");
	Format(CheckWords[94], sizeof(CheckWords[]), ".eu");
	Format(CheckWords[95], sizeof(CheckWords[]), ".pl");
	Format(CheckWords[96], sizeof(CheckWords[]), ".gg");
	Format(CheckWords[97], sizeof(CheckWords[]), ".ru");
	Format(CheckWords[98], sizeof(CheckWords[]), ".com");
	Format(CheckWords[99], sizeof(CheckWords[]), ".net");
	
	
}


public void OnClientPutInServer(int User) 
{
	CreateTimer(3.0, CheckUser, User);
}

public Action CheckUser(Handle Time, any Data)
{
	int User = Data;
	char UserName[64];
	
	GetClientName(User, UserName, sizeof(UserName));
	
	if(StrContains(UserName, "MyServ.pl", false) == -1)
	{
		for(int Number = 0; Number < sizeof(CheckWords); Number++)
		{
			if(!StrEqual(CheckWords[Number], "") && (StrContains(UserName, CheckWords[Number], false) != -1))
			{
				ReplaceString(UserName, sizeof(UserName), CheckWords[Number], "", false);
				SetClientInfo(User, "name", UserName);
			}
		}
	}
}
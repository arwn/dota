#!/usr/bin/env sh
# add duration
# add hero
awk '
BEGIN{
	{print "gold per minute, total xp, gold per minute, xp per minute"};
	{print "LastHit, Deny, ClaimedMiss, ClaimedDeny, Miss"};
	{print "Level, Gold, K, D, A"};
	{print "Actual Player Damage, Actual Building Damage, Actual Healing"};
	{print "Scaled Player Damage, Scaled Building Damage, Scaled Healing"};
	{print "XP per min, Gold per min, Claimed Farm, Support Gold"}
}

{
	if($0 ~ /Player 0 Account 0 TotalGold/){mode = "totals"};
	if($0 ~ /^Match signout:  duration/){mode = "beef"};
	if($0 ~ /^KILLEATER/){mode = 0}
	
	if($0 ~ /PR:SetSelectedHero/){
		hero[h] = $3;
		h++;
	}else if(mode == "totals"){
		gold[i] = $7;
		xp[i] = $10;
		gpm[i] = $13;
		xppm[i] = $16;
		i++;
	}else if(mode == "beef"){
		if ($0 ~ /^Team/){
			printf "%s,%d,%d,%d,%d", hero[j], gold[j], xp[j], gpm[j], xppm[j];
			j++;
		}else if($0 ~ /LastHit/){
			printf "%d,%d,%d,%d,%d,", $3, $6, $9, $12, $15;
		}else if($0 ~ /Level:/){
			printf "%d,%d,%d,%d,%d,", $2, $4, $6, $8, $10;
		}else if($0 ~ /Actual Player Damage:/\
				|| $0 ~ /Scaled Player Damage:/){
			printf "%d,%d,%d", $4, $8, $11;
		}else if($0 ~ /XP per min:/){
			printf "%d,%d,%d,%d\n", $4, $8, $11, $14 "\n";
		}
	}
}

' $1
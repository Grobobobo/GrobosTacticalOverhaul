class X2Effect_Shrouded_LW extends X2Effect_Shrouded;


function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ShotMod;
	if (!bIndirectFire)
	{
		ShotMod.ModType = eHit_Success;
		ShotMod.Value = -class'X2StatusEffects'.default.SHROUDED_DEFENSE_BONUS;
		ShotMod.Reason = class'X2StatusEffects'.default.ShroudedFriendlyName;
		ShotModifiers.AddItem(ShotMod);
    }
    if (bFlanking)
    {
        ShotMod.ModType = eHit_Crit;
        ShotMod.Reason = class'X2StatusEffects'.default.ShroudedFriendlyName;
        ShotMod.Value = 0 - Attacker.GetCurrentStat(eStat_FlankingCritChance);
        ShotModifiers.AddItem(ShotMod);
    }
	
}
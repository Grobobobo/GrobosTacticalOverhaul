class X2Effect_SmokeGrenade_Antiflank extends X2Effect_SmokeGrenade config(GameCore);

var config bool bSmokePreventsFlanking;

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ShotMod;

	if (Target.IsInWorldEffectTile(class'X2Effect_ApplySmokeGrenadeToWorld'.default.Class.Name) || Target.IsInWorldEffectTile(class'X2Effect_ApplySmokeGrenadeToWorld_NoLOS'.default.Class.Name))
	{
		ShotMod.ModType = eHit_Success;
		ShotMod.Value = HitMod;
		ShotMod.Reason = FriendlyName;
		ShotModifiers.AddItem(ShotMod);

		if (bFlanking && bSmokePreventsFlanking)
		{
			ShotMod.ModType = eHit_Crit;
			ShotMod.Reason = FriendlyName;
			ShotMod.Value = 0 - Attacker.GetCurrentStat(eStat_FlankingCritChance);

			ShotModifiers.AddItem(ShotMod);
		}
	}
}

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
	return TargetUnit.IsInWorldEffectTile(class'X2Effect_ApplySmokeGrenadeToWorld'.default.Class.Name) ||
		   TargetUnit.IsInWorldEffectTile(class'X2Effect_ApplySmokeGrenadeToWorld_NoLOS'.default.Class.Name);
}

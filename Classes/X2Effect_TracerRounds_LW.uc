class X2Effect_TracerRounds_LW extends X2Effect_TracerRounds config(GameCore);

var config int TRACER_AIM_MOD;
var config int TRACER_CRIT_MOD;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ModInfo;
	local XComGameState_Item SourceWeapon;

	SourceWeapon = AbilityState.GetSourceWeapon();
	if (SourceWeapon != none && SourceWeapon.LoadedAmmo.ObjectID == EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID)
	{
		ModInfo.ModType = eHit_Success;
		ModInfo.Reason = FriendlyName;
		ModInfo.Value = default.TRACER_AIM_MOD;
		ShotModifiers.AddItem(ModInfo);

        ModInfo.ModType = eHit_Crit;
		ModInfo.Reason = FriendlyName;
		ModInfo.Value = default.TRACER_CRIT_MOD;
		ShotModifiers.AddItem(ModInfo);
	}
}

DefaultProperties
{
	DuplicateResponse = eDupe_Ignore
}
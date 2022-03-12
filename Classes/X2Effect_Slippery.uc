//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_CombatAwareness
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up armor and defense bonuses for Combat Awareness; template definition
//	specifies effect as conditional on having an OW point
//---------------------------------------------------------------------------------------
class X2Effect_Slippery extends X2Effect_BonusArmor config (GameData_SoldierSkills);

var config int SLIPPERY_BONUS_ARMOR;
var config int SLIPPERY_BONUS_DEFENSE;


function int GetArmorMitigation(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
	if (UnitState.IsUnitApplyingEffectName( class'X2AbilityTemplateManager'.default.BoundName))
	{
	    return default.SLIPPERY_BONUS_ARMOR;		
	}
	return 0;
}
	
function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo ShotInfo;

	if (Target.IsUnitApplyingEffectName( class'X2AbilityTemplateManager'.default.BoundName))
	{
		ShotInfo.ModType = eHit_Success;
		ShotInfo.Reason = FriendlyName;
		ShotInfo.Value = -default.SLIPPERY_BONUS_DEFENSE;
		ShotModifiers.AddItem(ShotInfo);
	}
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
    EffectName="Slippery"
}
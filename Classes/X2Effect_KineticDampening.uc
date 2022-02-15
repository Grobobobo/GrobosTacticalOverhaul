//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_Brawler
//  AUTHOR:  Grobobobo
//  PURPOSE: Sets up the DR bonus for brawler
//---------------------------------------------------------------------------------------
class X2Effect_KineticDampening extends X2Effect_Persistent config (GameData_SoldierSkills);

var config float DrPerTile;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	local int   Tiles;

	Tiles = Attacker.TileDistanceBetween(XComGameState_Unit(TargetDamageable));       
	if (AbilityState.IsMeleeAbility())
	{
        return 0;
    }

    return -CurrentDamage * DrPerTile * Tiles;

}

defaultproperties
{
	DuplicateResponse=eDupe_Ignore
	EffectName="KineticDampening"
	bDisplayInSpecialDamageMessageUI=true
}

class X2Effect_SoulFireBonusDamage extends X2Effect_SecondaryMeleeBonus;

var int SoulFireDamageBonusTier2;

var int SoulFireDamageBonusTier3;


function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Item PrimaryWeapon;
    local array<name> EquippedUpgrades;

	PrimaryWeapon = Attacker.GetPrimaryWeapon();

    if (PrimaryWeapon == none)
    {
        return 0;
    }

    EquippedUpgrades = PrimaryWeapon.GetMyWeaponUpgradeTemplateNames();

    if (AbilityState.GetMyTemplateName() != 'SoulFire')
    {
        return 0; // don't incresae damage for takedowns
    }

    if(IsWeaponTier3(EquippedUpgrades))
    {
        return SoulFireDamageBonusTier3;
    }
    if(IsWeaponTier2(EquippedUpgrades))
    {   
        return SoulFireDamageBonusTier2;
    }  

    return 0;
}


defaultproperties
{
	bDisplayInSpecialDamageMessageUI = false
}

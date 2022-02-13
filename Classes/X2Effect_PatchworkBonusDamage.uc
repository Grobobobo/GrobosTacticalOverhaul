class X2Effect_PatchWorkBonusDamage extends X2Effect_SecondaryMeleeBonus;

var int PatchWorkDamageBonusTier2;

var int PatchWorkDamageBonusTier3;


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

    if (AbilityState.GetMyTemplateName() != 'CombatProtocol')
    {
        return 0;
    }

    if(IsWeaponTier3(EquippedUpgrades))
    {
        return PatchWorkDamageBonusTier3;
    }
    if(IsWeaponTier2(EquippedUpgrades))
    {   
        return PatchWorkDamageBonusTier2;
    }

    return 0;
}


defaultproperties
{
	bDisplayInSpecialDamageMessageUI = false
}

class X2Effect_TorqueBonusDamage extends X2Effect_SecondaryMeleeBonus;

var int TorqueDamageBonusTier2;

var int TorqueDamageBonusTier3;


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

    if (AbilityState.GetMyTemplateName() == 'Inquisitor_PoisonSpit' || AbilityState.GetMyTemplateName() == 'BreachInquisitorAbility')
    {
        if(IsWeaponTier3(EquippedUpgrades))
        {
            return TorqueDamageBonusTier3;
        }
        if(IsWeaponTier2(EquippedUpgrades))
        {   
            return TorqueDamageBonusTier2;
        }

    }


    return 0;
}


defaultproperties
{
	bDisplayInSpecialDamageMessageUI = false
}

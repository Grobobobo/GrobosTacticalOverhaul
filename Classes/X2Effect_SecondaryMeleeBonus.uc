class X2Effect_SecondaryMeleeBonus extends X2Effect_Persistent;

var int MeleeDamageBonusTier2;

var int MeleeDamageBonusTier3;


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


    if (AbilityState.GetMyTemplateName() == 'Takedown' || AbilityState.GetMyTemplateName() == 'HellionTakedown'
    || AbilityState.GetMyTemplateName() == 'RiotBash')
    {
        return 0;
    }

    if(IsWeaponTier3(EquippedUpgrades) && AbilityState.IsMeleeAbility())
    {
        return MeleeDamageBonusTier3;
    }
    if(IsWeaponTier2(EquippedUpgrades) && AbilityState.IsMeleeAbility())
    {   
        return MeleeDamageBonusTier2;
    }

	return 0;
}

static function bool IsWeaponTier2(array<name> EquippedUpgrades)
{
    if(EquippedUpgrades.Find('EnhancedARsUpgrade') != INDEX_NONE ||
    EquippedUpgrades.Find('EnhancedShotgunsUpgrade') != INDEX_NONE ||
    EquippedUpgrades.Find('EnhancedSMGsUpgrade') != INDEX_NONE ||
    EquippedUpgrades.Find('EnhancedPistolsUpgrade') != INDEX_NONE ||
    EquippedUpgrades.Find('EnhancedGauntletsUpgrade') != INDEX_NONE)
    {
        return true;
    }
    else
    {
        return false;
    }
}

static function bool IsWeaponTier3(array<name> EquippedUpgrades)
{
    if(EquippedUpgrades.Find('MastercraftedARsUpgrade') != INDEX_NONE ||
    EquippedUpgrades.Find('MastercraftedShotgunsUpgrade') != INDEX_NONE ||
    EquippedUpgrades.Find('MastercraftedSMGsUpgrade') != INDEX_NONE ||
    EquippedUpgrades.Find('MastercraftedPistolsUpgrade') != INDEX_NONE ||
    EquippedUpgrades.Find('MastercraftedGauntletsUpgrade') != INDEX_NONE)
    {
        return true;
    }
    else
    {
        return false;
    }
}

defaultproperties
{
	bDisplayInSpecialDamageMessageUI = false
}

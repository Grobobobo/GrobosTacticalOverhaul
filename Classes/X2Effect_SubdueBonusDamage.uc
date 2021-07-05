class X2Effect_SubdueBonusDamage extends X2Effect_Persistent;

var int MeleeDamageBonusTier2;

var int MeleeDamageBonusTier3;


function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
    local XComGameState_Item Armor;

    Armor = Attacker.GetItemInSlot(eInvSlot_Armor);

    if (AbilityState.GetMyTemplateName() != 'Takedown')
    {
        return 0; // don't incresae damage for takedowns
    }
    if(Armor.GetMyTemplateName() == 'EnhancedKevlarArmor' && AbilityState.IsMeleeAbility())
    {
        return MeleeDamageBonusTier2;
    }
    else if(Armor.GetMyTemplateName() == 'MastercraftedKevlarArmor' && AbilityState.IsMeleeAbility())
    {
         
        return MeleeDamageBonusTier3;
    }
	return 0;
}


defaultproperties
{
	bDisplayInSpecialDamageMessageUI = false
}

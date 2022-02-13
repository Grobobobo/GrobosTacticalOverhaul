class X2Effect_SoulFireBonusDamage extends X2Effect_Persistent;

var int SoulFireDamageBonusTier2;

var int SoulFireDamageBonusTier3;


function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
    local XComGameState_Item Armor;

    Armor = Attacker.GetItemInSlot(eInvSlot_Armor);

    if (AbilityState.GetMyTemplateName() != 'SoulFire')
    {
        return 0; // don't incresae damage for takedowns
    }
    if(Armor.GetMyTemplateName() == 'EnhancedKevlarArmor')
    {
           
        return SoulFireDamageBonusTier2;
    }
    else if(Armor.GetMyTemplateName() == 'MastercraftedKevlarArmor')
    {
         
        return SoulFireDamageBonusTier3;
    }
	return 0;
}


defaultproperties
{
	bDisplayInSpecialDamageMessageUI = false
}

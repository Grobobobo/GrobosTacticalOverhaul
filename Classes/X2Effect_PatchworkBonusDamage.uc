class X2Effect_PatchWorkBonusDamage extends X2Effect_Persistent;

var int PatchWorkDamageBonusTier2;

var int PatchWorkDamageBonusTier3;


function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
    local XComGameState_Item Armor;

    Armor = Attacker.GetItemInSlot(eInvSlot_Armor);

    if (AbilityState.GetMyTemplateName() != 'CombatProtocol')
    {
        return 0; // don't incresae damage for takedowns
    }
    if(Armor.GetMyTemplateName() == 'EnhancedKevlarArmor')
    {
           
        return PatchWorkDamageBonusTier2;
    }
    else if(Armor.GetMyTemplateName() == 'MastercraftedKevlarArmor')
    {
         
        return PatchWorkDamageBonusTier3;
    }
	return 0;
}


defaultproperties
{
	bDisplayInSpecialDamageMessageUI = false
}

class X2Effect_PrimaryHitBonusCritDamage extends X2Effect_Persistent;

var int BonusCritDamage;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local X2WeaponTemplate WeaponTemplate;
    local X2AbilityToHitCalc_StandardAim StandardHit;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;

	if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
	{
		WeaponDamageEffect = X2Effect_ApplyWeaponDamage(class'X2Effect'.static.GetX2Effect(AppliedData.EffectRef));
		if (WeaponDamageEffect != none)
		{			
			if (WeaponDamageEffect.bIgnoreBaseDamage)
			{	
				return 0;		
			}
		}
		WeaponTemplate = X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate());
		if (WeaponTemplate.weaponcat == 'grenade')
		{
			return 0;
		}
		StandardHit = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
		if (StandardHit != none && StandardHit.bIndirectFire)
		{
			return 0;
		}		
		if (AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef || AbilityState.GetSourceWeapon().GetMyTemplateName() == 'WPN_XComLancerPistol')
		{
			if (AppliedData.AbilityResultContext.HitResult == eHit_Crit)
			{
				return BonusCritDamage;
			}			
			else
			{
				return 0;
			}
		}
	}
	return 0;
}

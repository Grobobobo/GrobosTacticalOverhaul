class X2Effect_SubServienceDamage extends X2Effect_ApplyWeaponDamage;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local Damageable kNewTargetDamageableState;
	local int iDamage;
	local XComGameState_Unit TargetUnit;
    local UnitValue UValue;

     
	kNewTargetDamageableState = Damageable(kNewTargetState);
	if( kNewTargetDamageableState != none )
	{
        TargetUnit = XComGameState_Unit(kNewTargetState);
        TargetUnit.GetUnitValue('SubservienceDamageTaken',UValue);
        iDamage = int(Uvalue.fValue);
		kNewTargetDamageableState.TakeEffectDamage(self, iDamage, 0, 0, ApplyEffectParameters, NewGameState);

	}
}

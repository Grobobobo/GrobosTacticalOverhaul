class X2Effect_CombatStims_LW extends X2Effect_CombatStims config(GameCore);


function bool ProvidesDamageImmunity(XComGameState_Effect EffectState, name DamageType)
{
	return false;
}


DefaultProperties
{
	EffectName="CombatStims"
	DuplicateResponse=eDupe_Refresh
}
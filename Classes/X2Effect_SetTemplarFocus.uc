class X2Effect_SetTemplarFocus extends X2Effect;

var int SetFocus;
var bool bRemoveAll;
var bool bUseDeferredModifyValue;
var localized string FlyoverText;
var localized string BreakerFlyoverText;
var localized string BreakerRemoveFocusText;
var localized string FocusDepletedText;
var array<Name> BonusAppliedEffectNames;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Effect_TemplarFocus FocusState;
	local XComGameState_Unit TargetUnit;

	TargetUnit = XComGameState_Unit(kNewTargetState);
	FocusState = TargetUnit.GetTemplarFocusEffectState();
	if (FocusState != none)
	{
		FocusState = XComGameState_Effect_TemplarFocus(NewGameState.ModifyStateObject(FocusState.Class, FocusState.ObjectID));
		if(bRemoveAll)
		{
			FocusState.SetFocusLevel(0, TargetUnit, NewGameState);		
		}
		else
		{
			FocusState.SetFocusLevel(SetFocus, TargetUnit, NewGameState);		
		}
	}
}


DefaultProperties
{
	SetFocus = 5;
	bRemoveAll = false;
}
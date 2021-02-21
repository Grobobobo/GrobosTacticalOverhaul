//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_Subservience.uc
//  AUTHOR:  Dakota LeMaster
//  PURPOSE: 	Block all incoming damage from a single source, then the effect is destroyed.
//				When the effect is destroyed be sure to notify the source of this effect so
//				(the Sorcerer/Acolyte) can kill its serving unit
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2019 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Effect_Subservience_LW extends X2Effect_Subservience;

function bool ChangeHitResultForTarget(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, bool bIsPrimaryTarget, const EAbilityHitResult CurrentResult, out EAbilityHitResult NewHitResult)
{

	if( CanTriggerSubservienceSacrifice( EffectState, AbilityState, TargetUnit) && CurrentResult != eHit_Miss )
	{
		NewHitResult = eHit_Deflect;
		return true;
	}

	return false;
}


/*
// When a unit with kinetic shield takes effect damage, remove the shield effect and trigger an event
static function EventListenerReturn RedirectDamage(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateHistory				History;
	local XComGameState_Unit				TargetUnitState, EffectOwnerState;
	local UnitValue							SubservienceDamageTaken;
	local XComGameState_Effect EffectState;
	local XComGameState NewGameState;

		EffectState = XComGameState_Effect(EventSource);

		History = `XCOMHISTORY;


		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Set Float Values");

		TargetUnitState = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
		EffectOwnerState = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
		
		TargetUnitState.GetUnitValue('SubservienceDamageTaken',SubservienceDamageTaken);
		EffectOwnerState.SetUnitFloatValue('SubservienceDamageTaken',SubservienceDamageTaken.fvalue);
		EffectOwnerState = XComGameState_Unit(NewGameState.ModifyStateObject(EffectOwnerState.Class, EffectOwnerState.ObjectID));

		`XEVENTMGR.TriggerEvent('SubservienceDamageAbsorbed', TargetUnitState, TargetUnitState, NewGameState);

		`TACTICALRULES.SubmitGameState(NewGameState);

	return ELR_NoInterrupt;
}

*/

/*
static function EventListenerReturn RedirectDamage(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState						NewGameState;
	local XComGameStateHistory				History;
	local XComGameStateContext_EffectRemoved EffectRemovedState;
	local X2TacticalGameRuleset				TacticalRules;
	local XComGameState_Unit				TargetUnitState, EffectOwnerState;
	local UnitValue							MarkedDeflectEffectID;
	local array<XComGameState_Effect> EffectStates;
	local XComGameState_Effect SubservienceEffectState;
	local XComGameState_Effect	TetherEffectState;
	local X2Effect_Persistent	PersistentEffect;
	SubservienceEffectState = XComGameState_Effect(CallbackData);
	EffectStates.AddItem(SubservienceEffectState);

	if (!SubservienceEffectState.bRemoved)
	{
		History = `XCOMHISTORY;

		TargetUnitState = XComGameState_Unit(History.GetGameStateForObjectID(SubservienceEffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
		EffectOwnerState = XComGameState_Unit(History.GetGameStateForObjectID(SubservienceEffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
		//only remove if this is the marked effect from the deflect
		if( !EffectOwnerState.GetUnitValue('SubServienceMarkedForRemoval', MarkedDeflectEffectID) )
		{
			return ELR_NoInterrupt;
		}
		
		foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Effect', TetherEffectState)
		{
			if (SubservienceEffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID == TetherEffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID &&
				SubservienceEffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID == TetherEffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID)
			{
				PersistentEffect = TetherEffectState.GetX2Effect();
				if (PersistentEffect.EffectName == 'SubservienceTetherEffect')
				{
					EffectStates.AddItem(TetherEffectState);

					EffectRemovedState = class'XComGameStateContext_EffectRemoved'.static.CreateEffectsRemovedContext(EffectStates);
					NewGameState = History.CreateNewGameState(true, EffectRemovedState);
					SubservienceEffectState.RemoveEffect(NewGameState, GameState);
					TetherEffectState.RemoveEffect(NewGameState, GameState);
				}
			}
		}

		
		`XEVENTMGR.TriggerEvent('SubservienceDamageAbsorbed', TargetUnitState, TargetUnitState, NewGameState);
		
		if (NewGameState.GetNumGameStateObjects() > 0)
		{
			TacticalRules = `TACTICALRULES;
			TacticalRules.SubmitGameState(NewGameState);
		}
		else
		{
			History.CleanupPendingGameState(NewGameState);
		}
	}

	return ELR_NoInterrupt;
}
*/
simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameState_Effect	TetherEffectState;
	local X2Effect_Persistent PersistentEffect;
	super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Effect', TetherEffectState)
	{
		if (ApplyEffectParameters.SourceStateObjectRef.ObjectID == TetherEffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID &&
			ApplyEffectParameters.TargetStateObjectRef.ObjectID == TetherEffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID)
		{
			PersistentEffect = TetherEffectState.GetX2Effect();
			if (PersistentEffect.EffectName == 'SubservienceTetherEffect')
			{
				if(!TetherEffectState.bRemoved)
				{	
					TetherEffectState.RemoveEffect(NewGameState, NewGameState);
				}

			}
		}
	}
}

DefaultProperties
{
	bDisplayInSpecialDamageMessageUI=true
	EffectName="SubservienceEffect"
}
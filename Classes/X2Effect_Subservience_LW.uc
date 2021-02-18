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
class X2Effect_Subservience_LW extends X2Effect_Persistent;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	local XComGameState_Unit TargetUnitState;
	local int TargetIndex;

	TargetUnitState = XComGameState_Unit(TargetDamageable);
	if( CurrentDamage > 0 && CanTriggerSubservienceSacrifice( EffectState, AbilityState, TargetUnitState ) )
	{
		if( TargetUnitState != None )
		{
			if( AppliedData.AbilityInputContext.PrimaryTarget.ObjectID == TargetUnitState.ObjectID &&
				AppliedData.AbilityResultContext.HitResult == eHit_Deflect )
			{
				TargetUnitState.SetUnitFloatValue('SubservienceDamage',CurrentDamage);
				return -CurrentDamage;
			}
			for( TargetIndex = 0; TargetIndex < AppliedData.AbilityInputContext.MultiTargets.Length; ++TargetIndex )
			{
				if( AppliedData.AbilityInputContext.MultiTargets[TargetIndex].ObjectID == TargetUnitState.ObjectID &&
					AppliedData.AbilityResultContext.MultiTargetHitResults[TargetIndex] == eHit_Deflect )
				{

					TargetUnitState.SetUnitFloatValue('SubservienceDamage',CurrentDamage);
					return -CurrentDamage;
				}
			}
		}
	}

	return 0;
}
//
//function int ModifyDamageFromDestructible(XComGameState_Destructible DestructibleState, int IncomingDamage, XComGameState_Unit TargetUnit, XComGameState_Effect EffectState)
//{
//	// destructible damage is always considered to be explosive (copied from X2Effect_BlastShield)
//	return -IncomingDamage;
//}

function bool CanTriggerSubservienceSacrifice(XComGameState_Effect EffectState, XComGameState_Ability AbilityState, XComGameState_Unit TargetUnit)
{
	local StateObjectReference CheckAbilityRef;
	local XComGameState_Ability CheckAbilityState;
	local XComGameStateHistory History;
	local XComGameState_Unit SubservienceUnit;
	local XComGameState_Item SourceItemState;
	local X2AbilityTemplate AbilityTemplate;

	SourceItemState = AbilityState.GetSourceWeapon();
	if( AbilityState != None && SourceItemState != None )
	{
		AbilityTemplate = AbilityState.GetMyTemplate();
		if( false == AbilityTemplate.TargetEffectsDealDamage( SourceItemState, AbilityState ) )
		{
			return false;
		}
	}

	if( TargetUnit != None )
	{
		//target must be able to pass along the 'SubservienceSacrifice' in order to deflect
		History = `XCOMHISTORY;
			CheckAbilityRef = TargetUnit.FindAbility( 'SubservienceSacrifice' );
		CheckAbilityState = XComGameState_Ability( History.GetGameStateForObjectID( CheckAbilityRef.ObjectID ) );
		SubservienceUnit = XComGameState_Unit( History.GetGameStateForObjectID( EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID ) );
		if( CheckAbilityState != None && SubservienceUnit != None )
		{
			if( CheckAbilityState.CanActivateAbilityForObserverEvent( SubservienceUnit ) == 'AA_Success' )
			{
				if( X2AbilityToHitCalc_StandardAim( AbilityState.GetMyTemplate().AbilityToHitCalc ) != none )
				{
					return true;
				}
			}
		}
	}
	return false;
}
function bool ChangeHitResultForTarget(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, bool bIsPrimaryTarget, const EAbilityHitResult CurrentResult, out EAbilityHitResult NewHitResult)
{
	if( CanTriggerSubservienceSacrifice( EffectState, AbilityState, TargetUnit ) )
	{
		NewHitResult = eHit_Deflect;
		return true;
	}

	return false;
}

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit TargetUnitState;
	local XComGameStateHistory History;
	local Object EffectObj;

	History = `XCOMHISTORY;
	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	TargetUnitState = XComGameState_Unit(History.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	// Register for the required events
	EventMgr.RegisterForEvent(EffectObj, 'HitResultIs_Deflect', OnSubservienceUnitTookEffectDamage, ELD_OnStateSubmitted, , TargetUnitState);
}

function EventListenerReturn OnSubservienceUnitTookEffectDamage(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Unit				TargetUnitState;

	TargetUnitState = XComGameState_Unit(CallbackData);

	`XEVENTMGR.TriggerEvent('SubservienceDamageAbsorbed', TargetUnitState, TargetUnitState, GameState);

	return ELR_NoInterrupt;
}
DefaultProperties
{
	bDisplayInSpecialDamageMessageUI=true
	EffectName="SubservienceEffect"
}
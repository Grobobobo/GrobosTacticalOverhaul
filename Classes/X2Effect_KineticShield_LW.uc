class X2Effect_KineticShield_LW extends X2Effect_KineticShield;

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
	//just in case
	EventMgr.UnRegisterFromEvent(EffectObj, 'UnitAttackedWithNoDamage');
	// Register for the required events
	EventMgr.RegisterForEvent(EffectObj, 'UnitAttackedWithNoDamage', OnKineticShieldUnitTookEffectDamage_LW, ELD_OnStateSubmitted, , TargetUnitState,, EffectGameState);
}

function bool ChangeHitResultForTarget(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, bool bIsPrimaryTarget, const EAbilityHitResult CurrentResult, out EAbilityHitResult NewHitResult)
{
	return false;
}


static function EventListenerReturn OnKineticShieldUnitTookEffectDamage_LW(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState NewGameState;
	local XComGameStateHistory History;
	local XComGameStateContext_EffectRemoved EffectRemovedState;
	local X2TacticalGameRuleset TacticalRules;
	local StateObjectReference SourceStateObjectRef;
	local XComGameState_Unit	UnitState;
	local XComGameState_BattleData BattleData;
	local XcomGameState_Item	ItemState;
	local XComGameState_Effect EffectGameState;
	local XComGameStateContext_Ability	AbilityContext;
	EffectGameState =  XComGameState_Effect(CallBackData);
	// If this effect is already removed, don't do it again
	// no protection from tick damage

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

	if (!EffectGameState.bRemoved && XComGameStateContext_TickEffect( GameState.GetContext() ) == none )
	{
		History = `XCOMHISTORY;
		BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));

		SourceStateObjectRef = EffectGameState.ApplyEffectParameters.SourceStateObjectRef;
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(SourceStateObjectRef.ObjectID));
		ItemState = XcomGameState_Item(History.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.ItemStateObjectRef.ObjectID));
		//if(EffectGameState.ApplyEffectParameters.AbilityResultContext.HitResult != eHit_Miss)
		if(!AbilityContext.IsResultContextMiss())
		{
				
			EffectRemovedState = class'XComGameStateContext_EffectRemoved'.static.CreateEffectRemovedContext(EffectGameState);
			NewGameState = History.CreateNewGameState(true, EffectRemovedState);
			EffectGameState.RemoveEffect(NewGameState, GameState);
			if (X2WeaponTemplate(ItemState.GetMyTemplate()).WeaponCat == 'riotshield')
			{
				if (BattleData.bInBreachPhase)
				{
					//dakota.lemaster: Handled by OnPhalanxUnitTookEffectDamage
					//UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitState.ObjectID));
					//UnitState.SetUnitFloatValue('KineticShieldAbsorbed_Deferred', 1);
				}
				else
				{
					`XEVENTMGR.TriggerEvent('KineticShieldAbsorbed', UnitState, UnitState, NewGameState);
				}
			}
		}
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

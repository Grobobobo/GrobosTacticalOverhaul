class X2Effect_LightningReflexes_LW extends X2Effect_Persistent config (GameData_SoldierSkills);

var config int LR_DEFENSE;
var config int LR_DODGE;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', IncomingReactionFireCheck, ELD_OnStateSubmitted,,,, EffectObj);
	EventMgr.RegisterForEvent(EffectObj, 'TriggerLRLWFlyover', EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted,, UnitState);
}

static function EventListenerReturn IncomingReactionFireCheck(Object EventData, Object EventSource, XComGameState GameState, name EventID, Object CallbackData)
{
	local XComGameState_Unit			AttackingUnit, DefendingUnit;
	local XComGameState_Ability			ActivatedAbilityState;
	local XComGameState_Ability			LightningReflexesAbilityState;
	local XComGameStateContext_Ability	AbilityContext;
	local XComGameState_Effect			EffectState;

	EffectState = XComGameState_Effect(CallbackData);
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	LightningReflexesAbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
	DefendingUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
	if (DefendingUnit != none)
	{
		if((DefendingUnit.HasSoldierAbility('DarkEventAbility_LightningReflexes') && `XCOMHQ.TacticalGameplayTags.Find('DarkEvent_LightningReflexes') != INDEX_NONE) 
        || DefendingUnit.HasSoldierAbility('LightningReflexes_LW')
        || DefendingUnit.HasSoldierAbility('AdrenalWeave_LightningReflexes')
        )//if ( && !DefendingUnit.IsImpaired(false) && !DefendingUnit.IsBurning() && !DefendingUnit.IsPanicked())
		{
			AttackingUnit = class'X2TacticalGameRulesetDataStructures'.static.GetAttackingUnitState(GameState);
			if(AttackingUnit != none && AttackingUnit.IsEnemyUnit(DefendingUnit))
			{
				ActivatedAbilityState = XComGameState_Ability(EventData);
				if (ActivatedAbilityState != none)
				{		
					if (X2AbilityToHitCalc_StandardAim(ActivatedAbilityState.GetMyTemplate().AbilityToHitCalc).bReactionFire)
					{
						// Update the Lightning Reflexes counter
						//DefendingUnit.GetUnitValue('LW2WotC_LightningReflexes_Counter', LightningReflexesCounterValue);
						//DefendingUnit.SetUnitFloatValue ('LW2WotC_LightningReflexes_Counter', LightningReflexesCounterValue.fValue + 1, eCleanup_BeginTurn);

						// Send event to trigger the flyover, but only for the first shot
						`XEVENTMGR.TriggerEvent('TriggerLRLWFlyover', LightningReflexesAbilityState, DefendingUnit, GameState);
					}
				}
			}
		}	
	}
	return ELR_NoInterrupt;
}

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ShotInfo;

	//if (Target.IsImpaired(false) || Target.IsBurning() || Target.IsPanicked())
	//	return;

	if (X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc) != none)
	{
		if (X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc).bReactionFire)
		{

			ShotInfo.ModType = eHit_Success;
			ShotInfo.Reason = FriendlyName;
			ShotInfo.Value = -default.LR_DEFENSE;
			ShotModifiers.AddItem(ShotInfo);

            ShotInfo.ModType = eHit_Graze;
			ShotInfo.Reason = FriendlyName;
			ShotInfo.Value = default.LR_DODGE;
			ShotModifiers.AddItem(ShotInfo);
		}
	}
}

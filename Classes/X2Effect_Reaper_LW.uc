class X2Effect_Reaper_LW extends X2Effect_Reaper;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;

	EventMgr.RegisterForEvent(EffectObj, class'X2Effect_Lifeline'.default.LifelineEvent, ReaperKillCheck_LW, ELD_OnStateSubmitted,,,,EffectObj);
	EventMgr.RegisterForEvent(EffectObj, 'UnitDied', ReaperKillCheck_LW, ELD_OnStateSubmitted,,,,EffectObj);
	EventMgr.RegisterForEvent(EffectObj, 'UnitUnconscious', ReaperKillCheck_LW, ELD_OnStateSubmitted,,,,EffectObj);
	EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', EffectGameState.ReaperActivatedCheck, ELD_OnStateSubmitted);
}

function bool ChangeHitResultForAttacker(XComGameState_Unit Attacker, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, const EAbilityHitResult CurrentResult, out EAbilityHitResult NewHitResult)
{
	return false;
}

static function EventListenerReturn ReaperKillCheck_LW(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit UnitState;
	local X2AbilityTemplate AbilityTemplate;
	local XComGameState NewGameState;
	local UnitValue ReaperKillCount;
    local XComGameState_Effect EffectGameState;

    EffectGameState = XComGameState_Effect(CallbackData);
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

	//  was this a melee kill made by the reaper unit? if so, grant an action point
	if (AbilityContext != None && EffectGameState.ApplyEffectParameters.SourceStateObjectRef == AbilityContext.InputContext.SourceObject)
	{
		AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(AbilityContext.InputContext.AbilityTemplateName);
		if (AbilityTemplate != none && (AbilityTemplate.IsMelee() || AbilityTemplate.DataName == 'CrowdControl'))
		{
			UnitState = XComGameState_Unit(GameState.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
			if (UnitState == None)
				UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
			UnitState.GetUnitValue(class'X2Effect_Reaper'.default.ReaperKillName, ReaperKillCount);
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
			XComGameStateContext_ChangeContainer(NewGameState.GetContext()).BuildVisualizationFn = EffectGameState.ReaperKillVisualizationFn;
			UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(UnitState.Class, UnitState.ObjectID));
			UnitState.SetUnitFloatValue(class'X2Effect_Reaper'.default.ReaperKillName, ReaperKillCount.fValue + 1, eCleanup_BeginTurn);
			UnitState.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
			UnitState.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
			UnitState.SetUnitFloatValue('MovesThisTurn', 0, eCleanup_BeginTurn);
			UnitState.SetUnitFloatValue('MetersMovedThisTurn', 0, eCleanup_BeginTurn);
			`TACTICALRULES.SubmitGameState(NewGameState);
		}
	}

	return ELR_NoInterrupt;
}

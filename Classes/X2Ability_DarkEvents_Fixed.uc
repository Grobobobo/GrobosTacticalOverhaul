class X2Ability_DarkEvents_Fixed extends X2Ability_DarkEvents config(GameCore);

static function X2AbilityTemplate DarkEventAbility_Regeneration() {
	local X2AbilityTemplate						Template;
	local X2Condition_GameplayTag				GameplayCondition;
	local X2Effect_Regeneration				RegenerationEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'DarkEventAbility_Regeneration');
	Template.bDontDisplayInAbilitySummary = true;
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;

	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.AbilityToHitCalc = default.DeadEye;

	// Build the regeneration effect
	GameplayCondition = new class'X2Condition_GameplayTag';
	GameplayCondition.RequiredGameplayTag = 'DarkEvent_Regeneration';
	Template.AbilityShooterConditions.AddItem(GameplayCondition);   
	RegenerationEffect = new class'X2Effect_Regeneration';
   RegenerationEffect.EffectName = 'DarkEventRegenerationEffect';
	RegenerationEffect.BuildPersistentEffect(1, true, false, false, eWatchRule_UnitTurnBegin);
	RegenerationEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName, true);
	RegenerationEffect.HealAmount = default.DARK_EVENT_REGEN;
   RegenerationEffect.TargetConditions.AddItem(GameplayCondition);
	Template.AddShooterEffect(RegenerationEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
   Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate DarkEventAbility_LightningReflexes() {
	local X2AbilityTemplate						Template;
	local X2AbilityTargetStyle                  TargetStyle;
	local X2AbilityTrigger						Trigger;
	local X2Effect_Persistent                   ReflexesEffect;
	local X2Condition_GameplayTag				GameplayCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'DarkEventAbility_LightningReflexes');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_lightningreflexes";

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	GameplayCondition = new class'X2Condition_GameplayTag';
	GameplayCondition.RequiredGameplayTag = 'DarkEvent_LightningReflexes';
	ReflexesEffect = new class'X2Effect_Persistent';
   ReflexesEffect.EffectName = 'DarkEventLightningReflexesEffect';
	ReflexesEffect.BuildPersistentEffect(1, true, false, false, eWatchRule_UnitTurnBegin);
	ReflexesEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	ReflexesEffect.EffectAddedFn = ReflexesEffectAdded;
	ReflexesEffect.EffectTickedFn = ReflexesEffectTicked;
	ReflexesEffect.DuplicateResponse = eDupe_Ignore;
   ReflexesEffect.ApplyChance = 75;
   ReflexesEffect.TargetConditions.AddItem(GameplayCondition);
	Template.AddTargetEffect(ReflexesEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	
	return Template;
}

function ReflexesEffectAdded(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
	local XComGameState_Unit SourceUnit, NewSourceUnit;

	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if (SourceUnit != none)
	{
		if (!SourceUnit.bLightningReflexes)
		{
			NewSourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(SourceUnit.Class, SourceUnit.ObjectID));
			NewSourceUnit.bLightningReflexes = true;
		}
	}
}
function bool ReflexesEffectTicked(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication)
{
	local XComGameState_Unit SourceUnit, NewSourceUnit;

	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if (SourceUnit != none)
	{
		if (!SourceUnit.bLightningReflexes)
		{
			NewSourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(SourceUnit.Class, SourceUnit.ObjectID));
			NewSourceUnit.bLightningReflexes = true;
		}
	}

	return false;           //  do not end the effect
}
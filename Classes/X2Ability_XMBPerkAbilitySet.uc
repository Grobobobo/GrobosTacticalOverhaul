class X2Ability_XMBPerkAbilitySet extends XMBAbility config(GameData_SoldierSkills);

var config int OverkillBonusDamage;

var config int SurvivalInstinctCritBonus;
var config int SurvivalInstinctDefenseBonus;

var config int PREDATOR_AIM_BONUS;
var config int PREDATOR_CRIT_BONUS;

var config int OPENFIRE_AIM;
var config int OPENFIRE_CRIT;

var config int AVENGER_RADIUS;

var config int DEDICATION_MOBILITY;

var config int IMPULSE_AIM_BONUS;
var config int IMPULSE_CRIT_BONUS;

var config int INSPIRE_DODGE;

var config int WILLTOSURVIVE_DEF_PENALTY;
var config int STILETTO_ARMOR_PIERCING;

var const name VampUnitValue;
var config int RAGE_APPLY_CHANCE_PERCENT;
var config float RAGE_MOBILITY_MULTIPLY_MODIFIER;

var config float WHIRLWIND_MOBILITY_MOD;

var config int RESILIENCE_CRITDEF_BONUS;

var config int DAMAGE_CONTROL_DURATION;
var config int DAMAGE_CONTROL_BONUS_ARMOR;
var localized string LocRageFlyover;
var localized string RageTriggeredFriendlyName;
var localized string RageTriggeredFriendlyDesc;
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
    
    Templates.AddItem(Avenger());
	Templates.AddItem(Predator());
    Templates.AddItem(OpenFire());
	Templates.AddItem(Impulse());
	Templates.AddItem(SurvivalInstinct());
	Templates.AddItem(Overkill());
	
	Templates.AddItem(InspireAgility());
	Templates.AddItem(InspireAgilityTrigger());
	Templates.AddItem(PrimaryReturnFire());
	Templates.AddItem(PrimaryReturnFireShot());

	Templates.AddItem(PsychoticRage());

	Templates.AddItem(Vampirism());
	Templates.AddItem(VampirismPassive());

	Templates.AddItem(AddBrawler());
	Templates.AddItem(AddCloseEncountersAbility());
	Templates.AddItem(AddWilltoSurviveAbility());
	Templates.AddItem(AddSlippery());
	Templates.AddItem(CreateReadyForAnythingAbility());
	Templates.AddItem(ReadyForAnythingFlyover());
	Templates.AddItem(CreateTriggerRageAbility());
	Templates.AddItem(AddLowProfileAbility());
	Templates.AddItem(FreeGrenades());

	Templates.AddItem(ImpactCompensation());
	Templates.AddItem(ImpactCompensationPassive());
	Templates.AddItem(AddWhirlwind());
	Templates.AddItem(AddWhirlwindPassive());
	Templates.AddItem(AddSentinel_LWAbility());
	Templates.AddItem(AddBastion());
	Templates.AddItem(AddBastionPassive());
	Templates.AddItem(Impulse());
	Templates.AddItem(AddDamageControlAbility());
	Templates.AddItem(AddDamageControlAbilityPassive()); //Additional Ability
	Templates.AddItem(CreateBullRush()); //Additional Ability
	Templates.AddItem(CreateBullRushPassive());
	
	Templates.AddItem(ChosenSoulstealerPasive());	
	
	Templates.AddItem(AddResilienceAbility());
	Templates.AddItem(Concentration());

	Templates.AddItem(AddEvasiveAbility());
	Templates.AddItem(RemoveEvasive()); // Additional Ability

	Templates.AddItem(AddExecutionerAbility());

	Templates.AddItem(AddHitandSlitherAbility());
	
	return Templates;
}


static function X2AbilityTemplate Avenger()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTargetStyle                  TargetStyle;
	local X2AbilityTrigger						Trigger;
	local X2Effect_ReturnFireAOE                FireEffect;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'Avenger_LW');
	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_pistol_circle";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	FireEffect = new class'X2Effect_ReturnFireAOE';
    FireEffect.RequiredAllyRange = default.AVENGER_RADIUS;
    FireEffect.bAllowSelf = false;
	FireEffect.BuildPersistentEffect(1, true, false, false, eWatchRule_UnitTurnBegin);
	FireEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(FireEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	
	Template.AdditionalAbilities.AddItem('PrimaryReturnFireShot');

	Template.bCrossClassEligible = false;

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

static function X2AbilityTemplate Stiletto()
{
	local XMBEffect_ConditionalBonus ShootingEffect;
	local X2AbilityTemplate Template;

	// Create an armor piercing bonus
	ShootingEffect = new class'XMBEffect_ConditionalBonus';
	ShootingEffect.EffectName = 'Stiletto_LW_Bonuses';
	ShootingEffect.AddArmorPiercingModifier(default.STILETTO_ARMOR_PIERCING);

	// Only with the associated weapon
	ShootingEffect.AbilityTargetConditions.AddItem(default.MatchingWeaponCondition);

	// Prevent the effect from applying to a unit more than once
	ShootingEffect.DuplicateResponse = eDupe_Refresh;

	// The effect lasts forever
	ShootingEffect.BuildPersistentEffect(1, true, false, false, eWatchRule_UnitTurnBegin);
	
	// Activated ability that targets user
	Template = Passive('Stiletto_LW', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Needle", true, ShootingEffect);

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}


static function X2AbilityTemplate SurvivalInstinct()
{
	local XMBEffect_ConditionalBonus Effect;
	local X2Condition_UnitStatCheck Condition;

	// Create a condition that checks that the unit is at less than 100% HP.
	// X2Condition_UnitStatCheck can also check absolute values rather than percentages, by
	// using "false" instead of "true" for the last argument.
	Condition = new class'X2Condition_UnitStatCheck';
	Condition.AddCheckStat(eStat_HP, 100, eCheck_LessThan,,, true);

	// Create a conditional bonus effect
	Effect = new class'XMBEffect_ConditionalBonus';

	// The effect grants +20 Crit chance and +20 Defense
	Effect.AddToHitModifier(default.SurvivalInstinctCritBonus, eHit_Crit);
	Effect.AddToHitAsTargetModifier(-default.SurvivalInstinctDefenseBonus, eHit_Success);

	// The effect only applies while wounded
	EFfect.AbilityShooterConditions.AddItem(Condition);
	Effect.AbilityTargetConditionsAsTarget.AddItem(Condition);
	
	// Create the template using a helper function
	return Passive('SurvivalInstinct_LW', "img:///UILibrary_SOHunter.UIPerk_survivalinstinct", true, Effect);
}

static function X2AbilityTemplate Overkill()
{
	local X2Effect_Overkill Effect;

	Effect = new class'X2Effect_Overkill';
	Effect.BonusDamage = default.OverkillBonusDamage;

	return Passive('Overkill_LW', "img:///UILibrary_SODragoon.UIPerk_overkill", true, Effect);
}


static function X2AbilityTemplate Predator()
{
	local XMBEffect_ConditionalBonus Effect;

	// Create a conditional bonus
	Effect = new class'XMBEffect_ConditionalBonus';

	// The bonus adds the aim and crit chance
	Effect.AddToHitModifier(default.PREDATOR_AIM_BONUS, eHit_Success);
	Effect.AddToHitModifier(default.PREDATOR_CRIT_BONUS, eHit_Crit);

	// The bonus only applies while flanking
	Effect.AbilityTargetConditions.AddItem(default.FlankedCondition);
	Effect.AbilityTargetConditions.AddItem(default.RangedCondition);

	// Create the template using a helper function
	return Passive('Predator_LW', "img:///UILibrary_FavidsPerkPack.Perk_Ph_Predator", true, Effect);
}

    static function X2AbilityTemplate InspireAgility()
{
	local X2Effect_PersistentStatChange Effect;
	local X2AbilityTemplate Template;
	local X2AbilityCooldown Cooldown;
	// Create a persistent stat change effect that grants +50 Dodge
	Effect = new class'X2Effect_PersistentStatChange';
	Effect.EffectName = 'InspireAgility';
	Effect.AddPersistentStatChange(eStat_Dodge, default.INSPIRE_DODGE);

	// Prevent the effect from applying to a unit more than once
	Effect.DuplicateResponse = eDupe_Ignore;

	// The effect lasts until the beginning of the player's next turn
	Effect.BuildPersistentEffect(1, false, false, false, eWatchRule_UnitTurnBegin);

	// Add a visualization that plays a flyover over the target unit
	Effect.VisualizationFn = EffectFlyOver_Visualization;

	// Create a targeted buff that affects allies
	Template = TargetedBuff('InspireAgility_LW', "img:///UILibrary_XPerkIconPack.UIPerk_move_command", true, Effect, class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY, eCost_Free);

	// The ability starts out with a single charge
	AddCharges(Template, 1);

	// By default, you can target a unit with an ability even if it already has the effect the
	// ability adds. This helper function prevents targetting units that already have the effect.
	PreventStackingEffects(Template);
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 1;
	Template.AbilityCooldown = Cooldown;
	// Add a secondary ability that will grant the bonus charges on kills
	AddSecondaryAbility(Template, InspireAgilityTrigger());

	return Template;
}
	
static function X2AbilityTemplate InspireAgilityTrigger()
{
	local XMBEffect_AddAbilityCharges Effect;

	// Create an effect that will add a bonus charge to the Inspire Agility ability
	Effect = new class'XMBEffect_AddAbilityCharges';
	Effect.AbilityNames.AddItem('InspireAgility_LW');
	Effect.BonusCharges = 1;

	// Create a triggered ability that activates when the unit gets a kill
	return SelfTargetTrigger('InspireAgilityTrigger_LW', "img:///UILibrary_XPerkIconPack.UIPerk_move_command", false, Effect, 'KillMail');
}

static function X2AbilityTemplate PrimaryReturnFire()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTargetStyle                  TargetStyle;
	local X2AbilityTrigger						Trigger;
	local X2Effect_ReturnFire                   FireEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'PrimaryReturnFire');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_returnfire";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	FireEffect = new class'X2Effect_ReturnFire';
	FireEffect.BuildPersistentEffect(1, true, false, false, eWatchRule_UnitTurnBegin);
	FireEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	FireEffect.EffectName = 'PrimaryReturnFireShot';
	FireEffect.AbilityToActivate = 'PrimaryReturnFireShot';
	FireEffect.bDirectAttackOnly = true;
	FireEffect.bOnlyWhenAttackMisses = false;
	Template.AddTargetEffect(FireEffect);

	Template.AdditionalAbilities.AddItem('PrimaryReturnFireShot');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	Template.bCrossClassEligible = false;       //  this can only work with pistols, which only sharpshooters have

	return Template;
}


static function X2AbilityTemplate PrimaryReturnFireShot()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ReserveActionPoints ReserveActionPointCost;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2Condition_UnitProperty          ShooterCondition;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityTarget_Single            SingleTarget;
	local X2AbilityTrigger_EventListener	Trigger;
	local X2Effect_Knockback				KnockbackEffect;
	local array<name>                       SkipExclusions;
	local X2Condition_Visibility            TargetVisibilityCondition;
	local X2AbilityCost_Ammo				AmmoCost;


	`CREATE_X2ABILITY_TEMPLATE(Template, 'PrimaryReturnFireShot');

	Template.bDontDisplayInAbilitySummary = true;
	ReserveActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
	ReserveActionPointCost.iNumPoints = 1;
	ReserveActionPointCost.AllowedTypes.AddItem(class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint);
	ReserveActionPointCost.AllowedTypes.AddItem(class'X2CharacterTemplateManager'.default.ReturnFireActionPoint);
	Template.AbilityCosts.AddItem(ReserveActionPointCost);

	//	pistols are typically infinite ammo weapons which will bypass the ammo cost automatically.
	//  but if this ability is attached to a weapon that DOES use ammo, it should use it.
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bReactionFire = true;
	Template.AbilityToHitCalc = StandardAim;
	Template.AbilityToHitOwnerOnMissCalc = StandardAim;

	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);	
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bRequireBasicVisibility = true;
	TargetVisibilityCondition.bDisablePeeksOnMovement = false; //Don't use peek tiles for over watch shots	
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	Template.AbilityTargetConditions.AddItem(new class'X2Condition_EverVigilant');
	Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);	
	ShooterCondition = new class'X2Condition_UnitProperty';
	ShooterCondition.ExcludeConcealed = true;
	Template.AbilityShooterConditions.AddItem(ShooterCondition);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);
	
	SingleTarget = new class'X2AbilityTarget_Single';
	SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
	Template.AbilityTargetStyle = SingleTarget;

	//Trigger on movement - interrupt the move
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.EventID = 'ObjectMoved';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.Filter = eFilter_None;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.TypicalOverwatchListener;
	Template.AbilityTriggers.AddItem(Trigger);

	Template.CinescriptCameraType = "StandardGunFiring";	
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_overwatch";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.PISTOL_OVERWATCH_PRIORITY;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.DisplayTargetHitChance = false;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bAllowFreeFireWeaponUpgrade = false;	
	Template.bAllowAmmoEffects = true;

	// Damage Effect
	//
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.bAllowBonusWeaponEffects = true;
	
	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_returnfire";
	Template.bShowPostActivation = true;
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

static function X2AbilityTemplate PsychoticRage()
{
	local XMBEffect_ConditionalBonus Effect;
	local X2Condition_UnitStatCheck Condition;

	// Create a condition that checks that the unit is at less than 100% HP.
	// X2Condition_UnitStatCheck can also check absolute values rather than percentages, by
	// using "false" instead of "true" for the last argument.
	Condition = new class'X2Condition_UnitStatCheck';
	Condition.AddCheckStat(eStat_HP, 36, eCheck_LessThan,,, true);

	// Create a conditional bonus effect
	Effect = new class'XMBEffect_ConditionalBonus';

	//Need to add for all of them because apparently if you crit you don't hit lol
	Effect.AddPercentDamageModifier(50, eHit_Success);
	Effect.AddPercentDamageModifier(50, eHit_Graze);
	Effect.AddPercentDamageModifier(50, eHit_Crit);
	Effect.EffectName = 'PsychoticRage_Bonus';

	// The effect only applies while wounded
	EFfect.AbilityShooterConditions.AddItem(Condition);
	Effect.AbilityTargetConditionsAsTarget.AddItem(Condition);
	
	// Create the template using a helper function
	return Passive('PsychoticRage_LW', "img:///UILibrary_XPerkIconPack.UIPerk_melee_adrenaline", true, Effect);
}

static function X2AbilityTemplate Vampirism()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityTrigger_EventListener    EventListener;
	local X2Condition_UnitProperty          ShooterProperty;
	local X2Effect_SoulSteal                StealEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Vampirism_LW');

	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.str_soulstealer";
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';

	ShooterProperty = new class'X2Condition_UnitProperty';
	ShooterProperty.ExcludeAlive = false;
	ShooterProperty.ExcludeDead = true;
	ShooterProperty.ExcludeFriendlyToSource = false;
	ShooterProperty.ExcludeHostileToSource = true;
	ShooterProperty.ExcludeFullHealth = true;
	Template.AbilityShooterConditions.AddItem(ShooterProperty);

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventFn = VampirismListener;
	EventListener.ListenerData.EventID = 'UnitTakeEffectDamage';
	EventListener.ListenerData.Filter = eFilter_None;
	Template.AbilityTriggers.AddItem(EventListener);

	StealEffect = new class'X2Effect_SoulSteal';
	StealEffect.UnitValueToRead = default.VampUnitValue;
	Template.AddShooterEffect(StealEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bShowActivation = true;
	Template.bSkipFireAction = true;
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	Template.AdditionalAbilities.AddItem('VampirismPassive_LW');

	return Template;
}

static function EventListenerReturn VampirismListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState NewGameState;
	local XComGameState_Unit AbilityOwnerUnit, TargetUnit, SourceUnit;
	local int DamageDealt, DmgIdx;
	local float StolenHP;
	local XComGameState_Ability AbilityState, InputAbilityState;
	local X2TacticalGameRuleset Ruleset;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

	AbilityState = XComGameState_Ability(CallbackData);
	InputAbilityState = XComGameState_Ability(GameState.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
	if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
	{
		Ruleset = `TACTICALRULES;
		TargetUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
		SourceUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));

		if (TargetUnit != none)
		{
			if(SourceUnit.ObjectID == AbilityState.OwnerStateObject.ObjectID)
			{
				if(InputAbilityState.SourceWeapon.ObjectID == AbilityState.SourceWeapon.ObjectID)
				{
					for (DmgIdx = 0; DmgIdx < TargetUnit.DamageResults.Length; ++DmgIdx)
					{
						if (TargetUnit.DamageResults[DmgIdx].Context == AbilityContext)
						{
							DamageDealt += TargetUnit.DamageResults[DmgIdx].DamageAmount;
						}
					}
					if (DamageDealt > 0)
					{
						StolenHP = DamageDealt;
						if (StolenHP > 0)
						{
							NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Chosen Soul Steal Amount");
							AbilityOwnerUnit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', AbilityState.OwnerStateObject.ObjectID));
							AbilityOwnerUnit.SetUnitFloatValue(default.VampUnitValue, StolenHP);
							Ruleset.SubmitGameState(NewGameState);

							AbilityState.AbilityTriggerAgainstSingleTarget(AbilityState.OwnerStateObject, false);

						}
					}
				}
			}
		}
	}

	return ELR_NoInterrupt;
}

static function X2AbilityTemplate VampirismPassive()
{
	local X2AbilityTemplate         Template;

	Template = PurePassive('VampirismPassive_LW', "img:///UILibrary_PerkIcons.UIPerk_soulsteal", false, 'eAbilitySource_Perk');

	return Template;
}

static function X2AbilityTemplate AddBrawler()
{
	local X2AbilityTemplate						Template;
	local X2Effect_Brawler					DamageReduction;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'Brawler');
	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_enemy_defense_chevron";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;

	DamageReduction = new class 'X2Effect_Brawler';
	DamageReduction.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	DamageReduction.BuildPersistentEffect(1, true, false);
	Template.AddTargetEffect(DamageReduction);

	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;

	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  No visualization
	return Template;
}

static function X2AbilityTemplate AddCloseEncountersAbility()
{
	local X2AbilityTemplate							Template;
	local X2Effect_CloseEncounters					ActionEffect;
	
	`CREATE_X2ABILITY_TEMPLATE (Template, 'CloseEncounters');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityCloseEncounters";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	//Template.bIsPassive = true;  // needs to be off to allow perks
	ActionEffect = new class 'X2Effect_CloseEncounters';
	ActionEffect.SetDisplayInfo (ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	ActionEffect.BuildPersistentEffect(1, true, false);
	Template.AddTargetEffect(ActionEffect);
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	// Visualization handled in Effect
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}


static function X2AbilityTemplate AddWilltoSurviveAbility()
{
	local X2AbilityTemplate						Template;
	local X2Effect_WilltoSurvive				ArmorBonus;
	local X2Effect_PersistentStatChange			WillBonus;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'WilltoSurvive');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityWilltoSurvive";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	ArmorBonus = new class 'X2Effect_WilltoSurvive';
	ArmorBonus.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	ArmorBonus.BuildPersistentEffect(1, true, false);
	Template.AddTargetEffect(ArmorBonus);

	WillBonus = new class'X2Effect_PersistentStatChange';
	WillBonus.AddPersistentStatChange(eStat_Defense, default.WILLTOSURVIVE_DEF_PENALTY);
	WillBonus.BuildPersistentEffect (1, true, false, false, 7);
	Template.AddTargetEffect(WillBonus);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  No visualization
	return Template;
}

static function X2AbilityTemplate AddSlippery()
{
	local X2AbilityTemplate					Template;
	local X2Effect_Slippery					DefenseEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'Slippery');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityThreatAssesment";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bCrossClassEligible = false;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.bShowActivation = false;

	DefenseEffect = new class'X2Effect_Slippery';
	DefenseEffect.BuildPersistentEffect(1,true,false);
	DefenseEffect.SetDisplayInfo (ePerkBuff_Passive,Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName); 
	Template.AddTargetEffect(DefenseEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;		
	return Template;
}


static function X2DataTemplate CreateReadyForAnythingAbility()
{
	local X2AbilityTemplate							Template;
	local X2Effect_ReadyForAnything					ActionPointEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'ReadyForAnything');

	Template.IconImage = "img:///UILibrary_LWAlienPack.LW_AbilityReadyForAnything";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.bShowActivation = false;
	Template.bIsPassive = true;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	ActionPointEffect = new class'X2Effect_ReadyForAnything';
	ActionPointEffect.BuildPersistentEffect (1, true, false);
	ActionPointEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
	Template.AddTargetEffect(ActionPointEffect);
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	Template.AdditionalAbilities.AddItem('ReadyForAnythingFlyover');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;


	return Template;
}

static function X2DataTemplate ReadyForAnythingFlyover()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_EventListener	EventListener;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'ReadyForAnythingFlyover');

	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.bShowActivation = true;
	Template.bSkipFireAction = true;
	Template.bDontDisplayInAbilitySummary = true;

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'ReadyForAnythingTriggered';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(EventListener);

	Template.CinescriptCameraType = "Overwatch";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = ReadyforAnything_BuildVisualization;

	return Template;
}

simulated function ReadyForAnything_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory			History;
	local XComGameStateContext_Ability	Context;
	local VisualizationActionMetadata	EmptyTrack;
	local VisualizationActionMetadata	BuildTrack;
	local X2Action_PlaySoundAndFlyOver	SoundAndFlyOver;
	local StateObjectReference			InteractingUnitRef;
	local XComGameState_Ability			Ability;

	History = `XCOMHISTORY;
	context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;
	Ability = XComGameState_Ability(History.GetGameStateForObjectID(context.InputContext.AbilityRef.ObjectID, 1, VisualizeGameState.HistoryIndex - 1));
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, Context, false, BuildTrack.LastActionAdded));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(SoundCue'SoundUI.OverWatchCue', Ability.GetMyTemplate().LocFlyOverText, '', eColor_Alien, "img:///UILibrary_PerkIcons.UIPerk_overwatch");
}

static function X2AbilityTemplate CreateTriggerRageAbility()
{
	local X2AbilityTemplate Template;
	local X2Effect_PersistentStatChange RageTriggeredPersistentEffect;
	local X2Condition_UnitEffects RageTriggeredCondition;
	local array<name> SkipExclusions;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'TriggerRage');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_beserk";

	Template.bDontDisplayInAbilitySummary = true;
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	
	// Rage may trigger if the unit is burning
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	// Check to make sure rage has been activated
	RageTriggeredCondition = new class'X2Condition_UnitEffects';
	RageTriggeredCondition.AddExcludeEffect('RageTrigger', 'AA_UnitRageTriggered');
	Template.AbilityShooterConditions.AddItem(RageTriggeredCondition);

	// Create the Rage Triggered Effect
	RageTriggeredPersistentEffect = new class'X2Effect_PersistentStatChange';
	RageTriggeredPersistentEffect.EffectName = 'RageTrigger';
	RageTriggeredPersistentEffect.BuildPersistentEffect(1, true, true, true);
	RageTriggeredPersistentEffect.SetDisplayInfo(ePerkBuff_Bonus, default.RageTriggeredFriendlyName, default.RageTriggeredFriendlyDesc, Template.IconImage, true);
	RageTriggeredPersistentEffect.DuplicateResponse = eDupe_Ignore;
	RageTriggeredPersistentEffect.EffectHierarchyValue = class'X2StatusEffects'.default.RAGE_HIERARCHY_VALUE;
	RageTriggeredPersistentEffect.AddPersistentStatChange(eStat_Mobility, default.RAGE_MOBILITY_MULTIPLY_MODIFIER, MODOP_Multiplication);
	RageTriggeredPersistentEffect.ApplyChanceFn = ApplyChance_Rage;
	RageTriggeredPersistentEffect.VisualizationFn = RageTriggeredVisualization;
	Template.AddTargetEffect(RageTriggeredPersistentEffect);

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Berserker_Rage";

	return Template;
}

static function name ApplyChance_Rage(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
	local XComGameState_Unit UnitState;
	local int RandRoll;

	UnitState = XComGameState_Unit(kNewTargetState);
	if( UnitState.GetCurrentStat(eStat_HP) <= (UnitState.GetMaxStat(eStat_HP) / 2) )
	{
		// If the current health is <= to half her max health, attach the Rage effect
		`log("Success!");
		return 'AA_Success';
	}

	if (default.RAGE_APPLY_CHANCE_PERCENT > 0)
	{
		RandRoll = `SYNC_RAND_STATIC(100);

		`log("ApplyChance_Rage check chance" @ default.RAGE_APPLY_CHANCE_PERCENT @ "rolled" @ RandRoll);
		if (RandRoll <= default.RAGE_APPLY_CHANCE_PERCENT)
		{
			`log("Success!");
			return 'AA_Success';
		}
		`log("Failed.");
	}

	return 'AA_EffectChanceFailed';
}

static function RageTriggeredVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local X2Action_PlayAnimation PlayAnimation;

	if (EffectApplyResult != 'AA_Success')
		return;

	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, default.LocRageFlyover, '', eColor_Bad);

	PlayAnimation = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
	PlayAnimation.Params.AnimName = 'NO_Rage';
}

static function X2AbilityTemplate AddLowProfileAbility()
{
	local X2AbilityTemplate					Template;
	local X2Effect_LowProfile_LW			DefModifier;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LowProfile');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityLowProfile";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	DefModifier = new class 'X2Effect_LowProfile_LW';
	DefModifier.BuildPersistentEffect (1, true, false);
	DefModifier.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (DefModifier);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;	
	//no visualization
	return Template;
}


static function X2DataTemplate FreeGrenades()
{
	local X2AbilityTemplate Template;
	local X2Effect_FreeGrenades GrenadeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'FreeGrenades');
	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_adrenaline_defense";
	Template.Hostility = eHostility_Neutral;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	GrenadeEffect = new class'X2Effect_FreeGrenades';
	GrenadeEffect.BuildPersistentEffect(1, true, true);

	Template.AddTargetEffect(GrenadeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddWhirlwind()
{
	local X2AbilityTemplate					Template;
	local X2Effect_Whirlwind2				WhirlwindEffect;
	local X2Effect_PersistentStatChange	MobilityIncrease;
	// LWOTC: For historical and backwards compatibility reasons, this is called
	// Whirlwind2 rather than Whirlwind, even though the original Whirlwind has
	// been removed.
	`CREATE_X2ABILITY_TEMPLATE(Template, 'Whirlwind2');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_riposte";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	WhirlwindEffect = new class'X2Effect_Whirlwind2';
	WhirlwindEffect.BuildPersistentEffect(1, true, false, false);
	WhirlwindEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,, Template.AbilitySourceName);
	WhirlwindEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(WhirlwindEffect);

	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.bShowActivation = true;
	Template.bShowPostActivation = false;

	MobilityIncrease = new class'X2Effect_PersistentStatChange';
	MobilityIncrease.BuildPersistentEffect(1, false, true);
	MobilityIncrease.AddPersistentStatChange(eStat_Mobility, default.WHIRLWIND_MOBILITY_MOD, MODOP_Multiplication);
	Template.AddShooterEffect(MobilityIncrease);

	Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;

	return Template;
}

static function X2AbilityTemplate AddWhirlwindPassive()
{
	local X2AbilityTemplate Template;

	Template = PurePassive('WhirlwindPassive', "img:///UILibrary_PerkIcons.UIPerk_riposte", , 'eAbilitySource_Perk');

	return Template;
}

static function X2AbilityTemplate ImpactCompensationPassive()
{
	local X2AbilityTemplate                 Template;	

	Template = PurePassive('ImpactCompensationPassive_LW', "img:///UILibrary_LW_PerkPack.LW_AbilityDamageControl", true, 'eAbilitySource_Perk');
	Template.bCrossClassEligible = false;
	//Template.AdditionalAbilities.AddItem('DamageControlAbilityActivated');
	return Template;
}

static function X2AbilityTemplate ImpactCompensation()
{
	local X2AbilityTemplate						Template;	
	local X2AbilityTrigger_EventListener		EventListener;
	local X2Effect_ImpactCompensation 				ImpactEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ImpactCompensation_LW');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityDamageControl";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
	Template.bShowActivation = false;
	Template.bSkipFireAction = true;
	//Template.bIsPassive = true;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// Trigger on Damage
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'UnitTakeEffectDamage';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);

	ImpactEffect = new class'X2Effect_ImpactCompensation';
	ImpactEffect.BuildPersistentEffect(1,false,true,,eWatchRule_UnitTurnEnd);
	ImpactEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	ImpactEffect.DuplicateResponse = eDupe_Allow;
	Template.AddTargetEffect(ImpactEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.AdditionalAbilities.AddItem('ImpactCompensationPassive_LW');

	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;

	return Template;
}

static function X2AbilityTemplate AddSentinel_LWAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_Sentinel_LW				PersistentEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Sentinel_LW');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilitySentinel";
	Template.Hostility = eHostility_Neutral;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	PersistentEffect = new class'X2Effect_Sentinel_LW';
	PersistentEffect.BuildPersistentEffect(1, true, false);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddTargetEffect(PersistentEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.bCrossClassEligible = false;
	return Template;
}


static function X2AbilityTemplate AddBastion()
{
	local X2AbilityTemplate             Template;
	local X2Effect_Bastion               Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Bastion');

	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityBastion";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bCrossClassEligible = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllAllies';

	Effect = new class'X2Effect_Bastion';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddMultiTargetEffect(Effect);

	Template.AdditionalAbilities.AddItem('BastionCleanse');
	Template.AdditionalAbilities.AddItem('BastionPassive');

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.PrerequisiteAbilities.AddItem('Fortress');

	return Template;
}

static function X2AbilityTemplate AddBastionPassive()
{
	return PurePassive('BastionPassive', "img:///UILibrary_LW_PerkPack.LW_AbilityBastion", , 'eAbilitySource_Psionic');
}

static function X2AbilityTemplate Impulse()
{
	local X2AbilityTemplate Template;
	local XMBEffect_ConditionalBonus OffenseEffect;
	local X2Condition_UnitValue Condition;

	// Create a conditional bonus effect
	OffenseEffect = new class'XMBEffect_ConditionalBonus';

	// Add the aim and crit bonuses
	OffenseEffect.AddToHitModifier(default.IMPULSE_AIM_BONUS, eHit_Success);
	OffenseEffect.AddToHitModifier(default.IMPULSE_CRIT_BONUS, eHit_Crit);

	// Only if you have moved this turn
	Condition = new class'X2Condition_UnitValue';
	Condition.AddCheckValue('MovesThisTurn', 0, eCheck_GreaterThan);
	OffenseEffect.AbilityShooterConditions.AddItem(Condition);
	
	OffenseEffect.AbilityTargetConditions.AddItem(default.RangedCondition);

	// Create the template using a helper function
	Template = Passive('Impulse_LW', "img:///UILibrary_XPerkIconPack.UIPerk_shot_move2", false, OffenseEffect);

	return Template;
}

static function X2AbilityTemplate OpenFire()
{
	local X2AbilityTemplate Template;
    local X2Condition_UnitStatCheck Condition;
	local XMBEffect_ConditionalBonus Effect;

    // Aim and crit bonus
	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.AddToHitModifier(default.OPENFIRE_AIM, eHit_Success);
	Effect.AddToHitModifier(default.OPENFIRE_CRIT, eHit_Crit);
    
    // Only applies to full health targets
    Condition = new class'X2Condition_UnitStatCheck';
    Condition.AddCheckStat(eStat_HP, 100, eCheck_Exact, 100, 100, true);
	Effect.AbilityTargetConditions.AddItem(Condition);
	Effect.AbilityTargetConditions.AddItem(default.RangedCondition);

	Template = Passive('OpenFire_LW', "img:///UILibrary_XPerkIconPack.UIPerk_stabilize_shot_2", true, Effect);

    return Template;
}

	static function X2AbilityTemplate AddDamageControlAbilityPassive()
{
	local X2AbilityTemplate                 Template;	

	Template = PurePassive('DamageControlPassive', "img:///UILibrary_LW_PerkPack.LW_AbilityDamageControl", true, 'eAbilitySource_Perk');
	Template.bCrossClassEligible = false;
	//Template.AdditionalAbilities.AddItem('DamageControlAbilityActivated');
	return Template;
}

static function X2AbilityTemplate AddDamageControlAbility()
{
	local X2AbilityTemplate						Template;	
	local X2AbilityTrigger_EventListener		EventListener;
	local X2Effect_DamageControl 				DamageControlEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'DamageControl');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityDamageControl";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
	Template.bShowActivation = true;
	Template.bSkipFireAction = true;
	//Template.bIsPassive = true;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// Trigger on Damage
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'UnitTakeEffectDamage';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);

	DamageControlEffect = new class'X2Effect_DamageControl';
	DamageControlEffect.BuildPersistentEffect(default.DAMAGE_CONTROL_DURATION,false,true,,eWatchRule_UnitTurnBegin);
	DamageControlEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	DamageControlEffect.DuplicateResponse = eDupe_Refresh;
	DamageControlEffect.BonusArmor = default.DAMAGE_CONTROL_BONUS_ARMOR;
	Template.AddTargetEffect(DamageControlEffect);


	Template.AddTargetEffect(DamageControlEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.AdditionalAbilities.AddItem('DamageControlPassive');

	return Template;
}


static function X2AbilityTemplate CreateBullRush()
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_EventListener Trigger;
	local X2Effect_RunBehaviorTree ReactionEffect;
	local X2Effect_GrantActionPoints AddAPEffect;
	local array<name> SkipExclusions;
	local X2Condition_UnitProperty UnitPropertyCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'BullRush');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_combatstims";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.ConfusedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'UnitTakeEffectDamage';
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Trigger.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(Trigger);

	// The unit must be alive and not stunned
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeAlive = false;
	UnitPropertyCondition.ExcludeStunned = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

	AddAPEffect = new class'X2Effect_GrantActionPoints';
	AddAPEffect.NumActionPoints = 1;
	AddAPEffect.PointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;
	Template.AddTargetEffect(AddAPEffect);

	ReactionEffect = new class'X2Effect_RunBehaviorTree';
	ReactionEffect.BehaviorTreeName = 'BerserkerReaction';
	Template.AddTargetEffect(ReactionEffect);

	Template.bShowActivation = true;
	Template.bSkipExitCoverWhenFiring = true;
	Template.bSkipFireAction = true;

	Template.FrameAbilityCameraType = eCameraFraming_Always;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.AdditionalAbilities.AddItem('BullRushPassive');

	return Template;
}

static function X2AbilityTemplate CreateBullRushPassive()
{
	local X2AbilityTemplate		Template;

	Template = PurePassive('BullRushPassive', "img:///UILibrary_PerkIcons.UIPerk_combatstims", , 'eAbilitySource_Perk');

	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;

	return Template;
}

static function X2AbilityTemplate ChosenSoulstealerPasive()
{
	local X2AbilityTemplate         Template;

	Template = PurePassive('ChosenSoulstealerPassive', "img:///UILibrary_PerkIcons.UIPerk_soulsteal", false, 'eAbilitySource_Perk');

	return Template;
}

static function X2AbilityTemplate AddResilienceAbility()
{
	local X2AbilityTemplate					Template;
	local X2Effect_Resilience				MyCritModifier;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Resilience');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityResilience";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	MyCritModifier = new class 'X2Effect_Resilience';
	MyCritModifier.CritDef_Bonus = default.RESILIENCE_CRITDEF_BONUS;
	MyCritModifier.BuildPersistentEffect (1, true, false, true);
	MyCritModifier.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (MyCritModifier);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;		
}

static function X2AbilityTemplate Concentration()
{
	local X2AbilityTemplate Template;
	local XMBEffect_ChangeHitResultForAttacker Effect;

	// Create an effect that will change attack hit results
	Effect = new class'XMBEffect_ChangeHitResultForAttacker';
	Effect.EffectName = 'Concentration';
    Effect.IncludeHitResults.AddItem(eHit_Graze);
	Effect.NewResult = eHit_Success;

	// Create the template using a helper function
	Template = Passive('Concentration_LW', "img:///UILibrary_FavidsPerkPack.UIPerk_Concentration", true, Effect);

	return Template;
}


	static function X2AbilityTemplate AddEvasiveAbility()
{
	local X2AbilityTemplate						Template;	
	local X2Effect_PersistentStatChange			DodgeBonus;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Evasive');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityEvasive";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.bCrossClassEligible = true;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bShowActivation = true;
	Template.bSkipFireAction = true;

	DodgeBonus = new class'X2Effect_PersistentStatChange';
	DodgeBonus.BuildPersistentEffect(1,true,true,false);
	DodgeBonus.SetDisplayInfo (ePerkBuff_Passive,Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName); 
	DodgeBonus.AddPersistentStatChange (eStat_Dodge, float (100));
	DodgeBonus.EffectName='EvasiveEffect';
	Template.AddTargetEffect(DodgeBonus);

	Template.AdditionalAbilities.AddItem('RemoveEvasive');
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;  

	Return Template;
}


static function X2AbilityTemplate RemoveEvasive()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTrigger_EventListener		EventListener;
	local X2Effect_RemoveEffects				RemoveEffect;
	local X2Condition_UnitEffects				RequireEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RemoveEvasive');	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityEvasive";
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'UnitTakeEffectDamage';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);

	Template.bShowActivation = true;
	Template.bSkipFireAction = true;

	RequireEffect = new class'X2Condition_UnitEffects';
    RequireEffect.AddRequireEffect('EvasiveEffect', 'AA_EvasiveEffectPresent');
	Template.AbilityTargetConditions.AddItem(RequireEffect);

	RemoveEffect = new class'X2Effect_RemoveEffects';
	RemoveEffect.EffectNamesToRemove.AddItem('EvasiveEffect');
	Template.AddTargetEffect(RemoveEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Return Template;
}

static function X2AbilityTemplate AddExecutionerAbility()
{
	local X2AbilityTemplate					Template;
	local X2Effect_Executioner_LW			AimandCritModifiers;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Executioner_LW');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityExecutioner";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	AimandCritModifiers = new class 'X2Effect_Executioner_LW';
	AimandCritModifiers.BuildPersistentEffect (1, true, false);
	AimandCritModifiers.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (AimandCritModifiers);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;		
}



static function X2AbilityTemplate AddHitandSlitherAbility()
{
	local X2AbilityTemplate					Template;
	local X2Effect_HitandRun				HitandRunEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'HitandSlither');
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityHitandRun";
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	HitandRunEffect = new class'X2Effect_HitandRun';
	HitandRunEffect.BuildPersistentEffect(1, true, false, false);
	HitandRunEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	HitandRunEffect.DuplicateResponse = eDupe_Ignore;
	HitandRunEffect.HITANDRUN_FULLACTION=false;
	Template.AddTargetEffect(HitandRunEffect);
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: Visualization handled in X2Effect_HitandRun
	return Template;
}
defaultproperties
{
	VampUnitValue="VampAmount"
}

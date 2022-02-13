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

var config int BREAKER_TIER_2_DAMAGE_BONUS;
var config int BREAKER_TIER_3_DAMAGE_BONUS;

var config int WARDEN_TIER_2_DAMAGE_BONUS;
var config int WARDEN_TIER_3_DAMAGE_BONUS;

var config int SUBDUE_TIER_2_DAMAGE_BONUS;
var config int SUBDUE_TIER_3_DAMAGE_BONUS;

var config int SMG_MOBILITY_BONUS;
var config int SHOTGUN_MOBILITY_PENALTY;

var config int CHERUB_RIOT_GUARD_HP;

var config int REACTION_FIRE_ANTI_COVER_BONUS;

var config int EXTRA_HELLWEAVE_HP_BONUS;

var config int EXTRA_HAZMAT_HP_BONUS;

var config int EXTRA_ADRENAL_HP_BONUS;

var config int MOVING_TARGET_DEFENSE;
var config int MOVING_TARGET_DODGE;

var config int EXTRA_PLATED_HP_BONUS;

var config int TACSENSE_DEF_BONUS;
var config int GRAZING_FIRE_SUCCESS_CHANCE;
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
	Templates.AddItem(AddBastionCleanse());

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
	
	Templates.AddItem(CreateSecondaryMeleeBuff('BreakerBonus', default.BREAKER_TIER_2_DAMAGE_BONUS, default.BREAKER_TIER_3_DAMAGE_BONUS));
	Templates.AddItem(CreateSecondaryMeleeBuff('WardenBonus', default.WARDEN_TIER_2_DAMAGE_BONUS, default.WARDEN_TIER_3_DAMAGE_BONUS));
	Templates.AddItem(CreateSubdueBonusDamageBuff('SubdueBonus', default.SUBDUE_TIER_2_DAMAGE_BONUS, default.SUBDUE_TIER_3_DAMAGE_BONUS));

	Templates.AddItem(AddSMGBonusAbility());
	Templates.AddItem(AddShotgunPenaltyAbility());

	Templates.AddItem(CreateReactionFireAgainstCoverBonus());

	Templates.AddItem(AddExtraHellWeaveHP());
	Templates.AddItem(AddExtraHazmatHP());
	Templates.AddItem(AddExtraAdrenalHP());

	
	Templates.AddItem(NewFluxWeaveAbility());
	Templates.AddItem(CreateSustainingShield());

	Templates.AddItem(AddCritDamageWeaponBonus());

	
	Templates.AddItem(class'X2Ability_Chosen'.static.CreateMeleeImmunity());

	Templates.AddItem(class'X2Ability_Chosen'.static.ChosenSoulstealer());
	Templates.AddItem(class'X2Ability_Chosen'.static.CreateChosenRegenerate());

	
	Templates.AddItem(OverrideLR('LightningReflexes'));
	Templates.AddItem(OverrideLR('AdrenalWeave_LightningReflexes'));
	Templates.AddItem(OverrideLR('DarkEventAbility_LightningReflexes'));

	Templates.AddItem(CreateWeaponUpgradeCritBonus('EnhancedSMGCrit',class'X2Item_RebalancedWeapons'.default.ENHANCED_SMG_CRIT_BONUS));
	Templates.AddItem(CreateWeaponUpgradeCritBonus('MasterShotgunCrit',class'X2Item_RebalancedWeapons'.default.MASTER_SHOTGUN_CRIT_BONUS));
	Templates.AddItem(CreateWeaponUpgradeCritBonus('EnhancedPistolCrit',class'X2Item_RebalancedWeapons'.default.ENHANCED_PISTOLS_CRIT_BONUS));

	Templates.AddItem(NewBreakerFocus());
	Templates.AddItem(CloseandPersonal());
	
	Templates.AddItem(CreateCallForAndroidReinforcements());
	Templates.AddItem(Packmaster());
	Templates.AddItem(Reposition());
	Templates.AddItem(CreateMindFlayDamageBuff());
	Templates.AddItem(CreateSoulFireDamageBuff());
	Templates.AddItem(CreatePatchWorkDamageBuff());
	
	Templates.AddItem(AddGrazingFireAbility());

	Templates.AddItem(ChosenDragonRounds());
	Templates.AddItem(ChosenDragonRoundsPassive());

	Templates.AddItem(ChosenVenomRounds());
	Templates.AddItem(ChosenVenomRoundsPassive());
	Templates.AddItem(AddExtraPlatedHP());

	Templates.AddItem(PinningAttacks());
	Templates.AddItem(PinningAttacksPassive());
	Templates.AddItem(TacticalSense());
	Templates.AddItem(AddInfighterAbility());
	Templates.AddItem(BerserkerBladestorm());
	Templates.AddItem(BerserkerBladestormAttack());

	
	
	//Templates.AddItem(OverrideDELR());

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
	Condition.AddCheckStat(eStat_HP, 51, eCheck_LessThan,,, true);

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
	local X2Condition_BreachPhase	BreachPhase;
	`CREATE_X2ABILITY_TEMPLATE (Template, 'CloseEncounters');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityCloseEncounters";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);


	BreachPhase = new class'X2Condition_BreachPhase';
	BreachPhase.bValidInBreachPhase = false;
	Template.AbilityShooterConditions.AddItem(BreachPhase);

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

	Template.AdditionalAbilities.AddItem('WhirlwindPassive');

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

static function X2AbilityTemplate AddBastionCleanse()
{
	local X2AbilityTemplate                     Template;
	local X2AbilityTrigger_EventListener        EventListener;
	local X2Condition_UnitProperty              DistanceCondition;
	local X2Effect_RemoveEffects				FortressRemoveEffect;
	local X2Condition_UnitProperty              FriendCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'BastionCleanse');

	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityBastion";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitMoveFinished';
	EventListener.ListenerData.Filter = eFilter_None;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.SolaceCleanseListener;  // keep this, since it's generically just calling the associate ability
	Template.AbilityTriggers.AddItem(EventListener);

	//removes any ongoing effects
	FortressRemoveEffect = new class'X2Effect_RemoveEffects';
	FortressRemoveEffect.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.AcidBurningName);
	FortressRemoveEffect.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.BurningName);
	FortressRemoveEffect.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.PoisonedName);
	FortressRemoveEffect.EffectNamesToRemove.AddItem(class'X2Effect_ParthenogenicPoison'.default.EffectName);
	FriendCondition = new class'X2Condition_UnitProperty';
	FriendCondition.ExcludeFriendlyToSource = false;
	FriendCondition.ExcludeHostileToSource = true;
	FortressRemoveEffect.TargetConditions.AddItem(FriendCondition);
	Template.AddTargetEffect(FortressRemoveEffect);

	DistanceCondition = new class'X2Condition_UnitProperty';
	DistanceCondition.RequireWithinRange = true;
	DistanceCondition.WithinRange = Sqrt(class'X2Effect_Bastion'.default.BASTION_DISTANCE_SQ) *  class'XComWorldData'.const.WORLD_StepSize; // same as Solace for now
	DistanceCondition.ExcludeFriendlyToSource = false;
	DistanceCondition.ExcludeHostileToSource = false;
	Template.AbilityTargetConditions.AddItem(DistanceCondition);

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
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
	//looks like it's not needed?
	//Template.AdditionalAbilities.AddItem('DamageControlPassive');

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
	local X2Condition_BreachPhase BreachPhase;
	`CREATE_X2ABILITY_TEMPLATE(Template, 'BullRush');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_combatstims";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	BreachPhase = new class'X2Condition_BreachPhase';
	BreachPhase.bValidInBreachPhase = false;
	Template.AbilityShooterConditions.AddItem(BreachPhase);

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


static function X2AbilityTemplate CreateSecondaryMeleeBuff(name TemplateName, int Tier2Bonus, int Tier3Bonus)
{
	local X2AbilityTemplate					Template;
	local X2Effect_SecondaryMeleeBonus				MeleeBuffsEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, TemplateName);
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_combatstims";
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	MeleeBuffsEffect = new class'X2Effect_SecondaryMeleeBonus';
    MeleeBuffsEffect.BuildPersistentEffect(1, true, false); 
    MeleeBuffsEffect.MeleeDamageBonusTier2 = Tier2Bonus;
    MeleeBuffsEffect.MeleeDamageBonusTier3 = Tier3Bonus;
	Template.AddTargetEffect(MeleeBuffsEffect);
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.bDontDisplayInAbilitySummary = true;

	//  NOTE: Visualization handled in X2Effect_HitandRun
	return Template;
}

static function X2AbilityTemplate CreateSubdueBonusDamageBuff(name TemplateName, int Tier2Bonus, int Tier3Bonus)
{
	local X2AbilityTemplate                 Template;
	local X2Effect_SubdueBonusDamage				MeleeBuffsEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, TemplateName);
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_combatstims";
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	MeleeBuffsEffect = new class'X2Effect_SubdueBonusDamage';
    MeleeBuffsEffect.BuildPersistentEffect(1, true, false); 
    MeleeBuffsEffect.MeleeDamageBonusTier2 = Tier2Bonus;
    MeleeBuffsEffect.MeleeDamageBonusTier3 = Tier3Bonus;
	Template.AddTargetEffect(MeleeBuffsEffect);

	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: Visualization handled in X2Effect_HitandRun
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;

	return Template;
}
static function X2AbilityTemplate CreateMindFlayDamageBuff()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_MindFlayBonusDamage				MeleeBuffsEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'MindFlayBonusDamage');
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_combatstims";
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	MeleeBuffsEffect = new class'X2Effect_MindFlayBonusDamage';
    MeleeBuffsEffect.BuildPersistentEffect(1, true, false); 
    MeleeBuffsEffect.MindFlayDamageBonusTier2 = 1;
    MeleeBuffsEffect.MindFlayDamageBonusTier3 = 2;

	Template.AddTargetEffect(MeleeBuffsEffect);
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: Visualization handled in X2Effect_HitandRun
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;

	return Template;
}

static function X2AbilityTemplate CreateSoulFireDamageBuff()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_SoulFireBonusDamage				MeleeBuffsEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'SoulFireBonusDamage');
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_combatstims";
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	MeleeBuffsEffect = new class'X2Effect_SoulFireBonusDamage';
    MeleeBuffsEffect.BuildPersistentEffect(1, true, false); 
    MeleeBuffsEffect.SoulFireDamageBonusTier2 = 1;
    MeleeBuffsEffect.SoulFireDamageBonusTier3 = 2;

	Template.AddTargetEffect(MeleeBuffsEffect);
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: Visualization handled in X2Effect_HitandRun
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;

	return Template;
}

static function X2AbilityTemplate CreatePatchWorkDamageBuff()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_PatchWorkBonusDamage		MeleeBuffsEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'PatchWorkBonusDamage');
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_combatstims";
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	MeleeBuffsEffect = new class'X2Effect_PatchWorkBonusDamage';
    MeleeBuffsEffect.BuildPersistentEffect(1, true, false); 
    MeleeBuffsEffect.PatchWorkDamageBonusTier2 = 1;
    MeleeBuffsEffect.PatchWorkDamageBonusTier3 = 2;

	Template.AddTargetEffect(MeleeBuffsEffect);
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: Visualization handled in X2Effect_HitandRun
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;

	return Template;
}


static function X2AbilityTemplate AddSMGBonusAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SMG_StatBonus');
	Template.IconImage = "img:///gfxXComIcons.NanofiberVest";  

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	// Bonus to Mobility and DetectionRange stat effects
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, "", "", Template.IconImage, false,,Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.SMG_MOBILITY_BONUS);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

	static function X2AbilityTemplate AddShotgunPenaltyAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Shotgun_StatPenalty');
	Template.IconImage = "img:///gfxXComIcons.NanofiberVest";  

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	// Bonus to Mobility and DetectionRange stat effects
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, "", "", Template.IconImage, false,,Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.SHOTGUN_MOBILITY_PENALTY);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

static function X2AbilityTemplate CreateReactionFireAgainstCoverBonus()
{
	local X2AbilityTemplate					Template;
	local X2Effect_ReactionFireAntiCover	AntiCoverEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ReactionFireAgainstCoverBonus');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_standard";
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	AntiCoverEffect = new class'X2Effect_ReactionFireAntiCover';
	AntiCoverEffect.BuildPersistentEffect(1, true);
	AntiCoverEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
	AntiCoverEffect.AimBonus = default.REACTION_FIRE_ANTI_COVER_BONUS;
	Template.AddTargetEffect(AntiCoverEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddExtraHellWeaveHP()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'HellWeaveBonus');
	Template.IconImage = "img:///UILibrary_Common.ArmorMod_ExtraPadding";

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	// Bonus to health stat Effect
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false, , Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_HP, default.EXTRA_HELLWEAVE_HP_BONUS);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddExtraHazmatHP()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'HazmatHPBonus');
	Template.IconImage = "img:///UILibrary_Common.ArmorMod_ExtraPadding";

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	// Bonus to health stat Effect
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false, , Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_HP, default.EXTRA_HAZMAT_HP_BONUS);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddExtraPlatedHP()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'PlatedHPBonus');
	Template.IconImage = "img:///UILibrary_Common.ArmorMod_ExtraPadding";

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	// Bonus to health stat Effect
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false, , Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_HP, default.EXTRA_PLATED_HP_BONUS);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate NewFluxWeaveAbility()
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentStatChange		    PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'FluxWeaveAbility');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_Common.ArmorMod_FluxWeave";
	Template.bDontDisplayInAbilitySummary = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);


	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.EffectName = 'FluxStatBonus';
    PersistentStatChangeEffect.AddPersistentStatChange(eStat_Defense, 10);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Offense, 5);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_FlankingCritChance, 15);
    Template.AddTargetEffect(PersistentStatChangeEffect);     

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


static function X2AbilityTemplate CreateSustainingShield()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_PersistentStatChange     ShieldedEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SustainingShieldBonus');
	Template.IconImage = "img:///UILibrary_Common.ArmorMod_SustainingSphere";

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

    ShieldedEffect = class'X2Ability_AdventShieldBearer'.static.CreateShieldedEffect(Template.LocFriendlyName, Template.GetMyLongDescription(), 3);

	Template.AddShooterEffect(ShieldedEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddCritDamageWeaponBonus()
{
	local X2AbilityTemplate						Template;
	local X2Effect_PrimaryHitBonusCritDamage        DamageEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'WeaponUpgradeCritDamageBonus');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityCenterMass";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;

	DamageEffect = new class'X2Effect_PrimaryHitBonusCritDamage';
	DamageEffect.BonusCritDamage = 1;
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  No visualization
	// NOTE: Limitation of this ability to PRIMARY weapons only must be configured in ClassData.ini, otherwise will apply to pistols/swords, etc., contrary to design and loc text
	// Ability parameter is ApplyToWeaponSlot=eInvSlot_PrimaryWeapon
	return Template;
}


static function X2AbilityTemplate OverrideLR(name TemplateName)
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_LightningReflexes_LW		PersistentEffect;
	local X2Condition_GameplayTag GameplayCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_lightningreflexes";
	Template.Hostility = eHostility_Neutral;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	PersistentEffect = new class'X2Effect_LightningReflexes_LW';
	PersistentEffect.BuildPersistentEffect(1, true, false);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddTargetEffect(PersistentEffect);

	if(TemplateName == 'DarkEventAbility_LightningReflexes')
	{
		GameplayCondition = new class'X2Condition_GameplayTag';
		GameplayCondition.RequiredGameplayTag = 'DarkEvent_LightningReflexes';
		Template.AbilityShooterConditions.AddItem(GameplayCondition);
	}

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.bCrossClassEligible = true;
	return Template;
}

static function X2AbilityTemplate AddExtraAdrenalHP()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'AdrenalHPBonus');
	Template.IconImage = "img:///UILibrary_Common.ArmorMod_ExtraPadding";

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	// Bonus to health stat Effect
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false, , Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_HP, default.EXTRA_ADRENAL_HP_BONUS);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate CreateWeaponUpgradeCritBonus(name Templatename, int CritBonus)
{
	local XMBEffect_ConditionalBonus Effect;
	local X2AbilityTemplate Template;
	// Create a conditional bonus
	Effect = new class'XMBEffect_ConditionalBonus';

	// The bonus adds the aim and crit chance
	Effect.AddToHitModifier(CritBonus, eHit_Crit);

	Effect.AbilityTargetConditions.AddItem(default.MatchingWeaponCondition);

	// Create the template using a helper function
	Template = Passive(Templatename, "img:///UILibrary_FavidsPerkPack.Perk_Ph_Predator", true, Effect);

	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, false,,Template.AbilitySourceName);

	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;

	return Template;
}


static function X2AbilityTemplate NewBreakerFocus() 
{
	local X2AbilityTemplate		Template;
	local X2Effect_TemplarFocus	FocusEffect;
	local array<StatChange>		StatChanges;
	local StatChange			NewStatChange;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'BreakerFocus');

	Template.IconImage = class'UIUtilities'.static.GetAbilityIconPath('MutonRage');
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;
	Template.bFeatureInCharacterUnlock = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	FocusEffect = new class'X2Effect_TemplarFocus';
	FocusEffect.BuildPersistentEffect(1, true, false);
	FocusEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, false, , Template.AbilitySourceName);
	FocusEffect.EffectSyncVisualizationFn = class'X2Ability_TemplarAbilitySet'.static.FocusEffectVisualization;
	FocusEffect.VisualizationFn = class'X2Ability_TemplarAbilitySet'.static.FocusEffectVisualization;

	//	Rage 0 Stack
	StatChanges.Length = 0;
	FocusEffect.AddNextFocusLevel(StatChanges, 0, 0);

   ///////////////////////////////////////////////////////////////////////////////////////
	//	Rage 1 Stack
   ///////////////////////////////////////////////////////////////////////////////////////
	StatChanges.Length = 0;
   // Trade Offense and Dodge
	NewStatChange.StatType = eStat_Offense;
	NewStatChange.StatAmount = 5; // 15
	StatChanges.AddItem(NewStatChange);
	NewStatChange.StatType = eStat_Defense;
	NewStatChange.StatAmount = -7; // 15
	StatChanges.AddItem(NewStatChange);
   // Trade Defense and Crit Chance
	NewStatChange.StatType = eStat_CritChance;
	NewStatChange.StatAmount = 10; // 5
	StatChanges.AddItem(NewStatChange);
   // Trade Strength and Willpower
	NewStatChange.StatType = eStat_Will;
	NewStatChange.StatAmount = -10;
	StatChanges.AddItem(NewStatChange);
	NewStatChange.StatType = eStat_Strength;
	NewStatChange.StatAmount = 10;
	StatChanges.AddItem(NewStatChange);
	NewStatChange.StatType = eStat_Mobility;
	NewStatChange.StatAmount = 1;
	StatChanges.AddItem(NewStatChange);
	FocusEffect.AddNextFocusLevel(StatChanges, 0, 0);

   ///////////////////////////////////////////////////////////////////////////////////////
	//	Rage 2 Stack
   ///////////////////////////////////////////////////////////////////////////////////////
	StatChanges.Length = 0;
   // Trade Offense and Dodge
	NewStatChange.StatType = eStat_Offense;
	NewStatChange.StatAmount = 10; // 15
	StatChanges.AddItem(NewStatChange);
   // Trade Defense and Crit Chance
	NewStatChange.StatType = eStat_CritChance;
	NewStatChange.StatAmount = 20; // 5
	StatChanges.AddItem(NewStatChange);
	NewStatChange.StatType = eStat_Defense;
	NewStatChange.StatAmount = -14; // -5
	StatChanges.AddItem(NewStatChange);
   // Trade Strength and Willpower
	NewStatChange.StatType = eStat_Will;
	NewStatChange.StatAmount = -20;
	StatChanges.AddItem(NewStatChange);
	NewStatChange.StatType = eStat_Strength;
	NewStatChange.StatAmount = 20;
	StatChanges.AddItem(NewStatChange);
	NewStatChange.StatType = eStat_Mobility;
	NewStatChange.StatAmount = 2;
	StatChanges.AddItem(NewStatChange);
	FocusEffect.AddNextFocusLevel(StatChanges, 0, 0);

   ///////////////////////////////////////////////////////////////////////////////////////
	//	Rage 3 Stack
   ///////////////////////////////////////////////////////////////////////////////////////
	StatChanges.Length = 0;
   // Trade Offense and Dodge
	NewStatChange.StatType = eStat_Offense;
	NewStatChange.StatAmount = 15; // 15
	StatChanges.AddItem(NewStatChange);
   // Trade Defense and Crit Chance
	NewStatChange.StatType = eStat_CritChance;
	NewStatChange.StatAmount = 30; // 5
	StatChanges.AddItem(NewStatChange);
	NewStatChange.StatType = eStat_Defense;
	NewStatChange.StatAmount = -21; // -5
	StatChanges.AddItem(NewStatChange);
   // Trade Strength and Willpower
	NewStatChange.StatType = eStat_Will;
	NewStatChange.StatAmount = -30;
	StatChanges.AddItem(NewStatChange);
	NewStatChange.StatType = eStat_Strength;
	NewStatChange.StatAmount = 30;
	StatChanges.AddItem(NewStatChange);
	NewStatChange.StatType = eStat_Mobility;
	NewStatChange.StatAmount = 3;
	StatChanges.AddItem(NewStatChange);
	FocusEffect.AddNextFocusLevel(StatChanges, 0, 0);


   ///////////////////////////////////////////////////////////////////////////////////////
	//	Rage 4 Stack
   ///////////////////////////////////////////////////////////////////////////////////////
	StatChanges.Length = 0;
   // Trade Offense and Dodge
	NewStatChange.StatType = eStat_Offense;
	NewStatChange.StatAmount = 20; // 15
	StatChanges.AddItem(NewStatChange);

	NewStatChange.StatType = eStat_CritChance;
	NewStatChange.StatAmount = 40; // 5
	StatChanges.AddItem(NewStatChange);
	NewStatChange.StatType = eStat_Defense;
	NewStatChange.StatAmount = -28; // -5
	StatChanges.AddItem(NewStatChange);
   // Trade Strength and Willpower
	NewStatChange.StatType = eStat_Will;
	NewStatChange.StatAmount = -40;
	StatChanges.AddItem(NewStatChange);
	NewStatChange.StatType = eStat_Strength;
	NewStatChange.StatAmount = 40;
	StatChanges.AddItem(NewStatChange);
	NewStatChange.StatType = eStat_Mobility;
	NewStatChange.StatAmount = 4;
	StatChanges.AddItem(NewStatChange);
	FocusEffect.AddNextFocusLevel(StatChanges, 0, 0);

   ///////////////////////////////////////////////////////////////////////////////////////
	//	Rage 5 Stack
   ///////////////////////////////////////////////////////////////////////////////////////
	StatChanges.Length = 0;
   // Trade Offense and Dodge
	NewStatChange.StatType = eStat_Offense;
	NewStatChange.StatAmount = 25; // 15
	StatChanges.AddItem(NewStatChange);
   // Trade Defense and Crit Chance
	NewStatChange.StatType = eStat_CritChance;
	NewStatChange.StatAmount = 50; // 5
	StatChanges.AddItem(NewStatChange);
	NewStatChange.StatType = eStat_Defense;
	NewStatChange.StatAmount = -35; // -5
	StatChanges.AddItem(NewStatChange);
   // Trade Strength and Willpower
	NewStatChange.StatType = eStat_Will;
	NewStatChange.StatAmount = -50;
	StatChanges.AddItem(NewStatChange);
	NewStatChange.StatType = eStat_Strength;
	NewStatChange.StatAmount = 50;
	StatChanges.AddItem(NewStatChange);
   // Bonus Mobility
	NewStatChange.StatType = eStat_Mobility;
	NewStatChange.StatAmount = 5;
	StatChanges.AddItem(NewStatChange);
	FocusEffect.AddNextFocusLevel(StatChanges, 0, 0);

	Template.AddTargetEffect(FocusEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;

	Template.AdditionalAbilities.AddItem('BreakerAddFocusOnDamage');
	//Template.AdditionalAbilities.AddItem('BreakerRefreshFocus');
	Template.AdditionalAbilities.AddItem('Focus_Refresh');
	Template.AdditionalAbilities.AddItem('MutonRageBerserk');

	return Template;
}


static function X2AbilityTemplate CreateCallForAndroidReinforcements()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_UnitEffects			UnitEffects;
	local X2Condition_AndroidReinforcements RNFCondition;
	local X2AbilityMultiTarget_Radius RadiusMultiTarget;
	local X2AbilityTarget_Cursor	CursorTarget;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'XComCallForAndroidReinforcements');

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.MUST_RELOAD_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_move_command";
	//Costs
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	//Targeting
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();
	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.TargetingMethod = class'X2TargetingMethod_Teleport';

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = true;
	CursorTarget.FixedAbilityRange = 2;     // yes there is.
	Template.AbilityTargetStyle = CursorTarget;
	

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = 0.25; // small amount so it just grabs one tile
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;


	UnitEffects = new class'X2Condition_UnitEffects';
	UnitEffects.AddExcludeEffect('MindControl', 'AA_UnitIsMindControlled');
	Template.AbilityShooterConditions.AddItem(UnitEffects);

	Template.ModifyNewContextFn = AndroidReinforcement_ModifyActivatedAbilityContext;
	Template.BuildNewGameStateFn = AndroidReinforcement_BuildGameState; // TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = CallInXComAndroidReinforcementVisualization;
	Template.bShowActivation = true;
	Template.bSkipFireAction = true;

	Template.bSkipExitCoverWhenFiring = true;

	Template.CinescriptCameraType = "";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Defensive;

	//Template.CustomFireAnim = 'NO_CallReinforcements';
	
	RNFCondition = new class'X2Condition_AndroidReinforcements';
	Template.AbilityShooterConditions.AddItem(RNFCondition);


	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;
	return Template;
}

static simulated function AndroidReinforcement_ModifyActivatedAbilityContext(XComGameStateContext Context)
{
	local XComGameStateContext_Ability AbilityContext;
	local PathingInputData InputData;


	AbilityContext = XComGameStateContext_Ability(Context);
	
	// Build the MovementData for the path
	// First posiiton is the current location
	AbilityContext.InputContext.MovementPaths.AddItem(InputData);
}


static function XComGameState AndroidReinforcement_BuildGameState(XComGameStateContext Context)
{
	local XComGameStateHistory		History;
	local StateObjectReference		AndroidRef,AbilityRef;
	local XComGameState_BattleData	BattleData;
	local int						AvaliableAndroidCount;
	local XComGameState_Unit		AndroidState;
	local XComGameState_Ability		AbilityState;
	local XComGameState_MissionSite MissionSiteState;
	local XComGameState_StrategyAction_Mission MissionAction;
	local XComGameState NewGameState;
	local X2Effect_GroupTimelineMove GroupMoveEffect;
	local EffectAppliedData ApplyData;
	local XComGameStateContext_Ability	AbilityContext;
	//local array<StateObjectReference> AvailableAndroidReferences;
	local vector NewLocation;
	local TTile NewTileLocation; 


	//Spawn the android at first breach point
	NewGameState = TypicalAbility_BuildGameState(Context);

	AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());	

	History = `XCOMHISTORY;

	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData', false));
	BattleData = XComGameState_BattleData(NewGameState.ModifyStateObject(class'XComGameState_BattleData', BattleData.ObjectID));

	MissionSiteState = XComGameState_MissionSite(History.GetGameStateForObjectID(BattleData.m_iMissionID));
	MissionAction = MissionSiteState.GetMissionAction();

	AvaliableAndroidCount = BattleData.StartingAndroidReserves.length - BattleData.SpentAndroidReserves.length;

	if(AvaliableAndroidCount > 0)
	{	//Grab the first available android;
		foreach BattleData.StartingAndroidReserves(AndroidRef)
		{
			if(BattleData.SpentAndroidReserves.find('ObjectID',AndroidRef.ObjectID) == INDEX_NONE)
			{
				break;
			}
		}
			AndroidState = XComGameState_Unit(History.GetGameStateForObjectID(AndroidRef.ObjectID));
			AndroidState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', AndroidState.ObjectID));

			AndroidState.ClearRemovedFromPlayFlag();
			//AndroidState.bCanTraverseRooms = true;

			//TargetTile = `XWORLD.GetTileCoordinatesFromPosition(BreachDataState.CachedBreachPointInfos[0].BreachPointLocation);
			/*
			foreach BreachDataState.CachedBreachPointInfos (PointInfo)
			{
				break;	
			}
			`XWORLD.GetFloorTileForPosition(PointInfo.BreachPointLocation, TargetTile);
				*/

			NewLocation = AbilityContext.InputContext.TargetLocations[0];
			NewTileLocation = `XWORLD.GetTileCoordinatesFromPosition(NewLocation);
			NewLocation = `XWORLD.GetPositionFromTileCoordinates(NewTileLocation);
			AndroidState.SetVisibilityLocation(NewTileLocation);

			AndroidState.ActionPoints.Length = 0;
			/*
			for (i = 0; i < NumActionPoints; ++i)
			{
				AndroidState.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
			}
				*/
			GroupMoveEffect = new class 'X2Effect_GroupTimelineMove';
			GroupMoveEffect.BuildPersistentEffect(1, false, true, false, eWatchRule_UnitTurnEnd);
			GroupMoveEffect.bMoveRelativeToCurrentGroup = true;
			GroupMoveEffect.NumberOfRelativePlacesToMove = 1;
			GroupMoveEffect.bApplyMoveOnEffectAdded = true;

			ApplyData.SourceStateObjectRef = AndroidState.GetReference();
			ApplyData.TargetStateObjectRef = AndroidState.GetReference();
			GroupMoveEffect.ApplyEffect(ApplyData, AndroidState, NewGameState);



			// init & register for UnitPostBeginPlayTrigger 
			foreach AndroidState.Abilities(AbilityRef)
			{
				AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityRef.ObjectID));
				AbilityState.CheckForPostBeginPlayActivation(NewGameState);
			}

			// lot of systems expect XCOM units to be in the AssignedUnitRefs array
			MissionAction.AssignUnit(NewGameState, AndroidRef);

			BattleData.SpentAndroidReserves.AddItem(AndroidRef);

			// init & register for unit specific events
			AndroidState.OnBeginTacticalPlay(NewGameState);

		//`XEVENTMGR.TriggerEvent('RequestXComAndroidReinforcement', self, BattleData, NewGameState);
	}
	return NewGameState;
}

static function CallInXComAndroidReinforcementVisualization(XComGameState VisualizeGameState)
{
	local VisualizationActionMetadata ActionMetadata;
	local XComGameState_Unit UnitState, FreshlySpawnedUnitState;
	local XComGameStateHistory History;
	local X2Action_UpdateUI UpdateUIAction;
	local XComContentManager ContentManager;
	local X2Action_PlayEffect	SpawnEffectAction;
	local TTile SpawnedUnitTile;


	History = `XCOMHISTORY;

	TypicalAbility_BuildVisualization(VisualizeGameState);

	ContentManager = `CONTENT;


	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Unit', UnitState)
	{

		if( History.GetGameStateForObjectID(UnitState.ObjectID, , VisualizeGameState.HistoryIndex - 1) == None )
		{	//Yes, this assumes that only 1 unit spawned.
			FreshlySpawnedUnitState = UnitState;
		}
		ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(UnitState.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
		ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(UnitState.ObjectID);
		ActionMetadata.VisualizeActor = History.GetVisualizer(UnitState.ObjectID);
	
		class'X2Action_SyncVisualizer'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext());
	}

		FreshlySpawnedUnitState.GetKeystoneVisibilityLocation(SpawnedUnitTile);
		
		ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(FreshlySpawnedUnitState.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
		ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(FreshlySpawnedUnitState.ObjectID);
		ActionMetadata.VisualizeActor = History.GetVisualizer(FreshlySpawnedUnitState.ObjectID);

		SpawnEffectAction = X2Action_PlayEffect(class'X2Action_PlayEffect'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		//SpawnEffectAction.EffectName = ContentManager.PsiWarpInEffectPathName;
		SpawnEffectAction.EffectName = "FX_Psi_Bomb.P_Psi_Bomb_Explosion";
		
		SpawnEffectAction.EffectLocation = `XWORLD.GetPositionFromTileCoordinates(SpawnedUnitTile);
		SpawnEffectAction.bStopEffect = false;

		SpawnEffectAction = X2Action_PlayEffect(class'X2Action_PlayEffect'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		SpawnEffectAction.EffectName = ContentManager.PsiGateEffectPathName;
		SpawnEffectAction.EffectLocation = `XWORLD.GetPositionFromTileCoordinates(SpawnedUnitTile);
		SpawnEffectAction.bStopEffect = true;
	
		UpdateUIAction = X2Action_UpdateUI(class'X2Action_UpdateUI'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		UpdateUIAction.SpecificID = ActionMetadata.StateObject_NewState.ObjectID;
		UpdateUIAction.UpdateType = EUIUT_GroupInitiative;
	

}

static function X2AbilityTemplate Reposition()
{
	local X2AbilityTemplate					Template;
	local X2Effect_HitandRun				HitandRunEffect;
	local X2Condition_BreachPhase	BreachPhase;
	`CREATE_X2ABILITY_TEMPLATE (Template, 'Reposition_LW');
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_SOCombatEngineer.UIPerk_skirmisher";
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);


	BreachPhase = new class'X2Condition_BreachPhase';
	BreachPhase.bValidInBreachPhase = false;
	Template.AbilityShooterConditions.AddItem(BreachPhase);

	HitandRunEffect = new class'X2Effect_HitandRun';
	HitandRunEffect.HNRUsesName = 'RepositionUses';
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
static function X2AbilityTemplate CloseandPersonal()
{
	local X2AbilityTemplate						Template;
	local X2Effect_CloseandPersonal				CritModifier;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'CloseandPersonal');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityCloseandPersonal";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	CritModifier = new class 'X2Effect_CloseandPersonal';
	CritModifier.BuildPersistentEffect (1, true, false);
	CritModifier.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (CritModifier);
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}



static function X2DataTemplate PackMaster()
{
	local X2AbilityTemplate Template;
	local X2Effect_PackMaster PackMasterEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'PackMaster');
	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_adrenaline_defense";
	Template.Hostility = eHostility_Neutral;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.bHideOnClassUnlock = false;
	Template.bFeatureInCharacterUnlock = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	PackMasterEffect = new class'X2Effect_PackMaster';
	PackMasterEffect.BuildPersistentEffect(1, true, true);

	Template.AddTargetEffect(PackMasterEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}


	static function X2AbilityTemplate AddGrazingFireAbility()
{
	local X2AbilityTemplate					Template;
	local X2Effect_GrazingFire				GrazingEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'GrazingFire');

	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityGrazingFire";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.bShowActivation = false;
	Template.bSkipFireAction = true;
	Template.bCrossClassEligible = true;
	GrazingEffect = new class'X2Effect_GrazingFire';
	GrazingEffect.SuccessChance = default.GRAZING_FIRE_SUCCESS_CHANCE;
	GrazingEffect.BuildPersistentEffect (1, true, false);
	GrazingEffect.SetDisplayInfo (ePerkBuff_Passive,Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName); 
	Template.AddTargetEffect(GrazingEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	return Template;
}


static function X2AbilityTemplate ChosenDragonRounds()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_EventListener	EventListener;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ChosenDragonRounds');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_ammo_incendiary";
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	// Trigger on Damage
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'AbilityActivated';
	EventListener.ListenerData.EventFn = AbilityTriggerEventListener_DragonRounds;
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Priority = 40;
	EventListener.ListenerData.Filter = eFilter_Unit;

	Template.AbilityTriggers.AddItem(EventListener);

	//	putting the burn effect first so it visualizes correctly
	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateBurningStatusEffect(2, 1));

	Template.FrameAbilityCameraType = eCameraFraming_Never; 
	Template.bSkipExitCoverWhenFiring = true;
	Template.bSkipFireAction = true;	//	this fire action will be merged by Merge Vis function
	Template.bShowActivation = true;
	Template.bUsesFiringCamera = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.MergeVisualizationFn = ApplyEffect_MergeVisualization;
	Template.BuildInterruptGameStateFn = none;

	Template.AdditionalAbilities.AddItem('ChosenDragonRoundsPassive');

	Template.ChosenExcludeTraits.AddItem('ChosenBleedingRounds');
	Template.ChosenExcludeTraits.AddItem('ChosenVenomRounds');

	return Template;
}

static function X2AbilityTemplate ChosenDragonRoundsPassive()
{
	local X2AbilityTemplate	Template;

	Template = PurePassive('ChosenDragonRoundsPassive', "img:///UILibrary_LW_Overhaul.UIPerk_ammo_incendiary", false);

	return Template;
}

static function EventListenerReturn AbilityTriggerEventListener_DragonRounds(
	Object EventData,
	Object EventSource,
	XComGameState GameState,
	Name EventID,
	Object CallbackData)
{
	return HandleApplyEffectEventTrigger('ChosenDragonRounds', EventData, EventSource, GameState);
}

static function X2AbilityTemplate ChosenBleedingRounds()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_EventListener	EventListener;
	`CREATE_X2ABILITY_TEMPLATE(Template, 'ChosenBleedingRounds');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_ammo_incendiary";
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	// Trigger on Damage
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'AbilityActivated';
	EventListener.ListenerData.EventFn = AbilityTriggerEventListener_BleedingRounds;
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Priority = 40;
	EventListener.ListenerData.Filter = eFilter_Unit;

	Template.AbilityTriggers.AddItem(EventListener);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateBleedingStatusEffect(3, 2));

	Template.FrameAbilityCameraType = eCameraFraming_Never; 
	Template.bSkipExitCoverWhenFiring = true;
	Template.bSkipFireAction = true;	//	this fire action will be merged by Merge Vis function
	Template.bShowActivation = true;
	Template.bUsesFiringCamera = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.MergeVisualizationFn = ApplyEffect_MergeVisualization;
	Template.BuildInterruptGameStateFn = none;

	Template.AdditionalAbilities.AddItem('ChosenBleedingRoundsPassive');
	
	Template.ChosenExcludeTraits.AddItem('ChosenDragonRounds');
	Template.ChosenExcludeTraits.AddItem('ChosenVenomRounds');

	return Template;
}

static function X2AbilityTemplate ChosenBleedingRoundsPassive()
{
	local X2AbilityTemplate	Template;

	Template = PurePassive('ChosenBleedingRoundsPassive', "img:///UILibrary_LW_Overhaul.UIPerk_ammo_incendiary", false);

	return Template;
}

static function EventListenerReturn AbilityTriggerEventListener_BleedingRounds(
	Object EventData,
	Object EventSource,
	XComGameState GameState,
	Name EventID,
	Object CallbackData)
{
	return HandleApplyEffectEventTrigger('ChosenBleedingRounds', EventData, EventSource, GameState);
}
static function X2AbilityTemplate ChosenVenomRounds()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_EventListener	EventListener;
	`CREATE_X2ABILITY_TEMPLATE(Template, 'ChosenVenomRounds');

	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityVenomRounds";
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	// Trigger on Damage
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'AbilityActivated';
	EventListener.ListenerData.EventFn = AbilityTriggerEventListener_VenomRounds;
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Priority = 40;
	EventListener.ListenerData.Filter = eFilter_Unit;

	Template.AbilityTriggers.AddItem(EventListener);

	//	putting the burn effect first so it visualizes correctly
	Template.AddTargetEffect(class'X2StatusEffects'.static.CreatePoisonedStatusEffect());

	Template.FrameAbilityCameraType = eCameraFraming_Never; 
	Template.bSkipExitCoverWhenFiring = true;
	Template.bSkipFireAction = true;	//	this fire action will be merged by Merge Vis function
	Template.bShowActivation = true;
	Template.bUsesFiringCamera = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.MergeVisualizationFn = ApplyEffect_MergeVisualization;
	Template.BuildInterruptGameStateFn = none;

	Template.AdditionalAbilities.AddItem('ChosenVenomRoundsPassive');

	return Template;
}

static function X2AbilityTemplate ChosenVenomRoundsPassive()
{
	local X2AbilityTemplate	Template;

	Template = PurePassive('ChosenVenomRoundsPassive', "img:///UILibrary_LW_Overhaul.LW_AbilityVenomRounds", false);

	return Template;
}

	static function X2AbilityTemplate PinningAttacks()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_EventListener	EventListener;
	local X2Effect_Rooted RootedEffect;
	local X2Condition_BreachPhase BreachPhase;
	`CREATE_X2ABILITY_TEMPLATE(Template, 'PinningAttacks');

	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_move_circle";
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	// Trigger on Damage
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'AbilityActivated';
	EventListener.ListenerData.EventFn = AbilityTriggerEventListener_PinningAttacks;
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Priority = 40;
	EventListener.ListenerData.Filter = eFilter_Unit;

	Template.AbilityTriggers.AddItem(EventListener);

	BreachPhase = new class'X2Condition_BreachPhase';
	BreachPhase.bValidInBreachPhase = false;
	Template.AbilityTargetConditions.AddItem(BreachPhase);
	Template.AbilityShooterConditions.AddItem(BreachPhase);

	//	putting the burn effect first so it visualizes correctly

	RootedEffect = class'X2StatusEffects'.static.CreateRootedStatusEffect(2);
	RootedEffect.bRemoveWhenSourceDies = false;
	Template.AddTargetEffect(RootedEffect);

	Template.FrameAbilityCameraType = eCameraFraming_Never; 
	Template.bSkipExitCoverWhenFiring = true;
	Template.bSkipFireAction = true;	//	this fire action will be merged by Merge Vis function
	Template.bShowActivation = true;
	Template.bUsesFiringCamera = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.MergeVisualizationFn = ApplyEffect_MergeVisualization;
	Template.BuildInterruptGameStateFn = none;

	Template.AdditionalAbilities.AddItem('PinningAttacksPassive');

	return Template;
}

static function X2AbilityTemplate PinningAttacksPassive()
{
	local X2AbilityTemplate	Template;

	Template = PurePassive('PinningAttacksPassive', "img:///UILibrary_LW_Overhaul.UIPerk_move_circle", false);

	return Template;
}

function ApplyEffect_MergeVisualization(X2Action BuildTree, out X2Action VisualizationTree)
{
	local XComGameStateVisualizationMgr		VisMgr;
	local array<X2Action>					arrActions;
	local X2Action_MarkerTreeInsertBegin	MarkerStart;
	local X2Action_MarkerTreeInsertEnd		MarkerEnd;
	local X2Action							WaitAction;
	local X2Action_MarkerNamed				MarkerAction;
	local XComGameStateContext_Ability		AbilityContext;
	local VisualizationActionMetadata		ActionMetadata;
	local bool bFoundHistoryIndex;
	local int i;


	VisMgr = `XCOMVISUALIZATIONMGR;
	
	// Find the start of the Singe's Vis Tree
	MarkerStart = X2Action_MarkerTreeInsertBegin(VisMgr.GetNodeOfType(BuildTree, class'X2Action_MarkerTreeInsertBegin'));
	AbilityContext = XComGameStateContext_Ability(MarkerStart.StateChangeContext);

	//	Find all Fire Actions in the Triggering Shot's Vis Tree
	VisMgr.GetNodesOfType(VisualizationTree, class'X2Action_Fire', arrActions);

	//	Cycle through all of them to find the Fire Action we need, which will have the same History Index as specified in Singe's Context, which gets set in the Event Listener
	for (i = 0; i < arrActions.Length; i++)
	{
		if (arrActions[i].StateChangeContext.AssociatedState.HistoryIndex == AbilityContext.DesiredVisualizationBlockIndex)
		{
			bFoundHistoryIndex = true;
			break;
		}
	}
	//	If we didn't find the correct action, we call the failsafe Merge Vis Function, which will make both Singe's Target Effects apply seperately after the ability finishes.
	//	Looks bad, but at least nothing is broken.
	if (!bFoundHistoryIndex)
	{
		AbilityContext.SuperMergeIntoVisualizationTree(BuildTree, VisualizationTree);
		return;
	}

	//`LOG("Num of Fire Actions: " @ arrActions.Length,, 'IRISINGE');

	//	Add a Wait For Effect Action after the Triggering Shot's Fire Action. This will allow Singe's Effects to visualize the moment the Triggering Shot connects with the target.
	AbilityContext = XComGameStateContext_Ability(arrActions[i].StateChangeContext);
	ActionMetaData = arrActions[i].Metadata;
	WaitAction = class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetaData, AbilityContext,, arrActions[i]);

	//	Insert the Singe's Vis Tree right after the Wait For Effect Action
	VisMgr.ConnectAction(MarkerStart, VisualizationTree,, WaitAction);

	//	Main part of Merge Vis is done, now we just tidy up the ending part. As I understood from MrNice, this is necessary to make sure Vis will look fine if Fire Action ends before Singe finishes visualizing
	//	which tbh sounds like a super edge case, but okay
	//	Find all marker actions in the Triggering Shot Vis Tree.
	VisMgr.GetNodesOfType(VisualizationTree, class'X2Action_MarkerNamed', arrActions);

	//	Cycle through them and find the 'Join' Marker that comes after the Triggering Shot's Fire Action.
	for (i = 0; i < arrActions.Length; i++)
	{
		MarkerAction = X2Action_MarkerNamed(arrActions[i]);

		if (MarkerAction.MarkerName == 'Join' && MarkerAction.StateChangeContext.AssociatedState.HistoryIndex == AbilityContext.DesiredVisualizationBlockIndex)
		{
			//	Grab the last Action in the Singe Vis Tree
			MarkerEnd = X2Action_MarkerTreeInsertEnd(VisMgr.GetNodeOfType(BuildTree, class'X2Action_MarkerTreeInsertEnd'));

			//	TBH can't imagine circumstances where MarkerEnd wouldn't exist, but okay
			if (MarkerEnd != none)
			{
				//	"tie the shoelaces". Vis Tree won't move forward until both Singe Vis Tree and Triggering Shot's Fire action are not fully visualized.
				VisMgr.ConnectAction(MarkerEnd, VisualizationTree,,, MarkerAction.ParentActions);
				VisMgr.ConnectAction(MarkerAction, BuildTree,, MarkerEnd);
			}
			else
			{
				//	not sure what this does
				VisMgr.GetAllLeafNodes(BuildTree, arrActions);
				VisMgr.ConnectAction(MarkerAction, BuildTree,,, arrActions);
			}

			//VisMgr.ConnectAction(MarkerAction, VisualizationTree,, MarkerEnd);
			break;
		}
	}
}

static function EventListenerReturn AbilityTriggerEventListener_VenomRounds(
	Object EventData,
	Object EventSource,
	XComGameState GameState,
	Name EventID,
	Object CallbackData)
{
	return HandleApplyEffectEventTrigger('ChosenVenomRounds', EventData, EventSource, GameState);
}


static function EventListenerReturn AbilityTriggerEventListener_PinningAttacks(
	Object EventData,
	Object EventSource,
	XComGameState GameState,
	Name EventID,
	Object CallbackData)
{
	return HandleApplyEffectEventTrigger('PinningAttacks', EventData, EventSource, GameState);
}

static function EventListenerReturn HandleApplyEffectEventTrigger(
	name AbilityName,
	Object EventData,
	Object EventSource,
	XComGameState GameState)
{
	local XComGameStateContext_Ability		AbilityContext;
	local XComGameState_Ability				AbilityState, SlagAbilityState;
	local XComGameState_Unit				SourceUnit, TargetUnit;
	local XComGameStateContext				FindContext;
	local int								VisualizeIndex;
	local XComGameStateHistory				History;
	local X2AbilityTemplate					AbilityTemplate;
	local X2Effect							Effect;
	local X2AbilityMultiTarget_BurstFire	BurstFire;
	local bool bDealsDamage;
	local int NumShots;
	local int i;

	History = `XCOMHISTORY;

	AbilityState = XComGameState_Ability(EventData);	// Ability State that triggered this Event Listener
	SourceUnit = XComGameState_Unit(EventSource);
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	TargetUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
	AbilityTemplate = AbilityState.GetMyTemplate();

	if (AbilityState != none && SourceUnit != none && TargetUnit != none && AbilityTemplate != none && AbilityContext.InputContext.ItemObject.ObjectID != 0)
	{	
		//	try to find the ability on the source weapon of the same ability
		SlagAbilityState = XComGameState_Ability(History.GetGameStateForObjectID(SourceUnit.FindAbility(AbilityName, AbilityContext.InputContext.ItemObject).ObjectID));

		//	if this is an offensive ability that actually hit the enemy, the same weapon has a Singe ability, and the enemy is still alive
		if (SlagAbilityState != none && AbilityContext.IsResultContextHit() && AbilityState.GetMyTemplate().Hostility == eHostility_Offensive && TargetUnit.IsAlive())
		{
			//	check if the ability deals damage
			foreach AbilityTemplate.AbilityTargetEffects(Effect)
			{
				if (X2Effect_ApplyWeaponDamage(Effect) != none)
				{
					bDealsDamage = true;
					break;
				}
			}

			if (bDealsDamage)
			{
				//	account for abilities like Fan Fire and Cyclic Fire that take multiple shots within one ability activation
				NumShots = 1;
				BurstFire = X2AbilityMultiTarget_BurstFire(AbilityTemplate.AbilityMultiTargetStyle);
				if (BurstFire != none)
				{
					NumShots += BurstFire.NumExtraShots;
				}
				//	
				for (i = 0; i < NumShots; i++)
				{
					//	pass the Visualize Index to the Context for later use by Merge Vis Fn
					VisualizeIndex = GameState.HistoryIndex;
					FindContext = AbilityContext;
					while (FindContext.InterruptionHistoryIndex > -1)
					{
						FindContext = History.GetGameStateFromHistory(FindContext.InterruptionHistoryIndex).GetContext();
						VisualizeIndex = FindContext.AssociatedState.HistoryIndex;
					}
					//`LOG("Singe activated by: " @ AbilityState.GetMyTemplateName() @ "from: " @ AbilityState.GetSourceWeapon().GetMyTemplateName() @ "Singe source weapon: " @ SlagAbilityState.GetSourceWeapon().GetMyTemplateName(),, 'IRISINGE');
					SlagAbilityState.AbilityTriggerAgainstSingleTarget(AbilityContext.InputContext.PrimaryTarget, false, VisualizeIndex);
				}
			}
		}
	}

	return ELR_NoInterrupt;
}


	static function X2AbilityTemplate TacticalSense()
{
	local XMBEffect_ConditionalBonus ShootingEffect;
	local X2AbilityTemplate Template;
	local XMBCondition_CoverType CoverCondition;

	ShootingEffect = new class'XMBEffect_ConditionalBonus';
	ShootingEffect.EffectName = 'Tacsense';

	ShootingEffect.AddToHitAsTargetModifier(-1 * default.TACSENSE_DEF_BONUS, eHit_Success);

	
	CoverCondition = new class'XMBCondition_CoverType';
	CoverCondition.ExcludedCoverTypes.AddItem(CT_None);

	ShootingEffect.AbilityTargetConditionsAsTarget.AddItem(CoverCondition);

	// Prevent the effect from applying to a unit more than once
	ShootingEffect.DuplicateResponse = eDupe_Refresh;

	// The effect lasts forever
	ShootingEffect.BuildPersistentEffect(1, true, false, false, eWatchRule_TacticalGameStart);
	
	// Activated ability that targets user
	Template = Passive('TacticalSense_LW', "img:///UILibrary_XPerkIconPack.UIPerk_shot_box", true, ShootingEffect);

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use

	return Template;
}

	static function X2AbilityTemplate AddInfighterAbility()
{
	local X2AbilityTemplate						Template;
	local X2Effect_Infighter					DodgeBonus;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'Infighter');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityInfighter";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	DodgeBonus = new class 'X2Effect_Infighter';
	DodgeBonus.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	DodgeBonus.BuildPersistentEffect(1, true, false);
	Template.AddTargetEffect(DodgeBonus);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  No visualization
	return Template;
}


	static function X2AbilityTemplate BerserkerBladestorm()
{
	local X2AbilityTemplate                 Template;

	Template = PurePassive('BerserkerBladestorm', "img:///UILibrary_PerkIcons.UIPerk_beserk", false, 'eAbilitySource_Perk');
	Template.AdditionalAbilities.AddItem('BerserkerBladestormAttack');

	return Template;
}

static function X2AbilityTemplate BerserkerBladestormAttack(name TemplateName = 'BerserkerBladestormAttack')
{
	local X2AbilityTemplate Template;

	Template = class'X2Ability_Hellion'.static.BladestormAttack(TemplateName);

	Template.CustomFireAnim = 'FF_Melee';

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_beserk";

	return Template;
}


defaultproperties
{
	VampUnitValue="VampAmount"
}

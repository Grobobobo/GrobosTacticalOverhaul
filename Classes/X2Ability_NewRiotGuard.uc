class X2Ability_NewRiotGuard extends X2Ability_WeaponCommon config(GameData_SoldierSkills);

var config int RIOT_GUARD_HP;
// Overwrite the RiotGuard template.
static function X2AbilityTemplate AddNewRiotGuard()
{
	local X2AbilityTemplate				        Template;
	local X2AbilityCost_ActionPoints	        ActionCost;
	local X2AbilityCooldown                     Cooldown;
	local X2Condition_UnitProperty				ShooterCondition;
	local X2Effect_PersistentStatChange			StatChange;
	local X2Effect_EnergyShield					ShieldEffect;

	Template= new(None, string('RiotGuard')) class'X2AbilityTemplate'; Template.SetTemplateName('RiotGuard');;;

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
   Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.TAKEDOWN_PRIORITY+1; // To the right of Shield Bash
	Template.Hostility = eHostility_Defensive;
	Template.IconImage = "img:///UILibrary_Common.Ability_Guard";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	ShooterCondition = new class'X2Condition_UnitProperty';
	ShooterCondition.ExcludeImpaired = true;
	ShooterCondition.ExcludeDead = true;
	ShooterCondition.ExcludePanicked = true;
	ShooterCondition.ExcludeInStasis = true;
	ShooterCondition.ExcludeStunned = true;
	ShooterCondition.ExcludeUnableToAct = true;
	ShooterCondition.ExcludeIncapacitated = true;
	ShooterCondition.ExcludeUnconscious = true;
	Template.AbilityShooterConditions.AddItem(ShooterCondition);

	// +1 Armor
	StatChange = new class'X2Effect_PersistentStatChange';
	StatChange.bRemoveWhenSourceImpaired = true;
	StatChange.bRemoveWhenSourceDies = true;
    StatChange.bRemoveWhenSourceDamaged = false;
	StatChange.DuplicateResponse = eDupe_Allow;
	StatChange.BuildPersistentEffect(1, false, true, false, eWatchRule_UnitTurnBegin);
	StatChange.EffectName = 'BaseGuardStatChange';
	StatChange.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage);
	StatChange.AddPersistentStatChange(eStat_ArmorMitigation, default.BaseGuard_Armor);
	Template.AddTargetEffect(StatChange);

	ShieldEffect = new class'X2Effect_EnergyShield';
	ShieldEffect.BuildPersistentEffect(1, false, true, false, eWatchRule_UnitTurnBegin);
	ShieldEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false, , Template.AbilitySourceName);
	ShieldEffect.AddPersistentStatChange(eStat_ShieldHP, default.RIOT_GUARD_HP);
	ShieldEffect.EffectName='Shieldwall';
	Template.AddShooterEffect(ShieldEffect);


	Template.bSkipFireAction = false;
	Template.bShowActivation = true;
	Template.bSkipExitCoverWhenFiring = true;
	Template.CustomFireAnim = 'FF_Guard';

	Template.ActivationSpeech = 'AbilGuard';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.bDontDisplayInAbilitySummary = false;

	ActionCost = new class'X2AbilityCost_ActionPoints';
	ActionCost.iNumPoints = 1;
	ActionCost.bConsumeAllPoints = false;
   	ActionCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 2;
	Template.AbilityCooldown = Cooldown;

	return Template;
}
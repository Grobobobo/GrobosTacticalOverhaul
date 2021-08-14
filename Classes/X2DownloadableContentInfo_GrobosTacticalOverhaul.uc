//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_GrobosTacticalOverhaul.uc
//           
//	The X2DownloadableContentInfo class provides basic hooks into XCOM gameplay events. 
//  Ex. behavior when the player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_GrobosTacticalOverhaul extends X2DownloadableContentInfo config(GameData_SoldierSkills);

var config array<name> PrimaryWeaponAbilities;
var config array<name> SecondaryWeaponAbilities;

var config int MINDFLAY_COOLDOWN;
var config int GRAZE_BAND_WIDTH;
var config bool GUARANTEED_HIT_ABILITIES_IGNORE_GRAZE_BAND;

var config bool ALLOW_NEGATIVE_DODGE;
var config bool DODGE_CONVERTS_GRAZE_TO_MISS;

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
struct ToHitAdjustments
{
	var int ConditionalCritAdjust;	// reduction in bonus damage chance from it being conditional on hitting
	var int DodgeCritAdjust;		// reduction in bonus damage chance from enemy dodge
	var int DodgeHitAdjust;			// reduction in hit chance from dodge converting graze to miss
	var int FinalCritChance;
	var int FinalSuccessChance;
	var int FinalGrazeChance;
	var int FinalMissChance;
};
static event OnLoadedSavedGame()
{	
}

/// <summary>
/// This method is run when the player loads a saved game directly into Strategy while this DLC is installed
/// </summary>
static event OnLoadedSavedGameToStrategy()
{

}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed. When a new campaign is started the initial state of the world
/// is contained in a strategy start state. Never add additional history frames inside of InstallNewCampaign, add new state objects to the start state
/// or directly modify start state objects
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{
	local XComGameState_StrategyInventory HQInventory;

	// Retrieve the strategy inventory object
	foreach StartState.IterateByClassType(class'XComGameState_StrategyInventory', HQInventory)
	{
		break;
	}

	// Add 3 of each weapon type to player's inventory
	if( HQInventory != none )
	{
		HQInventory.AddItemByName(StartState, 'WPN_XComAR', 1);
		HQInventory.AddItemByName(StartState, 'WPN_XComSMG', 1);
		HQInventory.AddItemByName(StartState, 'WPN_XComShotgun', 1);
	}
}



/// <summary>
/// Called just before the player launches into a tactical a mission while this DLC / Mod is installed.
/// Allows dlcs/mods to modify the start state before launching into the mission
/// </summary>
static event OnPreMission(XComGameState StartGameState, XComGameState_MissionSite MissionState)
{

}

/// <summary>
/// Called when the player completes a mission while this DLC / Mod is installed.
/// </summary>
static event OnPostMission()
{

}

/// <summary>
/// Called when the player is doing a direct tactical->tactical mission transfer. Allows mods to modify the
/// start state of the new transfer mission if needed
/// </summary>
static event ModifyTacticalTransferStartState(XComGameState TransferStartState)
{

}

/// <summary>
/// Called after the player exits the post-mission sequence while this DLC / Mod is installed.
/// </summary>
static event OnExitPostMissionSequence()
{

}

/// <summary>
/// Called after the Templates have been created (but before they are validated) while this DLC / Mod is installed.
/// </summary>
static event OnPostTemplatesCreated()
{
	UpdateAbilities();
	UpdateItems();
	UpdateCharacters();
	UpdateStrategyTemplates();
}

static function UpdateStrategyTemplates()
{
	local X2StrategyElementTemplateManager StrategyManager;
	local X2DioUnitScarTemplate ScarTemplate;
	StrategyManager = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();

	ScarTemplate = X2DioUnitScarTemplate(StrategyManager.FindStrategyElementTemplate('UnitScar_HP'));
	ScarTemplate.StepDelta = 2;

	ScarTemplate = X2DioUnitScarTemplate(StrategyManager.FindStrategyElementTemplate('UnitScar_Offense'));
	ScarTemplate.StepDelta = 15;

	ScarTemplate = X2DioUnitScarTemplate(StrategyManager.FindStrategyElementTemplate('UnitScar_Mobility'));
	ScarTemplate.StepDelta = 2;

	ScarTemplate = X2DioUnitScarTemplate(StrategyManager.FindStrategyElementTemplate('UnitScar_Will'));
	ScarTemplate.StepDelta = 40;

	ScarTemplate = X2DioUnitScarTemplate(StrategyManager.FindStrategyElementTemplate('UnitScar_Dodge'));
	ScarTemplate.StepDelta = 40;
	ScarTemplate.LowerBound = -80;

	ScarTemplate = X2DioUnitScarTemplate(StrategyManager.FindStrategyElementTemplate('UnitScar_CritChance'));
	ScarTemplate.StepDelta = 20;
	ScarTemplate.LowerBound = -80;

	ScarTemplate = X2DioUnitScarTemplate(StrategyManager.FindStrategyElementTemplate('UnitScar_PsiOffense'));
	ScarTemplate.StepDelta = 15;
	ScarTemplate.LowerBound = 0;
	


}
static function UpdateAbilities()
{
	local X2AbilityTemplateManager	          AllAbilities;
	local X2AbilityTemplate                    CurrentAbility, Template;
	local X2Effect_HuntersInstinctDamage_LW		DamageModifier;
	local array<name> nAllAbiltyNames;
	local name TemplateName;
	

	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	// Fix Dark Events
	AllAbilities.AddAbilityTemplate(class'X2Ability_DarkEvents_Fixed'.static.DarkEventAbility_Regeneration(), true);
	// I dont think this is in game but if it is, its now fixed.
	AllAbilities.AddAbilityTemplate(class'X2Ability_DarkEvents_Fixed'.static.DarkEventAbility_LightningReflexes(), true);


	// Cannot use Reload if Panicked, Berserk, Muton Rage or Frenzied
	UpdateReload(AllAbilities);
 
	UpdateSelfDestruct(AllAbilities);
 
	// I dont know why this fixes it, but it fixes it. Bruisers/Guardians/Praetorians lost the ability, now they have it.
	// If i pop a Bruiser in the base game, it does NOT have RiotGuard. If I pop it after i do this, they work. So there.
	AllAbilities.AddAbilityTemplate(class'X2Ability_NewRiotGuard'.static.AddNewRiotGuard(), true);
 
	UpdatePsiReanimation(AllAbilities);
	UpdateCoress(AllAbilities);

	// Prevents multiple uses in same turn.
	CurrentAbility = AllAbilities.FindAbilityTemplate('TargetingSystem');
	CurrentAbility.AbilityCooldown = CreateCooldown(1);
 

	UpdateCCS();
	UpdateCombatProtocol();


	RemoveTheDeathFromHolyWarriorDeath();

	UpdateGunslingerBreach();

	// Prevents them from spaming.
	CurrentAbility = AllAbilities.FindAbilityTemplate('QuickBite');
	CurrentAbility.AbilityCooldown = CreateCooldown(2);
	X2AbilityToHitCalc_StandardMelee(CurrentAbility.AbilityToHitCalc).BuiltInHitMod = 25;
	CurrentAbility.PostActivationEvents.AddItem('PartingSilkActivated');

	UpdateFearlessAdvance();

	UpdateRiotBash();

	//MakeNonTurnEnding(CurrentAbility);
	UpdateHackRobot();
	UpdateKineticArmor();

	UpdateGuard();
	UpdateGeneratorTriggeredTemplate();

	UpdateAdrenalSurge();

	UpdateHailOfBullets();
 
	UpdateAidProtocol();

	UpdateTracerRounds();	

	// Dark Event Flashbang fix
	FixDarkEventFlashbang();
	FixDarkEventPlasmaGrenades();
 
	// Remove HolyWarriorM1 from Sectoid_Paladin
	//RemoveUnitPerk('Sectoid_Paladin', 'HolyWarriorM1');
 
	// Anima Consume enemies only
	AllAbilities.AddAbilityTemplate(class'X2Ability_GatekeeperAnimaFix'.static.NewCreateAnimaConsumeAbility(), true);
 
	// Enemy Bladestorm Overwatch is totally free


	CurrentAbility = AllAbilities.FindAbilityTemplate('BladestormOverwatch');
	MakeFreeAction(CurrentAbility);

	CurrentAbility = AllAbilities.FindAbilityTemplate('MeleeStance');
	MakeFreeAction(CurrentAbility);

 
	// This one fixes most issues.
	DisableMeleeStickyGrenadeOnAbility('StandardMelee');
 
	// Then go through exceptions.
	DisableMeleeStickyGrenadeOnAbility('ChryssalidSlash');
	DisableMeleeStickyGrenadeOnAbility('DevastatingPunch');
	DisableMeleeStickyGrenadeOnAbility('ScythingClaws');   
	DisableMeleeStickyGrenadeOnAbility('BigDamnPunch');
	DisableMeleeStickyGrenadeOnAbility('AnimaConsume');
	DisableMeleeStickyGrenadeOnAbility('FacelessBerserkMelee');
	DisableMeleeStickyGrenadeOnAbility('Bind');
	DisableMeleeStickyGrenadeOnAbility('RendingSlash');
	DisableMeleeStickyGrenadeOnAbility('RootingSlash');
	DisableMeleeStickyGrenadeOnAbility('DisarmingSlash');
	DisableMeleeStickyGrenadeOnAbility('BreakerRageAttack');
  
	// The Chryssalid can no longer target cannisters of explodables, LOL
	CurrentAbility = AllAbilities.FindAbilityTemplate('ChryssalidSlash');
	CurrentAbility.AbilityTargetConditions.AddItem(new class'X2Condition_BerserkerDevastatingPunch'); 
  
	CurrentAbility = AllAbilities.FindAbilityTemplate('TriggerHappy');
	CurrentAbility.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;
	CurrentAbility.bDisplayInUITooltip = true;
	CurrentAbility.bDisplayInUITacticalText = true;

	CurrentAbility = AllAbilities.FindAbilityTemplate('PsiDisable');
	MakeNonTurnEnding(CurrentAbility);

	CurrentAbility = AllAbilities.FindAbilityTemplate('DominatorMindControl');
	MakeFreeAction(CurrentAbility);

	UpdateSubservience(AllAbilities);


	UpdateSubservienceSacrifice(AllAbilities);
	CurrentAbility = AllAbilities.FindAbilityTemplate('Impel');
	MakeNonTurnEnding(CurrentAbility);


	UpdtateSoulSiphon();

	CurrentAbility = AllAbilities.FindAbilityTemplate('PsionicSuplex');
	MakeNonTurnEnding(CurrentAbility);

	CurrentAbility = AllAbilities.FindAbilityTemplate('Tyranny');
	MakeNonTurnEnding(CurrentAbility);

	MakeMeleeBlueMove('ChryssalidSlash');
	MakeMeleeBlueMove('DevastatingBlow');
	MakeMeleeBlueMove('BreakerSmash');
	//MakeMeleeBlueMove('StandardMelee');
	MakeMeleeBlueMove('CripplingBlow');
	MakeMeleeBlueMove('BloodLust');
	MakeMeleeBlueMove('BomberStrike');
	MakeMeleeBlueMove('DisablingSlash');
	MakeMeleeBlueMove('RootingSlash');
	MakeMeleeBlueMove('RendingSlash');
	MakeMeleeBlueMove('DisarmingSlash');
	MakeMeleeBlueMove('TakeDown');
	MakeMeleeBlueMove('HellionTakedown');
	MakeMeleeBlueMove('TriggerSelfDestruct');
	MakeMeleeBlueMove('RiotBash');
	MakeMeleeBlueMove('QuickBite');
	MakeMeleeBlueMove('MeleeStrike');
	//MakeMeleeBlueMove('ChargedBash');

	
	UpdateMotileInducer();
	UpdateMindfire();
	UpdatePsiDomain();

	UpdateSustainEffect();
	CurrentAbility = AllAbilities.FindAbilityTemplate('ChosenSoulStealer');
	CurrentAbility.AdditionalAbilities.AddItem('ChosenSoulstealerPassive');
	
	CurrentAbility = AllAbilities.FindAbilityTemplate('HuntersInstinct');

	CurrentAbility.AbilityTargetEffects.length = 0;
	DamageModifier = new class'X2Effect_HuntersInstinctDamage_LW';
	DamageModifier.BonusDamage = class'X2Ability_RangerAbilitySet'.default.INSTINCT_DMG;
	DamageModifier.BonusCritChance = class'X2Ability_RangerAbilitySet'.default.INSTINCT_CRIT;
	DamageModifier.BuildPersistentEffect(1, true, false, true);
	DamageModifier.SetDisplayInfo(0, CurrentAbility.LocFriendlyName, CurrentAbility.GetMyLongDescription(), CurrentAbility.IconImage, true,, CurrentAbility.AbilitySourceName);
	CurrentAbility.AddTargetEffect(DamageModifier);

	UpdatePsionicBomb();
	
	CurrentAbility = AllAbilities.FindAbilityTemplate('SprayAndPray');
	CurrentAbility.bDisplayInUITooltip = false;
	CurrentAbility.bDisplayInUITacticalText = false;
	CurrentAbility.bDontDisplayInAbilitySummary = true;

	CurrentAbility = AllAbilities.FindAbilityTemplate('BreakerSmash');
    CurrentAbility.AdditionalAbilities.AddItem('BreakerBonus');    

	
	CurrentAbility = AllAbilities.FindAbilityTemplate('ChargedBash');
    CurrentAbility.AdditionalAbilities.AddItem('WardenBonus'); 
	X2AbilityTarget_MovingMelee(CurrentAbility.AbilityTargetStyle).MovementRangeAdjustment=1;

	CurrentAbility = AllAbilities.FindAbilityTemplate('Takedown');
    CurrentAbility.AdditionalAbilities.AddItem('SubdueBonus');

	CurrentAbility = AllAbilities.FindAbilityTemplate('ViciousBite');
	MakeFreeAction(CurrentAbility);
	
	CurrentAbility = AllAbilities.FindAbilityTemplate('DevastatingBlow');
	X2AbilityToHitCalc_StandardMelee(CurrentAbility.AbilityToHitCalc).BuiltInHitMod = 25;

	CurrentAbility = AllAbilities.FindAbilityTemplate('DevastatingPunch');
	X2AbilityToHitCalc_StandardMelee(CurrentAbility.AbilityToHitCalc).BuiltInHitMod = 25;

	
	CurrentAbility = AllAbilities.FindAbilityTemplate('BomberStrike');
	X2AbilityToHitCalc_StandardMelee(CurrentAbility.AbilityToHitCalc).BuiltInHitMod = 25;

	CurrentAbility = AllAbilities.FindAbilityTemplate('MeleeStrike');
	X2AbilityToHitCalc_StandardMelee(CurrentAbility.AbilityToHitCalc).BuiltInHitMod = -10;
	MakeNonTurnEnding(CurrentAbility);
	CurrentAbility = AllAbilities.FindAbilityTemplate('ScatterShot');
	X2AbilityToHitCalc_StandardAim(CurrentAbility.AbilityToHitCalc).bAllowCrit = true;

	UpdateCoolUnderPressure();
	UpdateCrowdControl();
	UpdateReaper();

	CurrentAbility = AllAbilities.FindAbilityTemplate('PistolStandardShot');
	CurrentAbility.AddTargetEffect(class'X2Ability_Chosen'.static.HoloTargetEffect());
	CurrentAbility.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	CurrentAbility.AssociatedPassives.AddItem('HoloTargeting');

	CurrentAbility = AllAbilities.FindAbilityTemplate('DisablingShot');
	CurrentAbility.AddTargetEffect(class'X2Ability_Chosen'.static.HoloTargetEffect());
	CurrentAbility.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	CurrentAbility.AssociatedPassives.AddItem('HoloTargeting');

	CurrentAbility = AllAbilities.FindAbilityTemplate('MindShield');
	CurrentAbility.bDontDisplayInAbilitySummary = false;
	CurrentAbility.bDisplayInUITooltip = true;
	CurrentAbility.bDisplayInUITacticalText = true;

	CurrentAbility = AllAbilities.FindAbilityTemplate('HazmatSealBonus');
	CurrentAbility.bDontDisplayInAbilitySummary = false;
	CurrentAbility.bDisplayInUITooltip = true;
	CurrentAbility.bDisplayInUITacticalText = true;
	
	
	CurrentAbility = AllAbilities.FindAbilityTemplate('PistolOverwatchShot');
	CurrentAbility.AddTargetEffect(class'X2Ability_Chosen'.static.HoloTargetEffect());
	CurrentAbility.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect(true));
	CurrentAbility.AssociatedPassives.AddItem('HoloTargeting');

	CurrentAbility = AllAbilities.FindAbilityTemplate('WardenGuardPassive');
	CurrentAbility.bHideOnClassUnlock=false;

	

	UpdateExtraPadding();
	UpdateMachWeave();
	UpdateInfiltratorWeave();

	ReplaceWithDamageReductionMelee();

	UpdateVentilate();

	UpdateWrithe();
	UpdateMindFlay();

	AllAbilities.GetTemplateNames(nAllAbiltyNames);

	foreach nAllAbiltyNames(TemplateName)
	{
		Template = AllAbilities.FindAbilityTemplate(TemplateName);

		if (ClassIsChildOf(Template.AbilityToHitCalc.Class, class'X2AbilityToHitCalc_StandardAim'))
		{
			Template.AbilityToHitCalc.OverrideFinalHitChanceFns.AddItem(OverrideFinalHitChance);
		}
	}


}

static function UpdateItems()
{
	local X2ItemTemplateManager ItemTemplateManager;
	local X2DataTemplate DataTemplate;
	local X2WeaponTemplate WeaponTemplate;
	local X2WeaponUpgradeTemplate WeaponUpgradeTemplate;
	local X2EquipmentTemplate EquipmentTemplate;
	local X2GrenadeTemplate GrenadeTemplate;
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();


	//GremlinTemplate = X2GremlinTemplate(ItemTemplateManager.FindItemTemplate('WPN_XComOperatorGremlin'));
	//GremlinTemplate.BaseDamage.Spread=1;
	//GremlinTemplate.BaseDamage.Damage=4;


	//ChangeWeaponTable( 'Praetorian_RiotShield_WPN', ENEMY_MELEE_RANGE);
	//ChangeWeaponTable( 'Guardian_RiotShield_WPN', ENEMY_MELEE_RANGE);
	//ChangeWeaponTable( 'Bruiser_RiotShield_WPN', ENEMY_MELEE_RANGE);
 
	ChangeWeaponTable( 'Viper_Tongue_Wpn', class'X2Item_DefaultWeapons'.default.XCOM_MEDIUM_MAGNETIC_RANGE);
	ChangeWeaponTable( 'Praetorian_ShieldPistol_WPN', class'X2Item_DefaultWeapons'.default.XCOM_MEDIUM_MAGNETIC_RANGE);
	ChangeWeaponTable( 'Muton_Legionairre_WPN', class'X2Item_DefaultWeapons'.default.XCOM_SHORT_MAGNETIC_RANGE);
	ChangeWeaponTable( 'Viper_Python_WPN', class'X2Item_DefaultWeapons'.default.XCOM_MEDIUM_MAGNETIC_RANGE);
	ChangeWeaponTable( 'Viper_Adder_WPN', class'X2Item_DefaultWeapons'.default.XCOM_LONG_MAGNETIC_RANGE);
	ChangeWeaponTable( 'Sectoid_Dominator_WPN', class'X2Item_DefaultWeapons'.default.XCOM_MEDIUM_MAGNETIC_RANGE);
	ChangeWeaponTable( 'Sectoid_Paladin_WPN', class'X2Item_DefaultWeapons'.default.XCOM_LONG_MAGNETIC_RANGE);
	ChangeWeaponTable( 'Sectopod_Wpn', class'X2Item_DefaultWeapons'.default.XCOM_LONG_MAGNETIC_RANGE);
	ChangeWeaponTable( 'Guardian_ShieldPistol_WPN', class'X2Item_DefaultWeapons'.default.XCOM_MEDIUM_MAGNETIC_RANGE);
	ChangeWeaponTable( 'Commando_WPN', class'X2Item_DefaultWeapons'.default.XCOM_LONG_MAGNETIC_RANGE);
	ChangeWeaponTable( 'Android_AR', class'X2Item_DefaultWeapons'.default.XCOM_LONG_MAGNETIC_RANGE);
	ChangeWeaponTable( 'Android_SMG', class'X2Item_DefaultWeapons'.default.XCOM_MEDIUM_MAGNETIC_RANGE);
	ChangeWeaponTable( 'Android_Shotgun', class'X2Item_DefaultWeapons'.default.XCOM_SHORT_MAGNETIC_RANGE);
	ChangeWeaponTable( 'AdvMEC_M1_Wpn', class'X2Item_DefaultWeapons'.default.XCOM_LONG_MAGNETIC_RANGE);
	ChangeWeaponTable( 'AdvTurretM1_Wpn', class'X2Item_DefaultWeapons'.default.XCOM_LONG_MAGNETIC_RANGE);
	ChangeWeaponTable( 'Andromedon_Wpn', class'X2Item_DefaultWeapons'.default.XCOM_SHORT_MAGNETIC_RANGE);
	ChangeWeaponTable( 'Gatekeeper_Wpn', class'X2Item_DefaultWeapons'.default.XCOM_LONG_MAGNETIC_RANGE);
	ChangeWeaponTable( 'Sorcerer_WPN', class'X2Item_DefaultWeapons'.default.XCOM_MEDIUM_MAGNETIC_RANGE);
	ChangeWeaponTable( 'Acolyte_WPN', class'X2Item_DefaultWeapons'.default.XCOM_MEDIUM_MAGNETIC_RANGE);
	ChangeWeaponTable( 'Sectoid_Resonant_WPN', class'X2Item_DefaultWeapons'.default.XCOM_MEDIUM_MAGNETIC_RANGE);
	ChangeWeaponTable( 'THRALL_AR', class'X2Item_DefaultWeapons'.default.XCOM_LONG_MAGNETIC_RANGE);
	ChangeWeaponTable( 'THRALL_SMG', class'X2Item_DefaultWeapons'.default.XCOM_MEDIUM_MAGNETIC_RANGE);
	ChangeWeaponTable( 'THRALL_SHOTGUN', class'X2Item_DefaultWeapons'.default.XCOM_SHORT_MAGNETIC_RANGE);
	ChangeWeaponTable( 'Muton_Brute_WPN', class'X2Item_DefaultWeapons'.default.XCOM_SHORT_MAGNETIC_RANGE);
	ChangeWeaponTable( 'Archon_WPN', class'X2Item_DefaultWeapons'.default.XCOM_LONG_MAGNETIC_RANGE);
	ChangeWeaponTable( 'Cyberus_Wpn', class'X2Item_DefaultWeapons'.default.XCOM_LONG_MAGNETIC_RANGE);
	ChangeWeaponTable( 'Bruiser_ShieldPistol_WPN', class'X2Item_DefaultWeapons'.default.XCOM_MEDIUM_MAGNETIC_RANGE);
	ChangeWeaponTable( 'HITMAN_PISTOL', class'X2Item_DefaultWeapons'.default.XCOM_MEDIUM_MAGNETIC_RANGE);
	ChangeWeaponTable( 'COBRA_SMG', class'X2Item_DefaultWeapons'.default.XCOM_MEDIUM_MAGNETIC_RANGE);
	ChangeWeaponTable( 'Liquidator_AR', class'X2Item_DefaultWeapons'.default.XCOM_LONG_MAGNETIC_RANGE);
	ChangeWeaponTable( 'Liquidator_SMG', class'X2Item_DefaultWeapons'.default.XCOM_MEDIUM_MAGNETIC_RANGE);
	ChangeWeaponTable( 'Liquidator_Shotgun', class'X2Item_DefaultWeapons'.default.XCOM_SHORT_MAGNETIC_RANGE);
	ChangeWeaponTable( 'Muton_Bomber_WPN', class'X2Item_DefaultWeapons'.default.XCOM_SHORT_MAGNETIC_RANGE);
	ChangeWeaponTable( 'Sectoid_Necromancer_WPN', class'X2Item_DefaultWeapons'.default.XCOM_MEDIUM_MAGNETIC_RANGE);
	ChangeWeaponTable( 'TutorialTrooper_SMG', class'X2Item_DefaultWeapons'.default.XCOM_MEDIUM_MAGNETIC_RANGE);
	ChangeWeaponTable( 'RootingPoisonGlob', class'X2Item_DefaultWeapons'.default.XCOM_LONG_MAGNETIC_RANGE);
 
	ChangeWeaponTable( 'Inquisitor_Tongue_WPN', class'X2Item_DefaultWeapons'.default.XCOM_MEDIUM_MAGNETIC_RANGE);
	ChangeWeaponTable( 'InquisitorToxicGreetingGlob', class'X2Item_DefaultWeapons'.default.XCOM_LONG_MAGNETIC_RANGE);
 
	ChangeWeaponTable( 'WPN_XComLancerPistol', class'X2Item_DefaultWeapons'.default.XCOM_MEDIUM_MAGNETIC_RANGE);

	foreach ItemTemplateManager.IterateTemplates(DataTemplate)
	{
		WeaponTemplate = X2WeaponTemplate(DataTemplate);
		WeaponUpgradeTemplate = X2WeaponUpgradeTemplate(DataTemplate);
		EquipmentTemplate = X2EquipmentTemplate(DataTemplate);
		GrenadeTemplate = X2GrenadeTemplate(DataTemplate);

		if(WeaponTemplate != none)
		{
			switch(WeaponTemplate.DataName)
			{
				case 'ArchonStaff':
					WeaponTemplate.ExtraDamage = class'X2Item_RebalancedWeapons'.default.ARCHON_MELEEATTACK_EXTRADAMAGE;
					break;
				case 'Archon_Blazing_Pinions_WPN':
					WeaponTemplate.ExtraDamage = class'X2Item_RebalancedWeapons'.default.ARCHON_BLAZINGPINIONS_EXTRADAMAGE;
					break;
				case 'AdvMEC_M1_Shoulder_WPN':
					WeaponTemplate.ExtraDamage = class'X2Item_RebalancedWeapons'.default.ADVMEC_M1_MICROMISSILES_EXTRADAMAGE;
					break;			
				case 'AcidBlob':
					WeaponTemplate.ExtraDamage = class'X2Item_RebalancedWeapons'.default.ANDROMEDON_ACIDBLOB_EXTRADAMAGE;
					break;				
				case 'AndromedonRobot_MeleeAttack':
					WeaponTemplate.ExtraDamage = class'X2Item_RebalancedWeapons'.default.ANDROMEDONROBOT_MELEEATTACK_EXTRADAMAGE;
					break;
				case 'WPN_Muton_Brute_Melee':
					WeaponTemplate.ExtraDamage = class'X2Item_RebalancedWeapons'.default.BRUTE_MELEE_EXTRADAMAGE;
					break;

				case 'WPN_XComAR':
				case 'WPN_EpicAR_1':
				case 'WPN_EpicAR_2':
					WeaponTemplate.bisGenericWeapon=true;
					break;

				//shotgunmob

				case 'WPN_XComShotgun':
				case 'WPN_EpicShotgun_1':
				case 'WPN_EpicShotgun_2':
					WeaponTemplate.bisGenericWeapon=true;
				case 'Muton_Legionairre_WPN':
				case 'Android_Shotgun':
				case 'THRALL_SHOTGUN':
				case 'Muton_Brute_WPN':
				case 'Liquidator_Shotgun':
				case 'Muton_Bomber_WPN':
				case 'BreakerShotgun':
					WeaponTemplate.Abilities.AddItem('Shotgun_StatPenalty');
					WeaponTemplate.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, -1);
					break;

				case 'WPN_XComSMG':
				case 'WPN_EpicSMG_1':
				case 'WPN_EpicSMG_2':
					WeaponTemplate.bisGenericWeapon=true;

				case 'HITMAN_PISTOL':
				case 'Praetorian_ShieldPistol_WPN':
				case 'Viper_Python_WPN':
				case 'Sectoid_Dominator_WPN':
				case 'Guardian_ShieldPistol_WPN':
				case 'Android_SMG':
				case 'Sorcerer_WPN':
				case 'Acolyte_WPN':
				case 'Sectoid_Resonant_WPN':
				case 'THRALL_SMG':
				case 'Bruiser_ShieldPistol_WPN':
				case 'COBRA_SMG':
				case 'Liquidator_SMG':
				case 'Sectoid_Necromancer_WPN':
				case 'TutorialTrooper_SMG':
				case 'WPN_XComPistol':
				case 'WPN_XComGunslingerPistol':
				case 'WPN_XComLancerPistol':
				case 'WPN_XComWardenPistol':
				case 'WPN_EpicPistol_1':
				case 'WPN_EpicPistol_2':			
					WeaponTemplate.Abilities.AddItem('SMG_StatBonus');
					WeaponTemplate.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, 1);
					WeaponTemplate.Abilities.RemoveItem('SprayAndPray');
					break;
				default:
				break;


			}
		}
		if (WeaponUpgradeTemplate != none)
		{
			switch(WeaponUpgradeTemplate.DataName)
			{
				case 'EnhancedARsUpgrade':
				WeaponUpgradeTemplate.BaseDamage = 1;
				WeaponUpgradeTemplate.BonusDamage = class'X2Item_RebalancedWeapons'.default.ENHANCED_AR_BONUS;
				break;

				case 'MastercraftedARsUpgrade':
				WeaponUpgradeTemplate.BaseDamage = 1;
				WeaponUpgradeTemplate.BonusAbilities.RemoveItem('Shredder');
				WeaponUpgradeTemplate.BonusAbilities.AddItem('WeaponUpgradeCritDamageBonus');

				break;

				case 'EnhancedSMGsUpgrade':
				WeaponUpgradeTemplate.BaseDamage = 0;
				WeaponUpgradeTemplate.CritBonus = class'X2Item_RebalancedWeapons'.default.ENHANCED_SMG_CRIT_BONUS;
				WeaponUpgradeTemplate.BonusAbilities.AddItem('WeaponUpgradeCritDamageBonus');
				WeaponUpgradeTemplate.BonusAbilities.AddItem('EnhancedSMGCrit');
				break;

				case 'MastercraftedSMGsUpgrade':
				WeaponUpgradeTemplate.BaseDamage = 1;
				WeaponUpgradeTemplate.BonusAbilities.RemoveItem('Shredder');
				break;

				case 'EnhancedShotgunsUpgrade':
				WeaponUpgradeTemplate.BaseDamage = 1;
				WeaponUpgradeTemplate.BonusAbilities.AddItem('WeaponUpgradeCritDamageBonus');
				break;

				case 'MastercraftedShotgunsUpgrade':
				WeaponUpgradeTemplate.BaseDamage = 1;
				WeaponUpgradeTemplate.BonusAbilities.AddItem('MasterShotgunCrit');
				WeaponUpgradeTemplate.BonusAbilities.RemoveItem('Shredder');
				break;

				case 'EnhancedPistolsUpgrade':
				WeaponUpgradeTemplate.BaseDamage = 0;
				WeaponUpgradeTemplate.BonusAbilities.AddItem('WeaponUpgradeCritDamageBonus');
				WeaponUpgradeTemplate.BonusAbilities.AddItem('EnhancedPistolCrit');
				break;

				case 'MastercraftedPistolsUpgrade':
				WeaponUpgradeTemplate.BaseDamage = 1;
				WeaponUpgradeTemplate.BonusAbilities.RemoveItem('Shredder');
				break;

			}
		}
		if(EquipmentTemplate != none)
		{
			switch(EquipmentTemplate.DataName)
			{
				case 'Hellweave':
					EquipmentTemplate.Abilities.AddItem('ChosenImmuneMelee');
					EquipmentTemplate.Abilities.AddItem('HellWeaveBonus');
					EquipmentTemplate.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, 1);
					break;

				case 'HazmatSealing':
					EquipmentTemplate.Abilities.AddItem('HazmatHPBonus');
					EquipmentTemplate.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, 1);
					break;

				case 'PlatedVest':
					EquipmentTemplate.Abilities.AddItem('PlatedHPBonus');
					EquipmentTemplate.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, 2);
					break;
				
				case 'InfiltratorWeave':
					EquipmentTemplate.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, 2);
					break;
				case 'FluxWeave':
					EquipmentTemplate.SetUIStatMarkup(class'XLocalizedData'.default.AimLabel, eStat_Offense, 5);
					EquipmentTemplate.SetUIStatMarkup(class'XLocalizedData'.default.DefenseLabel, eStat_Defense, 10);
					EquipmentTemplate.SetUIStatMarkup("Flanking Crit Chance", eStat_FlankingCritChance, 15);
					break;
				case 'SustainingSphere':
					EquipmentTemplate.Abilities.AddItem('SustainingShieldBonus');
					break;
				case 'AdrenalWeave':
					EquipmentTemplate.Abilities.AddItem('AdrenalHPBonus');
					EquipmentTemplate.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, 1);
					break;
				case 'MachWeave':
					EquipmentTemplate.Abilities.AddItem('Infighter');
					EquipmentTemplate.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, 1);
					break;
				case 'TracerRounds':
					EquipmentTemplate.SetUIStatMarkup(class'XLocalizedData'.default.AimLabel, eStat_Offense, class'X2Effect_TracerRounds_LW'.default.TRACER_AIM_MOD);
					EquipmentTemplate.SetUIStatMarkup(class'XLocalizedData'.default.CritLabel, eStat_CritChance, class'X2Effect_TracerRounds_LW'.default.TRACER_CRIT_MOD);
					break;

					

				case 'Android_Lidar1':
					EquipmentTemplate.Abilities.RemoveItem('Android_Lidar1_Bonus');
					EquipmentTemplate.Abilities.AddItem('CloseAndPersonal');
					break;
				case 'Android_Lidar2':
				EquipmentTemplate.Abilities.RemoveItem('Android_Lidar2_Bonus');
				EquipmentTemplate.Abilities.AddItem('Executioner_LW');

				break;
				case 'Android_GPU1':
				EquipmentTemplate.Abilities.RemoveItem('Android_GPU1_Bonus');
				EquipmentTemplate.Abilities.AddItem('PackMaster');
				break;
				case 'Android_GPU2':
				EquipmentTemplate.Abilities.RemoveItem('Android_GPU2_Bonus');
				EquipmentTemplate.Abilities.AddItem('ReturnFire');

				break;
				case 'Android_ASIC1':
				EquipmentTemplate.Abilities.RemoveItem('Android_ASIC1_Bonus');
				EquipmentTemplate.Abilities.AddItem('Reposition_LW');
				break;

				case 'Android_ASIC2':
				EquipmentTemplate.Abilities.RemoveItem('Android_ASIC2_Bonus');
				EquipmentTemplate.Abilities.AddItem('CloseEncounters');
				break;
				case 'Android_Lining1':
				EquipmentTemplate.Abilities.RemoveItem('Android_Lining1_Bonus');
				EquipmentTemplate.Abilities.AddItem('WillToSurvive');
				break;
				case 'Android_Lining2':
				//EquipmentTemplate.Abilities.RemoveItem('Android_Lining2_Bonus');
				EquipmentTemplate.Abilities.AddItem('Brawler');
				break;
				case 'Android_Sheathing1':
				EquipmentTemplate.Abilities.RemoveItem('Android_Sheathing1_Bonus_HP');
				EquipmentTemplate.Abilities.RemoveItem('Android_Sheathing1_Bonus_Armor');
				EquipmentTemplate.Abilities.AddItem('DamageControl');
				break;
				case 'Android_Sheathing2':
				EquipmentTemplate.Abilities.RemoveItem('Android_Sheathing2_Bonus_Armor');
				EquipmentTemplate.Abilities.AddItem('ImpactCompensation_LW');
				break;
				case 'Android_Servo1':
				break;
				case 'Android_Servo2':
				EquipmentTemplate.Abilities.RemoveItem('Android_Servo2_Bonus');
				EquipmentTemplate.Abilities.AddItem('Predator_LW');
				break;				
				default:
				break;					

			}


		}
		if(GrenadeTemplate != none)
		{
			switch(GrenadeTemplate.DataName)
			{
				case 'BreachSmokeBomb':
				X2GrenadeTemplate(WeaponTemplate).ThrownGrenadeEffects.length = 0;
				X2GrenadeTemplate(WeaponTemplate).ThrownGrenadeEffects.AddItem(new class'X2Effect_ApplySmokeGrenadeToWorld');
				X2GrenadeTemplate(WeaponTemplate).GameArchetype = "WP_Grenade_Smoke.WP_Grenade_Smoke";
				break;

				case 'BreachCeasefirebomb':
					X2GrenadeTemplate(WeaponTemplate).iRadius = 6;
					X2GrenadeTemplate(WeaponTemplate).iClipSize = 1;
					break;
				case 'CreateBreachFlashbomb':
					X2GrenadeTemplate(WeaponTemplate).iRadius = 6;
					break;
			}
		}	
		
		

	}

}

static function UpdateCharacters()
{

	local X2CharacterTemplateManager	       AllCharacters;
	local X2CharacterTemplate		          CharTemplate;
	local array<name> nAllCharacterNames;
	local X2DataTemplate					              DifficultyTemplate;
	local array<X2DataTemplate>		              DifficultyTemplates;

	local name CurrentName;
 
	AllCharacters = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
 
	AllCharacters.GetTemplateNames(nAllCharacterNames);
 


	foreach nAllCharacterNames ( CurrentName ) {


	   	AllCharacters.FindDataTemplateAllDifficulties(CurrentName, DifficultyTemplates);
		foreach DifficultyTemplates(DifficultyTemplate) {
			CharTemplate = X2CharacterTemplate(DifficultyTemplate);
			CharTemplate.CharacterBaseStats[eStat_FlankingCritChance] = class'X2Item_RebalancedWeapons'.default.FLANKING_CRIT_CHANCE;
		}
		CharTemplate = AllCharacters.FindCharacterTemplate( CurrentName );

	   // EXPLICIT EXCEPTIONS:
	   switch( CurrentName ) {
		  case 'Berserker':
		  case 'Sectopod':
		  case 'AdvTurretM1':
		  case 'AndromedonRobot':
		  case 'PsiZombie':
		  case 'PsiZombieHuman':
		  case 'SpectralZombieM2':
		  case 'ChryssalidCocoon':
		  case 'ChryssalidCocoonHuman':
			 break;
		default:
		CharTemplate.Abilities.RemoveItem('DelayTurn'); // Prevents duplication
		CharTemplate.Abilities.AddItem('DelayTurn');
 
	   }
	   switch( CurrentName ) {
	   		case 'Thrall':
				CharTemplate.Abilities.AddItem('WilltoSurvive');
				CharTemplate.Abilities.AddItem('GrazingFire');
				//CharTemplate.Abilities.AddItem('PinningAttacks');
				break;

			case 'Sorcerer':
				CharTemplate.Abilities.AddItem('SustainingSphereAbility');
	   			break;
			case 'Muton_Brute':
				CharTemplate.Abilities.RemoveItem('CriminalSentinelAbility_StandardShotActivated');
				CharTemplate.Abilities.AddItem('CloseCombatSpecialist');
				break;
			case 'Acolyte':
	   			break;
			case 'Sectoid_Resonant':
				CharTemplate.Abilities.AddItem('TriggerHappy');
				//CharTemplate.Abilities.AddItem('KillZoneOverwatchShot');
				//CharTemplate.Abilities.AddItem('CriminalSentinelAbility_StandardShotActivated');
				//CharTemplate.Abilities.AddItem('OverwatchShot');
	   			break;
			case 'Cyberus':
	   			break;
			case 'Archon':
				CharTemplate.Abilities.AddItem('HazmatSealBonus');
	   			break;
	   		case 'ProgenyLeader':
			   CharTemplate.Abilities.AddItem('SustainingSphereAbility');
			   CharTemplate.Abilities.AddItem('Fortress');
	   			break;
			
			case 'Muton_Legionairre':
				CharTemplate.Abilities.AddItem('Brawler');
	   			break;
	   		case 'Viper_Adder':
				CharTemplate.Abilities.AddItem('SurvivalInstinct_LW');
				CharTemplate.Abilities.AddItem('Whirlwind2');
				CharTemplate.Abilities.AddItem('BendingReed');
	   			break;
			case 'Viper_Python':
				break;

	   		case 'Sectoid_Dominator':
			   CharTemplate.Abilities.AddItem('TacticalSense_LW');
			   break;
	   		case 'Sectoid_Paladin':
			   break;
			case 'Berserker':
				CharTemplate.Abilities.AddItem('Brawler');
				CharTemplate.Abilities.AddItem('ChosenImmuneMelee');
				break;
	   		case 'Faceless':
			case 'Sectopod':
				CharTemplate.Abilities.AddItem('ImpactCompensation_LW');
				break;

			case 'Muton_Praetorian':
				CharTemplate.Abilities.AddItem('LightningReflexes');
				break;
			case 'GP_Leader':
				CharTemplate.Abilities.AddItem('LightningReflexes');
				CharTemplate.Abilities.AddItem('Avenger_LW');
				break;
				
			case 'SC_Leader':
			case 'Ronin':
				CharTemplate.Abilities.AddItem('TacticalSense_LW');
				CharTemplate.Abilities.RemoveItem('DarkEventAbility_LightningReflexes');
				break;
			case 'Purifier':
				CharTemplate.Abilities.AddItem('TakeDown');
				break;
			case 'Guardian':
				CharTemplate.Abilities.AddItem('Resilience');
				break;
			case 'Commando':
			case 'SacredCoilDJ':
				CharTemplate.Abilities.AddItem('SkirmisherStrike');
	   			break;

			case 'Android':
			CharTemplate.Abilities.AddItem('GrazingFire');
	   		break;
			
			case 'AdvTurretM1':
			CharTemplate.Abilities.AddItem('PinningAttacks');

			break;
			case 'AdvMEC_M1':
				CharTemplate.Abilities.AddItem('DamageControl');
				CharTemplate.Abilities.AddItem('Resilience');
			break;
	   		case 'Chryssalid':
			case 'NeonateChryssalid':
			case 'AndromedonRobot':
			case 'Gatekeeper':
	   			break;
			///NICE INTERNAL NAMING SYSTEM FIRAXIS, BRAVOs
			case 'HardlinerLeader':
			case 'Hitman':
			case 'EPICPISTOL2Carrying_Hitman':
				CharTemplate.Abilities.AddItem('HoloTargeting');
				CharTemplate.Abilities.AddItem('TargetingSystemHoloTargeting');

				CharTemplate.Abilities.RemoveItem('Desperado_Hitman');
				CharTemplate.Abilities.AddItem('Desperado');
				break;
			case 'Muton_Bomber':
			case 'EPICSHOTGUN2Carrying_Bomber':
				break;
			case 'Liquidator':
			case 'EPICAR1Carrying_Adder':
			case 'EPICAR2Carrying_Commando':
			case 'EPICSHOTGUN1Carrying_Brute':

			CharTemplate.CharacterGroupName = 'CriminalOutlaw'; // from outlaw
			CharTemplate.Abilities.AddItem('PrimaryReturnFire');
			CharTemplate.Abilities.AddItem('GrazingFire');

				break;
			case 'Viper_Cobra':
			case 'EPICSMG2Carrying_Resonant':
			CharTemplate.Abilities.AddItem('HitAndSlither');
				break;
			case 'Sectoid_Necromancer':
			case 'EPICSMG1Carrying_Dominator':
	   				break;
			case 'Bruiser':
			case 'EPICPISTOL1Carrying_Guardian':
				break;
			case 'ConspiracyLeader':
			CharTemplate.Abilities.AddItem('CloseCombatSpecialist');
			CharTemplate.Abilities.AddItem('ChosenSoulstealer');
			CharTemplate.Abilities.AddItem('Sentinel_LW');
			CharTemplate.Abilities.AddItem('SkirmisherStrike');
			CharTemplate.Abilities.AddItem('TriggerHappy');
			CharTemplate.Abilities.AddItem('PsychoticRage_LW');
			CharTemplate.Abilities.AddItem('WillToSurvive');
				break;

			case 'HybridCivilian':
			case 'HumanCivilian':
			case 'MutonCivilian':
			case 'SectoidCivilian':
			case 'ViperCivilian':
			CharTemplate.CharacterBaseStats[eStat_HP] = 5;
			break;
	   		//I have no idea why that's not the case in vanilla
			case 'XComInquisitor':
			case 'XComBreaker':
			CharTemplate.bIsSoldier = true;
			break;
		   
	  default:
		break;
	 }

	 CharTemplate.Abilities.AddItem('ReactionFireAgainstCoverBonus');
	 CharTemplate.Abilities.AddItem('CoolUnderPressure');
	 //It's better to give it to everyone to account for custom classes
	 //not like AIs will use it
	 CharTemplate.Abilities.AddItem('XComCallForAndroidReinforcements'); 
	 


 
	}
	FixCharRoot('Purifier', "BreachScamperRoot_Generic");
	FixCharRoot('Sectoid_Dominator', "BreachScamperRoot_Sectoid_Dominator");
	FixCharRoot('Gatekeeper', "BreachScamperRoot_Generic");

	
}
/// <summary>
/// Called when the difficulty changes and this DLC is active
/// </summary>
static event OnDifficultyChanged()
{

}

/// <summary>
/// Called by the Geoscape tick
/// </summary>
static event UpdateDLC()
{

}

/// <summary>
/// Called after HeadquartersAlien builds a Facility
/// </summary>
static event OnPostAlienFacilityCreated(XComGameState NewGameState, StateObjectReference MissionRef)
{

}

/// <summary>
/// Called after a new Alien Facility's doom generation display is completed
/// </summary>
static event OnPostFacilityDoomVisualization()
{

}

/// <summary>
/// Called when viewing mission blades, used primarily to modify tactical tags for spawning
/// Returns true when the mission's spawning info needs to be updated
/// </summary>
static function bool ShouldUpdateMissionSpawningInfo(StateObjectReference MissionRef)
{
	return false;
}

/// <summary>
/// Called when viewing mission blades, used primarily to modify tactical tags for spawning
/// Returns true when the mission's spawning info needs to be updated
/// </summary>
static function bool UpdateMissionSpawningInfo(StateObjectReference MissionRef)
{
	return false;
}

/// <summary>
/// Called when viewing mission blades, used to add any additional text to the mission description
/// </summary>
static function string GetAdditionalMissionDesc(StateObjectReference MissionRef)
{
	return "";
}

/// <summary>
/// Called from X2AbilityTag:ExpandHandler after processing the base game tags. Return true (and fill OutString correctly)
/// to indicate the tag has been expanded properly and no further processing is needed.
/// </summary>
static function bool AbilityTagExpandHandler(string InString, out string OutString)
{

	local name Type;

	Type = name(InString);
	switch(Type)
{
	case 'IMPULSE_AIM_BONUS':
		OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.IMPULSE_AIM_BONUS);
		return true;
	case 'IMPULSE_CRIT_BONUS':
		OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.IMPULSE_CRIT_BONUS);
		return true;
	case 'PREDATOR_AIM_BONUS':
		OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.PREDATOR_AIM_BONUS);
		return true;
	case 'PREDATOR_CRIT_BONUS':
		OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.PREDATOR_CRIT_BONUS);
		return true;
	case 'STILETTO_ARMOR_PIERCING':
		OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.STILETTO_ARMOR_PIERCING);
		return true;		
	case 'OVERKILL_DAMAGE':
		OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.OverkillBonusDamage);
		return true;
	case 'INSPIRE_DODGE':
		OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.INSPIRE_DODGE);
		return true;
	case 'BRAWLER_DR_PCT':
		OutString = string(int(class'X2Effect_Brawler'.default.BRAWLER_DR_PCT));
		return true;
	case 'IMPACT_COMPENSATION_PCT_DR':
		Outstring = string(int(class'X2Effect_ImpactCompensation'.default.IMPACT_COMPENSATION_PCT_DR * 100));
		return true;
	case 'WTS_COVER_DR_PCT':
		Outstring = string(int(class'X2Effect_WillToSurvive'.default.WTS_COVER_DR_PCT * 100));
		return true;
	case 'RESILIENCE_BONUS_LW':
		Outstring = string(class'X2Ability_XMBPerkAbilitySet'.default.RESILIENCE_CRITDEF_BONUS);
		return true;
	case 'EXECUTIONER_AIM_BONUS':
		OutString = string(class'X2Effect_Executioner_LW'.default.EXECUTIONER_AIM_BONUS);
		return true;
	case 'EXECUTIONER_CRIT_BONUS':
		OutString = string(class'X2Effect_Executioner_LW'.default.EXECUTIONER_CRIT_BONUS);
		return true;
	case 'INFIGHTER_DODGE_BONUS':
		OutString = string(class'X2Effect_Infighter'.default.INFIGHTER_DODGE_BONUS);
		return true;
		
	default:
	return false;
}
}

/// <summary>
/// Called from XComGameState_Unit:GatherUnitAbilitiesForInit after the game has built what it believes is the full list of
/// abilities for the unit based on character, class, equipment, et cetera. You can add or remove abilities in SetupData.
/// </summary>
static function FinalizeUnitAbilitiesForInit(XComGameState_Unit UnitState, out array<AbilitySetupData> SetupData, optional XComGameState StartState, optional XComGameState_Player PlayerState, optional bool bMultiplayerDisplay)
{
	local XComGameState_MissionSite MissionSite;
	local int Act;
	local X2CharacterTemplate CharTemplate;
	local int i;
	//WHY AREN'T THERE DIFFERENT TEMPLATES FOR DIFFERENT TIER ENEMIES ANYMORE WHAT THE FUCK FIRAXIS REEEEEEEEE
	//Time to do this shit in the most roundabout way possible
	MissionSite = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(`DIOHQ.MissionRef.ObjectID));
	Act = MissionSite.MissionDifficultyParams.Act;

	CharTemplate = UnitState.GetMyTemplate();

	for (i = 0; i < SetupData.Length; i++)
	{
		if (default.PrimaryWeaponAbilities.Find(SetupData[i].TemplateName) != INDEX_NONE && SetupData[i].SourceWeaponRef.ObjectID == 0)
		{
			SetupData[i].SourceWeaponRef = UnitState.GetPrimaryWeapon().GetReference();
		}

		if (default.SecondaryWeaponAbilities.Find(SetupData[i].TemplateName) != INDEX_NONE && SetupData[i].SourceWeaponRef.ObjectID == 0)
		{
			SetupData[i].SourceWeaponRef = UnitState.GetSecondaryWeapon().GetReference();
		}	
	}

	if(Act >= 3)
	{
		GiveEnemiesAct2Perks(UnitState, SetupData, CharTemplate.DataName);
		GiveEnemiesAct3Perks(UnitState, SetupData, CharTemplate.DataName);
	}
	else if (Act == 2)
	{
		GiveEnemiesAct2Perks(UnitState, SetupData, CharTemplate.DataName);
	}


}

static function GiveEnemiesAct3Perks(XComGameState_Unit UnitState, out array<AbilitySetupData> SetupData, name TemplateName)
{
	switch (TemplateName)
	{
		case 'Thrall':
			AddAbilityToSetUpData(SetupData,'Huntersinstinct', UnitState);
			break;
		case 'Sorcerer':
			//AddAbilityToSetUpData(SetupData,'Bastion', UnitState);
			AddAbilityToSetUpData(SetupData,'ChosenSoulStealer', UnitState);
			break;
		case 'Muton_Brute':
			AddAbilityToSetUpData(SetupData,'Resilience', UnitState);

			break;
		case 'Acolyte':
			AddAbilityToSetUpData(SetupData,'ChosenVenomRounds', UnitState);
			break;
		case 'Sectoid_Resonant':
			AddAbilityToSetUpData(SetupData,'Sentinel_LW', UnitState);
			break;
		case 'Cyberus':
			AddAbilityToSetUpData(SetupData,'Evasive', UnitState);
			break;
		case 'Archon':
			AddAbilityToSetUpData(SetupData,'LightningReflexes', UnitState);
			break;
		case 'ProgenyLeader':
			//AddAbilityToSetUpData(SetupData,'Bastion', UnitState);
			AddAbilityToSetUpData(SetupData,'ChosenSoulStealer', UnitState);
			break;
		
		case 'Muton_Legionairre':
			AddAbilityToSetUpData(SetupData,'Resilience', UnitState);
			break;
		case 'Viper_Adder':
			AddAbilityToSetUpData(SetupData,'MindShield', UnitState);
			break;
		case 'Viper_Python':
			AddAbilityToSetUpData(SetupData,'Infighter', UnitState);
			break;

		case 'Sectoid_Dominator':
			break;
		case 'Sectoid_Paladin':
			AddAbilityToSetUpData(SetupData,'Concentration_LW', UnitState);
			break;
		case 'Berserker':
			AddAbilityToSetUpData(SetupData,'PsychoticRage', UnitState);
			break;
		case 'Faceless':
			AddAbilityToSetUpData(SetupData,'Brawler', UnitState);
		break;
		
		case 'Sectopod':
			AddAbilityToSetUpData(SetupData,'PrimaryReturnFire', UnitState);
			break;
		case 'Muton_Praetorian':
			AddAbilityToSetUpData(SetupData,'CloseCombatSpecialist', UnitState);
			break;
		case 'GP_Leader':
			AddAbilityToSetUpData(SetupData,'CloseCombatSpecialist', UnitState);
			break;

		case 'Ronin':
			AddAbilityToSetUpData(SetupData,'Bladestorm', UnitState);
			break;
		case 'Purifier':
			break;
		case 'Guardian':
			break;
		case 'Commando':
		case 'SacredCoilDJ':
			AddAbilityToSetUpData(SetupData,'FreeGrenades', UnitState);
			break;
		case 'AdvTurretM1':
		AddAbilityToSetUpData(SetupData,'DamageControl', UnitState);
		break;
		case 'AdvMEC_M1':
		break;
		case 'Chryssalid':
			break;
		case 'NeonateChryssalid':
			break;
		case 'Andromedon':
			AddAbilityToSetUpData(SetupData,'WillToSurvive', UnitState);
			break;
		case 'AndromedonRobot':
		case 'Gatekeeper':
		
		case 'SC_Leader':
		break;

		case 'HardlinerLeader':
		case 'Hitman':
		case 'EPICPISTOL2Carrying_Hitman':
			AddAbilityToSetUpData(SetupData,'Executioner_LW', UnitState);
			break;
		case 'Muton_Bomber':
		case 'EPICSHOTGUN2Carrying_Bomber':
			AddAbilityToSetUpData(SetupData,'FreeGrenades', UnitState);
			break;
		case 'Liquidator':
		case 'EPICAR1Carrying_Adder':
		case 'EPICAR2Carrying_Commando':
		case 'EPICSHOTGUN1Carrying_Brute':
			AddAbilityToSetUpData(SetupData,'Shredder', UnitState);
			break;
		case 'Viper_Cobra':
		case 'EPICSMG2Carrying_Resonant':
			AddAbilityToSetUpData(SetupData,'Evasive', UnitState);
			break;
		case 'Sectoid_Necromancer':
		case 'EPICSMG1Carrying_Dominator':
			AddAbilityToSetUpData(SetupData,'TacticalSense_LW', UnitState);
			break;
		case 'Bruiser':
		case 'EPICPISTOL1Carrying_Guardian':
			AddAbilityToSetUpData(SetupData,'HazmatSealBonus', UnitState);
			AddAbilityToSetUpData(SetupData,'PinningAttacks', UnitState);
			break;
		case 'ConspiracyLeader':
			break;
	}
}



static function GiveEnemiesAct2Perks(XComGameState_Unit UnitState, out array<AbilitySetupData> SetupData, name TemplateName)
{

	switch(TemplateName)
	{
		case 'Thrall':
			AddAbilityToSetUpData(SetupData,'ChosenRegenerate', UnitState);
			break;
		case 'Sorcerer':
			//AddAbilityToSetUpData(SetupData,'Fortress', UnitState);
			AddAbilityToSetUpData(SetupData,'SurvivalInstinct_LW', UnitState);


			break;
		case 'Muton_Brute':
			AddAbilityToSetUpData(SetupData,'Shredder', UnitState);
			break;
		case 'Acolyte':
			AddAbilityToSetUpData(SetupData,'LightningReflexes', UnitState);
			break;
		case 'Sectoid_Resonant':
			AddAbilityToSetUpData(SetupData,'Vampirism_LW', UnitState);
			break;
		case 'Cyberus':
			AddAbilityToSetUpData(SetupData,'LightningReflexes', UnitState);
			AddAbilityToSetUpData(SetupData,'Predator_LW', UnitState);
			break;
		case 'Archon':
			AddAbilityToSetUpData(SetupData,'Brawler', UnitState);
			break;
		case 'ProgenyLeader':
			AddAbilityToSetUpData(SetupData,'SurvivalInstinct_LW', UnitState);
			break;
		
		case 'Muton_Legionairre':
			AddAbilityToSetUpData(SetupData,'PsychoticRage_LW', UnitState);
			//AddAbilityToSetUpData(SetupData,'Brawler', UnitState);
			break;
		case 'Viper_Adder':	
			AddAbilityToSetUpData(SetupData,'Predator_LW', UnitState);
			AddAbilityToSetUpData(SetupData,'LightningReflexes', UnitState);
			break;
		case 'Viper_Python':
			//AddAbilityToSetUpData(SetupData,'MindShield', UnitState);
			AddAbilityToSetUpData(SetupData,'PackMaster', UnitState);
			break;

		case 'Sectoid_Dominator':
			AddAbilityToSetUpData(SetupData,'LightningReflexes', UnitState);
			break;
		case 'Sectoid_Paladin':
			AddAbilityToSetUpData(SetupData,'TriggerHappy', UnitState);
			break;
		case 'Berserker':
			//AddAbilityToSetUpData(SetupData,'BullRush', UnitState);
			AddAbilityToSetUpData(SetupData,'Resilience', UnitState);
			break;
		case 'Faceless':
			AddAbilityToSetUpData(SetupData,'LightningReflexes', UnitState);
			AddAbilityToSetUpData(SetupData,'PinningAttacks', UnitState);
			break;
		case 'Sectopod':
			break;
		case 'Muton_Praetorian':
			AddAbilityToSetUpData(SetupData,'Shredder', UnitState);
			break;
		case 'GP_Leader':
			AddAbilityToSetUpData(SetupData,'Shredder', UnitState);
			break;

		case 'Ronin':
			break;

		case 'Purifier':
			break;
		case 'Guardian':
			break;
		case 'Commando':
		case 'SacredCoilDJ':
			AddAbilityToSetUpData(SetupData,'Impulse_LW', UnitState);
		case 'AdvTurretM1':
			AddAbilityToSetUpData(SetupData,'Shredder', UnitState);
		break;
		case 'AdvMEC_M1':

		case 'Chryssalid':
		case 'NeonateChryssalid':

		case 'Andromedon':
		AddAbilityToSetUpData(SetupData,'Shredder', UnitState);
		break;
		case 'AndromedonRobot':
		case 'Gatekeeper':
		case 'SC_Leader':

		case 'HardlinerLeader':
		case 'Hitman':
		case 'EPICPISTOL2Carrying_Hitman':
			AddAbilityToSetUpData(SetupData,'ChosenVenomRounds', UnitState);
			break;
		case 'Muton_Bomber':
		case 'EPICSHOTGUN2Carrying_Bomber':
			break;
		case 'Liquidator':
		case 'EPICAR1Carrying_Adder':
		case 'EPICAR2Carrying_Commando':
		case 'EPICSHOTGUN1Carrying_Brute':
			AddAbilityToSetUpData(SetupData,'ChosenDragonRounds', UnitState);
			break;
		case 'Viper_Cobra':
		case 'EPICSMG2Carrying_Resonant':
			AddAbilityToSetUpData(SetupData,'HuntersInstinct', UnitState);
			break;
		case 'Sectoid_Necromancer':
		case 'EPICSMG1Carrying_Dominator':
		AddAbilityToSetUpData(SetupData,'Shredder', UnitState);

			break;
		case 'Bruiser':
		case 'EPICPISTOL1Carrying_Guardian':
			AddAbilityToSetUpData(SetupData,'Resilience', UnitState);
			break;
		case 'ConspiracyLeader':
			break;
	}

}

static function AddAbilityToSetUpData(out array<AbilitySetupData> SetupData, name AbilityName, XComGameState_Unit UnitState)
{

	local array<AbilitySetupData> arrData;
	local array<AbilitySetupData> arrAdditional;
	local X2AbilityTemplate AbilityTemplate;
	local int i;
	local AbilitySetupData Data, EmptyData;
	local X2AbilityTemplateManager AbilityTemplateMan;

	AbilityTemplateMan = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate(AbilityName);
	if (AbilityTemplate != none && !AbilityTemplate.bUniqueSource || arrData.Find('TemplateName', AbilityTemplate.DataName) == INDEX_NONE)
	{
		Data = EmptyData;
		Data.TemplateName = AbilityName;
		Data.Template = AbilityTemplate;
		if (default.PrimaryWeaponAbilities.Find(Data.TemplateName) != INDEX_NONE)
		{
			Data.SourceWeaponRef = UnitState.GetPrimaryWeapon().GetReference();
		}
		if (default.SecondaryWeaponAbilities.Find(Data.TemplateName) != INDEX_NONE)
		{
			Data.SourceWeaponRef = UnitState.GetSecondaryWeapon().GetReference();
		}	
		arrData.AddItem(Data); // array used to check for additional abilities
		SetupData.AddItem(Data);  // return array
	}

	//  Add any additional abilities
	for (i = 0; i < arrData.Length; ++i)
	{
		foreach arrData[i].Template.AdditionalAbilities(AbilityName)
		{
			AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate(AbilityName);
			if (AbilityTemplate != none && !AbilityTemplate.bUniqueSource || arrData.Find('TemplateName', AbilityTemplate.DataName) == INDEX_NONE)
			{
				Data = EmptyData;
				Data.TemplateName = AbilityName;
				Data.Template = AbilityTemplate;
				Data.SourceWeaponRef = arrData[i].SourceWeaponRef;
				arrAdditional.AddItem(Data);
			}			
		}
	}
	//  Move all of the additional abilities into the return list
	for (i = 0; i < arrAdditional.Length; ++i)
	{
		if( SetupData.Find('TemplateName', arrAdditional[i].TemplateName) == INDEX_NONE )
		{
			SetupData.AddItem(arrAdditional[i]);
		}
	}

}

/// <summary>
/// Calls DLC specific popup handlers to route messages to correct display functions
/// </summary>
static function bool DisplayQueuedDynamicPopup(DynamicPropertySet PropertySet)
{

}


static function DisableMeleeStickyGrenadeOnAbility( name AbilityName ) 
{
	local X2AbilityTemplateManager	          AllAbilities;
	local X2AbilityTemplate                    CurrentAbility;
	 local X2Condition_UnitEffects					 EffectCondition;
 
	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
 
	CurrentAbility = AllAbilities.FindAbilityTemplate(AbilityName);
	
	EffectCondition = new class'X2Condition_UnitEffects';
	EffectCondition.AddExcludeEffect(class'X2Effect_HomingMine'.default.EffectName, 'AA_UnitHasHomingMine');
	EffectCondition.AddExcludeEffect('StickyGrenadeRetreat', 'AA_UnitHasHomingMine');
	CurrentAbility.AbilityShooterConditions.AddItem(EffectCondition);

 }
 
static function FixCharRoot( name nUnitName, string sRootName ) 
{
	local X2CharacterTemplateManager	              AllCharacters;
	local X2CharacterTemplate		                 CurrentUnit;
	local X2DataTemplate					              DifficultyTemplate;
	local array<X2DataTemplate>		              DifficultyTemplates;
	
	AllCharacters    = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
 
	CurrentUnit = AllCharacters.FindCharacterTemplate(nUnitName);
 
	if ( CurrentUnit != none ) {
		if ( CurrentUnit.bShouldCreateDifficultyVariants == true ) {
			AllCharacters.FindDataTemplateAllDifficulties(nUnitName, DifficultyTemplates);
			foreach DifficultyTemplates(DifficultyTemplate) {
				CurrentUnit = X2CharacterTemplate(DifficultyTemplate);
			 CurrentUnit.strBreachScamperBT = sRootName;
		  }
		} else {
		  CurrentUnit = X2CharacterTemplate(DifficultyTemplate);
		  CurrentUnit.strBreachScamperBT = sRootName;
	   }
	} else {
	   `log("Change Unit Root: Current Unit is NONE.");
	}
 }
 
static function RemoveUnitPerk( name nUnitName, name nPerkName ) 
{
	local X2CharacterTemplateManager	              AllCharacters;
	local X2CharacterTemplate		                 CurrentUnit;
	local X2DataTemplate					              DifficultyTemplate;
	local array<X2DataTemplate>		              DifficultyTemplates;
	
	AllCharacters    = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
 
	CurrentUnit = AllCharacters.FindCharacterTemplate(nUnitName);
 
	if ( CurrentUnit != none ) {
		if ( CurrentUnit.bShouldCreateDifficultyVariants == true ) {
			AllCharacters.FindDataTemplateAllDifficulties(nUnitName, DifficultyTemplates);
			foreach DifficultyTemplates(DifficultyTemplate) {
				CurrentUnit = X2CharacterTemplate(DifficultyTemplate);
			 CurrentUnit.Abilities.RemoveItem(nPerkName);
		  }
		} else {
		  CurrentUnit.Abilities.RemoveItem(nPerkName);
	   }
	} else {
	   `log("Change Unit Perk: Current Unit is NONE.");
	}
 }
 
static function X2AbilityCooldown CreateCooldown( int iNewCooldown ) 
{
	local X2AbilityCooldown Cooldown;
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = iNewCooldown;
 
	return Cooldown;
 }


static function FixDarkEventFlashbang() 
{
	local X2Effect_Persistent                      CurrentDarkEventEffect;
	local X2AbilityTemplateManager	              AllAbilities;
	local X2AbilityTemplate                        CurrentAbility;
	local X2Effect                                 TempEffect;
 
	AllAbilities     = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
 
	CurrentAbility = AllAbilities.FindAbilityTemplate('DarkEventAbility_Flashbang');
	foreach CurrentAbility.AbilityTargetEffects( TempEffect ) {
	   if ( TempEffect.IsA('X2Effect_Persistent') == true ) {
		  CurrentDarkEventEffect = X2Effect_Persistent(TempEffect);
		  CurrentDarkEventEffect.EffectName = 'DarkEventFlashbangEffect';
	   }
	} 
	`log("Dark Event Flashbang patched to have a proper effect name.");
 }
 
 static function FixDarkEventPlasmaGrenades() {
	local X2Effect_Persistent                      CurrentDarkEventEffect;
	local X2AbilityTemplateManager	              AllAbilities;
	local X2AbilityTemplate                        CurrentAbility;
	local X2Effect                                 TempEffect;
 
	AllAbilities     = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
 
	CurrentAbility = AllAbilities.FindAbilityTemplate('DarkEvent_PlasmaGrenades');
	foreach CurrentAbility.AbilityTargetEffects( TempEffect ) {
	   if ( TempEffect.IsA('X2Effect_Persistent') == true ) {
		  CurrentDarkEventEffect = X2Effect_Persistent(TempEffect);
		  CurrentDarkEventEffect.EffectName = 'DarkEventPlasmaGrenadesEffect';
	   }
	} 
	`log("Dark Event Plasma Grenades patched to have a proper effect name.");
 }

static function MakeFreeAction(X2AbilityTemplate Template)
{
   local X2AbilityCost Cost;
   local X2AbilityCost_ActionPoints ActionCost;

   foreach Template.AbilityCosts(Cost)
   {
	   if(Cost.isA('X2AbilityCost_ActionPoints'))
	   {
		   Template.AbilityCosts.RemoveItem(Cost);
	   }
   }
   
   ActionCost = new class'X2AbilityCost_ActionPoints';
   ActionCost.iNumPoints = 1;
   ActionCost.bConsumeAllPoints = false;
   ActionCost.bFreeCost = true;
   Template.AbilityCosts.AddItem(ActionCost);
}

static function MakeNonTurnEnding(X2AbilityTemplate Template)
{
  local X2AbilityCost Cost;
  local X2AbilityCost_ActionPoints ActionCost;

  foreach Template.AbilityCosts(Cost)
  {
	  if(Cost.isA('X2AbilityCost_ActionPoints'))
	  {
		  Template.AbilityCosts.RemoveItem(Cost);
	  }
  }
  
  ActionCost = new class'X2AbilityCost_ActionPoints';
  ActionCost.iNumPoints = 1;
  ActionCost.bConsumeAllPoints = false;
  Template.AbilityCosts.AddItem(ActionCost);
}

static function RemoveAbilityTargetEffects(X2AbilityTemplate Template, name EffectName)
{
	local int i;
	for (i = Template.AbilityTargetEffects.Length - 1; i >= 0; i--)
	{
		if (Template.AbilityTargetEffects[i].isA(EffectName))
		{
			Template.AbilityTargetEffects.Remove(i, 1);
		}
	}
}
static function RemoveAbilityShooterEffects(X2AbilityTemplate Template, name EffectName)
{
	local int i;
	for (i = Template.AbilityShooterEffects.Length - 1; i >= 0; i--)
	{
		if (Template.AbilityShooterEffects[i].isA(EffectName))
		{
			Template.AbilityShooterEffects.Remove(i, 1);
		}
	}
}
static function RemoveAbilityTargetConditions(X2AbilityTemplate Template, name EffectName)
{
	local int i;
	for (i = Template.AbilityTargetConditions.Length - 1; i >= 0; i--)
	{
		if (Template.AbilityTargetConditions[i].isA(EffectName))
		{
			Template.AbilityTargetConditions.Remove(i, 1);
		}
	}
}
static function UpdatePsiReanimation(X2AbilityTemplateManager AllAbilities)
 {
	local X2AbilityTemplate                    CurrentAbility;

	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	CurrentAbility = AllAbilities.FindAbilityTemplate('PsiReanimation');
	MakeFreeAction(CurrentAbility);
	
 }

static function UpdateReload(X2AbilityTemplateManager AllAbilities)
 {
	local X2AbilityTemplate	CurrentAbility;
	local X2Condition_UnitEffects	UnitConditionEffects;

	CurrentAbility = AllAbilities.FindAbilityTemplate('Reload');
	UnitConditionEffects = new class'X2Condition_UnitEffects';
	UnitConditionEffects.AddExcludeEffect(class'X2AbilityTemplateManager'.default.BerserkName, 'AA_UnitRageTriggered');
	UnitConditionEffects.AddExcludeEffect(class'X2AbilityTemplateManager'.default.PanickedName, 'AA_UnitIsPanicked');
	UnitConditionEffects.AddExcludeEffect(class'X2AbilityTemplateMAnager'.default.MutonRageBerserkName, 'AA_UnitRageTriggered');
	UnitConditionEffects.AddExcludeEffect('FrenzyEffect', 'AA_UnitIsFrenzied');
	CurrentAbility.AbilityShooterConditions.AddItem(UnitConditionEffects);
 }

static function UpdateSelfDestruct(X2AbilityTemplateManager AllAbilities)
{
   local X2AbilityTemplate	Template;
   local X2Condition_UnitProperty	UnitPropertyCondition;
	local X2Effect_PersistentStatChange PersistentStatChangeEffect;
   Template = AllAbilities.FindAbilityTemplate('EngageSelfDestruct');
   UnitPropertyCondition = new class'X2Condition_UnitProperty';
   UnitPropertyCondition.ExcludeFriendlyToSource = false;
   UnitPropertyCondition.ExcludeFullHealth = true;
   UnitPropertyCondition.FailOnNonUnits = true;
   Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

   PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
   PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
   PersistentStatChangeEffect.EffectName = 'AndroidSelfDestructArmor';
   PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorMitigation, 2);
   PersistentStatChangeEffect.AddPersistentStatChange(eStat_Offense, 15);
   PersistentStatChangeEffect.AddPersistentStatChange(eStat_CritChance, 15);
   PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, 2);

   Template.AddTargetEffect(PersistentStatChangeEffect);

   MakeFreeAction(Template);

}

static function UpdateCoress(X2AbilityTemplateManager AllAbilities)
{
	local X2AbilityTemplate	CurrentAbility;

	CurrentAbility = AllAbilities.FindAbilityTemplate('CorressM2');
	MakeFreeAction(CurrentAbility);
}

static function UpdateSubservience(X2AbilityTemplateManager AllAbilities)
{
	local X2AbilityTemplate                    Template;
	local X2Effect_Subservience_LW ServeEffect;
	local X2Condition_UnitEffects SubServienceCondition;

	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	Template = AllAbilities.FindAbilityTemplate('Subservience');
	RemoveAbilityTargetEffects(Template,'X2Effect_Subservience');


	SubServienceCondition = new class'X2Condition_UnitEffects';
	SubServienceCondition.AddExcludeEffect('SubservienceEffect', 'AA_AbilityUnavailable');
	Template.AbilityTargetConditions.AddItem(SubServienceCondition);

	ServeEffect = new class'X2Effect_Subservience_LW';
	ServeEffect.bRemoveWhenSourceDies = true;
	ServeEffect.bRemoveWhenSourceUnconscious = true;
	ServeEffect.bRemoveWhenTargetDies = true;
	ServeEffect.bRemoveWhenTargetUnconscious = true;
	ServeEffect.BuildPersistentEffect(1, true, true, false, eWatchRule_UnitTurnBegin); //permanent
	ServeEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, class'X2Ability_Progeny'.default.SubservienceBuffEffectDescription, Template.IconImage);
	Template.AddTargetEffect(ServeEffect);
}

static function UpdateSubservienceSacrifice(X2AbilityTemplateManager AllAbilities)
{
	local X2AbilityTemplate                    Template;
	local X2Effect_Stunned StunnedEffect;
	//local X2Effect_SubServienceDamage FlayDamageEffect;
	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	Template = AllAbilities.FindAbilityTemplate('SubservienceSacrifice');

	RemoveAbilityTargetEffects(Template,'X2Effect_ApplyWeaponDamage');

	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(1, 100);
	StunnedEffect.BuildPersistentEffect(1, false, true, false, eWatchRule_RoomCleared);
	//StunnedEffect.TargetConditions.AddItem(UnitEffectsCondition);
	StunnedEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(StunnedEffect);

	//FlayDamageEffect = new class'X2Effect_SubServienceDamage';
	//FlayDamageEffect.EffectDamageValue.DamageType = 'Psi';
	//FlayDamageEffect.bIgnoreArmor = true;
	//FlayDamageEffect.bIgnoreBaseDamage = true;
	//Template.AddTargetEffect(FlayDamageEffect);
}

static function RemoveTheDeathFromHolyWarriorDeath()
{
	local X2AbilityTemplate                    Template;
	local X2AbilityTemplateManager 				AllAbilities;
	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	Template = AllAbilities.FindAbilityTemplate('HolyWarriorDeath');

	RemoveAbilityMultiTargetEffects(Template, 'X2Effect_HolyWarriorDeath');
}


static function MakeMeleeBlueMove(name TemplateName)
{
	local X2AbilityTemplate                    Template;
	local X2AbilityTemplateManager 				AllAbilities;
	local X2AbilityTarget_MovingMelee			MeleeTarget;
	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	Template = AllAbilities.FindAbilityTemplate(TemplateName);

	MeleeTarget = new class'X2AbilityTarget_MovingMelee';
	MeleeTarget.MovementRangeAdjustment = 1;
	Template.AbilityTargetStyle = MeleeTarget;
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';
}

static function UpdateMindfire()
{
	local X2AbilityTemplate                    Template;
	local X2AbilityTemplateManager 				AllAbilities;
	local X2Effect_PersistentStatChange StatChange;
	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	Template = AllAbilities.FindAbilityTemplate('MindFire');

	StatChange = new class'X2Effect_PersistentStatChange';
	StatChange.EffectName = 'MindFire';
	StatChange.AddPersistentStatChange(eStat_Offense, -25);
	StatChange.AddPersistentStatChange(eStat_Mobility, -6);

	
	// Prevent the effect from applying to a unit more than once
	StatChange.DuplicateResponse = eDupe_Ignore;

	// The effect lasts until the beginning of the player's next turn
	StatChange.BuildPersistentEffect(2, false, true, false, eWatchRule_UnitTurnBegin);
	StatChange.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddTargetEffect(StatChange);

	MakeNonTurnEnding(Template);
}

static function UpdateMotileInducer()
{
	local X2AbilityTemplate                    Template;
	local X2AbilityTemplateManager 				AllAbilities;
	local X2Effect_GrantActionPoints GrantActionPointsEffect;

		AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
		Template = AllAbilities.FindAbilityTemplate('AidBeaconAbility');

		RemoveAbilityTargetEffects(Template,'X2Effect_GrantActionPoints');

		GrantActionPointsEffect = new class 'X2Effect_GrantActionPoints';
		GrantActionPointsEffect.NumActionPoints = 1;
		GrantActionPointsEffect.PointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;
		GrantActionPointsEffect.bSelectUnit = true;
		Template.AddTargetEffect(GrantActionPointsEffect);
}


static function RemoveAbilityMultiTargetEffects(X2AbilityTemplate Template, name EffectName)
{
	local int i;
	for (i = Template.AbilityMultiTargetEffects.Length - 1; i >= 0; i--)
	{
		if (Template.AbilityMultiTargetEffects[i].isA(EffectName))
		{
			Template.AbilityMultiTargetEffects.Remove(i, 1);
		}
	}
}
static function UpdatePsiDomain()
{
	local X2AbilityTemplate                    Template;
	local X2AbilityTemplateManager 				AllAbilities;
	local X2Effect_PsiDomainDamage_LW DamageEffect;
	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	Template = AllAbilities.FindAbilityTemplate('PsiDomain');

	RemoveAbilityMultiTargetEffects(Template,'X2Effect_PsiDomainDamage');

	DamageEffect = new class'X2Effect_PsiDomainDamage_LW';
	DamageEffect.EffectName = 'PsiDomainDamage';
	DamageEffect.BuildPersistentEffect(1, false, true, false, eWatchRule_RoomCleared);
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true, , Template.AbilitySourceName);
	DamageEffect.bDisplayInSpecialDamageMessageUI = true;
	Template.AddMultiTargetEffect(DamageEffect);

	MakeNonTurnEnding(Template);
}

static function UpdatePsionicBomb()
{
	local X2AbilityTemplate                    Template;
	local X2AbilityTemplateManager 				AllAbilities;
	local X2Effect Effect;
	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	Template = AllAbilities.FindAbilityTemplate('PsiBombStage2');

	foreach Template.AbilityTargetEffects(Effect)
	{
		if(Effect.IsA('X2Effect_ApplyWeaponDamage'))
		{
			X2Effect_ApplyWeaponDamage(Effect).Act2DamageBonus=class'X2Item_RebalancedWeapons'.default.PSI_BOMB_ACT2_DAMAGE_BONUS;
			X2Effect_ApplyWeaponDamage(Effect).Act3DamageBonus=class'X2Item_RebalancedWeapons'.default.PSI_BOMB_ACT3_DAMAGE_BONUS;
		}

	}
}



static function int ChangeWeaponTable( name nWeaponName, array<int> tTableArray) {
	local X2ItemTemplateManager			AllItems;
	local X2DataTemplate					DifficultyTemplate;
	local array<X2DataTemplate>			DifficultyTemplates;
	local X2WeaponTemplate               CurrentWeapon;
 
	AllItems = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	 
	CurrentWeapon = X2WeaponTemplate(AllItems.FindItemTemplate(nWeaponName));
 
	//`log("Processing Weapon: " $ nWeaponName,,'NWRT');
 
	if ( CurrentWeapon == none ) {
	   return -1;
	}
 
	if ( CurrentWeapon.IsA('X2WeaponTemplate') == false ) {
	   return -1;
	}
 
	if ( CurrentWeapon.bShouldCreateDifficultyVariants == true ) 
	{
	   AllItems.FindDataTemplateAllDifficulties(nWeaponName, DifficultyTemplates);
	   foreach DifficultyTemplates(DifficultyTemplate) 
		{
		  	CurrentWeapon = X2WeaponTemplate(DifficultyTemplate);
			CurrentWeapon.RangeAccuracy = tTableArray;
	   	}
	} 
	else 
	{
	  CurrentWeapon.RangeAccuracy = tTableArray;
	}
 
	return 1;
 }


static function UpdateCrowdControl()
{
	local X2AbilityTemplate                    Template;
	local X2AbilityTemplateManager 				AllAbilities;
	local X2Effect Effect;
	local X2Condition_AbilityProperty AbilityCondition;
	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	Template = AllAbilities.FindAbilityTemplate('CrowdControl');


	foreach Template.AbilityMultiTargetEffects(Effect)
	{
		if(Effect.IsA('X2Effect_Rooted')|| Effect.IsA('X2Effect_DisableWeapon') || Effect.IsA('X2Effect_PersistentStatChange') )
		{
			AbilityCondition = new class'X2Condition_AbilityProperty';
			
				
			AbilityCondition.OwnerHasSoldierAbilities.AddItem('ClassTrainingAbility_Hellion');
			if(Effect.IsA('X2Effect_DisableWeapon'))
			{
				X2Effect_DisableWeapon(Effect).bFailSilently=true;
			}
			
			Effect.TargetConditions.AddItem(AbilityCondition);		
		}
	}
}

static function UpdateHailOfBullets()
{
	local X2AbilityTemplate                    Template;
	local X2AbilityTemplateManager 				AllAbilities;
	local X2AbilityCharges Charges;
	local X2AbilityCost_Charges Chargecost;
	local X2AbilityToHitCalc_StandardAim ToHitCalc;
	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	Template = AllAbilities.FindAbilityTemplate('HailOfBullets');

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.bGuaranteedHit = true;
	ToHitCalc.bAllowCrit = true;
	ToHitCalc.bHitsAreCrits = true;
	ToHitCalc.BuiltInCritMod = 150;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	
	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = 1;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);
}

static function UpdateGunslingerBreach()
{
	local X2AbilityTemplate                    Template;
	local X2AbilityTemplateManager 				AllAbilities;
	local X2AbilityToHitCalc_StandardAim ToHitCalc;
	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	Template = AllAbilities.FindAbilityTemplate('BreachGunslingerAbility');

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.bAllowCrit = true;
	ToHitCalc.bHitsAreCrits = true;
	ToHitCalc.BuiltInHitMod = -15;
	ToHitCalc.BuiltInCritMod = 150;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

}



static function UpdateKineticArmor()
{
	local X2AbilityTemplate                    Template;
	local X2AbilityTemplateManager 				AllAbilities;
	local X2Effect_ModifyTemplarFocus FocusEffect;
	local X2Condition_UnitEffectsOnSource SourceHasResonanceFieldCondition, SourceMissingResonanceFieldCondition;
	local X2Effect_KineticShield_LW	KineticShieldEffect, ResonanceFieldEffect;

	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	Template = AllAbilities.FindAbilityTemplate('KineticArmor');


	RemoveAbilityTargetEffects(Template,'X2Effect_KineticShield');

	KineticShieldEffect = new class'X2Effect_KineticShield_LW';
	KineticShieldEffect.BuildPersistentEffect(1, false, false, false, eWatchRule_RoomCleared);
	KineticShieldEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, class'X2Ability_Warden'.default.str_KineticArmorTargetDesc, Template.IconImage, true, , Template.AbilitySourceName);
	KineticShieldEffect.bDisplayInSpecialDamageMessageUI = true;
	KineticShieldEffect.bRemoveWhenTargetDies = true;
	KineticShieldEffect.bRemoveWhenTargetUnconscious = true;
	SourceMissingResonanceFieldCondition = new class'X2Condition_UnitEffectsOnSource';
	SourceMissingResonanceFieldCondition.AddExcludeEffect('ResonanceField', 'AA_MissingRequiredEffect');
	KineticShieldEffect.TargetConditions.AddItem(SourceMissingResonanceFieldCondition);
	Template.AddTargetEffect(KineticShieldEffect);

	// Apply the Kinetic armor effect WITH aim bonus to the target
	ResonanceFieldEffect = new class'X2Effect_KineticShield_LW';
	ResonanceFieldEffect.EffectName = class'X2Effect_KineticShield'.default.ResonanceEffectName;
	ResonanceFieldEffect.BuildPersistentEffect(1, false, false, false, eWatchRule_RoomCleared);
	ResonanceFieldEffect.AddPersistentStatChange(eStat_Offense, class'X2Ability_Warden'.default.RESONANCEFIELD_AIMBONUS);
	ResonanceFieldEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, class'X2Ability_Warden'.default.str_ResonanceFieldTargetDesc, Template.IconImage, true, , Template.AbilitySourceName);
	ResonanceFieldEffect.bDisplayInSpecialDamageMessageUI = true;
	SourceHasResonanceFieldCondition = new class'X2Condition_UnitEffectsOnSource';
	SourceHasResonanceFieldCondition.AddRequireEffect('ResonanceField', 'AA_MissingRequiredEffect');
	ResonanceFieldEffect.TargetConditions.AddItem(SourceHasResonanceFieldCondition);
	Template.AddTargetEffect(ResonanceFieldEffect);

	FocusEffect = new class'X2Effect_ModifyTemplarFocus';
	FocusEffect.ModifyFocus = 1;
	Template.AddShooterEffect(FocusEffect);
	
	Template.AbilityCooldown = CreateCooldown(2);
}

static function UpdateGuard()
{
	local X2AbilityTemplate                    Template;
	local X2AbilityTemplateManager 				AllAbilities;
	local X2Effect_Resilience MyCritModifier;
	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	Template = AllAbilities.FindAbilityTemplate('RiotAutoGuard');

	MyCritModifier = new class 'X2Effect_Resilience';
	MyCritModifier.CritDef_Bonus = 50;
	MyCritModifier.BuildPersistentEffect(1, false, true, false, eWatchRule_UnitTurnBegin);
	MyCritModifier.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false, , Template.AbilitySourceName);
	MyCritModifier.EffectName='Shieldwall';
	Template.AddShooterEffect(MyCritModifier);

}

static function UpdateAdrenalSurge()
{
	local X2AbilityTemplate                    Template;
	local X2AbilityTemplateManager 				AllAbilities;
	local X2Effect_SetTemplarFocus FocusEffect;
	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	Template = AllAbilities.FindAbilityTemplate('Adrenalsurge');


	FocusEffect = new class'X2Effect_SetTemplarFocus';
	FocusEffect.SetFocus = 5;

	Template.AddShooterEffect(FocusEffect);

}


	

static function UpdateAidProtocol()
{
	local X2AbilityTemplate                    Template;
	local X2AbilityTemplateManager 				AllAbilities;
	local X2Effect_GrantActionPoints GrantActionPointsEffect;
	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	Template = AllAbilities.FindAbilityTemplate('AidProtocol');
	Template.AbilityCooldown = CreateCooldown(2);

	GrantActionPointsEffect = new class 'X2Effect_GrantActionPoints';
	GrantActionPointsEffect.NumActionPoints = 1;
	GrantActionPointsEffect.PointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;
	GrantActionPointsEffect.bSelectUnit = true;
	Template.AddTargetEffect(GrantActionPointsEffect);
}

static function UpdateGeneratorTriggeredTemplate()
{
	local X2AbilityTemplateManager 			AbilityTemplateManager;
	local X2AbilityTemplate 				AbilityTemplate;
	local X2AbilityTrigger_EventListener	Trigger;
	local array<name>						SkipExclusions;

	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate('GeneratorTriggered');

	AbilityTemplate.AbilityTriggers.Length = 0;

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'UnitTurnEnded';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Trigger.ListenerData.Priority = 75;
	AbilityTemplate.AbilityTriggers.AddItem(Trigger);

	//AbilityTemplate.AbilityShooterConditions.AddItem(class'X2Ability'.default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.ConfusedName);
	AbilityTemplate.AddShooterEffectExclusions(SkipExclusions);
}

static function UpdateCoolUnderPressure()
{
	local X2AbilityTemplate                    Template;
	local X2AbilityTemplateManager 				AllAbilities;
	local X2Effect Effect;
	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	Template = AllAbilities.FindAbilityTemplate('CoolUnderPressure');
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;

	foreach Template.AbilityTargetEffects(Effect)
		{
			if(Effect.IsA('X2Effect_ModifyReactionFire'))
			{
				X2Effect_ModifyReactionFire(Effect).SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,false,,Template.AbilitySourceName);
			}

		}

}

static function UpdateExtraPadding()
{
	local X2AbilityTemplate                    Template;
	local X2AbilityTemplateManager 				AllAbilities;
	local X2Effect_Resilience CritDefEffect;
	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	Template = AllAbilities.FindAbilityTemplate('ExtraPaddingBonus');
	CritDefEffect = new class'X2Effect_Resilience';
	CritDefEffect.CritDef_Bonus = 25;
	CritDefEffect.BuildPersistentEffect (1, true, false, false);
	Template.AddTargetEffect(CritDefEffect);

}


static function ReplaceWithDamageReductionMelee()
{
	local X2Effect_DefendingMeleeDamageModifier DamageMod;
	local X2AbilityTemplate                    Template;
	local X2AbilityTemplateManager 				AllAbilities;
	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	Template = AllAbilities.FindAbilityTemplate('ChosenImmuneMelee');

	RemoveAbilityTargetEffects(Template,'X2Effect_DamageImmunity');

	DamageMod = new class'X2Effect_DefendingMeleeDamageModifier';
	DamageMod.DamageMod = 0.5f;
	DamageMod.BuildPersistentEffect(1, true, false, true);
	DamageMod.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
	Template.AddTargetEffect(DamageMod);
}

static function UpdateMachWeave()
{
	local X2AbilityTemplate                    Template;
	local X2AbilityTemplateManager 				AllAbilities;
	local X2Effect_PersistentStatChange	PersistentStatChangeEffect;
	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	Template = AllAbilities.FindAbilityTemplate('MachWeaveBonus');


	RemoveAbilityTargetEffects(Template,'X2Effect_PersistentStatChange' );

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false, , Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, 1);
	Template.AddTargetEffect(PersistentStatChangeEffect);
}


static function UpdateInfiltratorWeave()
{
	local X2AbilityTemplate                    Template;
	local X2AbilityTemplateManager 				AllAbilities;
	local X2Effect_PersistentStatChange PersistentStatChangeEffect;
	local X2Effect_DamageImmunity DamageImmunity;
	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();


	Template = AllAbilities.FindAbilityTemplate('InfiltratorWeaveAbility');
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.EffectName = 'InfiltratorMobilityBonus';
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, 2);

	Template.AddTargetEffect(PersistentStatChangeEffect);

	DamageImmunity = new class'X2Effect_DamageImmunity';
	DamageImmunity.ImmuneTypes.AddItem('Root');
	DamageImmunity.BuildPersistentEffect(1, true, false, false);
	Template.AddTargetEffect(DamageImmunity);

}

static function UpdateVentilate()
{
	local X2AbilityTemplate                    Template;
	local X2AbilityTemplateManager 				AllAbilities;
	local X2Condition_UnitProperty				UnitCondition;
	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	Template = AllAbilities.FindAbilityTemplate('Ventilate');
	UnitCondition = new class 'X2Condition_UnitProperty';
	UnitCondition.ExcludeStunned          = false;
	UnitCondition.ExcludeFriendlyToSource = true;
	UnitCondition.ExcludePanicked         = false;
	UnitCondition.ExcludeInStasis         = true;
	UnitCondition.ExcludeTurret           = false;
	UnitCondition.ExcludeDazed            = false;
	UnitCondition.ExcludeRobotic          = false;
	UnitCondition.ExcludeDead             = true;
	UnitCondition.ExcludeHostileToSource  = false;
	UnitCondition.RequireSquadmates       = false;
	UnitCondition.FailOnNonUnits          = true;   
	UnitCondition.RequireWithinRange      = true;
	UnitCondition.WithinRange             = 768; // 8 tiles (96*8)
	Template.AbilityTargetConditions.AddItem(UnitCondition);

}


static function UpdateHackRobot()
{
	local X2AbilityTemplate                    Template;
	local X2AbilityTemplateManager 				AllAbilities;
	local X2Effect_Stunned	StunEffect;
	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	Template = AllAbilities.FindAbilityTemplate('HackRobot');

	RemoveAbilityTargetEffects(Template, 'X2Effect_MindControl');
	RemoveAbilityTargetEffects(Template, 'X2Effect_RemoveEffects');


	StunEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, 100, false);
	StunEffect.SetDisplayInfo(ePerkBuff_Penalty, class'X2StatusEffects'.default.RoboticStunnedFriendlyName, class'X2StatusEffects'.default.RoboticStunnedFriendlyDesc, "img:///UILibrary_PerkIcons.UIPerk_stun");

	Template.AddTargetEffect(StunEffect);
}

static function UpdateReaper()
{
	local X2AbilityTemplate                    Template;
	local X2AbilityTemplateManager 				AllAbilities;
	local X2Effect_Reaper_LW	ReaperEffect;
	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	Template = AllAbilities.FindAbilityTemplate('Reaper');

	RemoveAbilityTargetEffects(Template, 'X2Effect_Reaper');

	ReaperEffect = new class'X2Effect_Reaper_LW';
	ReaperEffect.BuildPersistentEffect(1, false, true, false, eWatchRule_AnyTurnEnd);
	ReaperEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Template.AddTargetEffect(ReaperEffect);

}

static function UpdateTracerRounds()
{
	local X2AbilityTemplate                    Template;
	local X2AbilityTemplateManager 				AllAbilities;
	local X2Effect_TracerRounds_LW	Effect;
	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	Template = AllAbilities.FindAbilityTemplate('TracerRounds');

	RemoveAbilityShooterEffects(Template, 'X2Effect_TracerRounds');

	Effect = new class'X2Effect_TracerRounds_LW';
	Effect.BuildPersistentEffect(1, true, false, false);
	Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
	Template.AddShooterEffect(Effect);

}

static function UpdateSustainEffect()
{
	local X2Effect_SustainingSphere_LW SustainEffect;
	local X2AbilityTemplate                    Template;
	local X2AbilityTemplateManager 				AllAbilities;
	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	Template = AllAbilities.FindAbilityTemplate('SustainingSphereAbility');

	RemoveAbilityTargetEffects(Template,'X2Effect_SustainingSphere');

	SustainEffect = new class'X2Effect_SustainingSphere_LW';
	SustainEffect.BuildPersistentEffect(1, true, true);
	SustainEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddTargetEffect(SustainEffect);
}

static function UpdateWrithe()
{
	local X2Effect_ApplyMedikitHeal_LW MedikitHeal;
	local X2AbilityTemplate                    Template;
	local X2AbilityTemplateManager 				AllAbilities;
	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	Template = AllAbilities.FindAbilityTemplate('Writhe');

	RemoveAbilityShooterEffects(Template,'X2Effect_ApplyMedikitHeal');

	MedikitHeal = new class'X2Effect_ApplyMedikitHeal_LW';
	MedikitHeal.PerUseHP = class'X2Ability_Progeny'.default.WRITHE_SHOOTER_HEALHP;
	MedikitHeal.Act2PerUseHPBonus = 2;
	MedikitHeal.Act3PerUseHPBonus = 4;
	Template.AddShooterEffect(MedikitHeal);	
}
	
static function UpdateRiotBash()
{
	local X2AbilityTemplate                    Template;
	local X2AbilityTemplateManager 				AllAbilities;
	local X2Effect TargetEffect;
	local X2Effect_ApplyWeaponDamage DamageEffect;

	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	Template = AllAbilities.FindAbilityTemplate('RiotBash');

	MakeNonTurnEnding(Template);
	Template.AbilityCooldown = CreateCooldown(3);
	foreach Template.AbilityTargetEffects(TargetEffect)
	{
		DamageEffect = X2Effect_ApplyWeaponDamage(TargetEffect);
		if (DamageEffect != None)
		{
			DamageEffect.EffectDamageValue.Pierce = 0;
			DamageEffect.EffectDamageValue.Damage = 2;

			DamageEffect.Act2DamageBonus = 1;
			DamageEffect.Act2DamageBonus = 2;
			
		}
	}

}

static function UpdateCombatProtocol()
{
	local X2AbilityTemplate                    Template;
	local X2AbilityTemplateManager 				AllAbilities;
	local X2Effect Effect;
	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	Template = AllAbilities.FindAbilityTemplate('CombatProtocol');
	MakeNonTurnEnding(Template);
	foreach Template.AbilityTargetEffects(Effect)
	{
		if(Effect.IsA('X2Effect_Stunned'))
		{
			X2Effect_Stunned(Effect).ApplyChance = 50;
		}
	}

	foreach Template.AbilityMultiTargetEffects(Effect)
	{
		if(Effect.IsA('X2Effect_Stunned'))
		{
			X2Effect_Stunned(Effect).ApplyChance = 50;
		}
	}

}



static function UpdateRageSmash()
{
	local X2AbilityTemplate                    Template;
	local X2AbilityTemplateManager 				AllAbilities;
	local X2Condition_UnitProperty	UnitCondition;
	local X2AbilityToHitCalc_StandardMelee MeleeHitCalc;
	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	Template = AllAbilities.FindAbilityTemplate('BreakerRageAttack');

	RemoveAbilityTargetConditions(Template, 'X2Condition_UnitProperty');

	UnitCondition = new class 'X2Condition_UnitProperty';
	UnitCondition.ExcludeAlive = false;
	UnitCondition.ExcludeDead=true;
	UnitCondition.ExcludeFriendlyToSource=false;
	UnitCondition.ExcludeHostileToSource=false;
	UnitCondition.TreatMindControlledSquadmateAsHostile=true;
	UnitCondition.ExcludeUnBreached=true;

	Template.AbilityTargetConditions.AddItem(UnitCondition);

	MeleeHitCalc = new class'X2AbilityToHitCalc_StandardMelee';
	//MeleeHitCalc.BuiltInHitMod = -15;
	Template.AbilityToHitCalc = MeleeHitCalc;
}

static function UpdateCCS()
{
	local X2AbilityTemplate                    Template;
	local X2AbilityTemplateManager 				AllAbilities;
	local X2Condition_NotItsOwnTurn	NotItsOwnTurnCondition;
	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	
	Template = AllAbilities.FindAbilityTemplate('CloseCombatSpecialistShot');
	Template.AbilityCooldown = CreateCooldown(1);


	NotItsOwnTurnCondition = new class'X2Condition_NotItsOwnTurn';
	Template.AbilityShooterConditions.AddItem(NotItsOwnTurnCondition);

}

static function UpdateMindFlay()
{
	local X2AbilityTemplate                    Template;
	local X2AbilityTemplateManager 				AllAbilities;

	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	
	Template = AllAbilities.FindAbilityTemplate('MindFlay');
	Template.AbilityCooldown = CreateCooldown(default.MINDFLAY_COOLDOWN);
	MakeNonTurnEnding(Template);
	Template.AdditionalAbilities.AddItem('MindFlayBonusDamage');
}

static function UpdateFearlessAdvance()
{
	local X2AbilityTemplate                    Template;
	local X2AbilityTemplateManager 				AllAbilities;
	local X2Effect_SetUnitValue	UnitValueEffect;
	local X2Condition_UnitValue	UnitValueCondition;
	local X2Effect_DisableWeapon DisarmEffect;
	local X2Effect_Persistent DisorientedEffect;
	local X2Effect_Stunned StunnedEffect;
	local X2Effect_Rooted RootedEffect;
	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	
	Template = AllAbilities.FindAbilityTemplate(class'X2Ability_BreachAbilities'.default.BreachHellionRushAbilityName);

	// Add debuffs (disarm, disorient, stun, root)
	/// Disarm
	UnitValueEffect = new class'X2Effect_SetUnitValue';
	UnitValueEffect.NewValueToSet = 1;
	UnitValueEffect.UnitName = 'CripplingBlowDisarmResult';
	UnitValueEffect.CleanupType = eCleanup_BeginTurn;
	UnitValueEffect.ApplyChanceFn = class'X2Ability_Hellion'.static.CripplingBlowDisarm_ApplyChanceCheck;
	Template.AddTargetEffect(UnitValueEffect);

	UnitValueCondition = new class'X2Condition_UnitValue';
	UnitValueCondition.AddCheckValue('CripplingBlowDisarmResult', 1);

	DisarmEffect = new class'X2Effect_DisableWeapon';
	DisarmEffect.bFailSilently = true;
	DisarmEffect.TargetConditions.AddItem(UnitValueCondition);
	Template.AddTargetEffect(DisarmEffect);
	/// End disarm

	/// Disorient
	UnitValueEffect = new class'X2Effect_SetUnitValue';
	UnitValueEffect.NewValueToSet = 1;
	UnitValueEffect.UnitName = 'CripplingBlowDisorientResult';
	UnitValueEffect.CleanupType = eCleanup_BeginTurn;
	UnitValueEffect.ApplyChanceFn = class'X2Ability_Hellion'.static.CripplingBlowDisoriented_ApplyChanceCheck;
	Template.AddTargetEffect(UnitValueEffect);

	UnitValueCondition = new class'X2Condition_UnitValue';
	UnitValueCondition.AddCheckValue('CripplingBlowDisorientResult', 1);
	UnitValueCondition.AddCheckValue('CripplingBlowDisarmResult', 0);


	DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(, , false);
	DisorientedEffect.bRemoveWhenSourceDies = false;
	DisorientedEffect.TargetConditions.AddItem(UnitValueCondition);
	Template.AddTargetEffect(DisorientedEffect);
	/// End disorient

	/// Stun
	UnitValueEffect = new class'X2Effect_SetUnitValue';
	UnitValueEffect.NewValueToSet = 1;
	UnitValueEffect.UnitName = 'CripplingBlowStunResult';
	UnitValueEffect.CleanupType = eCleanup_BeginTurn;
	UnitValueEffect.ApplyChanceFn = class'X2Ability_Hellion'.static.CripplingBlowStun_ApplyChanceCheck;
	Template.AddTargetEffect(UnitValueEffect);

	UnitValueCondition = new class'X2Condition_UnitValue';
	UnitValueCondition.AddCheckValue('CripplingBlowStunResult', 1);
	UnitValueCondition.AddCheckValue('CripplingBlowDisarmResult', 0);
	UnitValueCondition.AddCheckValue('CripplingBlowDisorientResult', 0);

	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(class'X2Ability_Hellion'.default.CRIPPLINGBLOW_STUN_LEVEL, 100, false);
	StunnedEffect.bRemoveWhenSourceDies = false;
	StunnedEffect.TargetConditions.AddItem(UnitValueCondition);
	Template.AddTargetEffect(StunnedEffect);
	/// End stun

	/// Root
	UnitValueEffect = new class'X2Effect_SetUnitValue';
	UnitValueEffect.NewValueToSet = 1;
	UnitValueEffect.UnitName = 'CripplingBlowRootedResult';
	UnitValueEffect.CleanupType = eCleanup_BeginTurn;
	UnitValueEffect.ApplyChanceFn = class'X2Ability_Hellion'.static.CripplingBlowRoot_ApplyChanceCheck;
	Template.AddTargetEffect(UnitValueEffect);

	UnitValueCondition = new class'X2Condition_UnitValue';
	UnitValueCondition.AddCheckValue('CripplingBlowRootedResult', 1);
	UnitValueCondition.AddCheckValue('CripplingBlowDisarmResult', 0);
	UnitValueCondition.AddCheckValue('CripplingBlowDisorientResult', 0);
	UnitValueCondition.AddCheckValue('CripplingBlowStunResult', 0);

	RootedEffect = class'X2StatusEffects'.static.CreateRootedStatusEffect(class'X2Ability_Hellion'.default.CRIPPLINGBLOW_ROOT_TURNS);
	RootedEffect.bRemoveWhenSourceDies = false;
	RootedEffect.TargetConditions.AddItem(UnitValueCondition);
	Template.AddTargetEffect(RootedEffect);

}


	

static function UpdtateSoulSiphon()
{
	local X2AbilityTemplate                    Template;
	local X2AbilityTemplateManager 				AllAbilities;
	local X2Effect_RemoveEffectsByDamageType	RemoveEffects;
	local name HealType;

	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	Template = AllAbilities.FindAbilityTemplate('SoulSiphon');

	MakeFreeAction(Template);

	RemoveEffects = new class'X2Effect_RemoveEffectsByDamageType';
	foreach class'X2Ability_DefaultAbilitySet'.default.MedikitHealEffectTypes(HealType)
	{
		RemoveEffects.DamageTypesToRemove.AddItem(HealType);
	}
	Template.AddTargetEffect(RemoveEffects);
}

static function bool OverrideFinalHitChance(X2AbilityToHitCalc AbilityToHitCalc, out ShotBreakdown ShotBreakdown)
{
	local X2AbilityToHitCalc_StandardAim	StandardAim;
	local ToHitAdjustments					Adjustments;
	local ShotModifierInfo					ModInfo;

	StandardAim = X2AbilityToHitCalc_StandardAim(AbilityToHitCalc);
	if (StandardAim == none)
	{
		return false;
	}

	GetUpdatedHitChances(StandardAim, ShotBreakdown, Adjustments);

	// LWOTC Replacing the old FinalHitChance calculation with one that treats all graze
	// as a hit.
	//ShotBreakdown.FinalHitChance = ShotBreakdown.ResultTable[eHit_Success] + Adjustments.DodgeHitAdjust;
	ShotBreakdown.FinalHitChance = Adjustments.FinalSuccessChance + Adjustments.FinalGrazeChance + Adjustments.FinalCritChance;
	ShotBreakdown.ResultTable[eHit_Crit] = Adjustments.FinalCritChance;
	ShotBreakdown.ResultTable[eHit_Success] = Adjustments.FinalSuccessChance;
	ShotBreakdown.ResultTable[eHit_Graze] = Adjustments.FinalGrazeChance;
	ShotBreakdown.ResultTable[eHit_Miss] = Adjustments.FinalMissChance;

	if(Adjustments.DodgeHitAdjust != 0)
	{
		ModInfo.ModType = eHit_Success;
		ModInfo.Value   = Adjustments.DodgeHitAdjust;
		ModInfo.Reason  = class'XLocalizedData'.default.DodgeStat;
		ShotBreakdown.Modifiers.AddItem(ModInfo);
	}
	if(Adjustments.ConditionalCritAdjust != 0)
	{
		ModInfo.ModType = eHit_Crit;
		ModInfo.Value   = Adjustments.ConditionalCritAdjust;
		ModInfo.Reason  = "Aim";
		ShotBreakdown.Modifiers.AddItem(ModInfo);
	}
	if(Adjustments.DodgeCritAdjust != 0)
	{
		ModInfo.ModType = eHit_Crit;
		ModInfo.Value   = Adjustments.DodgeCritAdjust;
		ModInfo.Reason  = "Graze";
		ShotBreakdown.Modifiers.AddItem(ModInfo);
	}

	return true;
}

static function GetUpdatedHitChances(X2AbilityToHitCalc_StandardAim ToHitCalc, out ShotBreakdown ShotBreakdown, out ToHitAdjustments Adjustments)
{
	local int GrazeBand;
	local int CriticalChance, DodgeChance;
	local int MissChance, HitChance, CritChance;
	local int GrazeChance, GrazeChance_Hit, GrazeChance_Miss;
	local int CritPromoteChance_HitToCrit;
	local int CritPromoteChance_GrazeToHit;
	local int DodgeDemoteChance_CritToHit;
	local int DodgeDemoteChance_HitToGraze;
	local int DodgeDemoteChance_GrazeToMiss;
	local ShotModifierInfo	ModInfo;


	// STEP 1 "Band of hit values around nominal to-hit that results in a graze
	GrazeBand = default.GRAZE_BAND_WIDTH;

	// options to zero out the band for certain abilities -- either GuaranteedHit or an ability-by-ability
	if (default.GUARANTEED_HIT_ABILITIES_IGNORE_GRAZE_BAND && ToHitCalc.bGuaranteedHit)
	{
		GrazeBand = 0;
	}

	HitChance = ShotBreakdown.ResultTable[eHit_Success];
	// LWOTC: If hit chance is within grazeband of either 0 or 100%, then adjust
	// the band so that 100% is a hit and 0% is a miss.
	if (HitChance < GrazeBand)
	{
		GrazeBand = Max(0, HitChance);
	}
	else if (HitChance > (100 - GrazeBand))
	{
		GrazeBand = Max(0, 100 - HitChance);
	}
	// End LWOTC change

	GrazeChance_Hit = Clamp(HitChance, 0, GrazeBand); // captures the "low" side where you just barely hit
	GrazeChance_Miss = Clamp(100 - HitChance, 0, GrazeBand);  // captures the "high" side where  you just barely miss
	GrazeChance = GrazeChance_Hit + GrazeChance_Miss;

	
	if (GrazeChance_Hit > 0)
	{
		ModInfo.ModType = eHit_Success;
		ModInfo.Value   = GrazeChance_Hit;
		ModInfo.Reason  = "Graze Band";
		Shotbreakdown.Modifiers.AddItem(ModInfo);
	}
	

	//STEP 2 Update Hit Chance to remove GrazeChance -- for low to-hits this can be zero
	HitChance = Clamp(Min(100, HitChance)-GrazeChance_Hit, 0, 100-GrazeChance);

	//STEP 3 "Crits promote from graze to hit, hit to crit
	CriticalChance = ShotBreakdown.ResultTable[eHit_Crit];
	if (default.ALLOW_NEGATIVE_DODGE && ShotBreakdown.ResultTable[eHit_Graze] < 0)
	{
		// negative dodge acts like crit, if option is enabled
		CriticalChance -= ShotBreakdown.ResultTable[eHit_Graze];
	}
	CriticalChance = Clamp(CriticalChance, 0, 100);
	CritPromoteChance_HitToCrit = Round(float(HitChance) * float(CriticalChance) / 100.0);

	CritPromoteChance_GrazeToHit = Round(float(GrazeChance) * float(CriticalChance) / 100.0);


	CritChance = CritPromoteChance_HitToCrit; // crit chance is the chance you promoted to crit
	HitChance = HitChance + CritPromoteChance_GrazeToHit - CritPromoteChance_HitToCrit;  // add chance for promote from dodge, remove for promote to crit
	GrazeChance = GrazeChance - CritPromoteChance_GrazeToHit; // remove chance for promote to hit


	//save off loss of crit due to conditional on to-hit
	Adjustments.ConditionalCritAdjust = -(CriticalChance - CritPromoteChance_HitToCrit);

	//STEP 4 "Dodges demotes from crit to hit, hit to graze, (optional) graze to miss"
	if (ShotBreakdown.ResultTable[eHit_Graze] > 0)
	{
		DodgeChance = Clamp(ShotBreakdown.ResultTable[eHit_Graze], 0, 100);
		DodgeDemoteChance_CritToHit = Round(float(CritChance) * float(DodgeChance) / 100.0);
		DodgeDemoteChance_HitToGraze = Round(float(HitChance) * float(DodgeChance) / 100.0);
		if(default.DODGE_CONVERTS_GRAZE_TO_MISS)
		{
			DodgeDemoteChance_GrazeToMiss = Round(float(GrazeChance) * float(DodgeChance) / 100.0);
		}
		CritChance = CritChance - DodgeDemoteChance_CritToHit;
		HitChance = HitChance + DodgeDemoteChance_CritToHit - DodgeDemoteChance_HitToGraze;
		GrazeChance = GrazeChance + DodgeDemoteChance_HitToGraze - DodgeDemoteChance_GrazeToMiss;

		//save off loss of crit due to dodge demotion
		Adjustments.DodgeCritAdjust = -DodgeDemoteChance_CritToHit;

		//save off loss of to-hit due to dodge demotion of graze to miss
		Adjustments.DodgeHitAdjust = -DodgeDemoteChance_GrazeToMiss;
	}

	//STEP 5 Store
	Adjustments.FinalCritChance = CritChance;
	Adjustments.FinalSuccessChance = HitChance;
	Adjustments.FinalGrazeChance = GrazeChance;

	//STEP 6 Miss chance is what is left over
	MissChance = 100 - (CritChance + HitChance + GrazeChance);
	Adjustments.FinalMissChance = MissChance;
	if(MissChance < 0)
	{
		//This is an error so flag it
		`REDSCREEN("OverrideToHit : Negative miss chance!");
	}
}

 
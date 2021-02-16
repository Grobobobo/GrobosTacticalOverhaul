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

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
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
}

static function UpdateAbilities()
{
	local X2AbilityTemplateManager	          AllAbilities;
	local X2AbilityTemplate                    CurrentAbility;
	local X2Condition_UnitProperty             UnitPropertyCondition;
	local X2Condition_UnitEffects              UnitConditionEffects;
	local X2Effect_HuntersInstinctDamage_LW		DamageModifier;
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
 
	// Prevents them from spaming.
	CurrentAbility = AllAbilities.FindAbilityTemplate('QuickBite');
	CurrentAbility.AbilityCooldown = CreateCooldown(3);
 
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
	
	CurrentAbility = AllAbilities.FindAbilityTemplate('PsiDisable');
	MakeFreeAction(CurrentAbility);
	
	UpdateSubservience(AllAbilities);

	CurrentAbility = AllAbilities.FindAbilityTemplate('Impel');
	MakeFreeAction(CurrentAbility);

	CurrentAbility = AllAbilities.FindAbilityTemplate('SoulSiphon');
	MakeFreeAction(CurrentAbility);

	CurrentAbility = AllAbilities.FindAbilityTemplate('PsionicSuplex');
	MakeNonTurnEnding(CurrentAbility);

	MakeMeleeBlueMove('ChryssalidSlash');
	MakeMeleeBlueMove('DevastatingBlow');
	MakeMeleeBlueMove('StandardMelee');
	MakeMeleeBlueMove('CripplingBlow');
	MakeMeleeBlueMove('BloodLust');
	MakeMeleeBlueMove('BomberStrike');
	MakeMeleeBlueMove('BomberStrike');

	UpdateMindfire();
	UpdatePsiDomain();

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
}

static function UpdateItems()
{
	local X2ItemTemplateManager ItemTemplateManager;
	local X2DataTemplate DataTemplate;
	local X2WeaponTemplate WeaponTemplate;
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

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
 
	ChangeWeaponTable( 'Inquisitor_Tongue_WPN', class'X2Item_DefaultWeapons'.default.XCOM_LONG_MAGNETIC_RANGE);
	ChangeWeaponTable( 'InquisitorToxicGreetingGlob', class'X2Item_DefaultWeapons'.default.XCOM_LONG_MAGNETIC_RANGE);
 
	ChangeWeaponTable( 'WPN_XComLancerPistol', class'X2Item_DefaultWeapons'.default.XCOM_MEDIUM_MAGNETIC_RANGE);

	foreach ItemTemplateManager.IterateTemplates(DataTemplate)
	{
		WeaponTemplate = X2WeaponTemplate(DataTemplate);
		
		
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
			}

		}
		

	}

}

static function UpdateCharacters()
{

	local X2CharacterTemplateManager	       AllCharacters;
	local X2CharacterTemplate		          CharTemplate;
	local array<name> nAllCharacterNames;
 
	local name CurrentName;
 
	AllCharacters = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
 
	AllCharacters.GetTemplateNames(nAllCharacterNames);
 
	foreach nAllCharacterNames ( CurrentName ) {
	   CharTemplate = AllCharacters.FindCharacterTemplate( CurrentName );
	   CharTemplate.CharacterBaseStats[eStat_FlankingCritChance] = class'X2Item_RebalancedWeapons'.default.FLANKING_CRIT_CHANCE;

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

			case 'Sorcerer':
	   			break;
			case 'Muton_Brute':
				CharTemplate.Abilities.RemoveItem('CriminalSentinelAbility_StandardShotActivated');
				CharTemplate.Abilities.AddItem('CloseCombatSpecialist');
				break;
			case 'Acolyte':
	   			break;
			case 'Sectoid_Resonant':
				CharTemplate.Abilities.AddItem('TriggerHappy');
	   			break;
			case 'Cyberus':
	   			break;
			case 'Archon':
	   			break;
	   		case 'ProgenyLeader':
			   CharTemplate.Abilities.AddItem('ChosenSoulStealer');
	   			break;
			
			case 'Muton_Legionairre':
				CharTemplate.Abilities.AddItem('CloseEncounters');
	   			break;
	   		case 'Viper_Adder':
				CharTemplate.Abilities.AddItem('SurvivalInstinct_LW');
				CharTemplate.Abilities.AddItem('Whirlwind2');
	   			break;
			case 'Viper_Python':
				CharTemplate.Abilities.AddItem('Slippery');
				break;

	   		case 'Sectoid_Dominator':
			   CharTemplate.Abilities.AddItem('LowProfile');
			   break;
	   		case 'Sectoid_Paladin':
			   break;
			case 'Berserker':
				CharTemplate.Abilities.AddItem('Brawler');
				break;
	   		case 'Faceless':
			
			case 'Sectopod':
				CharTemplate.Abilities.AddItem('ImpactCompensation_LW');
				break;
			case 'GP_Leader':
				CharTemplate.Abilities.AddItem('ChosenSoulStealer');
				CharTemplate.Abilities.AddItem('Fortress');
				CharTemplate.Abilities.AddItem('Bastion');
				break;

			case 'Ronin':
			case 'Purifier':
				CharTemplate.Abilities.AddItem('TakeDown');
				break;
			case 'Guardian':
				CharTemplate.Abilities.AddItem('Resilience');
				break;
			case 'Commando':
			case 'SacredCoilDJ':

			case 'AdvTurretM1':
			case 'AdvMEC_M1':
	   		case 'Chryssalid':
			case 'NeonateChryssalid':
			case 'AndromedonRobot':
			case 'Gatekeeper':
			case 'SC_Leader':

			///NICE INTERNAL NAMING SYSTEM FIRAXIS, BRAVOs
			case 'HardlinerLeader':
			case 'Hitman':
			case 'EPICPISTOL2Carrying_Hitman':
				CharTemplate.Abilities.AddItem('Holotargeting');
				break;
			case 'Muton_Bomber':
			case 'EPICSHOTGUN2Carrying_Bomber':
				break;
			case 'Liquidator':
			case 'EPICAR1Carrying_Adder':
			case 'EPICAR2Carrying_Commando':
			case 'EPICSHOTGUN1Carrying_Brute':
			CharTemplate.Abilities.AddItem('PrimaryReturnFire');
			CharTemplate.Abilities.AddItem('CoolUnderPressure');
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
				break;
		   break;
	  default:
		break;
	 }
 
 
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
	local float TempFloat;

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
		Outstring = string(int(class'X2Effect_WillToSurvive'.default.WTS_COVER_DR_PCT));
		return true;
	case 'RESILIENCE_BONUS_LW':
		Outstring = string(class'X2Ability_XMBPerkAbilitySet'.default.RESILIENCE_CRITDEF_BONUS);
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
	//WHY AREN'T THERE DIFFERENT TEMPLATES FOR DIFFERENT TIER ENEMIES ANYMORE WHAT THE FUCK FIRAXIS REEEEEEEEE
	//Time to do this shit in the most roundabout way possible
	MissionSite = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(`DIOHQ.MissionRef.ObjectID));
	Act = MissionSite.MissionDifficultyParams.Act;

	CharTemplate = UnitState.GetMyTemplate();

	switch(Act)
	{
		case 3:
		GiveEnemiesAct3Perks(UnitState, SetupData, CharTemplate.DataName);
		case 2:
		GiveEnemiesAct2Perks(UnitState, SetupData, CharTemplate.DataName);
		break;
		default:
		break;
	}


}

static function GiveEnemiesAct3Perks(XComGameState_Unit UnitState, out array<AbilitySetupData> SetupData, name TemplateName)
{
	local array<AbilitySetupData> arrData;
	local array<AbilitySetupData> arrAdditional;
	local X2AbilityTemplate AbilityTemplate;
	local name AbilityName;
	local X2AbilityTemplateManager AbilityTemplateMan;

	AbilityTemplateMan = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	switch (TemplateName)
	{
		case 'Thrall':
			AddAbilityToSetUpData(SetupData,'Huntersinstinct', UnitState);
			break;
		case 'Sorcerer':
			AddAbilityToSetUpData(SetupData,'Bastion', UnitState);
			break;
		case 'Muton_Brute':
			AddAbilityToSetUpData(SetupData,'CoolUnderPressure', UnitState);
			break;
		case 'Acolyte':
			break;
		case 'Sectoid_Resonant':
			AddAbilityToSetUpData(SetupData,'Sentinel_LW', UnitState);
			break;
		case 'Cyberus':
			AddAbilityToSetUpData(SetupData,'Evasive', UnitState);
			break;
		case 'Archon':
			break;
		case 'ProgenyLeader':
			AddAbilityToSetUpData(SetupData,'Bastion', UnitState);
			AddAbilityToSetUpData(SetupData,'SurvivalInstinct_LW', UnitState);
			break;
		
		case 'Muton_Legionairre':
			AddAbilityToSetUpData(SetupData,'CoolUnderPressure', UnitState);
			break;
		case 'Viper_Adder':
			break;
		case 'Viper_Python':
			break;

		case 'Sectoid_Dominator':
			break;
		case 'Sectoid_Paladin':
			AddAbilityToSetUpData(SetupData,'Concentration_LW', UnitState);
			AddAbilityToSetUpData(SetupData,'CoolUnderPressure', UnitState);
			break;
		case 'Berserker':
			AddAbilityToSetUpData(SetupData,'PsychoticRage', UnitState);
			break;
		case 'Faceless':
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
		case 'AdvMEC_M1':
			AddAbilityToSetUpData(SetupData,'DamageControl', UnitState);
		break;
		case 'Chryssalid':
			break;
		case 'NeonateChryssalid':
			break;
		case 'Andromedon':

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
			break;
		case 'Viper_Cobra':
		case 'EPICSMG2Carrying_Resonant':
			AddAbilityToSetUpData(SetupData,'HuntersInstinct', UnitState);
			break;
		case 'Sectoid_Necromancer':
		case 'EPICSMG1Carrying_Dominator':
			break;
		case 'Bruiser':
		case 'EPICPISTOL1Carrying_Guardian':
			break;
		case 'ConspiracyLeader':
			break;
	}
}



static function GiveEnemiesAct2Perks(XComGameState_Unit UnitState, out array<AbilitySetupData> SetupData, name TemplateName)
{
	local array<AbilitySetupData> arrData;
	local array<AbilitySetupData> arrAdditional;
	local X2AbilityTemplate AbilityTemplate;
	local name AbilityName;
	local X2AbilityTemplateManager AbilityTemplateMan;
	local int i;
	local AbilitySetupData Data, EmptyData;

	AbilityTemplateMan = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	switch(TemplateName)
	{
		case 'Thrall':
			AddAbilityToSetUpData(SetupData,'ChosenRegenerate', UnitState);
			break;
		case 'Sorcerer':
			AddAbilityToSetUpData(SetupData,'Fortress', UnitState);
			break;
		case 'Muton_Brute':
			AddAbilityToSetUpData(SetupData,'Resilience', UnitState);
			break;
		case 'Acolyte':
			break;
		case 'Sectoid_Resonant':
			AddAbilityToSetUpData(SetupData,'Vampirism_LW', UnitState);
			break;
		case 'Cyberus':
			break;
		case 'Archon':
			AddAbilityToSetUpData(SetupData,'Brawler', UnitState);
			break;
		case 'ProgenyLeader':
			break;
		
		case 'Muton_Legionairre':
			AddAbilityToSetUpData(SetupData,'Brawler', UnitState);
			break;
		case 'Viper_Adder':
			break;
		case 'Viper_Python':
			AddAbilityToSetUpData(SetupData,'Infighter', UnitState);
			break;

		case 'Sectoid_Dominator':
		case 'Sectoid_Paladin':
			break;
		case 'Berserker':
			AddAbilityToSetUpData(SetupData,'BullRush', UnitState);
			break;
		case 'Faceless':
		
		case 'Sectopod':
			break;
		case 'GP_Leader':
			break;

		case 'Ronin':
			break;

		case 'Purifier':
			AddAbilityToSetUpData(SetupData,'Formidable', UnitState);
			break;
		case 'Guardian':
			break;
		case 'Commando':
		case 'SacredCoilDJ':
			AddAbilityToSetUpData(SetupData,'Impulse_LW', UnitState);

		case 'AdvTurretM1':
		case 'AdvMEC_M1':

		case 'Chryssalid':
		case 'NeonateChryssalid':
		case 'AndromedonRobot':
		case 'Gatekeeper':
		case 'SC_Leader':

		case 'HardlinerLeader':
		case 'Hitman':
		case 'EPICPISTOL2Carrying_Hitman':
			break;
		case 'Muton_Bomber':
		case 'EPICSHOTGUN2Carrying_Bomber':
			break;
		case 'Liquidator':
		case 'EPICAR1Carrying_Adder':
		case 'EPICAR2Carrying_Commando':
		case 'EPICSHOTGUN1Carrying_Brute':
			break;
		case 'Viper_Cobra':
		case 'EPICSMG2Carrying_Resonant':
			break;
		case 'Sectoid_Necromancer':
		case 'EPICSMG1Carrying_Dominator':
			break;
		case 'Bruiser':
		case 'EPICPISTOL1Carrying_Guardian':
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
   local X2AbilityTemplate	CurrentAbility;
   local X2Condition_UnitProperty	UnitPropertyCondition;

   CurrentAbility = AllAbilities.FindAbilityTemplate('EngageSelfDestruct');
   UnitPropertyCondition = new class'X2Condition_UnitProperty';
   UnitPropertyCondition.ExcludeFriendlyToSource = false;
   UnitPropertyCondition.ExcludeFullHealth = true;
   UnitPropertyCondition.FailOnNonUnits = true;
   CurrentAbility.AbilityTargetConditions.AddItem(UnitPropertyCondition);
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
	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	Template = AllAbilities.FindAbilityTemplate('Subservience');
	RemoveAbilityTargetEffects(Template,'X2Effect_Subservience');


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
	local X2Effect_SubServienceDamage FlayDamageEffect;
	AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	Template = AllAbilities.FindAbilityTemplate('SubservienceSacrifice');

	RemoveAbilityTargetEffects(Template,'X2Effect_ApplyWeaponDamage');

	FlayDamageEffect = new class'X2Effect_SubServienceDamage';
	FlayDamageEffect.EffectDamageValue.DamageType = 'Psi';
	FlayDamageEffect.bIgnoreArmor = true;
	FlayDamageEffect.bIgnoreBaseDamage = true;
	Template.AddTargetEffect(FlayDamageEffect);	
}

static function RemoveTheDeathFromHolyWarriorDeath(X2AbilityTemplate Template)
{
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
	StatChange.AddPersistentStatChange(eStat_Offense, -20);
	StatChange.AddPersistentStatChange(eStat_Mobility, -5);

	
	// Prevent the effect from applying to a unit more than once
	StatChange.DuplicateResponse = eDupe_Ignore;

	// The effect lasts until the beginning of the player's next turn
	StatChange.BuildPersistentEffect(2, false, true, false, eWatchRule_UnitTurnBegin);
	Template.AddTargetEffect(StatChange);

	MakeNonTurnEnding(Template);
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
	local X2Effect_PsiDomainDamage_LW DamageEffect;
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
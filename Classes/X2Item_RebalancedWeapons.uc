class X2Item_RebalancedWeapons extends X2Item config(GameData_WeaponData);

var config array<WeaponDamageValue> ARCHON_MELEEATTACK_EXTRADAMAGE;
var config array<WeaponDamageValue> ARCHON_BLAZINGPINIONS_EXTRADAMAGE;
var config array<WeaponDamageValue> ADVMEC_M1_MICROMISSILES_EXTRADAMAGE;
var config array<WeaponDamageValue> ANDROMEDON_ACIDBLOB_EXTRADAMAGE;

var config array<WeaponDamageValue> ANDROMEDONROBOT_MELEEATTACK_EXTRADAMAGE;
var config array<WeaponDamageValue> BRUTE_MELEE_EXTRADAMAGE;

var config int FLANKING_CRIT_CHANCE;

var config int ENHANCED_PISTOLS_CRIT_BONUS;
var config int ENHANCED_SMG_CRIT_BONUS;

var config int ENHANCED_SHOTGUN_CRIT_BONUS;
var config int MASTER_SHOTGUN_CRIT_BONUS;

var config int PSI_BOMB_ACT2_DAMAGE_BONUS;
var config int PSI_BOMB_ACT3_DAMAGE_BONUS;

var config WeaponDamageValue ENHANCED_AR_BONUS;
var config WeaponDamageValue MASTER_AR_BONUS;

var config WeaponDamageValue ENHANCED_SMG_BONUS;
var config WeaponDamageValue MASTER_SMG_BONUS;

var config WeaponDamageValue ENHANCED_SHOTGUN_BONUS;
var config WeaponDamageValue MASTER_SHOTGUN_BONUS;

var config WeaponDamageValue ENHANCED_PISTOLS_BONUS;
var config WeaponDamageValue MASTER_PISTOLS_BONUS;

var config int BERSERKER_IDEALRANGE;

var config WeaponDamageValue BERSERKER_WPN_BASEDAMAGE;
var config array<WeaponDamageValue> BERSERKER_WPN_EXTRADAMAGE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;
	Weapons.AddItem(CreateTemplate_Berserker_MeleeAttack());

	return Weapons;
}

static function X2DataTemplate CreateTemplate_Berserker_MeleeAttack()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Berserker_MeleeAttack');

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'baton';
	Template.WeaponTech = 'coventional';
	Template.strImage = "img:///UILibrary_Common.Sword";
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "";
    Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.iRange = 0;
	Template.iRadius = 1;
	Template.NumUpgradeSlots = 2;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;
	Template.iIdealRange = default.BERSERKER_IDEALRANGE;

	Template.BaseDamage = default.BERSERKER_WPN_BASEDAMAGE;
	Template.ExtraDamage = default.BERSERKER_WPN_EXTRADAMAGE;
	Template.BaseDamage.DamageType='Melee';
	Template.iSoundRange = 2;
	Template.iEnvironmentDamage = 10;

	//Build Data
	Template.StartingItem = false;
	Template.CanBeBuilt = false;

	return Template;
}

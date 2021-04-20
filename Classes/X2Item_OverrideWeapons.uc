//---------------------------------------------------------------------------------------
//  FILE:    X2Item_OverrideWeapons.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: List Of Override weapons which was Rage-Created because OPTC did not change them 
//  correctly for some ungodly reason
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2018 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Item_OverrideWeapons extends X2Item config(GameData_WeaponData);

var config int COMBAT_PROTOCOL_DAMAGE;

var config int CEASEFIREBOMB_RANGE;
var config int CEASEFIREBOMB_RADIUS;
var config int CEASEFIREBOMB_ICLIPSIZE;
var config int CEASEFIREBOMB_ISOUNDRANGE;
var config int CEASEFIREBOMB_IENVIRONMENTDAMAGE;
var config int CEASEFIREBOMB_IPOINTS;

var config WeaponDamageValue FLASHBOMB_BASEDAMAGE;
var config int FLASHBOMB_ISOUNDRANGE;
var config int FLASHBOMB_IENVIRONMENTDAMAGE;
var config int FLASHBOMB_ISUPPLIES;
var config int FLASHBOMB_TRADINGPOSTVALUE;
var config int FLASHBOMB_IPOINTS;
var config int FLASHBOMB_ICLIPSIZE;
var config int FLASHBOMB_RANGE;
var config int FLASHBOMB_RADIUS;


static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;


    Weapons.AddItem(CreateTemplate_XComOperatorGremlin());
    //Weapons.AddItem(CreateBreachSmokebomb());

	Weapons.AddItem(CreateBreachCeasefirebomb());
	Weapons.AddItem(CreateBreachFlashbomb());
	

    return Weapons;
}

static function X2DataTemplate CreateTemplate_XComOperatorGremlin()
{
	local X2GremlinTemplate Template;

	Template = CreateTemplate_XComGremlin('WPN_XComOperatorGremlin');
	
	Template.CosmeticUnitTemplate = "GremlinOperator";

	return Template;
}
static function X2GremlinTemplate CreateTemplate_XComGremlin(name TemplateName)
{
	local X2GremlinTemplate Template;

	`CREATE_X2TEMPLATE(class'X2GremlinTemplate', Template, TemplateName);
	Template.WeaponPanelImage = "_Gremlin";
	Template.WeaponTech = 'coventional';
	Template.strImage = "img:///UILibrary_Common.MagSecondaryWeapons.MagGremlin";
	Template.EquipSound = "Gremlin_Equip";

	Template.Abilities.AddItem('GremlinStabilize');

	Template.CosmeticUnitTemplate = "GremlinMk2";
	Template.Tier = 1;

	Template.ExtraDamage = class 'X2Item_DefaultWeapons'.default.XCOM_GREMLIN_ABILITYDAMAGE;
	Template.HackingAttemptBonus = 0;
	Template.AidProtocolBonus = 0;
	Template.HealingBonus = 0;
	Template.BaseDamage.Damage = default.COMBAT_PROTOCOL_DAMAGE;     //  combat protocol
	Template.BaseDamage.Pierce = 1000;  //  ignore armor
	Template.BaseDamage.Spread = 1;  //  ignore armor

	Template.iRange = 2;
	Template.iRadius = 40;              //  only for scanning protocol
	Template.NumUpgradeSlots = 2;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Electrical';

	Template.bHideDamageStat = true;

	return Template;
}


static function X2DataTemplate CreateBreachSmokebomb()
{
	local X2GrenadeTemplate		Template;
	local ArtifactCost			Resources;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'BreachSmokebomb');

	Template.strImage = "img:///UILibrary_Common.Armory_G_Smoke_R";
	Template.strBackpackIcon = "img:///UILibrary_PerkIcons.UIPerk_smokebomb";
	Template.EquipSound = "UI_Strategy_Armory_Equip_Grenade";
	Template.AddAbilityIconOverride('ThrowGrenade', "img:///UILibrary_PerkIcons.UIPerk_grenade_smoke");
	Template.AddAbilityIconOverride('LaunchGrenade', "img:///UILibrary_PerkIcons.UIPerk_grenade_smoke");
	Template.iRange = class'X2Item_DefaultGrenades'.default.SMOKEGRENADE_RANGE;
	Template.iRadius = class'X2Item_DefaultGrenades'.default.BREACHSMOKEBOMB_RADIUS;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.ChargesLabel, , 1);
	
	Template.iSoundRange = class'X2Item_DefaultGrenades'.default.SMOKEGRENADE_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultGrenades'.default.SMOKEGRENADE_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = 7;
	Template.PointsToComplete = class'X2Item_DefaultGrenades'.default.SMOKEGRENADE_IPOINTS;
	Template.iClipSize = class'X2Item_DefaultGrenades'.default.SMOKEGRENADE_ICLIPSIZE;
	Template.Tier = 0;

	Template.Abilities.AddItem('BreachThrowSmokebomb');
	Template.InventorySlot = eInvSlot_Breach;
	Template.StowedLocation = eSlot_BeltHolster;
	Template.WeaponCat = 'breachthrowable';
	Template.ItemCat = 'breachthrowable';

	Template.ThrownGrenadeEffects.AddItem(new class'X2Effect_ApplySmokeGrenadeToWorld');
	Template.LaunchedGrenadeEffects = Template.ThrownGrenadeEffects;
	Template.bIgnoreRadialBlockingCover = true;
	Template.GameArchetype = "WP_Grenade_Smoke.WP_Grenade_Smoke";

	Template.CanBeBuilt = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 25;
	Template.Cost.ResourceCosts.AddItem(Resources);

	// Soldier Bark

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , class'X2Item_DefaultGrenades'.default.SMOKEGRENADE_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , class'X2Item_DefaultGrenades'.default.SMOKEGRENADE_RADIUS);

	Template.WeaponPrecomputedPathData.MaxNumberOfBounces = 0;

	return Template;
}


static function X2DataTemplate CreateBreachCeasefirebomb()
{
	local X2GrenadeTemplate Template;
	local X2Effect_DisableWeapon DisableWeapon;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'BreachCeasefirebomb');

	Template.strImage = "img:///UILibrary_Common.Armory_G_Ceasefire_R";
	Template.EquipSound = "UI_Strategy_Armory_Equip_Grenade";
	Template.GameArchetype = "WP_Breach_CeaseFireBomb.WP_Breach_CeaseFireBomb"; 
	Template.CanBeBuilt = false;
	Template.AddAbilityIconOverride('ThrowGrenade', "img:///UILibrary_PerkIcons.UIPerk_grenade_smoke");
	Template.AddAbilityIconOverride('LaunchGrenade', "img:///UILibrary_PerkIcons.UIPerk_grenade_smoke");

	Template.SetUIStatMarkup(class'XLocalizedData'.default.ChargesLabel, , 1);

	DisableWeapon = new class'X2Effect_DisableWeapon';
	Template.ThrownGrenadeEffects.AddItem(DisableWeapon);

	Template.iRange = default.CEASEFIREBOMB_RANGE;
	Template.iRadius = default.CEASEFIREBOMB_RADIUS;
	Template.iSoundRange = default.CEASEFIREBOMB_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.CEASEFIREBOMB_IENVIRONMENTDAMAGE;
	Template.PointsToComplete = default.CEASEFIREBOMB_IPOINTS;
	Template.iClipSize = default.CEASEFIREBOMB_ICLIPSIZE;
	Template.Tier = 0;

	Template.Abilities.AddItem('BreachThrowCeasefirebomb');
	Template.InventorySlot = eInvSlot_Breach;
	Template.StowedLocation = eSlot_BeltHolster;
	Template.WeaponCat = 'breachthrowable';
	Template.ItemCat = 'breachthrowable';

	// Soldier Bark

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , default.CEASEFIREBOMB_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , default.CEASEFIREBOMB_RADIUS);

	Template.WeaponPrecomputedPathData.MaxNumberOfBounces = 0;

	return Template;
}


static function X2DataTemplate CreateBreachFlashbomb()
{
	local X2GrenadeTemplate Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'BreachFlashbomb');

	Template.strImage = "img:///UILibrary_Common.Armory_G_Flashbang_R";
	Template.EquipSound = "UI_Strategy_Armory_Equip_Grenade";
	Template.AddAbilityIconOverride('ThrowGrenade', "img:///UILibrary_PerkIcons.UIPerk_grenade_flash");
	Template.AddAbilityIconOverride('LaunchGrenade', "img:///UILibrary_PerkIcons.UIPerk_grenade_flash");
	Template.iRange = default.FLASHBOMB_RANGE;
	Template.iRadius = default.FLASHBOMB_RADIUS;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.ChargesLabel, , 1);

	Template.ItemCat = 'breachthrowable';
	Template.WeaponCat = 'breachthrowable';
	Template.InventorySlot = eInvSlot_Breach;
	Template.StowedLocation = eSlot_BeltHolster;
	Template.Abilities.AddItem('BreachThrowFlashbomb');

	Template.ThrownGrenadeEffects.AddItem(class'X2StatusEffects'.static.CreateDisorientedStatusEffect(true, , false));

	//We need to have an ApplyWeaponDamage for visualization, even if the grenade does 0 damage (makes the unit flinch, shows overwatch removal)
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	WeaponDamageEffect.DamageTypes.AddItem(class'X2Item_DefaultDamageTypes'.default.DisorientDamageType); // Added to allow 'immune' flyover on TheLost<apc> 
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);

	Template.LaunchedGrenadeEffects = Template.ThrownGrenadeEffects;

	Template.GameArchetype = "WP_Breach_FlashBomb.WP_Breach_FlashBomb";

	Template.CanBeBuilt = true;

	Template.iSoundRange = default.FLASHBOMB_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.FLASHBOMB_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = 10;
	Template.PointsToComplete = default.FLASHBOMB_IPOINTS;
	Template.iClipSize = default.FLASHBOMB_ICLIPSIZE;
	Template.Tier = 0;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 35;
	Template.Cost.ResourceCosts.AddItem(Resources);

	// Soldier Bark

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , default.FLASHBOMB_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , default.FLASHBOMB_RADIUS);

	Template.WeaponPrecomputedPathData.MaxNumberOfBounces = 0;

	return Template;
}
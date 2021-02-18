class X2Item_GauntletUpgrades extends X2Item_DefaultUpgrades config(GameData_WeaponData);

var config int GAUNTLETS_ENHANCED_UPGRADE;

var config int GAUNTLETS_MASTER_UPGRADE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Items;

	// Dio Research
	Items.AddItem(CreateEnhancedGauntletsUpgrade());
	Items.AddItem(CreateMastercraftedGauntletsUpgrade());

	return Items;
}

//---------------------------------------------------------------------------------------
// Sniper Rifles

static function X2DataTemplate CreateEnhancedGauntletsUpgrade()
{
	local X2WeaponUpgradeTemplate   Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'EnhancedGauntletsUpgrade');
	Template.strImage = "img:///UILibrary_Common.Armory_AM_Gauntlets_R";
	Template.Universal = true;
	Template.CanBeBuilt = false;
	Template.HideInInventory = true;
	Template.MaxQuantity = 1;
	Template.EquipSound = "UI_Strategy_Armory_Equip_WeaponMod";

	Template.BaseDamage = default.GAUNTLETS_ENHANCED_UPGRADE;
	Template.CanApplyUpgradeToWeaponFn = CanApplyUpgrade_Gauntlets;
	Template.GetBonusAmountFn = GetBaseDamageBonusAmount;
	Template.OnAcquiredFn = OnDioWeaponUpgradeAcquired;
	Template.OnDisplayDescFn = OnDesc_Gauntlets;

	return Template;
}

//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateMastercraftedGauntletsUpgrade()
{
	local X2WeaponUpgradeTemplate   Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'MastercraftedGauntletsUpgrade');
	Template.strImage = "img:///UILibrary_Common.Armory_AM_Gauntlets_R";
	Template.Universal = true;
	Template.CanBeBuilt = false;
	Template.HideInInventory = true;
	Template.MaxQuantity = 1;
	Template.EquipSound = "UI_Strategy_Armory_Equip_WeaponMod";

	Template.BaseDamage = default.GAUNTLETS_MASTER_UPGRADE;
	Template.CanApplyUpgradeToWeaponFn = CanApplyUpgrade_Gauntlets;
	Template.GetBonusAmountFn = GetBaseDamageBonusAmount;
	Template.OnAcquiredFn = OnDioWeaponUpgradeAcquired;
	Template.OnDisplayDescFn = OnDesc_Gauntlets;

	return Template;
}

//---------------------------------------------------------------------------------------
static function bool CanApplyUpgrade_Gauntlets(X2WeaponUpgradeTemplate UpgradeTemplate, XComGameState_Item Weapon, int SlotIndex)
{
	local array<name> CurrentUpgrades;

	CurrentUpgrades = Weapon.GetMyWeaponUpgradeTemplateNames();
	// Can't dupe
	if (CurrentUpgrades.Find(UpgradeTemplate.DataName) != INDEX_NONE)
	{
		return false;
	}

	if (Weapon.GetWeaponCategory() == 'gauntlet')
	{
		return true;
	}

	return false;
}

//---------------------------------------------------------------------------------------
static function string OnDesc_Gauntlets(X2ItemTemplate ItemTemplate)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersDio DioHQ;
	local XComGameState_Unit Unit;
	local X2WeaponUpgradeTemplate SelfTemplate;
	local array<string> UnitStrings;
	local int i;

	SelfTemplate = X2WeaponUpgradeTemplate(ItemTemplate);
	if (SelfTemplate == none)
	{
		return "";
	}

	History = `XCOMHISTORY;
	DioHQ = `DIOHQ;

	for (i = 0; i < DioHQ.Squad.Length; ++i)
	{
		Unit = XComGameState_Unit(History.GetGameStateForObjectID(DioHQ.Squad[i].ObjectID));
		if (CanApplyUpgrade_Gauntlets(SelfTemplate, Unit.GetPrimaryWeapon(), 0) ||
			CanApplyUpgrade_Gauntlets(SelfTemplate, Unit.GetSecondaryWeapon(), 0))
		{
			UnitStrings.AddItem(Unit.GetNickName(true));
		}
	}
	for (i = 0; i < DioHQ.Androids.Length; ++i)
	{
		Unit = XComGameState_Unit(History.GetGameStateForObjectID(DioHQ.Androids[i].ObjectID));
		if (CanApplyUpgrade_Gauntlets(SelfTemplate, Unit.GetPrimaryWeapon(), 0) ||
			CanApplyUpgrade_Gauntlets(SelfTemplate, Unit.GetSecondaryWeapon(), 0))
		{
			UnitStrings.AddItem(Unit.GetNickName(true));
		}
	}

	if (UnitStrings.Length == 0)
	{
		return default.AgentsAffectedText $ ":" @ `DIO_UI.default.strTerm_None;
	}
	else
	{
		return default.AgentsAffectedText $ ":" @ class'UIUtilities_Text'.static.StringArrayToCommaSeparatedLine(UnitStrings);
	}
}

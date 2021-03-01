
//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_Sustain_LW.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: Making sustain chance rely on overkill damage
//---------------------------------------------------------------------------------------
class X2Effect_SustainingSphere_LW extends X2Effect_SustainingSphere config(GameData_SoldierSkills);

var config array<name> SUSTAINTRIGGERUNITCHECK_LW_ARRAY;
var config array<int> SUSTAIN_ACT_PCT_CHANCE;

function bool PreDeathCheck(XComGameState NewGameState, XComGameState_Unit UnitState, XComGameState_Effect EffectState)
{
	local UnitValue SustainValue;
	local int Index, PercentChance, RandRoll;
	local UnitValue OverKillDamage;
    local XComGameState_MissionSite MissionSite;
    local int Act;

	if (!UnitState.IsAbleToAct(true))
	{
		// Stunned units may not go into Sustain
		return false;
	}

	if (UnitState.GetUnitValue(default.SustainUsed, SustainValue))
	{
		if (SustainValue.fValue > 0)
			return false;
	}
        
	UnitState.GetUnitValue('LastOverkillDamage', OverKillDamage);

	Index = default.SUSTAINTRIGGERUNITCHECK_LW_ARRAY.Find(UnitState.GetMyTemplateName());

	// If the Unit Type is not in the array, then it always triggers sustain
	if (Index != INDEX_NONE)
	{
        MissionSite = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(`DIOHQ.MissionRef.ObjectID));
        Act = MissionSite.MissionDifficultyParams.Act;
    
		PercentChance = 100 - (SUSTAIN_ACT_PCT_CHANCE[Act] * OverKillDamage.fValue);


		RandRoll = `SYNC_RAND(100);
		if (RandRoll >= PercentChance)
		{
			// RandRoll is greater or equal to the percent chance, so sustain failed
			return false;
		}
	}

	UnitState.SetUnitFloatValue(default.SustainUsed, 1, eCleanup_BeginTactical);
	UnitState.SetCurrentStat(eStat_HP, 1);
	`XEVENTMGR.TriggerEvent(default.SustainEvent, UnitState, UnitState, NewGameState);
	return true;
}

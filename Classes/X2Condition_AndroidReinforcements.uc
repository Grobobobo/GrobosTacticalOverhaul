class X2Condition_AndroidReinforcements extends X2Condition;

event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{
	local XComGameState_Unit UnitState;
	local int LivingUnitCount;
    local int AvailableAndroidCount;
    local XComGameState_BattleData BattleData;

    LivingUnitCount = 0;
    foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		if (UnitState.IsAlive() && !UnitState.IsUnconscious() && !UnitState.IsUnitAffectedByEffectName(class'X2StatusEffects'.default.BleedingOutName) && !UnitState.bRemovedFromPlay
            && UnitState.GetTeam() == eTeam_XCom && !UnitState.IsCivilian())
		{
			LivingUnitCount++;
		}
	}
    BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData', false));

    AvailableAndroidCount = BattleData.StartingAndroidReserves.length - BattleData.SpentAndroidReserves.length;

	if(class'XComBreachHelpers'.default.NormalSquadSize - LivingUnitCount > 0 && AvailableAndroidCount >0)
    {
        return 'AA_Success';
    }
    else
    {
        return 'AA_AbilityUnavailable';
    }

}



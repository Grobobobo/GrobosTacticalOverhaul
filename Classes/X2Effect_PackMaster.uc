//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_FreeGrenades.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: Makes throwing grenades a free action
//--------------------------------------------------------------------------------------- 

class X2Effect_PackMaster extends X2Effect_Persistent config (GameData_SoldierSkills);


function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager			EventMgr;
	local XComGameState_Unit		UnitState;
	local Object					EffectObj;

	EventMgr = `XEVENTMGR;
	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	EventMgr.RegisterForEvent(EffectObj, 'PackMasterTrigger', EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted, , UnitState);
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local XComGameState_Item	SourceWeapon;
    local int iUsesThisTurn;
    local UnitValue PMUsesThisTurn;
	local XComGameState_Ability AbilityState;
	if (kAbility == none)
    {
        return false;
    }

	SourceWeapon = kAbility.GetSourceWeapon();


    SourceUnit.GetUnitValue ('PackMasterUses', PMUsesThisTurn);
	iUsesThisTurn = int(PMUsesThisTurn.fValue);

	if (iUsesThisTurn > 0)
    {
        return false;

    }

	if (SourceWeapon.InventorySlot == eInvSlot_Utility)
	{
		if (SourceUnit.ActionPoints.Length != PreCostActionPoints.Length)
		{

			AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
            SourceUnit.SetUnitFloatValue ('PackMasterUses', 1.0, eCleanup_BeginTurn);
			SourceUnit.ActionPoints = PreCostActionPoints;
			`XEVENTMGR.TriggerEvent('PackMasterTrigger', AbilityState, SourceUnit, NewGameState);

			return true;
		}
	}
	return false;
}

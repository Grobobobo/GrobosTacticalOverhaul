//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_WilltoSurvive
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up bonus armor from W2S
//--------------------------------------------------------------------------------------- 

class X2Effect_WilltoSurvive extends X2Effect_BonusArmor config (GameData_SoldierSkills);

var config float WTS_COVER_DR_PCT;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	local XComGameState_Unit					Target;
	local GameRulesCache_VisibilityInfo			MyVisInfo;
	local array<GameRulesCache_VisibilityInfo>	VisInfoArray;
	local X2AbilityToHitCalc_StandardAim		StandardHit;
	local XComGameStateContext_Ability			AbilityContext;
	local Vector								SourceLocation;
	local int									k;
	local XComGameStateHistory					History;	
	local X2AbilityTarget_Cursor				TargetStyle;
	local X2AbilityMultiTarget_Radius			MultiTargetStyle;
	local array<name> IncomingTypes;

	WeaponDamageEffect.GetEffectDamageTypes(NewGameState, AppliedData, IncomingTypes);

	if (IncomingTypes.Find('Melee') != INDEX_NONE)
	{
		return 0;
	}


	Target = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	StandardHit = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);	
	TargetStyle = X2AbilityTarget_Cursor(AbilityState.GetMyTemplate().AbilityTargetStyle);
	MultiTargetStyle = X2AbilityMultiTarget_Radius(AbilityState.GetMyTemplate().AbilityMultiTargetStyle);
	AbilityContext=class'XComGameStateContext_Ability'.static.BuildContextFromAbility(AbilityState, EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID);
	if((StandardHit != none && StandardHit.bIndirectFire) || (TargetStyle != none && MultiTargetStyle != none))
	{
		History = `XCOMHISTORY;
		SourceLocation = AbilityContext.InputContext.ProjectileTouchEnd;				
		class'X2TacticalVisibilityHelpers'.static.GetAllVisibleEnemiesForLocation(SourceLocation, Attacker.ControllingPlayer.ObjectID, VisInfoArray, true);
		for( k = 0; k < VisInfoArray.Length; ++k )
		{
			if (XComGameState_Unit(History.GetGameStateForObjectID(VisInfoArray[k].SourceID,,-1)) == Target)
			{
				MyVisInfo = VisInfoArray[k];	
				break;
			}
		}
		if (MyVisInfo.TargetCover == CT_None)
			return 0;
		if (MyVisInfo.TargetCover == CT_Midlevel || MyVisInfo.TargetCover == CT_Standing)
        return -(CurrentDamage * WTS_COVER_DR_PCT);
	}
	else
	{
		if(X2TacticalGameRuleset(XComGameInfo(class'Engine'.static.GetCurrentWorldInfo().Game).GameRuleset).VisibilityMgr.GetVisibilityInfo(Attacker.ObjectID, Target.ObjectID, MyVisInfo))
		{
            if (MyVisInfo.TargetCover == CT_None)
			return 0;
            if (MyVisInfo.TargetCover == CT_Midlevel || MyVisInfo.TargetCover == CT_Standing)
            return -(CurrentDamage * WTS_COVER_DR_PCT);
		}
	}
    return 0;     
}

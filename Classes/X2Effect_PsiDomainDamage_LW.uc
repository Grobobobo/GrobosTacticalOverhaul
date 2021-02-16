class X2Effect_PsiDomainDamage_LW extends X2Effect_Persistent config(GameData_SoldierSkills);

var config int BonusPsiDamage_Act1;
var config int BonusPsiDamage_Act2;
var config int BonusPsiDamage_Act3;

var localized string PsiDomainDamageName;
var localized string PsiDomainDamageName_Removed;

function bool IsPsiDamage( X2EffectTemplateRef EffectRef )
{
	local X2Effect_ApplyWeaponDamage DamageEffect;

	DamageEffect = X2Effect_ApplyWeaponDamage(class'X2Effect'.static.GetX2Effect(EffectRef));
	if( DamageEffect != none && DamageEffect.EffectDamageValue.DamageType == 'Psi')
	{
		return true;
	}
	return false;
}

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local int ExtraDamage;
	local XComGameState_MissionSite MissionSite;
	local int Act;

    MissionSite = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(`DIOHQ.MissionRef.ObjectID));
	Act = MissionSite.MissionDifficultyParams.Act;
	if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
	{
		//	no game state means it's for damage preview
		if( IsPsiDamage(AppliedData.EffectRef) )
		{
            switch(Act)
            {
                case 3:
                    ExtraDamage = default.BonusPsiDamage_Act3;
                    break;
                case 2:
                    ExtraDamage = default.BonusPsiDamage_Act2;
                    break;
                default:
                    ExtraDamage = default.BonusPsiDamage_Act1;
                    break;
            }
            
            if (NewGameState == none)
            {				
                return ExtraDamage;
            }
                
		}
	}
	return ExtraDamage;
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack, name EffectApplyResult)
{
	local XComGameState_Unit UnitState;

	if (EffectApplyResult == 'AA_Success')
	{
		UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);
		if (UnitState != None)
		{


			//class'X2StatusEffects'.static.AddEffectCameraPanToAffectedUnitToTrack(BuildTrack, VisualizeGameState.GetContext());
			class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(BuildTrack, VisualizeGameState.GetContext(), PsiDomainDamageName, '', eColor_Good);

		}
	}

	super.AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, EffectApplyResult);
}

simulated function AddX2ActionsForVisualization_Removed(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult, XComGameState_Effect RemovedEffect)
{
	local XComGameState_Unit UnitState;

	super.AddX2ActionsForVisualization_Removed(VisualizeGameState, ActionMetadata, EffectApplyResult, RemovedEffect);

	UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);
	if (UnitState != none && UnitState.IsAlive() )
	{
		class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(ActionMetadata, VisualizeGameState.GetContext(), PsiDomainDamageName_Removed, '', eColor_Bad,,2.0f);
		class'X2StatusEffects'.static.UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
	}
}
defaultproperties
{
	bDisplayInSpecialDamageMessageUI = true
}

/*
	This class removes FillRequiresLOSToTargetLocation, which eliminates the buggy unreliable smoke problem.
	The smoke actually still requires LOS because that is handled by the targeting method (or MultiTarget_Radius, not sure).
*/
class X2Effect_ApplySmokeGrenadeToWorld_NoLOS extends X2Effect_ApplySmokeGrenadeToWorld;

event array<ParticleSystem> GetParticleSystem_Fill()
{
	local array<ParticleSystem> ParticleSystems;
	ParticleSystems.AddItem(none);
	ParticleSystems.AddItem(ParticleSystem(DynamicLoadObject(class'X2Effect_ApplySmokeGrenadeToWorld'.default.SmokeParticleSystemFill_Name, class'ParticleSystem')));
	return ParticleSystems;
}

static simulated function bool FillRequiresLOSToTargetLocation( ) { return false; }

static simulated function int GetTileDataNumTurns() 
{ 
	return class'X2Effect_ApplySmokeGrenadeToWorld'.default.Duration; 
}

defaultproperties
{
	bCenterTile = true;
}
class X2Effect_ApplySmokeBreachBombToWorld_LW extends X2Effect_ApplySmokeBreachBombToWorld config(GameData);

event array<X2Effect> GetTileEnteredEffects()
{
	local array<X2Effect> TileEnteredEffects;
	
	TileEnteredEffects.AddItem(class'X2StatusEffects'.static.CreateShroudedStatusEffect());

	return TileEnteredEffects;
}

static simulated function int GetTileDataNumTurns() 
{ 
	return 1; 
}
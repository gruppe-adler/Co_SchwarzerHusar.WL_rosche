class CfgFunctions
{
	class RCA3
	{
		class AI_Driving_Control
		{
			tag = "AI_Driving_Control";
			class AIDCinit
			{
				file = "USER\aidrivingcontrol\fn_aidrivingcontrol.sqf";
				preInit = 1;
			};
			class VehiclesAround
			{
				file = "USER\aidrivingcontrol\functions\fn_vehiclesaround.sqf";
			};
			class VehiclesFront
			{
				file = "USER\aidrivingcontrol\functions\fn_vehiclesfront.sqf";
			};
			class VehiclesSort
			{
				file = "USER\aidrivingcontrol\functions\fn_vehiclessort.sqf";
			};
		};
	};
};
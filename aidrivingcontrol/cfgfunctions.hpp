
class RCA3
{
	class AI_Driving_Control
	{
		tag = "RCA3";
		class AIDCinit
		{
			file = "aidrivingcontrol\fn_aidrivingcontrol.sqf";
			preInit = 1;
		};
		class VehiclesAround
		{
			file = "aidrivingcontrol\functions\fn_vehiclesaround.sqf";
		};
		class VehiclesFront
		{
			file = "aidrivingcontrol\functions\fn_vehiclesfront.sqf";
		};
		class VehiclesSort
		{
			file = "aidrivingcontrol\functions\fn_vehiclessort.sqf";
		};
	};
};
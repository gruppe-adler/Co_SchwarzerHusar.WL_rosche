/*
	AI Driving Control v2.4

	Author:
	RCA3

	Description:
	Gives more control to AI drivers.
	Script uses nearEntities to find vehicles/men, calculates relative angles to nearest one and applies forceSpeed depending on situation.
	Use "STEALTH" behaviour to temporarily bypass the script.

	Features:
	AI will brake and speed up for vehicles ahead.
	AI gives way to vehicles approaching from the right.
	Pedestrians have priority over vehicles.
	Pedestrians on road are overtaken or followed if directly in front of vehicle.
	Infantry (not civilians) offroad will be followed on a wider angle than on roads.
	Works on and offroad.
	Have less (not avoid) crashes.
	Engines turn off on idle if at final waypoint.
	Vehicles on "STEALTH" behaviour bypass code until behaviour changes (setBehaviour, etc.).
	Bypass script entirely on a vehicle's init with "this setVariable ["NOAIDRIVINGCONTROL", true, true]".
	For a convoy use "(object) limitSpeed (km/h)" on lead vehicle.
	Gates ("Land_BarGate_F") are detected when closed. Note: place gates BEFORE AI driver gets in vehicle/spawn/zeus/etc. i.e. not scanned in realtime.
	As a bonus, gates ("Land_BarGate_F") are made indestructible (by tanks as well unfortunately).

	Usage:
	Works with placed and spawned vehicles, single player and dedicated server.
	Clients with AI drivers must be running the addon.
	For Zeus, the player being Zeus must be running the addon.
	Does not cause dependency on missions.

	Notes:
	Vehicles moving over ~80Km/h will not have time to react. Use "car limitSpeed 80". * Might have increased since version 2.0.
	Any forceSpeed command (on affected land vehicles) will be overwritten by script.

	Known issues:
	When confronted with large groups of pedestrians, vehicles occasionally  stall.
	Quadbikes are not detected by other vehicles on road (@BI: they always report "isOnRoad false"). Are detected offroad.
	Does not work on ALiVE vehicles.
	Incompatible with TPW SANITY (uses forceSpeed as well).

	License:
	Non Military - You may not use this material as a whole or any part of this material for military purposes.
	No Monetization - You may not use this material as a whole or any part of this material on monetized servers.

	Attribution - You must attribute the material in the manner specified by the author or licensor (but not in any way that suggests that they endorse you or your use of the material).
	Noncommercial - You may not use this material for any commercial purposes.
	Arma Only - You may not convert or adapt this material to be used in other games than Arma.
	No Derivatives - If you remix, transform, or build upon the material, you may not distribute the modified material.

	Arma Public License No Derivatives (APL-ND)
	https://www.bohemia.net/community/licenses/arma-public-license-nd

	Credits:
	Bohemia Interactive
	BI Arma Forum Contributors
	Wikipedia
	BI Wiki Code Optimisation author(s) https://community.bistudio.com/wiki/Code_Optimisation
	3 1 A Measure of Relative Direction https://www.youtube.com/watch?v=uDwP4T7bPSY

	Thanks to:
	Armaholic.com
	Kremator for testing with tanks.

	Changelog:
	v2.4 - Added: New timeout system which starts only if crossing vehicle ahead is not moving. Results in much smoother traffic.
	       Fixed: Oncoming traffic was being evaluated as crossing (delaying traffic). Oncoming traffic vehicle rotation is now <45º, more is considered crossing.
	       Released: Script version.
	       Added: New server key.

	v2.3.1 - Hotfix: FSM was running on every vehicle's passenger.

	v2.3 - Changed: Passed main function and parts of code to CfgFunctions.
	       Changed: Code optimized when vehicle is stopped by vehicle/man ahead to ~0.19ms (benchmark) no matter how many vehicles/men around.
	       Changed: Optimized vehicles array sorting.
	       Changed: Vehicles stop on initialization while scanning for bargates.
	       Changed: Engine off on idle moved to separate FSM resulting on optimization to ~0.37ms (benchmark) for 10x men/cars scan.
	       Tweaked: Optimized main branch.
	       Fixed: On road vehicles were evaluating offroad vehicles.
	       Removed: Unnecessary BIS_fnc_getAngleDelta call removed.
	       Removed: Duplicated getDir removed.
	       Tweaked: Front buffer increased by 5 meters.
	       Tweaked: Give way right traffic timeout decreased back to 10 seconds.
	       Added: New server key.

	v2.02.2 - Hotfix: Vehicles weren't resuming after opening gates.

	v2.02.1 - Fixed: Vehicles relative position was being wrongfully checked according to their internal direction. Improves overall traffic and convoy behaviour.
	          Tweaked: Added one more distance check increasing pedestrians safety.
	          Tweaked: Give way right traffic timeout increased from 10 to 30 seconds.
	          Tweaked: Minimum scan radius increased to 50 meters.

	v2.02 - Changed: Reverted to civilian vehicle convoys offroad being possible as of v1.01. 15 meters width (overtake) buffer for all vehicles.

	v2.01.3 - Fixed: Minor fix where offroad vehicles could be following without proper angle.

	v2.01.2 - Fixed: On road vehicles were following offroad vehicles.

	v2.01.1 - Tweaked: Applied Pythagorean theorem to civilians buffer. It's a safer distance.

	v2.01 - Changed: AI tries to bypass civilians up until the last moment. Infantry are (still) followed at a more respectable distance.
	        Tweaked: Buffer width offroad is now 10 meters instead of 15 meters for infantry.

	v2.0 - Changed: Addon name changed from Road Control AI Addon to AI Driving Control.
	       [Warning] Changed: Variable to disable script is now "NOAIDRIVINGCONTROL".
	       Added: Scan radius is now dynamic with vehicle speed. Should increase performance.
	       Fixed: Maintain speed of front.

	v1.02 - Tweaked: Code optimized from ~0.49ms to ~0.38ms for 10 men/cars scan.
	        Added: Maintain speed of front.
	        Tweaked: Buffer width is now 15 meters on and offroad except for civilians. Offroad mil vehicles keep convoy, civs are overtaken.
	        Added: Demo missions.

	v1.01 - Tweaked: Wider offroad buffer now affected by military personnel only.
*/
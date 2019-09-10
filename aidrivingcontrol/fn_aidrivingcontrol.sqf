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

params ["_car", "_role", "_driver"];

//Exit non-wheeled, non-driver, player as driver, NOAIDRIVINGCONTROL variable and non-local drivers
if (!(_car isKindOf "Car" || _car isKindOf "Motorcycle" || _car isKindOf "Tank") || {!(_role isEqualTo "driver")} || {isPlayer _driver} || {_car getVariable "NOAIDRIVINGCONTROL"} || {!(local _driver)}) exitWith{};

private _carbb = 0 boundingBoxReal _car;
private _carp1 = _carbb select 0;
private _carp2 = _carbb select 1;
private _carwidth = (abs ((_carp2 select 0) - (_carp1 select 0))) / 2; //half width
private _carlength = (abs ((_carp2 select 1) - (_carp1 select 1))) / 2; //half length

#define BUFFER (15 + (_carlength*8))
#define SLEEPT 0.2

private _stopcar = objNull;
private _stopbuffer = 0;
private _t = 0;

private _groupcar = group _car;

private _frontcar = objNull;
private _dist = 0;
private _carfrontpos = [0,0,0];
private _cardir = 0;

private _scan = false;

//Gates
_car forceSpeed 0; //wait for objects scan
private _gates = [];
{_gates pushBack _x; sleep 0.2}forEach allMissionObjects "Land_BarGate_F";

//DEBUG
private _debug = false;
if (_debug) then{RCarrow = "Sign_Arrow_Large_F" createVehicle [0,0,0]; RCarrow setPos (getPos _car)};

while {canMove _car && alive _driver && _driver isEqualTo (driver (objectParent _driver))} do{
	_carfrontpos = _car modelToWorld [0,_carlength,0]; //position of front of vehicle (hood)
	_cardir = getDir _car;

	//Find front car
	if (isNull _stopcar) then{
		//All vehicles around
		private _carsarray = [_car, _gates] call RCA3_fnc_vehiclesaround;

		//Vehicles relative direction front
		if (count _carsarray > 0) then{
			private _carsinfrontarray = [_cardir, _carfrontpos, _carsarray] call RCA3_fnc_vehiclesfront;

			//Nearest vehicle in front
			if (count _carsinfrontarray > 0) then{
				//Sort front cars
				private _carsinfrontsorted =  [_carsinfrontarray, _carfrontpos] call RCA3_fnc_vehiclessort;

				//Front car and front car distance
				_dist = (_carsinfrontsorted select 0) select 0;
				_frontcar = (_carsinfrontsorted select 0) select 1;

				_scan = true;
			}else{
				_scan = false;
			};
		}else{
			_scan = false;
		};
	}else{
		_scan = [false, true] select (cos ((_carfrontpos getDir _stopcar) - _cardir) > 0); //Vehicle in front

		if (_scan) then{
			//Stop car
			_frontcar = _stopcar;
			_dist = _carfrontpos distance2D _frontcar;
		};
	};

	if (_scan && {!((behaviour _driver) isEqualTo "STEALTH")}) then{ //Scan and bypass scan on STEALTH
		switch (true) do{
			//Gates
			case (_frontcar isKindOf "Land_BarGate_F"):{
				if (_debug) then{hint str _frontcar};
				if (_frontcar animationPhase "Door_1_rot" < 1 && {damage _frontcar < 1}) then{ //There's a gate ahead lowered undamaged
					if (_dist > 15) then{ //BUFFER / 2
						_car forceSpeed 10; //slow down
						_stopcar = objNull;
					}else{
						_car forceSpeed 0; //stop
						_stopcar = _frontcar;
					};
				}else{
					//Speed up
					_car forceSpeed -1;
					_stopcar = objNull;
				};
			};

			//Men
			case (_frontcar isKindOf "Man"):{
				//Indoors check
				if (abs ((getPosATL _frontcar) select 2) > abs ((getPosATL _car) select 2)) exitWith{_car forceSpeed 10; _stopcar = objNull};

				private _onroad = isOnRoad _car;
				private _reldir = (_carfrontpos getDir _frontcar) - _cardir;
				private _heading = [abs _reldir, 360 - (abs _reldir)] select (abs _reldir > 180); //abs _reldir; if (_heading > 180) then{_heading = 360 - _heading};
				private _delta = abs round ([getDir _frontcar, _cardir] call BIS_fnc_getAngleDelta); //180º-0ºR -180º-0ºL
				private _speedfront = speed _frontcar / 3.6; //km/h > /m/s
				private _speed = -1;
				private _moving = !(_speedfront isEqualTo 0);
				private _seg = 2*_dist*(sin _heading/2); //chord length https://en.wikipedia.org/wiki/Circular_segment
				private _onroadfront = isOnRoad _frontcar;
				private _civfrontcar = (side _frontcar) isEqualTo civilian;
				private _bufferw = [_carwidth,10] select (!_onroad && !_onroadfront && !_civfrontcar);

				if (_dist > BUFFER / 2) then{
					if (_moving) then{
						if (_delta > 90) then{ //towards us (slow down)
							if (_seg > _bufferw * 2 && {_onroad}) then{ //outside wider buffer (road)
								_speed = 10; //approach faster
							}else{
								_speed = 5;
							};
						}else{ //away from us
							if (abs (_dist-(BUFFER / 2)) <= 5 && {_seg <= _bufferw}) then{ //following (5 meter buffer) //inside of buffer
								if (speed _car isEqualTo 0) then{sleep 2}; //let man move a bit further
								_speed = _speedfront;
							}else{ //outside buffer
								if (speed _car isEqualTo 0) then{sleep 2}; //let man move a bit further
								_speed = _speedfront + (_speedfront * 0.75); //approach
							};
						};
					}else{
						_speed = 10; //approach
					};
					_stopcar = objNull;
				}else{
					if (_seg > _bufferw * 2 && {_onroad}) then{ //outside wider buffer (road)
						_speed = 5; //bypass
						_stopcar = objNull;
					}else{
						if (_seg > _bufferw && {sqrt (_dist^2-_carwidth^2) > _bufferw}) then{ //outside buffer
							_speed = [3,_speedfront] select (_moving && _delta < 90);
							_stopcar = objNull;
						}else{ //inside buffer
							if (((_onroad && !_onroadfront) || _civfrontcar) && {sqrt (_dist^2-_carwidth^2) > _bufferw}) then{ //On road with man offroad on a curve or civilian on/offroad
								_speed = 3; //bypass slow
								_stopcar = objNull;
							}else{
								_speed = 0; //stop //end of line
								_stopcar = _frontcar;
							};
						};
					};
				};

				_car forceSpeed _speed;
				(group _driver) setCurrentWaypoint [(group _driver), currentWaypoint (group _driver)]; //Arma bug?

				if (_debug) then{
					RCarrow setPos (getPosATL _frontcar);
					//hint format["MEN:\ndst %1\nhdg: %2\nspeed: %3\nbuffer/2: %4\nseg: %5\nbufferw: %6\ndelta: %7\n%8\n%9\n%10\nstopcar: %11\nfrontcar: %12", _dist, round _heading, _speed, BUFFER/2, _seg, _bufferw, _delta, _speedfront, sqrt (_dist^2-_carwidth^2), BUFFER, _stopcar, _frontcar];
				};
			};

			//Cars
			case (_frontcar isKindOf "LandVehicle"):{
				//Bypass destroyed, empty or same group (not leader) car and on road vs offroad
				private _onroad = isOnRoad _car;
				if (!(canMove _frontcar) || {isNull (driver _frontcar)} || {(group _frontcar) isEqualTo _groupcar && (leader _groupcar) in _car} || {_onroad && {!(isOnRoad _frontcar)}}) exitWith{
					_car forceSpeed 5;
					_stopcar = objNull;
				};

				private _reldir = (_carfrontpos getDir _frontcar) - _cardir;
				private _heading = [abs _reldir, 360 - (abs _reldir)] select (abs _reldir > 180); //abs _reldir; if (_heading > 180) then{_heading = 360 - _heading};
				private _heading360 = [_reldir, 360 - abs _reldir] select (_reldir < 0); //_reldir; if (_heading360 < 0) then {_heading360 = 360 - abs _heading360};
				private _delta = [getDir _frontcar, _cardir] call BIS_fnc_getAngleDelta; //180º-0ºR -180º-0ºL
				private _speedfront = speed _frontcar / 3.6; //km/h > /m/s
				private _speed = -1;
				private _moving = !(_speedfront isEqualTo 0);
				private _seg = 2*_dist*(sin _heading/2); //chord length https://en.wikipedia.org/wiki/Circular_segment
				private _civfrontcar = (side _frontcar) isEqualTo civilian;

				if (abs _delta > 135) exitWith{ //oncoming traffic at <45º rotation
					_car forceSpeed 10;
					_stopcar = objNull;
				};

				if (abs _delta < 90 && {_heading < 45} && {_seg <= 15}) then{ //Facing both left and right 45º //inside of buffer
					if (_dist > BUFFER) then{
						if (_moving) then{
							_speed = _speedfront + (_speedfront * 0.25);
						}else{
							_speed = 20; //approach stopped
						};
						_stopcar = objNull;
					}else{
						if (_moving) then{
							_speed = [_speedfront, 0] select (abs (_dist - BUFFER) > 20); //BUFFER / 2
							_stopcar = [objNull, _frontcar] select (_speed isEqualTo 0); //move if buffer or stop if don't
						}else{
							_speed = 0; //stop
							_stopcar = _frontcar;
						};
					};
					_t = 0;
				}else{ //more than abs 45º
					if (_heading360 < 180) then{ //right
						if (_dist > BUFFER / 2) then{ //slow down
							_speed = 20; //approach
							_t = 0;
							_stopcar = objNull;
						}else{
							if (_delta < 0) then{ //frontcar facing left
								if (_seg > _carwidth * 8) then{ //move if carwidth
									_speed = 10;
									_t = 0;
									_stopcar = objNull;
								}else{
									_t = [_t + SLEEPT, 0] select _moving;
									if (_t < 5) then{ //timeout
										_speed = 0; //stop
										_stopcar = _frontcar;
									}else{
										_speed = 10; //bypass traffic jam slow
										_stopcar = objNull;
									};
								};
							}else{ //frontcar facing right
								if (_seg > _carwidth) then{ //move if carwidth
									_speed = 10;
									_t = 0;
									_stopcar = objNull;
								}else{
									_t = [_t + SLEEPT, 0] select _moving;
									if (_t < 3) then{ //timeout
										_speed = 0; //stop
										_stopcar = _frontcar;
									}else{
										_speed = 10; //bypass traffic jam slow
										_stopcar = objNull;
									};
								};
							};
						};
					}else{ //left
						if (_dist > BUFFER / 2) then{ //slow down
							_speed = 20; //approach
							_t = 0;
							_stopcar = objNull;
						}else{
							if (_delta < 0) then{ //frontcar facing left
								if (_seg > _carwidth * 8) then{ //move if carwidth //*4
									_speed = 10;
									_t = 0;
									_stopcar = objNull;
								}else{
									_t = [_t + SLEEPT, 0] select _moving;
									if (_t < 5) then{ //timeout
										_speed = 0; //stop
										_stopcar = _frontcar;
									}else{
										_speed = 10; //bypass traffic jam slow
										_stopcar = objNull;
									};
								};
							}else{ //frontcar facing right
								if (_seg > _carwidth) then{ //move if carwidth
									_speed = 10;
									_t = 0;
									_stopcar = objNull;
								}else{
									_t = [_t + SLEEPT, 0] select _moving;
									if (_t < 3) then{ //timeout
										_speed = 0; //stop
										_stopcar = _frontcar;
									}else{
										_speed = 10; //bypass traffic jam slow
										_stopcar = objNull;
									};
								};
							};
						};
					};
				};

				//Speed up
				_car forceSpeed _speed;

				//DEBUG
				if (_debug) then{
					RCarrow setPos (getPosATL _frontcar);
					hint format["CARS:\ndst %1\nhdg: %2\ndlt: %3\nfdlt: %4\nheading360: %5\nspeed: %6\nspeed front: %7\ndeltaroad: %8\nbuffer/2: %9\nseg: %10\nbufferw: %11\ncarwidth: %12\ntimeout: %13\nstopcar: %14\nfrontcar: %15\n%16\n%17", round _dist, round _heading, round _delta, 0, round _heading360, round _speed, round _speedfront, 90 , BUFFER / 2, _seg, 15, _carwidth, _t, _stopcar, _frontcar, round _dist mod round BUFFER];
				};
			};

			//Default
			default{
				//Speed up
				_car forceSpeed -1;
				_stopcar = objNull;
			};
		};
	}else{
		//Speed up
		_car forceSpeed -1;
		_stopcar = objNull;
	};

	sleep SLEEPT;
};

_driver forceSpeed -1;

if (_debug) then{deleteVehicle RCarrow};
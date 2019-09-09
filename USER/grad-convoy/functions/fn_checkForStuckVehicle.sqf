/*
	adapted from tankbuster BI Forums
*/

params ["_thisVeh"];

private _posASL = getPosASL _thisVeh;
private _pushdir = -10; //push backwards by default

if (
		(abs(speed _thisVeh) < 2) && 
		{ (_thisVeh getVariable ["GRAD_convoy_vehicleThinks", 0] != 0) } &&
		{ (alive (driver _thisVeh)) && (canMove _thisVeh) && ((fuel _thisVeh) > 0) } && 
		{ ((_thisVeh distance2D _posASL) < 8) } 
	) then
	{// vehicle is stuck
	if (
		(lineintersectssurfaces [
				_thisVeh modeltoworldworld [0,0,0.2], 
				_thisVeh modeltoworldworld [0,8,0.2], 
				_thisVeh
			]) isEqualTo []) then
		{//push it forwards a little
			_pushdir = 10;
		};
	_thisVeh setVelocityModelSpace [0,_pushdir,0];
	diag_log format ["*** pushing %1 a little", name driver _q];
	};

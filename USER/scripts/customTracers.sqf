params ["_dummy"];

systemChat "spawned";

private _green = "B_65x39_Case_green";
private _yellow = "B_65x39_Case_Yellow";
private _red = "B_65x39_Caseless";


[{
    params ["_args", "_handle"];
    _args params ["_dummy", "_green", "_yellow", "_red"];

    if (isNull _dummy) exitWith {
        [_handle] call CBA_fnc_removePerFrameHandler;
    };

    systemChat "firing";

    if (random 1 > 0.5) then {
        private _xVel = (floor (random 60)) * selectRandom [1,-1];
        private _yVel = (floor (random 60)) * selectRandom [1,-1];
        private _zVel = 70+ floor(random 100);

       
        private _projectile = createVehicle [_green,getPosATL _dummy, [],0, "CAN_COLLIDE"];
        _projectile setVelocity [_xVel+(random 1.5),_yVel+(random 1.5),_zVel+(random 1.5)];
    };
    
}, 0, [_dummy, _green, _yellow, _red]] call CBA_fnc_addPerFrameHandler;
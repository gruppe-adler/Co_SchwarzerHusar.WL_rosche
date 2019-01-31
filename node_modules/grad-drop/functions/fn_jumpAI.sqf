#include "..\component.hpp"

params ["_unit", "_plane"];

if (!local _unit) exitWith {};
if (hasInterface) exitWith {};

private _position = _plane getRelPos [13, ((random 30) - (random 60))];
private _zPos = getPos _plane select 2;
_position set [2, _zPos];
_unit setPos _position;
_unit enableAI "MOVE";
_unit enableAI "ANIM";
removeBackpack _unit;

[{
    params ["_unit", "_plane"];
    (toLower animationState _unit) in ["halofreefall_non","halofreefall_f","halofreefall_b"]
    }, {
    params ["_unit", "_plane"];
    _unit allowdamage false;

    _v1 = (random 20) + 70;
    _v1 = (getDir _plane) + (round (random 20) - 10);
    _unit setVelocity [_v1 * (sin _v1), _v1 * (cos _v1), 0 ];

    [{
        params ["_unit"];
        private _chute = createVehicle ['rhs_d6_Parachute', position _unit,[],0,'Fly'];
        _chute setPos position _unit;
        _unit moveIndriver _chute; 
        _chute allowDamage false;

    }, [_unit], 2] call CBA_fnc_waitAndExecute;

    _unit setVariable ["GRAD_drop_dropped", true];

    [{
        isTouchingGround _unit
    },{
        params ["_unit"];
        _unit allowdamage true;    
    }, [_unit]] call CBA_fnc_waitUntilAndExecute;

}, [_unit, _plane], 900, {}] call CBA_fnc_waitUntilAndExecute;
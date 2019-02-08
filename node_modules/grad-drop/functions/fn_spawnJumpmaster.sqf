#include "..\component.hpp"

params ["_plane"];

private _jm = (createGroup west) createUnit ["B_survivor_F", getPos _plane, [], 0, "CAN_COLLIDE"];

_jm allowDamage false;
_jm setBehaviour "SAFE";
{_jm disableAI _x} forEach ["MOVE","ANIM","AUTOTARGET"];

[_jm] call grad_drop_fnc_removeAllGear;


[_jm,"HubBriefing_loop"] call grad_drop_fnc_switchMove;

[{
    _this spawn {
        params ["_plane","_jm"];

        _jm attachTo [_plane,[ -1.25, 2.5, -4.8]];
        sleep 0.5;

        detach _jm;
        _jm setFormDir (getDir _plane) + 60;
        _jm setDir (getDir _plane) + 60;
        _jm setAnimSpeedCoef 0.8;

        [_jm,"InBaseMoves_HandsBehindBack1"] call grad_drop_fnc_switchMove;
        sleep 2;
        [_jm,"InBaseMoves_HandsBehindBack1"] call grad_drop_fnc_switchMove;
    };
}, [_plane,_jm], 2] call CBA_fnc_waitAndExecute;

_jm

#include "..\component.hpp"

params ["_units",["_plane",objNull]];

if (isNull _plane) exitWith {};
if (!hasInterface) exitWith {};
if ({local _x} count _units == 0) exitWith {};

private _fnc_create = {
    params ["_plane","_relPos"];

    private _light = "#lightpoint" createVehicle position _plane;
    _light setLightBrightness 0.2;
    _light setLightAmbient [0.3,0.3,0.3];
    _light setLightColor [0.5, 0.5, 0.7];
    _light lightAttachObject [_plane,_relPos];

    _light
};

_lightFront = [_plane,[0,-6.5,-2.3]] call _fnc_create;
_lightMid = [_plane, [0,-2,-2.3]] call _fnc_create;
_lightRear = [_plane, [0,3,-2.3]] call _fnc_create;

_plane setVariable ["grad_drop_lightStatus","DEFAULT",false];

[{(_this select 0) getVariable "grad_drop_lightStatus" == "RED"},{
    params ["_plane","_lights"];
    [_lights, [0.8, 0.07, 0.07], [0.3, 0.2, 0.2]] call grad_drop_fnc_setLights;
},[_plane,[_lightFront,_lightRear,_lightMid]],900,{{deleteVehicle _x} forEach (_this select 1)}] call CBA_fnc_waitUntilAndExecute;

[{(_this select 0) getVariable "grad_drop_lightStatus" == "GREEN"},{
    params ["_plane","_lights"];
    [_lights, [0.07, 0.4, 0.07], [0.2,0.3,0.2]] call grad_drop_fnc_setLights;
},[_plane,[_lightFront,_lightRear,_lightMid]],900,{{deleteVehicle _x} forEach (_this select 1)}] call CBA_fnc_waitUntilAndExecute;

[{(_this select 0) getVariable "grad_drop_lightStatus" == "DELETE"},{
    {deleteVehicle _x} forEach (_this select 1)
},[_plane,[_lightFront,_lightRear,_lightMid]],900,{{deleteVehicle _x} forEach (_this select 1)}] call CBA_fnc_waitUntilAndExecute;

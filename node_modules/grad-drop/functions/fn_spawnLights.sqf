#include "..\component.hpp"

params ["_plane"];

private _fnc_spawnLight = {
    params ["_plane","_class"];
    private _light = createVehicle [_class, [0,0,0], [], 0, "CAN_COLLIDE"];
    _light attachTo [_plane,[ 1.65 , 3.4, -3.1]];
    _light setDamage 1;
    _light enableSimulation false;
    detach _light;
    [_light, 90, 0] call BIS_fnc_setPitchBank;

    _light
};


private _white = [_plane,"PortableHelipadLight_01_white_F"] call _fnc_spawnLight;
private _green = [_plane,"PortableHelipadLight_01_green_F"] call _fnc_spawnLight;
private _red = [_plane,"PortableHelipadLight_01_red_F"] call _fnc_spawnLight;

_green hideObjectGlobal true;
_red hideObjectGlobal true;

[_white,_green,_red]

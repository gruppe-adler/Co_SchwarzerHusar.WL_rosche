#include "..\component.hpp"

params ["_source","_sound",["_units",[player]]];

if !(hasInterface) exitWith {};
if !(player in _units) exitWith {};

_source say3D _sound;
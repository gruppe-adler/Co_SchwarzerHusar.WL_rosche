#include "..\component.hpp"

params ["_light", "_light_color", "_light_ambi"];

if !(_light isEqualType []) then {_light = [_light]};

{
    _x setLightColor _light_color;
    _x setLightAmbient _light_ambi;
    false
} count _light;

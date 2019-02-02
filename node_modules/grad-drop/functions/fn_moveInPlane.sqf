#include "..\component.hpp"

params [["_plane",objNull],["_units",[]],["_giveParachute",false]];

_pos_unit_x = 0.6;
_pos_unit_y = -0.80; // -0.85
_pos_unit_c = 1;
_pos_count1 = 9;
_pos_count2 = 17;

if (count _units < 13) then {
   _pos_unit_y = -0.85;
   _pos_unit_x = -1;
   _pos_count1 = 6;
};


{
    _x allowDamage false;

    if (_pos_unit_c == _pos_count1) then {
        _pos_unit_y = 0.80; // 0.85
        _pos_unit_x = 0.6;
    };

    if (_pos_unit_c == _pos_count2) then {
        _pos_unit_y = 0;
        _pos_unit_x = 0.6;
    };

    // -4.9
    [_x,_plane,[ _pos_unit_y, _pos_unit_x, -4.8],_giveParachute] call grad_drop_fnc_moveInRemote;

    _pos_unit_c = _pos_unit_c + 1;
    _pos_unit_x = _pos_unit_x - 0.8; // 1.2;

    false
} count _units;

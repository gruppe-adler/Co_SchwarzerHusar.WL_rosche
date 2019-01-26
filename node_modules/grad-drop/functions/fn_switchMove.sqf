#include "..\component.hpp"

params [["_unit",objNull],["_anim",""]];

if (isRemoteExecuted || !isMultiplayer) then {
    if (isNull _unit || !alive _unit) exitWith {};
    _unit switchMove _anim;
} else {
    [_unit,_anim] remoteExec ["grad_drop_fnc_switchMove",0,true];
};

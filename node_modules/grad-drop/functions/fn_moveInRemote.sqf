#include "..\component.hpp"

params ["_unit","_object","_relPos","_giveParachute"];

if (!local _unit) exitWith {_this remoteExec ["grad_drop_fnc_moveInRemote",_unit,false]};

if (_giveParachute) then {
    if (isClass (configFile >> "CfgPatches" >> "zade_boc")) then {[_unit] call zade_boc_fnc_actionOnChest};
    removeBackpack _unit;
    _unit addBackpackGlobal "NonSteerable_Parachute_F";
};

_unit allowDamage false;

waitUntil { _object distance2D [0,0,0] > 1000 };

_unit attachTo [_object,_relPos];
detach _unit;

_object hideObject false;

_unit switchMove "AidlPknlMstpSnonWnonDnon_G01";
_unit disableAI "MOVE";
_unit disableAI "ANIM";

[_unit] call ace_weaponselect_fnc_putWeaponAway;
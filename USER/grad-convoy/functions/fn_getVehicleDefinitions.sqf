params ["_convoyID"];

private _definitions = [] call GRAD_convoy_fnc_userConvoys;
if ((count _definitions - 1) < _convoyID) exitWith {
	[]
};

(_definitions select _convoyID)
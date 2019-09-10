params ["_thisVeh", "_handle"];

// ensure convoy can always move, leading vehicle is first in array
if (!canMove _thisVeh || !alive _thisVeh || leader (group _thisVeh) getVariable ["GRAD_convoy_formationBroken", false]) exitWith {
    leader (group _thisVeh) setVariable ["GRAD_convoy_formationBroken", true];
    [_thisVeh] call GRAD_convoy_fnc_breakFormation;
    [_thisVeh] joinSilent grpNull;
};
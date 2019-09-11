params ["_vehicle"];


if (_vehicle isKindOf "Man") exitWith {};

private _loop = _vehicle getVariable ["GRAD_convoy_loop", -1];

// when loop was removed this had been running already
if (_loop < 0) exitWith {};
_vehicle setVariable ["GRAD_convoy_loop", -1];
[_loop] call CBA_fnc_removePerFrameHandler;


private _goLeft = (_forEachIndex mod 2 == 0);
private _dir = if (_goLeft) then { getDir _vehicle -10 } else { getDir _vehicle + 10 };
_vehicle limitSpeed 50;
private _ownPosition = getPos _vehicle;
private _targetPosition = _vehicle getPos [100, _dir];
// set speed
_vehicle move _targetPosition;
// systemChat "move";

systemChat format ["Defend %1 triggered", _vehicle];

[{
    params ["_vehicle"];
    
    private _group = (createGroup east);
    (driver _vehicle) enableAI "FSM";
    (driver _vehicle) enableAI "PATH";
    (driver _vehicle) setBehaviour "AWARE"; 
    (driver _vehicle) enableAI "autoCombat";
    (driver _vehicle) setCaptive false;
    private _crew = crew _vehicle;
    _crew joinSilent _group;

    _crew doFollow (driver _vehicle);

    _vehicle setVariable ["GRAD_convoy_formationBroken", true, true];

    private _cargo = assignedCargo _x;
    _cargo allowGetIn false;
    _cargo joinSilent _group;
    {
        _x action ["Eject", vehicle _x];
        unassignVehicle _x;
        [_x] allowGetIn false;

        _x setUnitPos "MIDDLE";
        _x setBehaviour "COMBAT"; // to force lights off
        _x setCombatMode "RED";  // disable him attacking
        _x enableAI "autoCombat";
        _x enableAI "TARGET";
        _x enableAI "AUTOTARGET";
        _x setSpeedMode "FULL";
    } forEach _cargo; // (crew _x); // cargo

    if (_vehicle isKindOf "Truck_F") then {

        {
            _x action ["Eject", vehicle _x];
            unassignVehicle _x;
            [_x] allowGetIn false;
            _x setUnitPos "MIDDLE";
            _x setBehaviour "COMBAT"; // to force lights off
            _x setCombatMode "RED";  // disable him attacking
            _x enableAI "autoCombat";
            _x enableAI "TARGET";
            _x enableAI "AUTOTARGET";
            _x setSpeedMode "FULL";
        } forEach crew _vehicle;
    };
}, [_vehicle], (random 3) + 2] call CBA_fnc_waitAndExecute;
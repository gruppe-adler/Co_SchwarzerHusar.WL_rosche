params ["_vehicle", "_index"];


if (_vehicle isKindOf "Man") exitWith {};

private _loop = _vehicle getVariable ["GRAD_convoy_loop", -1];

// when loop was removed this had been running already
if (_loop < 0) exitWith {};
_vehicle setVariable ["GRAD_convoy_loop", -1];
[_loop] call CBA_fnc_removePerFrameHandler;

private _numberInConvoy = _vehicle getVariable ["GRAD_convoy_vehicleNumber", 0];
private _goLeft = (_numberInConvoy mod 2 == 0);
private _dir = if (_goLeft) then { getDir _vehicle -10 } else { getDir _vehicle + 10 };
_vehicle limitSpeed 10;
private _ownPosition = getPos _vehicle;
private _targetPosition = _vehicle getPos [100, _dir];
// set speed
_vehicle move _targetPosition;
// systemChat "move";


systemChat format ["Defend %1 triggered", _index];

[{
    params ["_vehicle"];
    
    private _group = (createGroup east);
    (driver _vehicle) enableAI "FSM";
    (driver _vehicle) enableAI "PATH";
    (driver _vehicle) setBehaviour "AWARE"; 
    (driver _vehicle) enableAI "autoCombat";
    (driver _vehicle) setCombatMode "RED";
    (driver _vehicle) enableAI "TARGET";
    (driver _vehicle) enableAI "AUTOTARGET";

    (driver _vehicle) setCaptive false;
    private _crew = crew _vehicle;
    _crew joinSilent _group;

    _crew doFollow (driver _vehicle);

    _vehicle setVariable ["GRAD_convoy_formationBroken", true, true];

    private _cargo = assignedCargo _vehicle;
    _cargo allowGetIn false;
    _cargo joinSilent _group;
    {
        _x action ["Eject", _vehicle];
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

    // cargo exits completely, combat makes own groups
    if (_vehicle isKindOf "Truck_F" || _vehicle isKindOf "gm_wheeled_truck_base") then {
        {
            _x action ["Eject", _vehicle];
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
        [_group, _group, 150, 1, 0.1, true] call CBA_fnc_taskDefend;
    } else {
        [_vehicle] joinSilent (createGroup east);
        [_group, _group, 350, 20, true, false] call CBA_fnc_taskDefend;
    };  

}, [_vehicle], (random 3) + (0.1 * _index)] call CBA_fnc_waitAndExecute;
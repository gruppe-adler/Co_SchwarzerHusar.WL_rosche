params ["_convoy", "_waypoints"];

{
    private _vehicle = _x;
    private _goLeft = (_forEachIndex mod 2 == 0);
    private _dir = if (_goLeft) then { getDir _vehicle -10 } else { getDir _vehicle + 10 };
    _vehicle limitSpeed 50;
    private _ownPosition = getPos _vehicle;
    private _targetPosition = _vehicle getPos [100, _dir];
    // set speed
    _vehicle move _targetPosition;
    sleep (random .2);
    // systemChat "move";
} forEach _convoy;

systemChat "Defend convoy triggered";

[{
    params ["_convoy"];

    {
        private _group = (createGroup east);
        (driver _x) enableAI "FSM";
        (driver _x) enableAI "PATH";
        (driver _x) setBehaviour "AWARE"; 
        (driver _x) enableAI "autoCombat";
        (driver _x) setCaptive false;
        private _crew = crew _x;
        _crew joinSilent _group;

        _crew doFollow (driver _x);

        _x setVariable ["GRAD_convoy_formationBroken", true, true];

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

        if (_x isKindOf "Truck_F") then {

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
            } forEach crew _x;
        };

    } forEach _convoy;
}, [_convoy], 4] call CBA_fnc_waitAndExecute;
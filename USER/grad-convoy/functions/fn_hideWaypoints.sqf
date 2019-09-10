private _definitions = [] call GRAD_convoy_fnc_userConvoys;

{
    private _waypoints = _x select 0;
    private _startpoints = _x select 1 select 1;

    {
        private _wp = call compile _x;
        _wp hideObjectGlobal true;
    } forEach (_waypoints + _startpoints);

} forEach _definitions;
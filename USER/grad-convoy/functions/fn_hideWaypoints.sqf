private _definitions = [] call GRAD_convoy_fnc_userConvoys;

{
    private _waypointObjects = _x select 0;

    {
        private _wp = call compile _x;
        if (!isNull _wp) then {
            _wp hideObjectGlobal true;
        };
    } forEach _waypointObjects;

} forEach _definitions;
#include "..\component.hpp"

params ["_plane","_jm"];

{
    sleep (_x select 0);
    [_jm,_x select 1] call grad_drop_fnc_switchMove;
    false
} count [
    [3,"ACE_AmovPercMstpScapWnonDnon_AmovPercMstpSnonWnonDnon"],
    [2,"AmovPercMwlkSnonWnonDfl"],
    [2,"AmovPercMstpSnonWnonDnon_AmovPknlMstpSnonWnonDnon"]
];


_jm setFormDir (getDir _plane) + 17;
_jm setDir (getDir _plane) + 17;


{
    sleep (_x select 0);
    [_jm,_x select 1] call grad_drop_fnc_switchMove;
    false
} count [
    [3,"AidlPknlMstpSnonWnonDnon_G01"],
    [15,"AmovPknlMstpSnonWnonDnon_AmovPercMstpSnonWnonDnon"],
    [0.7,"AmovPercMwlkSnonWnonDb"],
    [2.33,"AmovPercMstpSnonWnonDnon_AmovPknlMstpSnonWnonDnon"],
    [2,"AidlPknlMstpSnonWnonDnon_G01"]
];

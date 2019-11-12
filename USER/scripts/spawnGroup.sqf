params ["_position"];

private _unitsToSpawn = [
"rhsgref_cdf_ngd_engineer",
"rhsgref_cdf_ngd_engineer",
"rhsgref_cdf_ngd_machinegunner",
"rhsgref_cdf_ngd_engineer",
"rhsgref_cdf_ngd_grenadier_rpg",
"rhsgref_cdf_ngd_engineer",
"rhsgref_cdf_ngd_medic",
"rhsgref_cdf_ngd_engineer"
];


private _group = (createGroup east);

{
  _group createUnit [_x, _position, [], 10, "NONE"];
} forEach _unitsToSpawn;

 // weird fuck
(units _group) joinSilent _group;


{
    _x addVest "rhs_6sh46";
    _x addBackpack "rhs_sidor";
} forEach units _group;
params ["_lastHeli"];

cutText ["", "BLACK OUT", 4];
sleep 4;


playMusic "LeadTrack04_F_Tacops";
STHud_UIMode = 0;
cutText ["", "BLACK IN", 8];

outro_speaker say3D ["gm_e57_test_near", 500];

private _filmgrain = ppEffectCreate ["FilmGrain",2000];  
_filmgrain ppEffectEnable true;  
_filmgrain ppEffectAdjust [0.3,0.3,0.12,0.12,0.12,true];  
_filmgrain ppEffectCommit 0;


private _camera = "camera" camCreate (position camOutroPos0);

_camera camCommand "inertia on";
_camera cameraEffect ["internal","back"];
_camera camPrepareFov 0.6;
_camera camPreparePos (position camOutroPos0);
_camera camPrepareTarget camOutroTarget0;
 preloadCamera (position camOutroPos0);
 waitUntil {
   camPreloaded _camera
 };
_camera camCommit 0;
sleep 3;
_camera camSetPos (position camOutroPos1);
_camera camSetTarget camOutroTarget1;
_camera camCommit 60;
sleep 30;

private _ctrlTWO = findDisplay 46 ctrlCreate ["RscStructuredText", -1];
_ctrlTWO ctrlSetPosition [ 
    safeZoneX + safeZoneW/2 - safeZoneW/2, 
    (safezoneY + safeZoneH)/5 + (safezoneY + safeZoneH)/8.5, 
    safezoneWAbs, 
    safeZoneH/10
];

_ctrlTWO ctrlSetStructuredText parseText "<t size='1' shadow='0' font='EtelkaMonospaceProBold' align='center' color='#ffffffff'>Celebrating 5 years of friendship<br/>Gruppe Adler invites to you the second part coming Summer 2020.</t>";
_ctrlTWO ctrlSetBackgroundColor [0, 0, 0, 0]; 
_ctrlTWO ctrlSetFade 1;
_ctrlTWO ctrlCommit 0;

[_ctrlTWO, 1.2, 5] spawn BIS_fnc_ctrlSetScale;

_ctrlTWO ctrlSetFade 0;
_ctrlTWO ctrlCommit 3;

sleep 30;
["BlackAndWhite", 25, false] call BIS_fnc_setPPeffectTemplate;
cutText ["", "BLACK OUT", 14];
sleep 14;

// ["DefaultMissionEnd", true, 0, false, true] spawn BIS_fnc_endMission;
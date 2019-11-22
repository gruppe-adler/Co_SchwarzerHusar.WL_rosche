params ["_lastHeli"];

cutText ["", "BLACK OUT", 4];
sleep 4;
diwako_dui_main_toggled_off = true;


playMusic "LeadTrack04_F_Tacops";
STHud_UIMode = 0;
cutText ["", "BLACK IN", 8];

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
 _camera camSetTarget camOutroTarget0;
_camera camCommitPrepared 0;
sleep 3;
_camera camSetPos (position camOutroPos1);
_camera camSetTarget camOutroTarget1;
_camera camSetFov 0.3;
_camera camCommit 30;
sleep 10;

private _ctrlTWO = findDisplay 46 ctrlCreate ["RscStructuredText", -1];
_ctrlTWO ctrlSetPosition [ 
    safeZoneX + safeZoneW/2 - safeZoneW/2, 
    (safezoneY + safeZoneH)/1.5, 
    safezoneWAbs, 
    safeZoneH/15
];

_ctrlTWO ctrlSetStructuredText parseText "<t size='1.5' shadow='0' font='EtelkaMonospaceProBold' align='center' color='#ffffffff'><br/>Celebrating 5 years of friendship.</t>";
_ctrlTWO ctrlSetBackgroundColor [0, 0, 0, 0.7]; 
_ctrlTWO ctrlSetFade 0;
_ctrlTWO ctrlCommit 0;

sleep 15;
["BlackAndWhite", 25, false] call BIS_fnc_setPPeffectTemplate;

_ctrlTWO ctrlSetStructuredText parseText "<t size='1.5' shadow='0' font='EtelkaMonospaceProBold' align='center' color='#ffffffff'><br/>Gruppe Adler invites to you the second part coming Summer 2020.</t>";
_ctrlTWO ctrlSetBackgroundColor [0, 0, 0, 0.7]; 
_ctrlTWO ctrlCommit 0;

_ctrlTWO ctrlSetFade 0;
_ctrlTWO ctrlCommit 3;

sleep 15;

cutText ["", "BLACK OUT", 14];
sleep 16;

["DefaultMissionEnd", true, 0, false, true] spawn BIS_fnc_endMission;
params ["_lastHeli"];

cutText ["", "BLACK OUT", 4];
sleep 4;

playMusic "LeadTrack04_F_Tacops";
STHud_UIMode = 0;
cutText ["", "BLACK IN", 8];

private _filmgrain = ppEffectCreate ["FilmGrain",2000];  
_filmgrain ppEffectEnable true;  
_filmgrain ppEffectAdjust [0.3,0.3,0.12,0.12,0.12,true];  
_filmgrain ppEffectCommit 0;


private _camera = "camera" camCreate (position camOutroPos0);
_camera camSetPos (position camOutroPos0);
_camera camCommand "inertia on";
_camera camSetTarget camOutroTarget0;
_camera cameraEffect ["internal","back"];
_camera camSetFov 0.6;
_camera camCommit 0;
_camera camSetPos (position camOutroPos1);
_camera camSetTarget camOutroTarget1;
_camera camCommit 5;
sleep 5;
["BlackAndWhite", 25, false] call BIS_fnc_setPPeffectTemplate;
_camera camSetTarget _lastHeli;
_camera camCommit 2;
_camera camSetPos (position camOutroPos2);
_camera camSetFov 0.6;
_camera camCommit 20;
sleep 20;
_camera camSetPos (position camOutroPos3);
_camera camSetTarget _lastHeli;
_camera camSetFov 0.8;
_camera camCommit 10;
sleep 12;
cutText ["", "BLACK OUT", 14];
sleep 14;

["DefaultMissionEnd", true, 0, false, true] spawn BIS_fnc_endMission;
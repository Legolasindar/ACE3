/*
 * Author: Garth 'L-H' de Wet
 * Sets the Dir and pitch of passed object
 *
 * Arguments:
 * 0: Explosive <OBJECT>
 * 1: Direction <NUMBER>
 * 2: Pitch <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_explosive, 150, 90] call ACE_Explosives_fnc_setPosition;
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_explosive", "_direction", "_pitch"];
TRACE_3("params",_explosive,_direction,_pitch);

if (isNull (attachedTo _explosive)) then {
    _explosive setDir _direction;
    if (_pitch != 0) then {
        [_explosive, _pitch, 0] call CALLSTACK(BIS_fnc_setPitchBank);
    };
} else {
    //Attaching to a vehicle (dirAndUp based on vehicle)
    _explosive setVectorDirAndUp [[0,0,1],[(sin _direction),(cos _direction),0]];
};

if (isServer) then {
    // Store the orientation to broadcast it later to JIP players
    GVAR(explosivesOrientations) pushBack [_explosive, _direction, _pitch];

    // This is a good time to filter the array and remove explosives that no longer exist
    GVAR(explosivesOrientations) = GVAR(explosivesOrientations) select {
        _x params ["_explosive"];
        (!isNull _explosive && {alive _explosive})
    };
    TRACE_1("setPosition",GVAR(explosivesOrientations));
};

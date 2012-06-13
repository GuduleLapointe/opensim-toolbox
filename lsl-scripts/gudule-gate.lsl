// Gudule's Gate 2.7
//
// Authors:    Olivier van Helden, Gudule Lapointe (Speculoos.net)
// http://www.speculoos.net/opensim-toolbox
// Reditribution, modification and use are authorized, provided that
// this disclaimer, the authors name and Speculoos web address stay in the redistributed code

// Advanced teleport script, configurable in two modes: touch and pass through (aka blam gate).
// Destination can be read from landmark or from prim description
//
// WARNING: Depends of following functions in server's config:
//    osTeleportAgent
//      osGetInventoryLandmarkParams
//
// Configuration:
// useLandmark = TRUE
//      REQUIRES: osGetInventoryLandmarkParams
//      Reads destination from landmark
//      If no landmark, or read error, fallback to ObjectName method
//      Otherwise, saves the destination and name in prim properties
//
// useObjectName = TRUE
//      Reads destination from prim description field
//      Formated in the form
//          grid.url:port:Region Name
//          example: speculoos.net:8002:Grand Place
//
// processCollision = TRUE
//      "Blam gate" effect (think about star gate)
//      Teleport occurs when avatar hits the object.
// processTouch = TRUE
//      Teleport occurs when avatar touches the object
// If both teleport methods are set to false, a clickable url is displayed in chat

integer useLandmark = TRUE;
integer useObjectName = TRUE;
integer processCollision = FALSE;
integer processTouch = TRUE;
string destinationHover = "";
integer removeOldLandmark = TRUE;

vector colorThisRegion = <0,1,0>;
vector colorOtherRegion = <1,1,1>;
vector colorInactive = <0.5,0.5,0.5>;
vector colorEmpty = <1,1,1>;

float alphaActive = 1.0;
float alphaEmpty = 0.0;
float alphaInactive = 0.5;

// Parameters below should not be modified
// I mean it

string internalUpdateMessage = "reset";
integer internalUpdateChannel = 17;
string destination;
string destinationName;
string destinationURL;
vector landingPoint = <128,128,30>;
vector landingLookAt = <1,1,1>;

key agentBeingTransferred;
list lastFewAgents;
string message;
string landmark;
string myGatekeeper;
string me;
integer debug = TRUE;

sayDebug(string str)
{
    if(debug == TRUE)
    {
        llOwnerSay(me + str);
    }
}

performTeleport( key avatar )
{
    integer CurrentTime = llGetUnixTime();
    integer AgentIndex = llListFindList( lastFewAgents, [ avatar ] );
    if (AgentIndex != -1)
    {
        integer PreviousTime = llList2Integer ( lastFewAgents, AgentIndex+1 );
        if (PreviousTime >= (CurrentTime - 5)) return;
        lastFewAgents = llDeleteSubList( lastFewAgents, AgentIndex, AgentIndex+1);
    }
    agentBeingTransferred=avatar;
    lastFewAgents += [ avatar, CurrentTime ];
    message = "Teleporting " + llKey2Name(avatar) + " to " + destinationName
    + " (" + destinationURL + ")";
    llWhisper(0, message);
    osTeleportAgent( avatar, destination, landingPoint, landingLookAt );
}

resetScript()
{
    if(llGetInventoryNumber(INVENTORY_LANDMARK) > 1 && removeOldLandmark)
    {
        llRemoveInventory(landmark);
    }
    llResetScript();
}

string strReplace(string str, string search, string replace) {
    return llDumpList2String(llParseStringKeepNulls((str),[search],[]),replace);
}

default
{
    on_rez(integer start_param)
    {
        resetScript();
    }
    changed(integer change)
    {
        if(change & CHANGED_OWNER)
            resetScript();
        if (change & CHANGED_REGION_START)
            resetScript();
        if (change & CHANGED_INVENTORY)
            resetScript();
    }
    state_entry()
    {
        me = "/me (" + llGetScriptName() + "): ";
        myGatekeeper = strReplace(osGetGridGatekeeperURI(), "http://", "");
        llSetAlpha(alphaActive, ALL_SIDES);
        llSetColor(colorInactive, ALL_SIDES);

        // Landmark read
        // Uncomment this section only if osGetInventoryLandmarkParams 
        // is implemented on your server
        
        // if (useLandmark && llGetInventoryName(INVENTORY_LANDMARK, 0)) {
        //     landmark = llGetInventoryName(INVENTORY_LANDMARK, 0);
        //     destination = osGetInventoryLandmarkParams(landmark, LANDMARK_ADDRESS);
        //     if (~llSubStringIndex(destination, "ERROR_")) {
        //         sayDebug(destination + " falling back to gatekeeper");
        //         destination = osGetInventoryLandmarkParams(landmark, LANDMARK_GATEKEEPER);
        //     }
        //     if (~llSubStringIndex(destination, "ERROR_")) {
        //         sayDebug(destination + ": Could not read landmark " + landmark
        //             + ", using last destination");
        //         destination = "";
        //     } else {
        //         destination = strReplace(destination, "http://", "");
        //         destinationName = landmark;
        //         destinationURL = osGetInventoryLandmarkParams(landmark, LANDMARK_URL);
        //         llSetObjectName(destinationName);
        //         llSetObjectDesc(destination);
        //     }
        //     llRemoveInventory(landmark);
        // }

        // End Landmark read

        if(destination == "" && useObjectName) {
            if(llGetObjectName() != "" & llGetObjectName() != "Primitive")
            {
                destinationName = llGetObjectName();
                if(llGetObjectDesc() != "")
                {
                    destination = llGetObjectDesc();
                } else {
                    destination = destinationName;
                }
            } else if(llGetObjectDesc() != "") {
                destination = llGetObjectDesc();
                destinationName = destination;
            }
            destinationURL = "secondlife://" 
                + strReplace(llEscapeURL(
                strReplace(destination, "http://", "")
                ), "%3A", ":" ) + "/";
        }
        destination = strReplace(destination, myGatekeeper + ":", "");
        destinationURL = strReplace(destinationURL, myGatekeeper + ":", "");
        if(destination == "" || destination == " ") {
                state empty;
        }
        if(~llSubStringIndex(destinationURL, "ERROR_"))
        {
            destinationURL = "secondlife://" 
                + strReplace(llEscapeURL(destination), "%3A", ":" ) + "/";
        }
        llMessageLinked(LINK_THIS, internalUpdateChannel, "reset", NULL_KEY);
        llSetText(destinationHover, <255,255,255>, 1);
        llSetStatus(STATUS_PHANTOM, FALSE);
        if(destination == llGetRegionName())
        {
            llSetColor(colorThisRegion, ALL_SIDES);
        } else {
            llSetColor(colorOtherRegion, ALL_SIDES);
        }
        if(llGetOwner() != (key)llGetParcelDetails(llGetPos(),[PARCEL_DETAILS_OWNER]))
        {
            state inactive;
        } else {
            message = destinationName + " gate activated ("+ destinationURL + ")";
            llWhisper(0, message);
        }
    }
    touch_start(integer num_detected)
    {
        key avatar = llDetectedKey(0);
        if(processTouch)
        {
            if(avatar != agentBeingTransferred)
            {
                performTeleport(avatar);
            }
            llSetTimerEvent(3);
        } else if(processCollision) {
            message = "Cross the gate to jump to " + destinationName;
            if(destinationURL != "")
            {
                message = message + "or click this link " + destinationURL;
            }
            llInstantMessage(avatar, message);
        } else {
            message = "Click " + destinationURL + "to jump to " + destinationName;
            llInstantMessage(avatar, message);
        }
    }
    collision_start(integer num_detected)
    {
        if(processCollision)
        {
            key avatar = llDetectedKey(0);
            llSetStatus(STATUS_PHANTOM, TRUE);
            if(avatar != agentBeingTransferred)
            {
                performTeleport(avatar);
            }
            llSetTimerEvent(3);
        }
    }
    timer()
    {
        agentBeingTransferred="";
        llSetTimerEvent(0);
        if(processCollision) {
            llSetStatus(STATUS_PHANTOM, FALSE);
        }
    }
}

state empty
{
    on_rez(integer start_param)
    {
        resetScript();
    }
    state_entry()
    {
        llSetColor(colorEmpty, ALL_SIDES);
        llSetAlpha(alphaEmpty, ALL_SIDES);
        llSetObjectName(" ");
        llMessageLinked(LINK_THIS, internalUpdateChannel, "reset", NULL_KEY);
    }
    changed(integer change)
    {
        if(change & CHANGED_OWNER)
            resetScript();
        if (change & CHANGED_REGION_START)
            resetScript();
        if (change & CHANGED_INVENTORY)
            resetScript();
    }
}
state inactive
{
    on_rez(integer start_param)
    {
        resetScript();
    }
    state_entry()
    {
        llSetColor(colorInactive, ALL_SIDES);
        llSetAlpha(alphaInactive, ALL_SIDES);
        sayDebug("Teleport can only work if object is owned by parcel owner");
    }
    touch_start(integer num_detected)
    {
        llInstantMessage(llDetectedKey(0), "Gate is disabled. Teleport can only work if object is owned by parcel owner");
    }
    changed(integer change)
    {
        if(change & CHANGED_OWNER)
            resetScript();
        if (change & CHANGED_REGION_START)
            resetScript();
        if (change & CHANGED_INVENTORY)
            resetScript();
    }
}

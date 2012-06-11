// Authors:	Olivier van Helden, Gudule Lapointe (Speculoos.net)
// http://www.speculoos.net/opensim-toolbox
// Reditribution, modification and use are authorized, provided that 
// this disclaimer, the authors name and Speculoos web address stay in the redistributed code

// Put this script in HUDs to ensure a safe position (ensures it is not hidden by a placement outside of the screen and keeps it at a reasonable margin from the borders)

float margin = 0.02;
float bottomBar = 0.04;

checkPosition()
{
    float y = 0;
    float z = 0;
    
    vector scale=llGetScale();
    integer point=llGetAttached();

    if(point==32 || point ==33 || point==34) // top
        z = - scale.z - margin;
    if(point==36 || point ==37 || point==38) // bottom
        z = scale.z + margin + bottomBar;
    if(point==34 || point==36) // left
        y = -scale.y / 2 -margin;
    if(point==32 || point==38)
        y = scale.y / 2 + margin;
    llSetPos(<0,y,z>);
}


default
{
    state_entry()
    {
        if(llGetAttached())
        {
            checkPosition();
        }
    }
    attach (key ownerID)
    {
        checkPosition();
    }
}
integer FRONT_FACE = 4;
integer FIRST_COLUMN = -25;
integer LAST_COLUMN = 25;
integer LOWERCASE = 3;
integer UPPERCASE = 1;
integer NUMERIC = -1;
integer SYMBOL = -3;

key ROBOTO_THIN = "b71200a2-e81a-a395-37e8-32da8d65671e";
key ROBOTO_LIGHT = "fa904b7a-7dcc-c3bd-99d9-b27a43bb9638";

integer FIRST_LOWERCASE_INDEX = 97;
integer LAST_LOWERCASE_INDEX = 122;
integer FIRST_UPPERCASE_INDEX = 65;
integer LAST_UPPERCASE_INDEX = 90;
integer FIRST_NUMERIC_INDEX = 48;    //Starts at 0
integer LAST_NUMERIC_INDEX = 57;     //Ends at 9

ChangeBlockTexture(string character, integer blockIndex)
{

}

integer GetASCINumber(string character) // 0 - 126 ASCII printable characters only
{
    return llBase64ToInteger(llStringToBase64(character)) >> 24; 
}

default
{
    state_entry()
    {
            /*
            llSetTextureAnim(FALSE, 
            FRONT_FACE, //Front face
            26, //Rows 
            4, //Columns 
            0, 
            0, 
            5);
            */
                    
            llSetLinkPrimitiveParamsFast(LINK_SET,
            [
            PRIM_TEXTURE, 
            FRONT_FACE, 
            ROBOTO_THIN, 
            <1/26.0, 1/4.0, 0.0>,   //Repeat
            <-25/52.0, UPPERCASE/8.0, 0.0>,   //Offset
            0.0
            ]);
    }
    
    touch_start(integer num_detected)
    {
        llOwnerSay((string) (GetASCINumber("1")));
        llOwnerSay((string) (GetASCINumber("9")));
        llOwnerSay((string) (GetASCINumber("0")));          
    }
}

integer FRONT_FACE = 4;
integer FIRST_TEXT_BLOCK = 2;
integer FIRST_COLUMN = -25;
//integer LAST_COLUMN = 25;
integer FIRST_ROW = 3;
//integer LAST_ROW = -3;
integer FIRST_ASCII = 32;
integer LAST_ASCII = 126;
integer TEXT_MAX_LENGTH = 20;
vector FONT_TEXTURE_REPEAT = <0.03846, 0.25, 0.0>; //<1/26.0, 1/4.0, 0.0>


/*Change these after import to SL main grid*/
key ROBOTO_THIN = "18ed2426-ba23-49ce-9f42-0ebb02e0721c"; 
key ROBOTO_LIGHT = "c62bcd6b-a67e-462b-b40f-1ea3ea1cff47";

vector GetRowColumnOffset(string character)
{
    integer asciiNumber = GetASCIINumber(character);
    
	//If asciiNumber is out of bound, set character to be space
    if(asciiNumber < FIRST_ASCII | asciiNumber > LAST_ASCII)
    {
        asciiNumber = FIRST_ASCII;
    }
    
    integer characterIndex = asciiNumber - FIRST_ASCII; //First character index = 0
    integer columnIndex = characterIndex % 26;
    integer rowIndex = characterIndex / 26;
    vector rowColumnOffset = ZERO_VECTOR;
    rowColumnOffset.x = (columnIndex * 2 + FIRST_COLUMN) / 52.0;
    rowColumnOffset.y = (-rowIndex * 2 + FIRST_ROW) / 8.0; 
    
    return rowColumnOffset;
}

//Returns ascii index of a character
integer GetASCIINumber(string character) //0 - 126 ASCII printable characters only
{
    return llBase64ToInteger(llStringToBase64(character)) >> 24; 
}

ChangeLinkedCharacter(string character, integer link_number)
{
    llSetLinkPrimitiveParamsFast(link_number,
    [
        PRIM_TEXTURE, 
        FRONT_FACE,
        ROBOTO_THIN,
        FONT_TEXTURE_REPEAT,                //Repeat
        GetRowColumnOffset(character),      //Offset
        0.0
    ]);
}

ResetTextDisplay()
{
    llSetLinkPrimitiveParamsFast(LINK_ALL_CHILDREN,
    [
        PRIM_TEXTURE, 
        FRONT_FACE,
        ROBOTO_THIN,
        FONT_TEXTURE_REPEAT,                //Repeat
        GetRowColumnOffset(" "),      		//Offset
        0.0
    ]);
}

ChangeTextDisplay(string text)
{       
    ResetTextDisplay();
     
    integer i = 0;
    for(i = 0; i < llStringLength(text) & i <= TEXT_MAX_LENGTH; i++)
    {
        string character = llGetSubString(text, i, i);
        ChangeLinkedCharacter(character, FIRST_TEXT_BLOCK + i);          
    }   
}

integer listenHandle; //For testing 

default
{
    state_entry()
    {            
         ChangeLinkedCharacter("=", LINK_ALL_CHILDREN);
         listenHandle = llListen(PUBLIC_CHANNEL, "", "", "");       
    }
    
    touch_start(integer num_detected)
    {
        
    }
    
    listen(integer channel, string name, key id, string message)
    {
        ChangeTextDisplay(message);
    } 
}

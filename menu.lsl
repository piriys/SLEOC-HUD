string VERSION = "1.0.2";
string ADD_API_URL = "http://crimsondash.com/sleoci/api/cardapi/addcard?";
string PREVIEW_API_URL = "http://crimsondash.com/sleoci/encryptedcard?";
string XOR_KEY = "SLEOC6411";
key OBJECT_KEY = NULL_KEY;
integer APP_KEY = 6411;
integer MENU_CHANNEL = 6411;
float TOUCH_HOLD_DELAY = 2.0;

string PROMPT = "--------------------------------\nRead Documentation at http://crimsondash.com/SLEOCi/Documentation/SLEOCi_Documentation.pdf";
list MAIN_OPTIONS = ["[Close]", "[Reset]", "Parameters", "Layout", "Preview"]; 
list LAYOUT_OPTIONS = ["video", "text", "mosaictext", "mosaiclist", "list", "hybridmosaic", "hybrid", "author"];
list LIST_OPTIONS = ["[Back]", "[Add]", "[Delete]"];
list FOOTER_OPTIONS = ["[Back]", "Show", "Hide"];

/*Menu States*/
integer MAIN = 101;
integer PARAMETERS = 102;

integer SET_CARD_TYPE = 201;
integer SET_PROFILE_IMAGE_URL = 202;
integer SET_IMAGE_URL_STRING = 203;
integer SET_TITLE = 204;
integer SET_NAME = 205;
integer SET_LOCATION = 206;
integer SET_VIDEO = 207;
integer SET_DESCRIPTION = 208;

integer SET_LEFT_FOOTER = 209;
integer SET_RIGHT_FOOTER = 210;
integer SET_SHOW_LEFT_FOOTER = 211;
integer SET_SHOW_RIGHT_FOOTER = 212;

integer LABEL_MENU = 301;
integer ITEM_MENU = 302;
integer IMAGE_URL_LIST_MENU = 303;

integer ADD_LABEL = 401;
integer ADD_ITEM = 402;
integer ADD_IMAGE_URL_LIST = 403;

integer DELETE_LABEL = 501;
integer DELETE_ITEM = 502;
integer DELETE_IMAGE_URL_LIST = 503;

integer listenHandle = 0;    
integer textboxHandle = 0;
integer currentState = 1;
list parameterOptions = [];

key requestCard;

//CARD \ PARAMETERS |PROFILE_IMAGE_URL  |LABEL  |ITEM       |IMAGE_URL(list)    |IMAGE_URL(string)  |TITLE  |NAME   |LOCATION |DESCRIPTION|
//------------------|-------------------|-------|-----------|-------------------|-------------------|-------|-------|---------|-----------|
//AUTHOR            |Y                  |       |           |                   |Y                  |       |Y      |Y        |Y          |
//HYBRID            |                   |       |           |                   |Y                  |       |       |         |Y          |
//HYBRID MOSAIC     |                   |       |           |Y                  |                   |       |       |         |Y          | 
//LIST              |                   |       |Y          |                   |                   |       |       |         |           |
//MOSAIC LIST       |                   |Y      |Y          |Y                  |                   |Y      |       |         |           |
//MOSAIC TEXT       |                   |       |           |Y                  |                   |Y      |       |         |Y          |
//TEXT              |                   |       |           |Y                  |                   |Y      |       |         |Y          |

/*Specific Card Parameters*/
string CARD_TYPE = "text";
string PROFILE_IMAGE_URL = "http://crimsondash.com/sleoci/Content/images/defaultprofileimage.png";
string IMAGE_URL_STRING = "http://crimsondash.com/sleoci/Content/images/defaultimage.png";
string TITLE = "Title";
string NAME = "Name";
string LOCATION = "Location";
string VIDEO = "4EvNxWhskf8";
string DESCRIPTION = "Description";

list LABEL = ["Label 1", "Label 2", "Label 3"];
list ITEM = ["Item 1", "Item 2", "Item 3"];
list IMAGE_URL_LIST = [
"http://crimsondash.com/sleoci/Content/images/defaultimage.png",
"http://crimsondash.com/sleoci/Content/images/defaultimage.png",
"http://crimsondash.com/sleoci/Content/images/defaultimage.png"];

/*Default Card Settings*/
string LEFT_FOOTER = "Left Footer";
string RIGHT_FOOTER = "Right Footer";
string SHOW_LEFT_FOOTER = "true";
string SHOW_RIGHT_FOOTER = "true";

/*Encryption Functions*/
string Xor(string data)
{
    return llXorBase64(llStringToBase64(data), llStringToBase64(XOR_KEY));
}
 
string Dexor(string data) 
{
    return llBase64ToString(llXorBase64(data, llStringToBase64(XOR_KEY)));
}

string EncryptCardParameters()
{
    string parameters = 
        "leftfooter=" + LEFT_FOOTER
        + "&rightfooter=" + RIGHT_FOOTER
        + "&showleftfooter=" + SHOW_LEFT_FOOTER
        + "&showrightfooter=" + SHOW_RIGHT_FOOTER;    
    
    if(CARD_TYPE == "author")
    {
        parameters += "&profileimageurl=" + PROFILE_IMAGE_URL;
        parameters += "&imageurl=" + IMAGE_URL_STRING;
        parameters += "&name=" + NAME;
        parameters += "&location=" + LOCATION;
        parameters += "&description=" + DESCRIPTION;                    
    }
    else if(CARD_TYPE == "hybrid")
    {
        parameters += "&imageurl=" + IMAGE_URL_STRING;                 
        parameters += "&description=" + DESCRIPTION;                    
    }
    else if(CARD_TYPE == "hybridmosaic")
    {  
        integer i = 0;
        for(i = 0; i < llGetListLength(IMAGE_URL_LIST); i++)
        {
            parameters += "&imageurl=" + llList2String(IMAGE_URL_LIST, i);
        }
        parameters += "&description=" + DESCRIPTION;                         
    }
    else if(CARD_TYPE == "list")
    {
        integer i = 0;        
        for(i = 0; i < llGetListLength(ITEM); i++)
        {
            parameters += "&item=" + llList2String(ITEM, i);
        }             
    }
    else if(CARD_TYPE == "mosaiclist")
    {
        integer i = 0;    
        for(i = 0; i < llGetListLength(LABEL); i++)
        {
            parameters += "&label=" + llList2String(LABEL, i);
        }                   
        for(i = 0; i < llGetListLength(ITEM); i++)
        {
            parameters += "&item=" + llList2String(ITEM, i);
        }  
        for(i = 0; i < llGetListLength(IMAGE_URL_LIST); i++)
        {
            parameters += "&imageurl=" + llList2String(IMAGE_URL_LIST, i);
        }  
        parameters += "&title=" + TITLE;                          
    }
    else if(CARD_TYPE == "mosaictext")
    {
        integer i = 0;        
        for(i = 0; i < llGetListLength(IMAGE_URL_LIST); i++)
        {
            parameters += "&imageurl=" + llList2String(IMAGE_URL_LIST, i);
        }    
        parameters += "&title=" + TITLE;     
        parameters += "&description=" + DESCRIPTION;                   
    }    
    else if(CARD_TYPE == "text")
    {
        parameters += "&title=" + TITLE;    
        parameters += "&description=" + DESCRIPTION;                
    }
    else if(CARD_TYPE == "video")
    {
        parameters += "&video=" + VIDEO;
    }
    
    string encryptedParameters = llEscapeURL(parameters);    
    return Xor(encryptedParameters);   
}

/*Menu Functions*/
MainMenu()
{
    currentState = MAIN;    
    llDialog(llGetOwner(), "Select options\n" + "Current layout: " + CARD_TYPE + "\n" + "Object Key: " + (string)OBJECT_KEY + "\n" +  PROMPT, MAIN_OPTIONS, MENU_CHANNEL);  
}

ParametersMenu()
{
    currentState = PARAMETERS;
    llDialog(llGetOwner(), "Select parameter to modify.\nParameters: \n" + llDumpList2String(parameterOptions, "\n") + "\n" + PROMPT, ["[Back]"] + parameterOptions, MENU_CHANNEL);         
}

ListMenu()
{
    string listType = "undefined";    
    list listParameter = [];
    
    if(currentState == LABEL_MENU)    
    {
        listType = "label";      
        listParameter = LABEL;
    }
    else if(currentState == ITEM_MENU)
    {
        listType = "item";  
        listParameter = ITEM;        
    }
    else if(currentState == IMAGE_URL_LIST_MENU)
    {
        listType = "image url";   
        listParameter = IMAGE_URL_LIST;            
    }
    llDialog(llGetOwner(), "Add or delete " + listType + " from list.\nCurrent parameter(s):\n" + llDumpList2String(listParameter, "\n") + "\n" + PROMPT, LIST_OPTIONS, MENU_CHANNEL); 
}

AddToList()
{
    string listType = "undefined";            
    if(currentState == ADD_LABEL)    
    {
        listType = "label";                
    }
    else if(currentState == ADD_ITEM)
    {
        listType = "item";                    
    }
    else if(currentState == ADD_IMAGE_URL_LIST)
    {
        listType = "image url";                    
    }
    llTextBox(llGetOwner(), "Input new " + listType + ". Leave textbox field empty to cancel.\n", MENU_CHANNEL);   
}

ShowFooterMenu()
{
    string footerSide = "undefined";       
    string currentVisibility = "undefined";
    if(currentState == SET_SHOW_LEFT_FOOTER)    
    {
        footerSide = "left";
        currentVisibility = SHOW_LEFT_FOOTER;
    }
    else if(currentState == SET_SHOW_RIGHT_FOOTER)
    {
        footerSide = "right";
        currentVisibility = SHOW_RIGHT_FOOTER;        
    }
    
    if(currentVisibility == "true")
    {
        currentVisibility = "show";
    }
    else if(currentVisibility == "false")
    {
        currentVisibility = "hide";
    }
    
    llDialog(llGetOwner(), "Select visibility option for " + footerSide + " footer.\nCurrent Parameter: " + currentVisibility + "\n" + PROMPT, FOOTER_OPTIONS, MENU_CHANNEL);         
}

DeleteFromList()
{ 
    list listParameter = [];
    
    if(currentState == DELETE_LABEL)
        listParameter = LABEL;
    else if(currentState == DELETE_ITEM)
        listParameter = ITEM;
    else if(currentState == DELETE_IMAGE_URL_LIST)
        listParameter = IMAGE_URL_LIST;
        
    string deletePrompt = "Select item to delete";
    list deleteOptions = ["[Back]"];
    
    integer i = 0;
    
    for(i = 0; i < llGetListLength(listParameter); i++)
    {
        deletePrompt += "\nItem " + (string)(i + 1) + ": " + llList2String(listParameter, i);
        deleteOptions += (string)(i + 1);        
    }
    
    llDialog(llGetOwner(), deletePrompt + "\n" +  PROMPT, deleteOptions , MENU_CHANNEL);  
}

list ListItemDelete(list target, string element) 
{
    integer placeinlist = llListFindList(target, [element]);
    if (placeinlist != -1)
        return llDeleteSubList(target, placeinlist, placeinlist);
    return target;
}

list ListItemDeleteByIndex(list target, integer index) 
{
    string listName = "";
    
    if(index < llGetListLength(target) & index >= 0)
    {
        llOwnerSay("Item deleted from " + "list.");    
        return llDeleteSubList(target, index, index);
    }
    
    return target;
}

/*Other Functions*/
ResetParameters()
{
    /*Specific Card Parameters*/
    CARD_TYPE = "mosaiclist";
    PROFILE_IMAGE_URL = "http://crimsondash.com/sleoci/Content/images/defaultprofileimage.png";
    IMAGE_URL_STRING = "http://crimsondash.com/sleoci/Content/images/defaultimage.png";
    TITLE = "Title";
    NAME = "Name";
    LOCATION = "Location";
    DESCRIPTION = "Description";

    LABEL = ["Label 1", "Label 2", "Label 3"];
    ITEM = ["Item 1", "Item 2", "Item 3"];
    IMAGE_URL_LIST = [
    "http://crimsondash.com/sleoci/Content/images/defaultimage.png",
    "http://crimsondash.com/sleoci/Content/images/defaultimage.png",
    "http://crimsondash.com/sleoci/Content/images/defaultimage.png"];

    /*Default Card Settings*/
    LEFT_FOOTER = "Left Footer";
    RIGHT_FOOTER = "Right Footer";
    SHOW_LEFT_FOOTER = "true";
    SHOW_RIGHT_FOOTER = "true";
    llOwnerSay("Parameters reset.");
}

string GetYoutubeIdFromUrl(string url)
{
    integer youtubeIdStartIndex = llSubStringIndex(url, "youtube.com/watch?v=");
    string endCharacter = "&";
    
    if(youtubeIdStartIndex  == -1)
    {
        youtubeIdStartIndex = llSubStringIndex(url, "youtu.be/");
        endCharacter = "?";    
        
        if(youtubeIdStartIndex == -1)
        {
            llOwnerSay("Invalid url. Reverted to previous value.");
            return VIDEO;
        }
    }

    integer youtubeIdEndIndex  = llSubStringIndex(url, endCharacter) - 1;
    
    if(youtubeIdEndIndex == -1)
    {
        youtubeIdEndIndex = llStringLength(url) - 1;
    }    
    
    return llGetSubString(url, youtubeIdStartIndex, youtubeIdEndIndex);        
}

default
{
    state_entry()
    {
        llOwnerSay("Initializing... Please wait.");
        OBJECT_KEY = llGenerateKey();
        MENU_CHANNEL = 0x80000000 | ((integer)("0x"+ (string)(OBJECT_KEY) + (string)(llGetOwner())) ^ APP_KEY);
        state ready;
    }
}

state ready
{
    state_entry()
    {
        llOwnerSay("SLEOCi object ready. Touch and hold object for " + (string)((integer)TOUCH_HOLD_DELAY) + " seconds to bring up settings menu.");
        llListenRemove(listenHandle);
        llListenRemove(textboxHandle);
    }
 
    touch_start(integer num_detected)
    {
        if (llDetectedKey(0) == llGetOwner())    
        {
            llResetTime();        
            llOwnerSay("Owner detected. Hold for " + (string)((integer)TOUCH_HOLD_DELAY) + " seconds to bring up settings menu.");
        }
    }
 
    touch(integer num_detected)
    {
        if (llDetectedKey(0) == llGetOwner() && llGetTime() > TOUCH_HOLD_DELAY)
        {
            llListenRemove(listenHandle);
            listenHandle = llListen(MENU_CHANNEL, "", llGetOwner(), "");            
            MainMenu();
        }
    } 
    
    touch_end(integer num_detected)
    {
        key avatarKey = llDetectedKey(0);
    
        string parameters = "key=" + (string)avatarKey + "&type=" + CARD_TYPE + "&encrypted=" + EncryptCardParameters();
        llReleaseURL(ADD_API_URL);
        requestCard = llHTTPRequest(ADD_API_URL + parameters, [HTTP_METHOD,"POST", HTTP_MIMETYPE,"application/x-www-form-urlencoded"], "");         
    }

    listen(integer channel, string name, key id, string message)
    {
        if(currentState == MAIN)
        {
            if(message == "Layout")
            {
                currentState = SET_CARD_TYPE;
                llDialog(llGetOwner(), "Select Layout\nCurrent Layout: " + CARD_TYPE + "\n" + PROMPT, "[Back]" + LAYOUT_OPTIONS, MENU_CHANNEL);
            }
            else if (message == "Preview")
            {
                string parameters = "type=" + CARD_TYPE + "&encrypted=" + EncryptCardParameters();            
                MainMenu();
                llOwnerSay("Click on the link below to see card preview: \n[" + PREVIEW_API_URL + parameters + " Card Preview]");                            
            }
            else if (message == "Parameters")
            {
                currentState = PARAMETERS;                
                parameterOptions = [];
                
                if(CARD_TYPE == "author")
                {
                    parameterOptions += "PROFILE_IMAGE_URL";
                    parameterOptions += "IMAGE_URL_STRING";
                    parameterOptions += "NAME";
                    parameterOptions += "LOCATION";
                    parameterOptions += "DESCRIPTION";                    
                }
                else if(CARD_TYPE == "hybrid")
                {
                    parameterOptions += "IMAGE_URL_STRING";                    
                    parameterOptions += "DESCRIPTION";                    
                }
                else if(CARD_TYPE == "hybridmosaic")
                {
                    parameterOptions += "IMAGE_URL_LIST";            
                    parameterOptions += "DESCRIPTION";                        
                }
                else if(CARD_TYPE == "list")
                {
                    parameterOptions += "ITEM";                    
                }
                else if(CARD_TYPE == "mosaiclist")
                {
                    parameterOptions += "LABEL";
                    parameterOptions += "ITEM";                    
                    parameterOptions += "IMAGE_URL_LIST";    
                    parameterOptions += "TITLE";                        
                }
                else if(CARD_TYPE == "mosaictext")
                {
                    parameterOptions += "IMAGE_URL_LIST";    
                    parameterOptions += "TITLE";    
                    parameterOptions += "DESCRIPTION";                    
                }    
                else if(CARD_TYPE == "text")
                {
                    parameterOptions += "TITLE";    
                    parameterOptions += "DESCRIPTION";                 
                }
                else if(CARD_TYPE == "video")
                {
                    parameterOptions += "VIDEO";   
                }
                
                parameterOptions +=    ["LEFT_FOOTER", "RIGHT_FOOTER", "SHOW_LEFT_FOOTER", "SHOW_RIGHT_FOOTER"];
                ParametersMenu();                     
            }
            else if(message == "[Reset]")
            {
                llOwnerSay("Resetting settings...");
                llResetScript();
            }
            else if(message == "[Close]")
            {
                llListenRemove(listenHandle);            
            }
        }
        else if (currentState == PARAMETERS)
        {
            if(message == "PROFILE_IMAGE_URL")
            {
                currentState = SET_PROFILE_IMAGE_URL;
                llTextBox(llGetOwner(), "Input new url for profile image. Leave textbox field empty to cancel.\nCurrent value: " + PROFILE_IMAGE_URL, MENU_CHANNEL);                
            }        
            else if(message == "LABEL")
            {
                currentState = LABEL_MENU;
                ListMenu();
            }
            else if(message == "ITEM")
            {
                currentState = ITEM_MENU;        
                ListMenu();                
            }
            else if(message == "IMAGE_URL_LIST")
            {
                currentState = IMAGE_URL_LIST_MENU;        
                ListMenu();                
            }            
            else if(message == "IMAGE_URL_STRING")
            {
                currentState = SET_IMAGE_URL_STRING;
                llTextBox(llGetOwner(), "Input new url for image. Leave textbox field empty to cancel.\nCurrent value: " + IMAGE_URL_STRING, MENU_CHANNEL);                  
            }
            else if(message == "TITLE")
            {
                currentState = SET_TITLE;
                llTextBox(llGetOwner(), "Input new title. Leave textbox field empty to cancel.\nCurrent value: " + TITLE, MENU_CHANNEL);                  
            }            
            else if(message == "NAME")
            {
                currentState = SET_NAME;
                llTextBox(llGetOwner(), "Input new name. Leave textbox field empty to cancel.\nCurrent value: " + NAME, MENU_CHANNEL);                  
            }        
            else if(message == "LOCATION")
            {
                currentState = SET_LOCATION;
                llTextBox(llGetOwner(), "Input new location. Leave textbox field empty to cancel.\nCurrent value: " + LOCATION, MENU_CHANNEL);               
            }
            else if(message == "VIDEO")
            {
                currentState = SET_VIDEO;
                llTextBox(llGetOwner(), "Input new youtube video url. Leave textbox field empty to cancel.\nCurrent value: " + VIDEO, MENU_CHANNEL);                
            }
            else if(message == "DESCRIPTION")
            {
                currentState = SET_DESCRIPTION;
                llTextBox(llGetOwner(), "Input new description. Leave textbox field empty to cancel.\nCurrent value: " + DESCRIPTION, MENU_CHANNEL);               
            }       
            else if(message == "LEFT_FOOTER")
            {
                currentState = SET_LEFT_FOOTER;
                llTextBox(llGetOwner(), "Input new left footer. Leave textbox field empty to cancel.\nCurrent value: " + LEFT_FOOTER, MENU_CHANNEL);   
            }
            else if(message == "RIGHT_FOOTER")
            {
                currentState = SET_RIGHT_FOOTER;
                llTextBox(llGetOwner(), "Input new right footer. Leave textbox field empty to cancel.\nCurrent value: " + RIGHT_FOOTER, MENU_CHANNEL);                   
            }
            else if(message == "SHOW_LEFT_FOOTER")
            {
                currentState = SET_SHOW_LEFT_FOOTER;
                ShowFooterMenu();
            }
            else if(message == "SHOW_RIGHT_FOOTER")
            {
                currentState = SET_SHOW_RIGHT_FOOTER;            
                ShowFooterMenu();
            }
            else if(message == "[Back]")
            {
                MainMenu();             
            }
        }
        else if(currentState == SET_CARD_TYPE)
        {
            if(message != "[Back]")
            {
                if(llListFindList(LAYOUT_OPTIONS, [message]) != -1)
                {
                    CARD_TYPE = message;
                    llOwnerSay("Card layout set. Current layout: " + CARD_TYPE);
                }
                else
                {
                    llOwnerSay("Invalid layout. Current layout: " + CARD_TYPE);                
                }
            }
            
            MainMenu();            
        }       
        else if(currentState  >= SET_PROFILE_IMAGE_URL & currentState <= SET_RIGHT_FOOTER)
        {         
            if(llStringLength(message) != 0)
            {
                if(currentState == SET_PROFILE_IMAGE_URL)                
                    PROFILE_IMAGE_URL = message;
                else if(currentState == SET_IMAGE_URL_STRING)
                    IMAGE_URL_STRING = message;
                else if(currentState == SET_TITLE)
                    TITLE = message;
                else if(currentState == SET_NAME)
                    NAME = message;
                else if(currentState == SET_LOCATION)
                    LOCATION = message;
                else if(currentState == SET_VIDEO)
                    VIDEO = GetYoutubeIdFromUrl(message);
                else if(currentState == SET_DESCRIPTION)
                    DESCRIPTION = message;
                else if(currentState == SET_LEFT_FOOTER)
                    LEFT_FOOTER = message;        
                else if(currentState == SET_RIGHT_FOOTER)
                    RIGHT_FOOTER = message;
                    
                llOwnerSay("Parameter updated. New value: " + message);
            }
                 
            ParametersMenu();      
        }
        else if(currentState == SET_SHOW_LEFT_FOOTER)
        {
            if(message == "Show")
            {
                SHOW_LEFT_FOOTER = "true";
                llOwnerSay("Parameter updated. Current settings: show left footer.");
            }
            else if(message == "Hide")
            {
                SHOW_LEFT_FOOTER = "false";            
                llOwnerSay("Parameter updated. Current settings: hide left footer.");                
            }
            
            ParametersMenu();             
        }
        else if(currentState == SET_SHOW_RIGHT_FOOTER)
        {
            if(message == "Show")
            {
                SHOW_RIGHT_FOOTER = "true";
                llOwnerSay("Parameter updated. Current settings: show right footer.");
            }
            else if(message == "Hide")
            {
                SHOW_RIGHT_FOOTER = "false";            
                llOwnerSay("Parameter updated. Current settings: hide right footer.");              
            }
            
            ParametersMenu();             
        }        
        else if(currentState >= LABEL_MENU & currentState <= IMAGE_URL_LIST_MENU)
        {
            if(message == "[Add]")
            {
                currentState += 100;
                AddToList();
            }
            else if(message == "[Delete]")
            {
                currentState += 200;   
                DeleteFromList();                        
            }
            else if(message == "[Back]")
            {
                ParametersMenu();   
            }    
        }
        else if(currentState >= ADD_LABEL & currentState <= ADD_IMAGE_URL_LIST)
        {
            if(llStringLength(llStringTrim(message, STRING_TRIM)) != 0)
            {
                string listType = "Undefined";
                if(currentState == ADD_LABEL)      
                {
                    listType = "Label";
                    LABEL += message;
                }
                else if(currentState == ADD_ITEM)
                {
                    listType = "Item";                
                    ITEM += message;
                }
                else if(currentState == ADD_IMAGE_URL_LIST)
                {
                    listType = "ImageUrl";                
                    IMAGE_URL_LIST += message;     
                }
                    
                llOwnerSay(listType + " added.");   
            }
            
            currentState -= 100;
            ListMenu();                        
        }
        else if(currentState >= DELETE_LABEL & currentState <= DELETE_IMAGE_URL_LIST)
        {
            if(message != "[Back]")
            {
                string listType = "Undefined";            
                if(currentState == DELETE_LABEL)    
                {
                    listType = "Label";                
                    LABEL = ListItemDeleteByIndex(LABEL, (integer)message - 1);
                }
                else if(currentState == DELETE_ITEM)
                {
                    listType = "Item";                    
                    ITEM = ListItemDeleteByIndex(ITEM, (integer)message - 1);
                }
                else if(currentState == DELETE_IMAGE_URL_LIST)
                {
                    listType = "ImageUrl";                    
                    IMAGE_URL_LIST = ListItemDeleteByIndex(IMAGE_URL_LIST, (integer)message - 1);
                }
            }
            
            currentState -= 200;
            ListMenu();                        
        }
    }
}
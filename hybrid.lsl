/*See documentation: http://piriysdev.wordpress.com/sleoc-documentation/
/*Send Options*/
integer USE_CUSTOM_TARGET = FALSE; //Set to true if target avatar is not the avatar that touches this object
key CUSTOM_TARGET_KEY = NULL_KEY;

/*Default Card Settings - Make Changes Here*/
string LEFT_FOOTER = "Left Footer";
string RIGHT_FOOTER = "Right Footer";
string SHOW_LEFT_FOOTER = "true";
string SHOW_RIGHT_FOOTER = "true";

/*Hybrid Card Settings - Make Changes Here*/
string DESCRIPTION = "Description";
string IMAGE_URL = "http://crimsondash.com/sleoci/Content/images/defaultimage.png";

/*====================*/
/*====================*/
/*====================*/
/*====================*/
/*====================*/
/*====================*/
/*====================*/
/*====================*/
/*Constants*/
string ADD_API_URL = "http://crimsondash.com/sleoci/api/cardapi/addcard?";
string XOR_KEY = "SLEOC6411";
integer APP_KEY = 6411;
integer HUD_FRONT_FACE = 4;
string CARD_TYPE = "hybrid";
/*Global Variables*/
integer ready = FALSE;
key requestCard;

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
		"imageurl=" + IMAGE_URL 
		+ "&description=" + DESCRIPTION
		
        + "&leftfooter=" + LEFT_FOOTER
        + "&rightfooter=" + RIGHT_FOOTER
        + "&showleftfooter=" + SHOW_LEFT_FOOTER
        + "&showrightfooter=" + SHOW_RIGHT_FOOTER;      
    
    string encryptedParameters = llEscapeURL(parameters);    
    return Xor(encryptedParameters);   
}

default
{
    state_entry()
    {
        llSetText("Card Type: " + CARD_TYPE, <1.0, 1.0, 1.0>, 1.0);       
    }
    touch_end(integer num_detected)
    {
        key avatarKey = CUSTOM_TARGET_KEY;
        
        if(!USE_CUSTOM_TARGET) {
            avatarKey = llDetectedKey(0);
        }
    
        string parameters = "key=" + (string)avatarKey + "&type=" + CARD_TYPE + "&encrypted=" + EncryptCardParameters();
        llReleaseURL(ADD_API_URL);
        requestCard = llHTTPRequest(ADD_API_URL + parameters, [HTTP_METHOD,"POST", HTTP_MIMETYPE,"application/x-www-form-urlencoded"], ""); 
    }
}
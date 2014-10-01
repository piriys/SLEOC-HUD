/*See documentation: http://piriysdev.wordpress.com/sleoc-documentation/
/*Default Card Settings - Make Changes Here*/
string LEFT_FOOTER = "Left Footer";
string RIGHT_FOOTER = "Right Footer";
string SHOW_LEFT_FOOTER = "true";
string SHOW_RIGHT_FOOTER = "true";

/*Hybrid Card Settings - Make Changes Here*/
string DESCRIPTION = "Description";
string IMAGE_URL = "http://crimsondash.com/SLEOC/Content/images/defaultimage.png";

/*====================*/
/*====================*/
/*====================*/
/*====================*/
/*====================*/
/*====================*/
/*====================*/
/*====================*/
/*Constants*/
string ADD_API_URL = "http://crimsondash.com/sleoc/api/cardapi/addcard?";
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
    touch_end(integer num_detected)
    {
        key avatarKey = llDetectedKey(0);
        string parameters = "key=" + (string)avatarKey + "&type=" + CARD_TYPE + "&encrypted=" + EncryptCardParameters();
        llReleaseURL(ADD_API_URL);
        requestCard = llHTTPRequest(ADD_API_URL + parameters, [HTTP_METHOD,"POST", HTTP_MIMETYPE,"application/x-www-form-urlencoded"], ""); 
    }    
}
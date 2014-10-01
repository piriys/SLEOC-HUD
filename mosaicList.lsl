/*See documentation: http://piriysdev.wordpress.com/sleoc-documentation/
/*Default Card Settings - Make Changes Here*/
string LEFT_FOOTER = "Left Footer";
string RIGHT_FOOTER = "Right Footer";
string SHOW_LEFT_FOOTER = "true";
string SHOW_RIGHT_FOOTER = "true";

/*Mosaic List Card Settings - Make Changes Here*/
string TITLE = "Title";
list IMAGE_URLS = 
[
"http://crimsondash.com/SLEOC/Content/images/defaultimage.png",
"http://crimsondash.com/SLEOC/Content/images/defaultimage.png",
"http://crimsondash.com/SLEOC/Content/images/defaultimage.png",
"http://crimsondash.com/SLEOC/Content/images/defaultimage.png"
];
list LABELS = 
[
"Label 1",
"Label 2",
"Label 3"
];
list ITEMS =
[
"Item 1",
"Item 2",
"Item 3"
];

/*====================*/
/*====================*/
/*====================*/
/*====================*/
/*====================*/
/*====================*/
/*====================*/
/*====================*/
/*Constants*/
string ADD_API_URL = "http://crimsondash.com/sleoc";
string XOR_KEY = "SLEOC6411";
integer APP_KEY = 6411;
integer HUD_FRONT_FACE = 4;
string CARD_TYPE = "mosaiclist";
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

string EncryptMosaicListCardParameters()
{
    string parameters = 
		"title=" + TITLE;
    
    integer i = 0;
    
    for(i = 0; i < llGetListLength(IMAGE_URLS); i++)
    {
        parameters += "&imageurl=" + llList2String(IMAGE_URLS, i);
    }
    
    for(i = 0; i < llGetListLength(LABELS); i++)
    {
        parameters += "&label=" +  llList2String(LABELS, i);
    }   
     
    for(i = 0; i < llGetListLength(ITEMS); i++)
    {
        parameters += "&item=" + llList2String(ITEMS, i);
    }      
    
	parameters += 
        "&leftfooter=" + LEFT_FOOTER
        + "&rightfooter=" + RIGHT_FOOTER
        + "&showleftfooter=" + SHOW_LEFT_FOOTER
        + "&showrightfooter=" + SHOW_RIGHT_FOOTER;   	
	
    string encryptedParameters = Xor(parameters);    
    return llEscapeURL(encryptedParameters);    
}

default
{
    touch_end(integer num_detected)
    {
        key avatarKey = llDetectedKey(0);
		parameters = "key=" + (string)avatarKey + "&type=" + CARD_TYPE + "&encrypted=" + EncryptMosaicListCardParameters();
		llReleaseURL(ADD_API_URL);
		requestCard = llHTTPRequest(ADD_API_URL, [HTTP_METHOD,"POST", HTTP_MIMETYPE,"application/x-www-form-urlencoded"], parameters); 
    }
}
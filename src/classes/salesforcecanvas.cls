public without sharing class salesforcecanvas
{
    public User record{get;set;}
    public String currentsession{get;set;}
    public String obj{get;set;}
    public string returnUrl{get;set;}
    globalcomponent gc=new globalcomponent();
    
    public salesforcecanvas()
    {      
		currentsession=Userinfo.getSessionID(); 
          	
	}
    public PageReference Redirect() 
    {
  		if(gc.userRedirect == true)
       	{
           	PageReference pageRedirect = new PageReference(gc.IDMRedirectURL);
           	
           	pageRedirect.getParameters().put('TARGET',gc.IDMTargetURL);   
           	      
           	pageRedirect.setRedirect(true);
           	return pageRedirect;
        } 
       	else
       	{
        	record = [select Contact.Id,Contact.Name,Contact.email,Contact.PS_Person_Id__c,Psft_Operator_ID__c,NOV_Preferred_Site__c from User where ID =: Userinfo.getUserID()];
       		obj = System.now().format('yyyy-MM-dd hh:mm:ssZ');
        	returnUrl= ApexPages.currentPage().getParameters().get('TargetURL');
       		return null;
        }
    }

     public string getmessage()
    {
      record = [select Contact.Id,Contact.Name,Contact.email,Contact.PS_Person_Id__c,Psft_Operator_ID__c,NOV_Preferred_Site__c from User where ID =: Userinfo.getUserID()];
      obj = System.now().format('yyyy-MM-dd hh:mm:ssZ');
      returnUrl= ApexPages.currentPage().getParameters().get('TargetURL');
      if(returnurl==null)
      {
        returnurl='';
      }
      string SSOparameter='{PeopleSoftID:"'+record.Psft_Operator_ID__c+'",Name:"'+String.escapeSingleQuotes(record.Contact.Name)+'",Email:"'+String.escapeSingleQuotes(record.Contact.email)+'",Timestamp:"'+obj+'",ReturnUrl:"'+returnUrl+'",PreferredSite:"'+record.NOV_Preferred_Site__c+'"}';
     // string URLencode=EncodingUtil.urlEncode(SSOparameter, 'UTF-8');
      String base64encode= EncodingUtil.base64Encode(Blob.valueof(SSOparameter));
      Blob mac=Crypto.generateMac('hmacSHA256',Blob.valueof(base64encode),Blob.valueof('218615755701448932'));
      string message=EncodingUtil.base64Encode(mac)+'.'+base64encode;   
      system.debug('JSON--'+SSOparameter);
      system.debug('message--'+message);
      return message;
    }


}
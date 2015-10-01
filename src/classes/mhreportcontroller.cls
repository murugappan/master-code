/**************************************************************************************************************
 *   @author         Varghese George <varghese.george@blackboard.com>										 
 *   @class          mhreportcontroller													  
 *   @abstract       Controller for btbb_mhreport visualforce page(Authenticated Page)															
 *   @since          2014.01.08																				  
 *   @discussion     Class to encrypt and redirect users to MH Insight Report								
 *																											  
 **************************************************************************************************************/



public  class mhreportcontroller {
	
	public list<account> accountlist{get;set;}
	public list <user> userlist{get;set;}
	public list <selectoption> accountoptions{get;set;} 
	public string pscomapnyid{get;set;}
	GlobalComponent gc = new GlobalComponent();
	public mhreportcontroller()
	{
		
	 }
	 
	 
	public pagereference InsightReportRedirect()
	{   
		pagereference InsightReport=new pagereference(generateURL());
		InsightReport.setredirect(true);
		return InsightReport;
	}
	
	public string generateURL()
	{ 
		string companyid=pscomapnyid;
		string operatorid;
		if(userlist!= null && userlist.size()>0)
		{	
		 operatorid=String.valueof(userlist[0].Psft_Operator_ID__c);
		} 
		String timestamp = system.now().format('yyyy-MM-dd\'T\'HH:mm:ssZ');
		 list<string>  slist= new list<string>();
		Slist.add(companyid);
		Slist.add(operatorid);
		Slist.add(timestamp);
        string strSSO = String.Format('{0}|{1}|{2}',Slist);
        blob key=blob.valueof('b3H1nDTehB1@ckB0ard');
		blob md5key=Crypto.generateDigest('md5',key);
		string message=strSSO;
		blob encrypt= Crypto.encryptWithManagedIV('AES128', md5key, Blob.valueof(message));
		string url='https://aspstats.blackboard.com/cgi-bin/AM/myCLadmin.php?auth=SF&sso='+EncodingUtil.convertToHex(encrypt).touppercase();
		return url;
	}
	
	
    public PageReference Redirect() {
        if(gc.userRedirect == true){
            PageReference pageRedirect = new PageReference(gc.IDMRedirectURL);
            pageRedirect.getParameters().put('TARGET',gc.IDMTargetURL);          
            pageRedirect.setRedirect(true);
            return pageRedirect;
        }
        else  
        {
        	accountoptions = new list<selectoption>();
			userlist=[select id,contactid,Psft_Operator_ID__c from user where id=:userinfo.getuserid()];
		  	if(userlist != null && userlist.size()>0)
			 {
			  	if(userlist[0].contactid  != null)
			  	{
			  		Set<Id> accId = new set<Id>();	
				  	map<string,string> accountmap=new map<string,string>();
				  	for(Contact_Role__c contRole : [Select Account__c, Role__c, Id, Contact__c From Contact_Role__c where contact__c = :userlist[0].ContactId AND Contact__c!= NULL]) {
	                        if(null != contRole.Role__c && (contRole.Role__c.Contains('LEARN') || contRole.Role__c.Contains('ANGEL')))
	                                accId.add(contRole.Account__c);
	                }  
				  	if(accId != null && accId.size() > 0)
				  	{
	                    for(Asset assetrec : [Select Managed_Hosting__c, AccountId,account.PS_Company_Id__c,account.name From Asset where accountId IN :accId]) {
	                        if(null != assetrec .Managed_Hosting__c && (assetrec .Managed_Hosting__c.Contains('Managed Hosting'))) {
	                             accountmap.put(assetrec.account.PS_Company_Id__c,assetrec.account.name ) ;
	                        }                                               
	                	}
				  	}
				  	for(string acc: accountmap.keyset())
				  	{
				  		accountoptions.add(new selectoption(acc,accountmap.get(acc)+'('+acc+')'));
				  	}
			  	}
			 }
			 if(accountoptions!=null && accountoptions.size()>0 && accountoptions.size()==1)
			 {
			 	pscomapnyid=accountoptions[0].getValue();
			 	pagereference InsightReport=new pagereference(generateURL());
				InsightReport.setredirect(true);
				return InsightReport; 
			 }
        	
        	
            	
        }
        return null;
        
    }
}
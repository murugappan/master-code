public with sharing class BMMassProvisioning {

  	// Project object
  	public BMUserSecurity__c security;
  	private List<BMUserSecurity__c> lSecurities;
  	private User[] usersToProvision;
  	public Boolean disableMassProvisioningButton;
  	public String currentlySelectedConfigId;
  	
  	private User[] usersInvalidForProvision;
  	public String currentlySelectedUserId;
  	
  	//constructor
	public BMMassProvisioning(ApexPages.StandardController stdController) 
	{
	}    
  	
  	// Getter for the resource object
    public BMUserSecurity__c getSecurity()
    {
    	BMUserSecurity__c[] tmpSecurity;
    	if (security == null){
    		System.Debug('getting security');
    		tmpSecurity = [SELECT b.Id, b.Name, b.isActive__c, b.AdminEmail__c, b.APIUserPassword__c, b.APIUserName__c, b.BMSSLRequired__c, b.APISubDomain__c From BMUserSecurity__c b WHERE isActive__c = true];
    		
	    	if(tmpSecurity != null && tmpSecurity.size() > 0)
	    	{
	    		security = tmpSecurity[0];
	    		setCurrentlySelectedConfigId(tmpSecurity[0].Id);
	    	}
	    	else
	    		security = new BMUserSecurity__c();
    	}
    	
    	return security;
    }  
    
    //gets existing security records
    public List<BMUserSecurity__c> getLSecurities(){
   		lSecurities = [SELECT b.Id, b.Name, b.isActive__c, b.AdminEmail__c, b.APIUserPassword__c, b.APIUserName__c, b.BMSSLRequired__c, b.APISubDomain__c From BMUserSecurity__c b];
   	
    	return lSecurities;
    }
    
    //sets the currenlty selected record's id
    public void setCurrentlySelectedConfigId(String id){
    	currentlySelectedConfigId = id;    	
    }
    
    //gets the currenlty selected record's id
    public String getCurrentlySelectedConfigId(){    	
    	return currentlySelectedConfigId;
    }
    
        //sets the currenlty selected user's id
    public void setCurrentlySelectedUserId(String id){
    	currentlySelectedUserId = id;    	
    }
    
    //gets the currenlty selected user's id
    public String getCurrentlySelectedUserId(){    	
    	return currentlySelectedUserId;
    }
    
    // Setter for the BMUserSecurity object
    public void setSecurity(BMUserSecurity__c s)
    {
    	security = s;
    }
  	
  	public List<User> getUsersInvalidForProvision() {
  		usersInvalidForProvision =  [SELECT u.Name, u.BMMassProvisioning__c, u.isBMEnabled__c, user.BMUserType__c, 
  				user.BMUserAccessType__c, user.BMPartnerCompanyNameFormula__c, u.Username 
  				From User u WHERE u.BMMassProvisioning__c = true AND u.isBMEnabled__c = false AND u.isActive = true and
  				((user.ContactId != null and user.BMUserType__c = :BMGlobal.BM_INTERNAL_USER) or  
  				  (user.ContactId = null and user.BMUserType__c = :BMGlobal.BM_PARTNER_USER) or
  				  user.BMUserAccessType__c = null)];
  		return usersInvalidForProvision;
  	}
  	
	public integer getUsersToProvision()
	{
		return [SELECT count() 
  				From User u WHERE u.BMMassProvisioning__c = true AND u.isBMEnabled__c = false AND u.isActive = true and
  				(((user.BMUserType__c = :BMGlobal.BM_PARTNER_USER and user.ContactId != null)  or 
  					(user.BMUserType__c = :BMGlobal.BM_INTERNAL_USER and user.ContactId = null)) and 
  				user.BMUserAccessType__c != null)];
	}

	//selects a new config record
	public void selectConfig(){		
		List<BMUserSecurity__c> tmpSecurity;
		if(getCurrentlySelectedConfigId() != null){			
			tmpSecurity = [SELECT b.Name, b.isActive__c, b.AdminEmail__c, b.APIUserPassword__c, b.APIUserName__c, b.BMSSLRequired__c, b.APISubDomain__c From BMUserSecurity__c b WHERE b.Id = :getCurrentlySelectedConfigId() limit 1];
			if(tmpSecurity.size() > 0)
				setSecurity(tmpSecurity[0]);
		}
	}
	
	//saves the record: upsert
	public PageReference saveConfig(){
		try{
			System.debug('inside save config');
			upsert getSecurity();
		}
		catch(Exception e){
			System.debug('Exception in saveConfig: ' + e.getMessage());
			if(e.getMessage().contains(BMGlobal.ERROR_MULTIPLE_ACTIVE_CONFIGS))			
				addError(BMGlobal.ERROR_MULTIPLE_ACTIVE_CONFIGS);
			else
				addError(e.getMessage());
		}	
		
		return null;
	}
	
	
	//deletes the selected config
	public void deleteConfig(){
		try{
			if(getSecurity() != null && getSecurity().Id != null)
				delete getSecurity();
			setSecurity(null);
			
		}
		catch(Exception e){
			System.debug('Exception in saveConfig: ' + e.getMessage());
			addError(e.getMessage());
		}		
	}
	
	//new button
	public void newConfig(){
		//set current security to new object		
		setSecurity(new BMUserSecurity__c());
	}

    // Provision User Functionality
    public void provisionUsers()
    {
    	provisionUsers(true);
    }

	public void provisionUsers(Boolean callOut)
	{
 	   	if (usersToProvision == null)
			usersToProvision = [SELECT u.Name, u.BMMassProvisioning__c, u.BMUserType__c, u.BMUserAccessType__c, u.BMPartnerCompanyNameFormula__c, u.isBMEnabled__c, u.Username 
				From User u WHERE u.BMMassProvisioning__c = true AND u.isBMEnabled__c = false AND u.isActive = true and
  				(((user.BMUserType__c = :BMGlobal.BM_PARTNER_USER and user.ContactId != null)  or 
  					(user.BMUserType__c = :BMGlobal.BM_INTERNAL_USER and user.ContactId = null)) and 
  				user.BMUserAccessType__c != null)];
			
			
		if (usersToProvision.size() > 0)
		{
			List<User> usersProvisioned = new List<User>();
			String usersNotProvisioned;
			String errorMsg;
			for (User user :usersToProvision)
			{
				try
				{
					// Set the call out to true
					UserMaintenance.callOut = callout;
					
					// Passed in username, isBMEnabled = true, callOut = true and Mass Provisioning = true
					UserMaintenance.insertUpdateUserProvision(user.Username, user.BMUserType__c, user.BMUserAccessType__c, user.BMPartnerCompanyNameFormula__c, true, true);
					user.isBMEnabled__c = true;
					user.BMMassProvisioning__c = false;
				}
				catch(Exception ex)
				{
					user.isBMEnabled__c = false;
					//user.BMMassProvisioning__c = false;
					if (usersNotProvisioned == null || usersNotProvisioned.length() == 0)
						usersNotProvisioned = user.Username;
					else
						usersNotProvisioned = usersNotProvisioned + ', ' + user.Username;
						
					if (errorMsg == null)
						errorMsg = ex.getMessage();
				}
				usersProvisioned.add(user);
			}
			if (usersProvisioned.size() > 0)
			{
				UserMaintenance.updateIsBMEnabled(usersProvisioned);
				usersToProvision.clear();
				usersToProvision = null;
			}
			
	
			if (usersNotProvisioned != null && usersNotProvisioned.length() > 0)
			{
				String msg = 'Following users: ' + usersNotProvisioned + ' were not provisioned - Error: ' + errorMsg;
				addError(msg);
				UserMaintenance.SendExceptionMessage(security.AdminEmail__c, msg);
			}
		}
	}
    
    public void addError(String errorMsg)
    {         
    	ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, errorMsg);                               
        ApexPages.addMessage(msg);
    }  
        
    public Boolean getDisableMassProvisioningButton()
    {
		disableMassProvisioningButton = false;
		if (getUsersToProvision() == 0)
			disableMassProvisioningButton = true;
    	return disableMassProvisioningButton;
    }
}
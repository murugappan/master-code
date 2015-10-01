global class UserUpdateTriggerHandler 
{
	public UserUpdateTriggerHandler()
	{
	}
     
    public static Boolean hasAfterInsertRun {get {if (hasAfterInsertRun == null) return false; return hasAfterInsertRun;} set;} 
    
    public void OnBeforeInsert(User[] newUsers)
    {
      	
    }
    
    public void OnAfterInsert(User[] newUsers,set<id> userids)
    {
       	hasAfterInsertRun=true;
        UpdateOperatorId(newUsers);
       	updateUserEmailLog(userids);
    }
        
    public void OnBeforeUpdate(User[] newUsers)
    {
       
    }
    
    public void OnAfterUpdate(User[] newUsers)
    {
    	
    }
     
     
  
 	public static void UpdateOperatorId(User[] newUsers)
	{
       	list<User> userupdatelist= new list<User>();
	    list<User> userlist=[Select id,firstname,lastname,contactid,PS_OperatorId_Counter__c,username from User where ID IN : newUsers AND profile.UserLicense.Name = 'Overage High Volume Customer Portal' AND Profile.Name='SRV - BTBB User'];
	    for(User u:userlist)
		{
			if(u.contactid!=null)
			{
				if(u.firstname==null)
				{
					string temp=(u.LastName.substring(0, 2) + u.PS_OperatorId_Counter__c);
					u.Psft_Operator_ID__c=temp.tolowerCase();
					u.username=temp.tolowerCase()+'@sfid.blackboard.com';
					userupdatelist.add(u);
				}
				else
				{
					string temp=(u.FirstName.substring(0, 1) + u.LastName.substring(0, 1) + u.PS_OperatorId_Counter__c);
					u.Psft_Operator_ID__c=temp.tolowerCase();
					u.username=temp.tolowerCase()+'@sfid.blackboard.com';
					userupdatelist.add(u);
				}
			}
		}
       
	
		if((userupdatelist!=null) && (userupdatelist.size()>0))
        {
            update userupdatelist;
        } 
   	} 
   	
   	
   	/* Future method for Inserting records into BtbbUserEmailLog__c Object */
   	
   	@future
    public static void updateUserEmailLog(set<Id> userids)
    {
    	List<BtbbUserEmailLog__c> emailloglist =  new list<BtbbUserEmailLog__c>();
    	String npassword;
    	list<User> userlist=[Select id,firstname,lastname,email,contactid,PS_OperatorId_Counter__c from User where ID IN : userids AND profile.UserLicense.Name = 'Overage High Volume Customer Portal' AND Profile.Name='SRV - BTBB User' AND IsMigration__c=false];
    	for(User u:userlist)
		{
			BtbbUserEmailLog__c ul = new BtbbUserEmailLog__c();
			if(u.contactid!=null)
			{
				ResetPasswordResult npr = System.resetPassword(u.id,false);
				npassword = npr.getPassword();
		        
		       	ul.user__c=u.id;
			   	ul.contact__c=u.contactid;
			   	ul.email__c=u.email;
			   	ul.Type__c='Initial';
			   	ul.Password__c=npassword;
			   	emailloglist.add(ul);
			}
		}
		
		if((emailloglist!=null) && (emailloglist.size()>0))
        {
            insert emailloglist;
        } 
    	
    }
   	
}
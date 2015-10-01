global class BtBbMassUserCredentialBatch implements Database.Batchable<sObject> {
	
	String query='select id,email,contactid,IsMigration__c from user where contactid!=null and IsMigration__c=true and isactive=true';
	
	global BtBbMassUserCredentialBatch() {
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<user> scope) {
   		list<BtbbUserEmailLog__c> UserEmailList= new list<BtBbUserEmailLog__c>();
		list<contact> contactupdatelist= new list<contact>();
		set<id> contactupdateids= new set<id>();

		for(user userrecord: scope)
		{
			BtbbUserEmailLog__c UserEmail = new BtbbUserEmailLog__c();	    		
	    	ResetPasswordResult rpr = System.resetPassword(userrecord.id,false);
		   	string password = rpr.getPassword();
		   	contactupdateids.add(userrecord.contactid);
		   	useremail.user__c = userrecord.id;
	  		useremail.contact__c = userrecord.contactid;
	    	useremail.email__c = userrecord.email;
	    	useremail.Type__c = 'Migration';
	    	useremail.Password__c = password;
	    	UserEmailList.add(useremail);
	    	userrecord.IsMigration__c=false;

		}

		insert UserEmailList;

		for (contact c: [select id,LastPasswordChange__c from contact where id in :contactupdateids])
		{
			c.LastPasswordChange__c=system.now();
			contactupdatelist.add(c);
		}

		update contactupdatelist;

		update scope;
	
	}


	
	global void finish(Database.BatchableContext BC) {
		 // Get the ID of the AsyncApexJob representing this batch job 
        // from Database.BatchableContext.         
        // Query the AsyncApexJob object to retrieve the current job's information. 
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email From AsyncApexJob Where Id =: BC.getJobId()];

        // Send an email to the Apex job's submitter notifying of job completion.
        if (a.NumberOfErrors > 0 ||test.isRunningTest())
        { 
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            list<String> toAddresses = new String[]{a.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
            mail.setSubject('Batch Apex NotifyKnowledgeFollowersBatch ' + a.Status);
            mail.setPlainTextBody
            ('The batch Apex job processed ' + a.TotalJobItems +
                    ' batches with '+ a.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }

		
	}
	
}
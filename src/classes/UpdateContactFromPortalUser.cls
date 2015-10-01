global class UpdateContactFromPortalUser {
    public static Boolean hasAfterUpdateRun {get {if (hasAfterUpdateRun == null) return false; return hasAfterUpdateRun;} set;}
    
    @future
    public static void updateContacts(set<Id> userids) 
    {
     hasAfterUpdateRun=true;
        
        list<user> userlist = [select ContactId,Street,State,PostalCode,Country,City,Phone,MobilePhone,Email,FirstName,LastName,Title,UserType,ProfileId,Id,NOV_isNew__c, isActive, NOV_Reset_Password__c, NOV_Debug__c, NOV_PSFT_User__c, NOV_SFDC_User__c, Psft_Operator_ID__c, NOV_isPilot__c, NOV_Preferred_Site__c
                    from User where Id IN :userIds];
        list<contact> contactupdatelist= new list<contact>();
         for(user u: userlist)
         {       
         if (u!=null && u.ContactId!=null) {
            Contact c = new Contact(Id=u.ContactId);
            if( u.Email!=null)
            c.Email = u.Email;
            //c.MaillingAddress = u.Address;
            if(u.Title!=null)
            c.Title = u.Title;
            if(u.Street!=null)
            c.MailingStreet = u.Street;
            if(u.State!=null)
            c.MailingState = u.State;
            if(u.PostalCode!=null)
            c.MailingPostalCode = u.PostalCode;
            if(u.Country!=null)
            c.MailingCountry = u.Country;
            if(u.City!=null)
            c.MailingCity = u.City;
            if(u.Phone!=null)
            c.Phone = u.Phone;
            if(u.MobilePhone!=null)
            c.MobilePhone = u.MobilePhone;
            if(u.FirstName!=null)
            c.FirstName=u.FirstName;
            if(u.LastName!=null)
            c.LastName=u.LastName;

            c.NOV_UserId__c=u.Id;
                c.NOV_UserProfileId__c=u.ProfileId;
                c.NOV_UserLicense__c=u.UserType;
                c.NOV_isNew__c=u.NOV_isNew__c;
                c.NOV_Reset_Password__c=u.NOV_Reset_Password__c;
                c.NOV_Debug__c=u.NOV_Debug__c;
                c.NOV_Old_BTBB_User__c=u.NOV_PSFT_User__c;
                c.NOV_SFDC_Portal_User__c=u.NOV_SFDC_User__c;
                c.Psft_Operator_ID__c=u.Psft_Operator_ID__c;
                c.NOV_isActive__c=u.isActive;
                c.NOV_isPilot__c=u.NOV_isPilot__c; 
                c.NOV_Preferred_Site__c=u.NOV_Preferred_Site__c;
                contactupdatelist.add(c);
         }
        }
        if((contactupdatelist!=null) && (contactupdatelist.size()>0))
        {
            update contactupdatelist;
        }
        
    }
}
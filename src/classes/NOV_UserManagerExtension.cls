/*
Author: ?
Date:   ?
Descr:  This is a helper class that is used by the IDM -> User -> Contact integration for btbb users.

ChangeLog:

2013-09-25: [LaL] TP4969-Contact.Title and Phone are being removed

*/
public class NOV_UserManagerExtension {
  
    private User user = new User();
    private Contact contact = new Contact();

    public Boolean ExistingUser {get;set;}
    public Boolean ActiveUser {get;set;}
    public Boolean ExistingUserAlert {get;set;}
    public String SelectedProfileId {get;set;}
    public Boolean PSFTUser {get;set;}
    public Boolean SFDCUser {get;set;}
    public Boolean Pilot {get;set;}
    public String SitePreference {get;set;}
    public Boolean hasInactiveUser {get;set;}
    public User userid{get;set;}
 
  
    public NOV_UserManagerExtension (ApexPages.StandardController stdController)
    {
        this.contact = (Contact)stdController.getRecord();
        if(this.contact.nov_userid__c !=null) { 
        for(User u:[Select Id, Username, Email, ContactId, isActive, Psft_Operator_Id__c, NOV_Reset_Password__c, NOV_Debug__c, Person_Id__c, NOV_PSFT_User__c, NOV_SFDC_User__c, NOV_isPilot__c, Profile.Name, NOV_Credentialed__c, NOV_isActive__c FROM User where contactid = :this.contact.id AND isActive = true limit 1]){
            this.user = u;
            ExistingUser = true;
            ActiveUser = true;
            }
        //Commented by shirish because it is contradicting with above if condition
        /*if(this.contact.nov_userid__c == null) {
        ExistingUser = false;
        
        } */
      }
      
      //Added by shirish on 15 July
      if(this.contact.nov_userid__c == null) {
        ExistingUser = false;
        hasInactiveUser = false;
      } 
      //End of added by Shirish
    }

    public String getContactFirstName()
    {
        return this.contact.FirstName;
    }
  
    public String getContactLastName()
    {
        return this.contact.LastName;
    }
  
    public String getContactEmail()
    {
        return this.contact.Email;
    }
  
    public String getContactPersonId() 
    {
        return this.contact.PS_Person_Id__c;
    }
    
    public String getCredentialedDate() 
    {
        return this.user.NOV_Credentialed__c;
    }
 
    public List<SelectOption> getCustomerPortalProfiles() 
    {
        
        Profile[] profiles = [Select p.name, p.id FROM Profile p where p.UserLicense.Name like '%Customer Portal%' AND p.Name like '%SRV%'];
        
        List<SelectOption> options = new List<SelectOption>();
            for(Profile p: profiles)
                  options.add(new SelectOption(p.id,p.name));
        return options;
    }

    public String getContactUserId() 
    {
        return this.contact.NOV_UserId__c;
    }
    
    public Boolean getActiveUserStatus() 
    {
        return this.user.isActive;
    }
    
    public Boolean getNOVisNew() 
    {
        return this.user.NOV_isNew__c;
    }
    
    public Boolean getNOVDebug() 
    {
        return this.user.NOV_Debug__c;
    }
    
    public Boolean getResetUserPassword() 
    {
        return this.user.NOV_Reset_Password__c;
    }
    
    public String getUserEmail() 
    {
        return this.user.email;
    }

    public Boolean getPSFTBTBBAccess() 
    {
        return this.user.NOV_PSFT_User__c;
    }
    
    public String getUserOperatorId() 
    {
        return this.user.Psft_Operator_ID__c;
    }
    
    public String getUserUsername() 
    {
        return this.user.Username;
    }
    
    public Boolean getSFDCBTBBAccess() 
    {
        return this.user.NOV_SFDC_User__c;
    }
    
    public Boolean getPilotUser() 
    {
        return this.user.NOV_isPilot__c;
    }
    
    public String getUserProfileName() 
    {
        return this.user.profile.name;
    }
    
    public String getUserPreferredSite() 
    {
        return this.user.NOV_Preferred_Site__c;
    }
    
    public pageReference ResetPassword() {
    try {
            BtbbUserEmailLog__c useremail = new BtbbUserEmailLog__c();
            String result;
            
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.EmailHeader.triggerUserEmail = false;
            
            /*
                this.user.NOV_Reset_Password__c = true;
                update user;
                PageReference Refresh = new PageReference('/apex/NOV_UserManager?id='+this.contact.id);
                Refresh.SetRedirect(true);
                return Refresh;
           */
           
           
            userid = [Select id,email from user where contact.id=:Apexpages.currentpage().getparameters().get('id')];
            ResetPasswordResult rpr = System.resetPassword(userid.id,false);
            result = rpr.getPassword();
            Contact.LastPasswordChange__c=DateTime.now();
            update contact;
            
            useremail.user__c=userid.id;
            useremail.contact__c=contact.id;
            useremail.email__c=userid.email;
            useremail.Type__c='Recredential';
            useremail.Password__c=result;
            insert useremail;
            
            PageReference Refresh = new PageReference('/apex/NOV_UserManager?id='+this.contact.id);
            Refresh.SetRedirect(true);
            return Refresh;
        }
        catch(Exception ex) 
        {
            ApexPages.addMessages(ex);
            return null;
        }
        
    }

    public pageReference Deactivate() {
    
    try {
        hasInactiveUser = true;
        activeuser = false;
        this.user.NOV_isActive__c = false;
        this.user.isActive = False;
        update user;
        PageReference Refresh = new PageReference('/apex/NOV_UserManager?id='+this.contact.id);
        Refresh.SetRedirect(true);
        return Refresh;
        }
        catch(Exception ex) {
            ApexPages.addMessages(ex);
            return null;
        }
    }
    
    public pageReference CreateUser()
    {     
        if(hasInactiveUser == False)
        {  //Modified by Shirish on 15 July         
            try 
            {
                BtbbUserEmailLog__c usercreation = new BtbbUserEmailLog__c();
                String npassword;
            
            
                Database.DMLOptions dmo = new Database.DMLOptions();
                dmo.EmailHeader.triggerUserEmail = false;
                Contact con = [SELECT Id, FirstName, LastName, Email, Title, Phone, MobilePhone, MailingStreet, MailingCity, MailingState, MailingCountry, MailingPostalCode, PS_Person_ID__c, psft_operator_id__c FROM contact WHERE id = :this.contact.id];
                User usr = new User(
                alias='btbbusr',
                Person_Id__c=con.PS_Person_ID__c,
                email=con.email,
                emailencodingkey='UTF-8',
                lastname=con.lastname,
                firstname=con.firstname,
                contactid=con.id,
                profileId = selectedProfileId,
                username=con.email,
                CommunityNickname=con.psft_operator_id__c,
                languagelocalekey='en_US',
                localesidkey='en_US',
                timezonesidkey='America/Los_Angeles',
                isActive=true,
                    
                // TP 4969 fix 
                Title = con.Title,
                Phone = con.Phone,
                MobilePhone = con.MobilePhone,
                Street = con.MailingStreet,
                City = con.MailingCity,
                State = con.MailingState,
                Country = con.MailingCountry,
                PostalCode = con.MailingPostalCode,    
                // TP 4969 fix
                    
                NOV_SFDC_User__c=SFDCUser,
                NOV_PSFT_User__c=PSFTUser,
                NOV_isPilot__c=Pilot,
                NOV_Debug__c=true,
                NOV_isNew__c=true,
                PSFT_Operator_Id__c=con.PSFT_Operator_Id__c,
                NOV_Preferred_Site__c=SitePreference,
                NOV_isActive__c = true);
                usr.setOptions(dmo);
                System.debug(usr);
                insert usr;
                
                
                /*ResetPasswordResult npr = System.resetPassword(usr.id,false);
                npassword = npr.getPassword();
                
                usercreation.user__c=usr.id;
                usercreation.contact__c=con.id;
                usercreation.email__c=usr.email;
                usercreation.Type__c='Initial';
                usercreation.Password__c=npassword;
                insert usercreation; */
                
                
                PageReference Refresh = new PageReference('/apex/NOV_UserManager?id='+this.contact.id);
                Refresh.SetRedirect(true);
                return Refresh;
            }
            catch(Exception ex)  
            {  
                ApexPages.addMessages(ex); 
                return null; 
            }          
        
        }
       User u = new User(Id=this.contact.NOV_UserId__c);
       try {    
           u.isActive=true;
           u.NOV_isActive__c = true;
           u.NOV_isNew__c = true;
           u.NOV_Debug__c = true;
           hasInactiveUser = false;
           activeuser = true;
           update u;
        PageReference Refresh = new PageReference('/apex/NOV_UserManager?id='+this.contact.id);
           Refresh.SetRedirect(true);
           return Refresh;
           }
           catch (Exception ex){
               ApexPages.addMessages(ex);
               return null;
               }   
    }
    
    
    public pageReference GoToUser() {
    PageReference ReturnUser = new PageReference ('/'+this.user.id);
    ReturnUser.SetRedirect(true);
    return ReturnUser;
    }
}
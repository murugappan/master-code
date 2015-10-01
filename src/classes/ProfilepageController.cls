public class ProfilepageController {
    GlobalComponent gc = new GlobalComponent();
    public boolean editsec {get;set;}
    public User u {get;set;}
    
    public void showeditsec(){
         editsec = true;
    }
    
    public Id id { get; set; }
    public String FirstName{ get; set;}
    public String LastName{ get; set; }
    public String Email{ get; set; }
    public String ContactId{ get; set; }
    public String Title{ get; set; }
    public String MobilePhone {get; set;}
    public String Phone {get; set; }
    public String Fax {get; set; }
    public String Street{get; set; }
    public String City{get; set; }
    public String State{get; set; }
    public String PostalCode{get; set; }
    public String NOVPreferredSite {get; set; }
    public String BTBBKBDefaultProd {get; set; }
    public string selectedproduct{get;set;}
    List<User> userList;
    public string BUaccess{get;set;}
     public String ccRecipients {get;set;}
    public boolean ccerrorShow{get;set;}
    public String  ccerrorMessage{get;set;}
  /*  public List<SelectOption> getDefaultCategory() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All Products','All Products'));
        options.add(new SelectOption('ANGEL','ANGEL'));
        options.add(new SelectOption('CE/Vista','CE/Vista'));
        options.add(new SelectOption('Learn','Learn'));
        options.add(new SelectOption('Xythos','Xythos'));
        return options;
        // options.add(new SelectOption('Moodlerooms','Moodlerooms')); 
        
    }*/
    
    public List<SelectOption> getLoginPreference() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Learn','Learn'));
        options.add(new SelectOption('Transact','Transact'));        
        return options;
    }
    
     public List<SelectOption> getDatabaseList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('-- None --','-- None --'));
        options.add(new SelectOption('Microsoft SQL Server 2005','Microsoft SQL Server 2005'));
        options.add(new SelectOption('Microsoft SQL Server 2008','Microsoft SQL Server 2008'));
        options.add(new SelectOption('Oracle 10g','Oracle 10g'));
        options.add(new SelectOption('Oracle 11g','Oracle 11g'));
        return options;
    }
    
    public void updateproduct(){
    BTBBKBDefaultProd =selectedproduct;
    }
    
    public ProfilepageController() {
        editsec = false;
       /* if(System.currentPageReference().getParameters().get('id') != null && System.currentPageReference().getParameters().get('id') != '')   
            Id = System.currentPageReference().getParameters().get('id');   */
            id=Userinfo.getuserid();
        if(id != null) {
            userList = [select  NOV_Preferred_Site__c, BTBB_KB_Default_Prod__c, Phone, MobilePhone, City, Street, State, PostalCode,
                        Fax, ContactId, LastName, FirstName, Email, Title, TimeZoneSidKey,Btbb_Case_Cc__c From User Where id = : id];
           
            FirstName = userList[0].FirstName;
            LastName = userList[0].LastName;
            Email = userList[0].Email;
            ContactId = userList[0].ContactId;
            Title = userList[0].Title;
            MobilePhone = userList[0].MobilePhone;
            Phone = userList[0].Phone;
            Fax = userList[0].Fax;
            Street = userList[0].Street;
            City = userList[0].City;
            State = userList[0].State;
            PostalCode = userList[0].PostalCode;
            NOVPreferredSite = userList[0].NOV_Preferred_Site__c;
            BTBBKBDefaultProd = userList[0].BTBB_KB_Default_Prod__c;
            ccRecipients=userList[0].Btbb_Case_Cc__c;
            if(BTBBKBDefaultProd=='All Products')
            {
                BTBBKBDefaultProd=null;
            }
            u = userList[0];
            
        }
        
        for(Contact_Role__c cr1 : [Select c.Role__c, c.Code__c,c.Contact__c, c.Account__c From Contact_Role__c c where Contact__c =: userList[0].ContactID AND Expire_Role__c = false AND Contact__c!= NULL]){
             if(cr1.Role__c.containsignorecase('Learn')||cr1.Role__c.containsignorecase('Angel')||cr1.Role__c.containsignorecase('Vista')||cr1.Role__c.containsignorecase('Xythos'))
                        {
                                BUaccess=BUaccess+',Learn_BU,ANGEL_BU,Xythos_BU,CE_Vista_BU';
                        }
                        else if(cr1.Role__c.containsignorecase('Collaborate'))
                        {
                                BUaccess=BUaccess+',Collaborate';
                        }
                        else if(cr1.Role__c.containsignorecase('Moodlerooms'))
                        {
                                BUaccess=BUaccess+',Moodlerooms';
                        }
                        else if(cr1.Role__c.containsignorecase('Analytics'))
                        {
                                BUaccess=BUaccess+',Analytics';
                        }
                        else if(cr1.Role__c.containsignorecase('xpLor'))
                        {
                                BUaccess=BUaccess+',xpLor';
                        }
        }
       //u = (User)controller.getRecord();
        System.debug(u);
    
    }
    
    
    
    public pagereference doSave(){
        editsec = false;        
        u.NOV_Preferred_Site__c = NOVPreferredSite;
        u.BTBB_KB_Default_Prod__c = BTBBKBDefaultProd;
        if(false==  validateccemails())
        {   
            editsec = true; 
            return null;
        }
        Update u; 
        FirstName = u.FirstName;
        LastName = u.LastName;
        Email = u.Email;
        ContactId = u.ContactId;
        Title = u.Title;
        MobilePhone = u.MobilePhone;
        Phone = u.Phone;
        Fax = u.Fax;
        Street = u.Street;
        City = u.City;
        State = u.State;
        PostalCode = u.PostalCode;
        return null;
               
    }
    
    public PageReference doCancel(){
        PageReference pageRedirect = new PageReference('/btbb_myprofile?id=' + UserInfo.getUserId());
        //pageRedirect.getParameters().put('id',UserInfo.getUserId());    
        pageRedirect.setRedirect(true);
        return pageRedirect ;
        //editsec = false;
    }
    public PageReference Redirect() {
        if(gc.userRedirect == true){
            PageReference pageRedirect = new PageReference(gc.IDMRedirectURL);
            pageRedirect.getParameters().put('TARGET',gc.IDMTargetURL);          
            pageRedirect.setRedirect(true);
            return pageRedirect;
        }  
        else if(System.currentPageReference().getParameters().get('id') == null || System.currentPageReference().getParameters().get('id') == '' || UserInfo.getUserId() != System.currentPageReference().getParameters().get('id')) {
           PageReference pageRedirect = new PageReference('/btbb_myprofile?Id='+UserInfo.getUserId());
           System.debug('<<<<<<<< In pageRedirect >>>>>>>>>' +pageRedirect );
            pageRedirect.setRedirect(true);
            return pageRedirect ;
        }
        else
            return null;
    }  

    public boolean validateccemails()
  {

    ccerrorShow=false;
    ServiceCloudUtility.ValidateEmailResults ccErrorResult= ServiceCloudUtility.validateccemails(ccRecipients);
      if(ccErrorResult != null && ccErrorResult.isSuccess==false)
      {
        ccerrorShow=true;
        ccerrorMessage=ccErrorResult.errormessage;
        return false;
      }
      else{
         u.Btbb_Case_Cc__c=ccRecipients;
         return true;
      }
  }
     public boolean isTransactUser {
        
        get {
            User curUser=[SELECT Id, ContactId FROM User where Id = :userInfo.getUserId()];
            if(curUser != null) {
                Integer flag = 0;               
                for(Contact_Role__c contRole : [Select c.Role__c, c.Id, c.Contact__c, c.Contact_Role_Email__c From Contact_Role__c c  where contact__c = :curUser.ContactId AND Contact__c!= NULL]) {
                     System.debug('In ProfilepageController contRole >>>>>>>>>' +contRole);
                    if(null != contRole.Role__c && (contRole.Role__c.Contains('Transact') || contRole.Role__c.Contains('TRANSACT'))) {
                        isTransactUser = true;
                        flag = 1;
                        break;
                    }
                }
                if(flag == 0)
                    isTransactUser = false;             
            }
            System.debug('isTransactUser >>>>>>>>>' +isTransactUser);
            return isTransactUser;
        }
        set { 
            if(value != null) isTransactUser = value;
        }       
            
    }

    public pagereference changepassword()
    {
        pagereference pageref= Page.changepassword;
        pageref.getparameters().put('retURL','/btbb_myprofile');
        pageref.setredirect(true);
        return pageref;
    }
    
     static testMethod void testSave() {
        
        
        User curUser=[SELECT Id, ContactId FROM User where Id = :userInfo.getUserId()];
        System.currentPageReference().getParameters().put('id',curUser.id);
        //system.currentpagereference().getParameters().put('id',sol.id);
        ProfilepageController controller = new ProfilepageController();
        controller.u = curUser;
        controller.id = curUser.Id; 
        controller.FirstName='test';
        controller.LastName = 'last';
        controller.Email='test@mail.com';
        controller.ContactId='';
        controller.Title='test';
        controller.MobilePhone='3333';
        controller.Phone='3333';
        controller.Fax='3333';
        controller.Street='test';
        controller.City='test';
        controller.State='3333';
        controller.PostalCode='3333';
        controller.NOVPreferredSite='Learn';
        controller.editsec = false; 
        controller.showeditsec();
        controller.BTBBKBDefaultProd='Transact';
        List<User> userList = controller.userList;
       // controller.getDefaultCategory();
        controller.getLoginPreference();
        controller.getDatabaseList();
        controller.doCancel();
        controller.doCancel();
        controller.doSave();
        
        controller.ccRecipients='';
        controller.validateccemails();
        controller.ccRecipients='testacc;testcc';
        controller.validateccemails();
        controller.ccRecipients='test@acc1.com;test@acc2.com;test@acc3.com;test@acc4.com;test@acc5.com;test@acc6.com;';
        controller.validateccemails();
        controller.ccRecipients='test@acc1.com;test@acc2.com;test@acc3.com;test@acc4.com;test@acc5.com;';
        controller.validateccemails();
        controller.isTransactUser = false;
        controller.isTransactUser = true;
        Boolean test = controller.isTransactUser;
        controller.isTransactUser = false;      
        test = controller.isTransactUser;
        controller.Redirect();
        System.currentPageReference().getParameters().put('id',null);           
        controller.Redirect();
        List<User> existingPortalUsers = [SELECT id, profileId, userRoleId FROM User WHERE UserRoleId <> null AND UserType='CustomerSuccess'];
        if(!existingPortalUsers.isEmpty()) {
            User existingPortalUser = existingPortalUsers[0];                
            System.runAs(existingPortalUser) {
                System.currentPageReference().getParameters().put('id',null);
                controller = new ProfilepageController();
                controller.Redirect();
                
            }
        }
        
     }
      static testMethod void UnittestMethod1(){

        PageReference pageRef = Page.btbb_myprofile;
        test.setcurrentpage(pageRef);
        ProfilepageController controller = new ProfilepageController();
        controller.changepassword();
        controller.updateproduct();

      }
     static testMethod void UnitTestMoodleroomsPositiveScenario(){
      user sysuser=[select id,name from user where username like 'tsg@blackboard.com%' and isactive =true limit 1];
      system.runas(sysuser){

        PageReference pageRef = Page.btbb_myprofile;
        test.setcurrentpage(pageRef);

        Account ac=TestMethodUtility.createAccount();
        ac.ownerid=userinfo.getuserid();
        ac.PS_Company_ID__c='78907';
        insert ac; 

        Contact cont = new Contact(LastName = 'Contact Last Name', AccountId = ac.id);
        cont.AccountId=ac.id;
        cont.Account=ac;
        cont.PS_Person_Id__c='67367332';
        cont.email='test@bb.com';
        insert cont; 
        
        Profile p1 = [select id,Name from Profile where Name='SRV - BTBB User'];
        User u = TestMethodUtility.createUser(p1);
        u.contactId=cont.id;
        insert u;

        Core_License__c cr = TestMethodUtility.createCoreLicense();
        cr.Name = 'Moodlerooms';
        insert cr;

        Contact_Role__c crr = TestMethodUtility.createContactRole(ac);
        crr.CurrencyIsoCode='GBP';
        crr.Expire_Role__c=False;
        crr.Contact__c=u.contactId;
        crr.Role__c= 'Moodlerooms - Admin';
        
        insert crr;

        system.runAs(u){

      ProfilepageController controller1 = new ProfilepageController();

      }
      }


     }

     static testMethod void UnitTestAnalyticsPositiveScenario(){
      user sysuser=[select id,name from user where username like 'tsg@blackboard.com%' and isactive =true limit 1];
      system.runas(sysuser){

        PageReference pageRef = Page.btbb_myprofile;
        test.setcurrentpage(pageRef);

        Account ac=TestMethodUtility.createAccount();
        ac.ownerid=userinfo.getuserid();
        ac.PS_Company_ID__c='78907';
        insert ac; 

        Contact cont = new Contact(LastName = 'Contact Last Name', AccountId = ac.id);
        cont.AccountId=ac.id;
        cont.Account=ac;
        cont.PS_Person_Id__c='67367332';
        cont.email='test@bb.com';
        insert cont; 
        
        Profile p1 = [select id,Name from Profile where Name='SRV - BTBB User'];
        User u = TestMethodUtility.createUser(p1);
        u.contactId=cont.id;
        insert u;

        Core_License__c cr = TestMethodUtility.createCoreLicense();
        cr.Name = 'Analytics';
        insert cr;

        Contact_Role__c crr = TestMethodUtility.createContactRole(ac);
        crr.CurrencyIsoCode='GBP';
        crr.Expire_Role__c=False;
        crr.Contact__c=u.contactId;
        crr.Role__c= 'ANALYTICS - Admin';
        
        insert crr;

        system.runAs(u){

      ProfilepageController controller2 = new ProfilepageController();

      }
      }


     }

     static testMethod void UnitTestxpLorPositiveScenario(){
      user sysuser=[select id,name from user where username like 'tsg@blackboard.com%' and isactive =true limit 1];
      system.runas(sysuser){

        PageReference pageRef = Page.btbb_myprofile;
        test.setcurrentpage(pageRef);

        Account ac=TestMethodUtility.createAccount();
        ac.ownerid=userinfo.getuserid();
        ac.PS_Company_ID__c='78907';
        insert ac; 

        Contact cont = new Contact(LastName = 'Contact Last Name', AccountId = ac.id);
        cont.AccountId=ac.id;
        cont.Account=ac;
        cont.PS_Person_Id__c='67367332';
        cont.email='test@bb.com';
        insert cont; 
        
        Profile p1 = [select id,Name from Profile where Name='SRV - BTBB User'];
        User u = TestMethodUtility.createUser(p1);
        u.contactId=cont.id;
        insert u;

        Core_License__c cr = TestMethodUtility.createCoreLicense();
        cr.Name = 'xpLor';
        insert cr;

        Contact_Role__c crr = TestMethodUtility.createContactRole(ac);
        crr.CurrencyIsoCode='GBP';
        crr.Expire_Role__c=False;
        crr.Contact__c=u.contactId;
        crr.Role__c= 'XPLOR - Admin';
        
        insert crr;

        system.runAs(u){

      ProfilepageController controller2 = new ProfilepageController();

      }
      }


     }

     static testMethod void UnitTestCollaboratePositiveScenario(){
      user sysuser=[select id,name from user where username like 'tsg@blackboard.com%' and isactive =true limit 1];
      system.runas(sysuser){

        PageReference pageRef = Page.btbb_myprofile;
        test.setcurrentpage(pageRef);

        Account ac=TestMethodUtility.createAccount();
        ac.ownerid=userinfo.getuserid();
        ac.PS_Company_ID__c='78907';
        insert ac; 

        Contact cont = new Contact(LastName = 'Contact Last Name', AccountId = ac.id);
        cont.AccountId=ac.id;
        cont.Account=ac;
        cont.PS_Person_Id__c='67367332';
        cont.email='test@bb.com';
        insert cont; 
        
        Profile p1 = [select id,Name from Profile where Name='SRV - BTBB User'];
        User u = TestMethodUtility.createUser(p1);
        u.contactId=cont.id;
        insert u;

        Core_License__c cr = TestMethodUtility.createCoreLicense();
        cr.Name = 'Collaborate';
        insert cr;

        Contact_Role__c crr = TestMethodUtility.createContactRole(ac);
        crr.CurrencyIsoCode='GBP';
        crr.Expire_Role__c=False;
        crr.Contact__c=u.contactId;
        crr.Role__c= 'Collaborate - Admin';
        
        insert crr;

        system.runAs(u){

      ProfilepageController controller2 = new ProfilepageController();

      }
      }


     }

     static testMethod void UnitTestTransactScenario(){
      user sysuser=[select id,name from user where username like 'tsg@blackboard.com%' and isactive =true limit 1];
      system.runas(sysuser){

        PageReference pageRef = Page.btbb_myprofile;
        test.setcurrentpage(pageRef);

        Account ac=TestMethodUtility.createAccount();
        ac.ownerid=userinfo.getuserid();
        ac.PS_Company_ID__c='78907';
        insert ac; 

        Contact cont = new Contact(LastName = 'Contact Last Name', AccountId = ac.id);
        cont.AccountId=ac.id;
        cont.Account=ac;
        cont.PS_Person_Id__c='67367332';
        cont.email='test@bb.com';
        insert cont; 
        
        Profile p1 = [select id,Name from Profile where Name='SRV - BTBB User'];
        User u = TestMethodUtility.createUser(p1);
        u.contactId=cont.id;
        insert u;

        Core_License__c cr = TestMethodUtility.createCoreLicense();
        cr.Name = 'Transact';
        insert cr;

        Contact_Role__c crr = TestMethodUtility.createContactRole(ac);
        crr.Contact__c=u.contactId;
        
        crr.Role__c= 'TRANSACT - Admin';
        
        insert crr;

        system.runAs(u){

      ProfilepageController controller2 = new ProfilepageController();
    
      controller2.isTransactUser = true;
        Boolean test = controller2.isTransactUser;

      }
      }


     }

static testMethod void UnitTestLearnPositiveScenario(){
      user sysuser=[select id,name from user where username like 'tsg@blackboard.com%' and isactive =true limit 1];
      system.runas(sysuser){

        PageReference pageRef = Page.btbb_myprofile;
        test.setcurrentpage(pageRef);

        Account ac=TestMethodUtility.createAccount();
        ac.ownerid=userinfo.getuserid();
        ac.PS_Company_ID__c='78907';
        insert ac; 

        Contact cont = new Contact(LastName = 'Contact Last Name', AccountId = ac.id);
        cont.AccountId=ac.id;
        cont.Account=ac;
        cont.PS_Person_Id__c='67367332';
        cont.email='test@bb.com';
        insert cont; 
        
        Profile p1 = [select id,Name from Profile where Name='SRV - BTBB User'];
        User u = TestMethodUtility.createUser(p1);
        u.contactId=cont.id;
        insert u;

        Core_License__c cr = TestMethodUtility.createCoreLicense();
        cr.Name = 'ANGEL';
        insert cr;

        Contact_Role__c crr = TestMethodUtility.createContactRole(ac);
        crr.CurrencyIsoCode='GBP';
        crr.Expire_Role__c=False;
        crr.Contact__c=u.contactId;
        crr.Role__c= 'LEARN (Bb) - Admin';
        
        insert crr;

        system.runAs(u){

      ProfilepageController controller2 = new ProfilepageController();

      }
      }


     }


     
     
}
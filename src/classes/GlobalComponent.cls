global class GlobalComponent {
    
    User curUser;
    Profile profileObj;
    List<CategoryNode> catNodeList;
    public String InstanceURL;
    public String IDMRedirectURL;
    public Boolean UserRedirect;
    public String IDMTargetURL;
    public String SiteURL;
    public Id ContactId;
    public Id accountId;
    public String profileName;

    private static Map<String, Id> CACHE;
    public static user currentuser{get;set;}
    public static Boolean getApiUser(Id userid){
        If(currentuser == null)
        {
                currentuser = [Select Integration_User__c From User Where Id =:userid];
        }
                if(currentuser.Integration_User__c != false)
                    return true;
                else
                    return false;

    }

    public GlobalComponent() {
        profileObj = [Select Name,Id From Profile where Id = : UserInfo.getprofileId()];
        profileName = profileObj.Name;
        System.debug('profileObj >>>>>>>>' + profileObj.Name);
        curUser = [select ID,Contact.AccountId,ContactID, Name, BTBB_KB_Default_Prod__c from User where ID =: Userinfo.getUserID()];   
      /*  catNodeList = [SELECT Id, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, MasterLabel, ParentId, SortOrder, SortStyle, SystemModstamp 
                                            FROM CategoryNode WHERE MasterLabel != 'Process/Procedure'
                                            ORDER BY MasterLabel ASC]; */
                                            
       ContactId = curUser.ContactId;
       accountId = curUser.Contact.AccountId;
       /* Get the Current Base URL */
       InstanceURL = URL.getSalesforceBaseUrl().toExternalForm();
                   
       IDMRedirectURL = '/Login';
       
       /* Evaluate Whether a User Has a Session on BTBB */
        if(profileObj.Name == 'BTBB Profile') 
            UserRedirect = true;
        else
            UserRedirect = false;
        if(InstanceURL.contains('na5') || InstanceURL.contains('http://blackboard.force.com') || InstanceURL.contains('https://blackboard.secure.force.com')||InstanceURL.containsignorecase('blackboard.my.salesforce'))
           SiteURL = 'https://blackboard.secure.force.com';
       else if(InstanceURL.containsignorecase('--qax') || InstanceURL.contains('blackboard.qax')||InstanceURL.contains('qax-blackboard'))
             SiteURL = 'https://qax-blackboard.cs30.force.com';
           
       else if(/*InstanceURL.contains('cs3') ||*/ InstanceURL.contains('blackboard.dvx'))
           SiteURL = 'http://blackboard.dvx.cs3.force.com';
       else
            SiteURL = 'https://blackboard.secure.force.com';
                        
        //IDMTargetURL = SiteURL+ApexPages.currentPage().getUrl();
        IDMTargetURL = ApexPages.currentPage().getUrl();
                            
    }

    public boolean isXythosOnly() 
    {
        Boolean isXythosOnly;                        
        if(curUser != null) 
        {
            Integer flag = 0;                
            for(Contact_Role__c contRole : [Select Account__c, Role__c, Id, Contact__c From Contact_Role__c where contact__c = :curUser.ContactId AND Contact__c!= NULL]) 
            {
                if(null != contRole.Role__c && (contRole.Role__c.Contains('Xythos'))) 
                {
                    isXythosOnly = true;                      
                }
                else 
                {
                    isXythosOnly = false;  
                    break; 
                }
            }
        }
        if(isXythosOnly == null)          
            isXythosOnly = false;
        System.debug('isXythosOnly >>>>>>>>>' +isXythosOnly);
        return isXythosOnly;
        
    }
    
    public boolean isTransactUser() 
    {
        boolean isTransactUser;
        if(curUser != null) 
        {
            Integer flag = 0;                
            for(Contact_Role__c contRole : [Select c.Role__c, c.Id, c.Contact__c, c.Contact_Role_Email__c From Contact_Role__c c  where contact__c = :curUser.ContactId AND Contact__c!= NULL]) 
            {
                System.debug('In Global Search contRole >>>>>>>>>' +contRole);
                if(null != contRole.Role__c && (contRole.Role__c.Contains('Transact') || contRole.Role__c.Contains('TRANSACT'))) 
                {
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
    
    public String defaultProduct() 
    {
        String category;
        if(null != curUser)
        {            
            String defaultCategory = curUser.BTBB_KB_Default_Prod__c;
            System.debug('defaultCategory >>>>>' +defaultCategory);
            if(defaultCategory != null)
              /*  for(CategoryNode catNode : catNodeList) {
                    
                    if(catNode.ParentId == null && defaultCategory.equals(catNode.MasterLabel)) {
                        category = catNode.Id;
                        break;
                    }
                } */
            System.debug('category >>>>>' +defaultCategory);                                   
         }
         return category;    
    }
    
    public boolean isMLAAdmin() 
    {                    
      
        boolean isMLAAdmin;
        if(curUser != null) 
        {
            Integer flag = 0;                
            for(Contact_Role__c contRole : [Select Account__c, Role__c, Id, Contact__c From Contact_Role__c where contact__c = :curUser.ContactId AND Contact__c!= NULL]) {
                if(null != contRole.Role__c && (contRole.Role__c.Contains('MLA') && contRole.Role__c.Contains('Admin'))) {
                    
                    isMLAAdmin = true;                      
                } else {
                    isMLAAdmin = false;  
                    break; 
                }
            }
           
        }         
        System.debug('isMLAAdmin >>>>>>>>>' +isMLAAdmin);
        return isMLAAdmin;
    }  
    
    public boolean isCollabAdmin() {                    
        
        boolean isCollabadmin=false;
        if(curUser != null) {
            Integer flag = 0;                
            for(Contact_Role__c contRole : [Select Account__c, Role__c, Id, Contact__c From Contact_Role__c where contact__c = :curUser.ContactId AND Contact__c!= NULL]) {
                if(null != contRole.Role__c && (contRole.Role__c.Containsignorecase('Collaborate') && contRole.Role__c.Containsignorecase('Admin'))) {
                    
                    isCollabadmin = true;
                    break;                      
                } else {
                    isCollabadmin = false;  
                   
                }
            }
           
        }         
        return isCollabadmin;
    }  
    
    public boolean isLearnAcademicDeveloper() {                    
        
        boolean isLearnAcademicDeveloper;
        if(curUser != null) {
            Integer flag = 0;                
            for(Contact_Role__c contRole : [Select Account__c, Role__c, Id, Contact__c From Contact_Role__c where contact__c = :curUser.ContactId AND Contact__c!= NULL]) {
                    if(null != contRole.Role__c && contRole.Role__c =='Learn - Academic Developer') {
                    
                    isLearnAcademicDeveloper = true;                      
                } else {
                    isLearnAcademicDeveloper = false;  
                    break; 
                }
            }
           
        }         
        System.debug('isLearnAcademicDeveloper >>>>>>>>>' + isLearnAcademicDeveloper);
        return isLearnAcademicDeveloper;
    }  
    
    
    public boolean isCollabOnlyContactRole() {
        Boolean iscollabonlyContactRole;                        
        if(curUser != null) {
            Integer flag = 0;                
            for(Contact_Role__c contRole : [Select Account__c, Role__c, Id, Contact__c From Contact_Role__c where contact__c = :curUser.ContactId AND Contact__c!= NULL]) {
                if(null != contRole.Role__c && (contRole.Role__c.Contains('Collaborate') && (!contRole.Role__c.Contains('Learn')) && (!contRole.Role__c.Contains('All Products')))) {
                    
                    iscollabonlyContactRole = true;                      
                } else {
                    iscollabonlyContactRole = false;  
                    break; 
                }
            }
        }
        if(iscollabonlyContactRole == null)          
            iscollabonlyContactRole = false;
        System.debug('iscollabonlyContactRole >>>>>>>>>' +iscollabonlyContactRole);
        return iscollabonlyContactRole;
        
    }
    
    
    
    
    
    
    
    
    static testMethod void GlobalComponent() {
    GlobalComponent GlobalComponentObj = new GlobalComponent();
    Profile pf1= [select id from Profile where name = 'SRV - KM USR - Publisher'];
        User u2 = TestMethodUtility.createUser(pf1);
        insert u2;
        System.runas(u2){
        GlobalComponent.getApiUser(u2.id);
        GlobalComponentObj.defaultProduct();
        GlobalComponentObj.isMLAAdmin();
        GlobalComponentObj.isTransactUser();
        GlobalComponentObj.isXythosOnly();
       
        }
    }
}
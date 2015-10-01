public Without Sharing class  BtBbXythosHomePageController {
/*        
    GlobalComponent gc = new GlobalComponent();   
    public List<CategoryNode> catNodeList; 
    public String category;
    public boolean xythosonly {get;set;}
    public Boolean runFromTest;
    transient List<Solution> results;
    List<User> u;
    private List<Solution> KIArticles;
    private List<Solution> SBSAArticles;
    private List<Solution> PRIArticles;
    private List<Solution> SPArticles;
    private List<Solution> allArticles;
    List<Case> caselist = new List<Case>();
    public List<String> clientID {get;set;}
    //public Boolean loadArticle { get; set; }
    
    public List<Solution> getKIArticles() {
        return KIArticles;
    }
    
    public List<Solution> getSBSAArticles() {
        return SBSAArticles;
    }
    
    public List<Solution> getPRIArticles() {
        return PRIArticles;
    }
    public List<Solution> getSPArticles() {
        return SPArticles;
    }
    public String getCategory() {
        return category;
    }
    
    public List<Solution> getAllArticles() {
        return allArticles;
    }
        
    public void setCategory(String category) {
        this.category = category;
    }

        public List<Case> getRecentCases() {
        
               List<Case> clist = new List<Case>();
               if(caselist.size() > 10){ 
                   for(Integer i=0; i<10; i++){
                       clist.add(caselist[i]);
                   }
                }else{
                   for(Integer i=0; i<caselist.size(); i++){
                       clist.add(caselist[i]);
                   }
                }
             return clist;   
        }
        public BtBbXythosHomePageController() {
                
            catNodeList = [SELECT Id, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, MasterLabel, ParentId, SortOrder, SortStyle, SystemModstamp 
                                            FROM CategoryNode WHERE MasterLabel != 'Process/Procedure'
                                            ORDER BY MasterLabel ASC];
                                            
            u = new List<User>([select ID,ContactID, Name, BTBB_KB_Default_Prod__c from User where ID =: Userinfo.getUserID()]);
           
           //Update by Shirish On 08/June/2011 for Implementing default product in what new section
           if(null != u && u.size() > 0){               
                String defaultCategory = u[0].BTBB_KB_Default_Prod__c;                
                if(defaultCategory != null)
                    for(CategoryNode catNode : catNodeList) {
                        
                        if(catNode.ParentId == null && defaultCategory == catNode.MasterLabel) {
                            category = catNode.Id;
                            break;
                        }
                    } 
                
                                           
            } 
            //End of Update by Shirish On 08/June/2011
       Map<ID,Set<String>> accountmap = new Map<ID,Set<String>>();
       Set<ID> AccountID = new Set<ID>();
       Set<String> croles = new Set<String>();
       RecentArticles();
       
       for(List<Contact_Role__c> cr : [Select c.Role__c, c.Code__c,c.Contact__c, c.Account__c From Contact_Role__c c where Contact__c =: u[0].ContactID AND Expire_Role__c = false]){     
           for(Contact_Role__c cr1 : cr){                  
               if(null != accountmap && (accountmap.size() == 0 || !accountmap.containsKey(cr1.Account__c))){
                   
                   Set<String> role = new Set<String>();
                   if(null != cr1.Code__c) {
                        role.add(cr1.Code__c);
                   }
                   accountmap.put(cr1.Account__c,role);
                   AccountID.add(cr1.Account__c);
               }else if(null != accountmap){
                   
                   Set<String> role = new Set<String>();
                   role = accountmap.get(cr1.Account__c);
                   if(null != cr1.Code__c) {
                       role.add(cr1.Code__c);
                   }
                   accountmap.put(cr1.Account__c,role);
                   AccountID.add(cr1.Account__c);
               } 
               if(cr1.Code__c != null)              
                   croles.add(cr1.Code__c);
            }
         }   
        
         for(Case c : [SELECT Id, AccountId, IsSelfServiceClosed, Case_Record__c, Account_Name__c ,ContactId, Contact.Name, CaseNumber, Subject, Status, Customer_Portal_Status__c, Case_Severity__c, LastModifiedDate, Psft_Case_Id__c FROM Case where AccountID IN: accountmap.Keyset() ORDER BY LastModifiedDate DESC LIMIT 100]){
             Set<String> roles = new Set<String>();             
             roles = accountmap.get(c.AccountID);             
             if(roles.contains('LEARN')){
                 if(c.Case_Record__c != null && c.Case_Record__c.contains('Learn'))
                    caselist.add(c);
             }if(roles.contains('ANGEL')){
                 if(c.Case_Record__c != null && c.Case_Record__c.contains('ANGEL'))
                     caselist.add(c);
             }if(roles.contains('TRANSACT')){
                 if(c.Case_Record__c != null && c.Case_Record__c.contains('Transact'))
                     caselist.add(c); 
             }if(roles.contains('XYTHOS')){
                 if(c.Case_Record__c != null && c.Case_Record__c.contains('Xythos'))
                     caselist.add(c); 
             }
             if(roles.contains('CEVISTA')){
                 if(c.Case_Record__c != null && c.Case_Record__c.contains('CE') && c.Case_Record__c.contains('Vista'))
                     caselist.add(c); 
             }
          }  
          clientID = new List<String>();  
          Set<String> cId = new Set<String>();
          for(List<Account> acc : [select ID,PS_Company_Id__c,Name from Account where ID IN: AccountID ORDER BY NAME DESC]){
              for(Account a : acc){
                      cId.add(a.Name + ' : ' + a.PS_Company_Id__c); 
              }        
          }
          clientID.addAll(cId); 
          
          if(croles.size() == 1 && croles.contains('XYTHOS'))
             xythosonly = true;
          else    
             xythosonly = false;
       }
        
        //Return picklist values for product 
     public List<SelectOption> getCategories() {
        
                List<SelectOption> options = new List<SelectOption>();
                options.add(new SelectOption('','All Products'));
        for(CategoryNode catNode : catNodeList) {
            
            if(catNode.ParentId == null) {
                if(catNode.MasterLabel != 'Mobile') {
                    options.add(new SelectOption(catNode.Id,catNode.MasterLabel));                       
                }
                if(catNode.MasterLabel == 'Xythos') {
                    category = catNode.Id;                      
                }
            }
        } 
        return options;
    }
    
    public PageReference selectCategory() {
        
        //loadArticle = true;
        KIArticles = new List<Solution>();
        SBSAArticles = new List<Solution>();
        PRIArticles = new List<Solution>();
        SPArticles = new List<Solution>();
        allArticles = new List<Solution>();
        RecentArticles();
        return null;
    }
    
    
    public void RecentArticles() {
                
        set<Id> finalCatIdList = new set<Id>();
        set<Id> tempCatIdList1 = new set<Id>();
        set<Id> tempCatIdList2 = new set<Id>();
        List<Solution> solList = new List<Solution>();
                
                if(null == category || category.equals(''))
                                                //Added on 27-FEB-2012 RecordType.Name != 'Known Issue' condition to implemlement TP #1629
                        results = [SELECT Id, LastModifiedDate, SolutionName, RecordType.Name, summary__c, SolutionNumber FROM Solution WHERE RecordType.Name != 'Process/Procedure' and RecordType.Name != 'Known Issue' and Status = 'Published' and Visible_in_Customer_Portal__c = true ORDER BY LastModifiedDate DESC ];
                else
                {
            
            Boolean flag = false;
            for(Integer i = 0; i < 5; i++) {
                
                if(flag == false) {
                    if(i == 0) {
                        if(null != category) {
                            tempCatIdList1.add(category);
                        } else {
                            flag = true;
                            break;
                        }
                    } else {

                        if(tempCatIdList2.size() > 0) {
                            tempCatIdList1 = tempCatIdList2;
                            tempCatIdList2 = new set<Id>();
                            
                        } else {
                            flag = true;
                            break;
                        }
                        
                    }                    
                    for(Id parentCatId : tempCatIdList1) {
                        
                        for(CategoryNode catNode : catNodeList) {
                            
                            tempCatIdList2.add(parentCatId);
                            finalCatIdList.add(parentCatId); 
                            if(catNode.ParentId == parentCatId) {                                 
                                tempCatIdList2.add(catNode.Id);
                                finalCatIdList.add(catNode.Id); 
                            }                       
                        }
                    }
                }
            }
            
            if(finalCatIdList.size() > 0) {
                set<Id> solIdSet = new set<Id>();
                List<CategoryData> catDataList = [Select RelatedSobjectId, IsDeleted, Id, CategoryNodeId From CategoryData where CategoryNodeId IN : finalCatIdList];
                for(CategoryData catData : catDataList) {
                    solIdSet.add(catData.RelatedSobjectId);
                }
                //Added on 27-FEB-2012 RecordType.Name != 'Known Issue' condtion to implement TP#1629                      
                results = [Select Id, SolutionNumber, RecordType.Name, SolutionName, Status, LastModifiedDate From Solution WHERE RecordType.Name != 'Process/Procedure' and RecordType.Name != 'Known Issue' and Status = 'Published' and Visible_in_Customer_Portal__c = true and id IN : solIdSet ORDER BY LastModifiedDate DESC];
            }
        }       
        if((null != results && results.size() > 0) || runFromTest == true) {

            Integer SBSACount = 0;
            Integer KICount = 0;
            Integer PRICount = 0;
            Integer SPCount = 0;
            Integer allCount = 0;
            KIArticles = new List<Solution>();
            SBSAArticles = new List<Solution>();
            PRIArticles = new List<Solution>();
            SPArticles = new List<Solution>();
            allArticles = new List<Solution>();
            for(Solution sol : results) {
                
                if(SBSACount < 2 && sol.RecordType.Name.equals('Support Bulletin/Security Advisory')) {
                        SBSAArticles.add(sol);
                        SBSACount++;
                        continue;
                } else if(KICount < 2 && sol.RecordType.Name.equals('Announcement')) {
                        
                        KIArticles.add(sol);
                        KICount++;    
                        continue;                          
                } else if(PRICount < 1 && sol.RecordType.Name.equals('Release')) {
                        
                        PRIArticles.add(sol);
                        PRICount++; 
                        continue; 
                } else if(SPCount < 1 && sol.RecordType.Name.equals('Maintenance Release')) {
                        
                        SPArticles.add(sol);
                        SPCount++; 
                        continue;                             
                }else if(allCount < 2) {
                        
                        allArticles.add(sol);
                        allCount++; 
                        continue;                             
                }
                if(KICount == 2 && SBSACount == 2 && PRICount == 2 && allCount == 2)
                        //loadArticle = false;
                        break;              
                  
            }               
        }                       
    }
            
    public List<CategoryNode> getArticleCategories() {    
    
        return [SELECT Id, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, MasterLabel, ParentId, SortOrder, SortStyle, SystemModstamp 
            FROM CategoryNode
            WHERE ParentId != Null
            ORDER BY MasterLabel DESC];
            
    }
     public PageReference redirect() {
        if(gc.userRedirect == true){
            PageReference pageRedirect = new PageReference(gc.IDMRedirectURL);
            pageRedirect.getParameters().put('TARGET',gc.IDMTargetURL);          
            pageRedirect.setRedirect(true);
            return pageRedirect;
        } else {
        return null;
        }
    }
    
    //Added By Shirish On 9-june-11 for conditional display of link    
    public boolean isMHDisplay {
                
        get {                   
                
            if(u != null && u.size() > 0) {
                Integer flag = 0;
                Set<Id> accId = new set<Id>();
                //List<Contact_Role__c> contRoleList = [Select Account__c, Role__c, Id, Contact__c, Contact_Role_Email__c From Contact_Role__c where contact__c = :u[0].ContactId];
                for(Contact_Role__c contRole : [Select Account__c, Role__c, Id, Contact__c From Contact_Role__c where contact__c = :u[0].ContactId]) {
                        if(null != contRole.Role__c && (contRole.Role__c.Contains('LEARN') || contRole.Role__c.Contains('ANGEL')))
                                accId.add(contRole.Account__c);
                }                         
                if(accId != null && accId.size() > 0)
                    for(Asset asset : [Select Managed_Hosting__c, AccountId From Asset where accountId IN :accId]) {
                        //System.debug('asset >>>>>>>>>>> '+ asset.Managed_Hosting__c);
                        if(null != asset.Managed_Hosting__c && (asset.Managed_Hosting__c.Contains('Managed Hosting'))) {
                                
                                isMHDisplay = true;
                                flag = 1;
                                break;
                        }                                               
                    }
                    if(flag == 0)
                            isMHDisplay = false;
                                                    
            }
            return isMHDisplay;
        }
        set { 
            if(value != null) isMHDisplay = value;
        }
    }   
    //End of Added By Shirish On 9-june-11 for conditional display of link 
    
    //Added By Shirish On 23-August-11 for MLA Admin contact roles  
    public boolean isMLAAdmin {
                
        get {                   
                
            if(u != null && u.size() > 0) {
                Integer flag = 0;                
                for(Contact_Role__c contRole : [Select Account__c, Role__c, Id, Contact__c From Contact_Role__c where contact__c = :u[0].ContactId]) {
                    if(null != contRole.Role__c && (contRole.Role__c.Contains('MLA') && contRole.Role__c.Contains('Admin'))) {
                        
                        isMLAAdmin = true;                      
                    } else {
                        isMLAAdmin = false;  
                        break; 
                    }
                }
            }         

            return isMLAAdmin;
        }
        set { 
            if(value != null) isMLAAdmin = value;
        }
    }   
    //End of Added By Shirish On 23-August-11 for MLA Admin contact roles
      
    public string getURL1(){
        String retURL;
        if(null == category || category.equals('')){
         retURL='../services/xml/All_Articles_Support_Bulletins';   
        }
        else
        {
            String catName;
            for(CategoryNode catNode : catNodeList){
                if(category == catNode.id)
                    catName=catNode.MasterLabel;
            }
            if(catName.equals('Learn')){
            retURL='../services/xml/Learn_Support_Bulletins';
            }
            else if(catName.equals('ANGEL')){               
            retURL='../services/xml/ANGEL_Support_Bulletins';
            }
            else if(catName.equals('CE/Vista')){
            retURL='../services/xml/CE_Vista_Support_Bulletins';
            }
            else if(catName.equals('Xythos')){
            retURL='../services/xml/Xythos_Support_Bulletins';
            }
            //else if(catName.equals('Process/Procedure')){
            //retURL='../services/xml/Process_Procedure_Support_Bulletins';
            //}           
        }
        return retURL;
    }
    
    public string getURL2(){
        String retURL;
        if(null == category || category.equals('')){
         retURL='../services/xml/All_Articles_Product_Release_Information'; 
        }
        else
        {
            String catName;
            for(CategoryNode catNode : catNodeList){
                if(category == catNode.id)
                    catName=catNode.MasterLabel;
            }
            if(catName.equals('Learn')){
            retURL='../services/xml/Learn_Product_Release_Information';
            }
            else if(catName.equals('ANGEL')){               
            retURL='../services/xml/ANGEL_Product_Release_Information';
            }
            else if(catName.equals('CE/Vista')){
            retURL='../services/xml/CE_Vista_Product_Release_Information';
            }
            else if(catName.equals('Xythos')){
            retURL='../services/xml/Xythos_Product_Release_Information';
            }
            //else if(catName.equals('Process/Procedure')){
            //retURL='../services/xml/Process_Procedure_Product_Release_Information';
            //}           
        }
        return retURL;
    }
    
    public string getURL3(){
        String retURL;
        if(null == category || category.equals('')){
         retURL='../services/xml/All_Articles';   
        }
        else
        {
            String catName;
            for(CategoryNode catNode : catNodeList){
                if(category == catNode.id)
                    catName=catNode.MasterLabel;
            }
            if(catName.equals('Learn')){
            retURL='../services/xml/All_Learn_Articles';
            }
            else if(catName.equals('ANGEL')){               
            retURL='../services/xml/All_ANGEL_Articles';
            }
            else if(catName.equals('CE/Vista')){
            retURL='../services/xml/All_CE_Vista_Articles';
            }
            else if(catName.equals('Xythos')){
            retURL='../services/xml/All_Xythos_Articles';
            }
            //else if(catName.equals('Process/Procedure')){
            //retURL='../services/xml/All_Articles';
            //}           
        }
        return retURL;
    }
    
    public string getURL4(){
        String retURL;
        if(null == category || category.equals('')){
         retURL='../services/xml/All_Articles_Announcement'; 
        }
        else
        {
            String catName;
            for(CategoryNode catNode : catNodeList){
                if(category == catNode.id)
                    catName=catNode.MasterLabel;
            }
            if(catName.equals('Learn')){
            retURL='../services/xml/Learn_Announcement';
            }
            else if(catName.equals('ANGEL')){               
            retURL='../services/xml/ANGEL_Announcement';
            }
            else if(catName.equals('CE/Vista')){
            retURL='../services/xml/CE_Vista_Announcement';
            }
            else if(catName.equals('Xythos')){
            retURL='../services/xml/Xythos_Announcement';
            }
            //else if(catName.equals('Process/Procedure')){
            //retURL='../services/xml/Process_Procedure_Announcement';
            //}           
        }
        return retURL;
    }
    
    static testmethod void BtBbXythosHomePageControllertest(){
        
        Core_License__c cr = new  Core_License__c();
        cr.Name = 'ANGEL';
        insert cr;  
        
        Module__c m = new Module__c();
        m.Name = 'MH Request';
        m.Core_Licence__c = cr.ID;    
        insert m;
        
        Functional_Area__c f = new Functional_Area__c();
        f.Name = 'Upgrades';
        f.Module__c = m.ID;  
        insert f;
        
        Category__c cat = new Category__c();
        cat.NAme = 'ANGEL';
        cat.Functional_Area__c = f.ID;
        insert cat;
        
        Account ac=new Account();
        ac.Name='bucknell university';
        ac.BillingCity='abc';
        ac.BillingCountry='USA';
        ac.BillingPostalCode='abc';
        ac.BillingState='abc';
        ac.BillingStreet='abc';
        insert ac;
       
      
        Profile pf3= [select id from Profile where name = 'BTBB Profile'];
       
        User u3 = new User(LastName = 'Test Usser',Username = 'tuu1@test1.com',Email = 'testuser@test1.com',Alias = 'tu1' ,CommunityNickname= 'tu11' ,
                           TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',
                           ProfileId = pf3.Id, LanguageLocaleKey = 'en_US');
        insert u3;                    
                           
                           
        
        Profile pf1= [select id from Profile where name = 'SRV - BTBB User'];                  
        user u2 =[select id, Name,contactId,BTBB_KB_Default_Prod__c from user where contactId != null and isactive=true  and profileid = :pf1.id limit 1 ];    
        
        Contact_Role__c crr = new Contact_Role__c();
        crr.CurrencyIsoCode='GBP';
        crr.Account__c=ac.id;
        crr.Expire_Role__c=False;
        crr.Contact__c=u2.contactId;
        crr.Role__c= 'LEARN (Bb) - Admin';
        
        insert crr;
        
        Contact_Role__c crr2 = new Contact_Role__c();
        crr2.CurrencyIsoCode='GBP';
        crr2.Account__c=ac.id;
        crr2.Expire_Role__c=False;
        crr2.Contact__c=u2.contactId;
        crr2.Role__c= 'LEARN (Bb) - Admin';
        
        insert crr2;
        
        
        Contact ct= new Contact ();
        ct.AccountId=ac.id;
        ct.Account=ac;
        ct.LastName='abc';
        insert ct;
    
        Core_License__c cl=new Core_License__c();
        cl.Name='ANGEL';
        insert cl;
    
        Asset a=new Asset();
        a.Name='abc';
        a.Core_License__c=cl.id;
        a.AccountId=ac.id;
        a.Contact=ct;
        a.Account=ac;
        insert a;
    
       Case cs1=new Case();
       cs1.Status='Solution Suggested';
       cs1.Description='this case has to be resolved';
       cs1.Type='abc';
       cs1.Subject='abc';
       cs1.Case_Severity__c='2';
       cs1.Primary_Group_Name__c='ANGEL - Development';
       cs1.Previous_Owner__c='yyyy';
       cs1.AccountId=ac.id;
       cs1.Account=ac;
       cs1.Contact=ct;
       cs1.AssetID=a.ID;
       cs1.Replication_in_the_Case__c = 'Test';
       insert cs1;
                   
        
       
        BtBbXythosHomePageController home = new BtBbXythosHomePageController();
        home.Redirect();
        System.runas(u2)
         { 
        
            home = new BtBbXythosHomePageController();
            home.getKIArticles();
            home.getSBSAArticles();
            home.getPRIArticles();
            home.getSPArticles();
            home.getCategory();
            home.getAllArticles();
            home.runFromTest = true;
            home.getRecentCases();
            home.getCategories();
            Test.StartTest();
            home.selectCategory();
            home.getArticleCategories();
            home.Redirect();
            Boolean b = home.isMHDisplay;
            Boolean b1 = home.isMLAAdmin;
            home.setCategory('');
            home.getURL1();
            home.getURL2();
            home.getURL3();
            home.getURL4();
            for(CategoryNode catNode : home.catNodeList) {
                
                if(catNode.MasterLabel == 'Learn') {
                    home.setCategory(catNode.Id);
                    home.getURL1();
                    home.getURL2();
                    home.getURL3();
                    home.getURL4();
                }
                else if(catNode.MasterLabel == 'ANGEL') {
                    home.setCategory(catNode.Id);
                    home.getURL1();
                    home.getURL2();
                    home.getURL3();
                    home.getURL4();
                }
                else if(catNode.MasterLabel == 'CE/Vista') {
                    home.setCategory(catNode.Id);
                    home.getURL1();
                    home.getURL2();
                    home.getURL3();
                    home.getURL4();
                }
                else if(catNode.MasterLabel == 'Xythos') {
                    home.setCategory(catNode.Id);
                    home.getURL1();
                    home.getURL2();
                    home.getURL3();
                    home.getURL4();
                }
                else if(catNode.MasterLabel == 'Process/Procedure') {
                    home.setCategory(catNode.Id);
                    home.getURL1();
                    home.getURL2();
                    home.getURL3();
                    home.getURL4();
                }
            }
            Test.StopTest();
            home.isMLAAdmin = true; 
            home.isMHDisplay = true;           
            
        }
        
   system.runas(u3)
    {
    BtBbXythosHomePageController home1 = new BtBbXythosHomePageController();
    home1.Redirect();  
    }   

    }
    */
}
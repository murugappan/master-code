public  Without Sharing class BtBbHomePageController{
    GlobalComponent gc = new GlobalComponent();
    public List<CategoryNode> catNodeList;  
    public Boolean runFromTest;
    public String selectedProduct {get; set;}
    public boolean xythosonly {get;set;}
    public transient list<Support_Bulletin_Security_Advisory__kav> sbsaList {get; private set;}
    public transient list<Announcement__kav> announcementList {get; private set;}
    public transient list<Release__kav> releaseList {get; private set;}
    public transient list<Maintenance_Release__kav> maintenanceList {get; private set; }
    public transient map<id,Release__kav> releaseMap {get; private set;}
    public transient map<id,Maintenance_Release__kav> maintenanceMap {get; private set;}
    public transient set<id>Productid=  new set<id>();
    public transient list<knowledgearticlewrapper> ProductList {get; private set;}
    public transient list<General_Article__kav> generalList {get; private set;}
    transient List<Solution> results;
    List<User> u;
    private boolean firstRun = true;
    List<Case> caselist = new List<Case>();
    //public List<String> clientID {get;set;}
    public boolean isCollabUser{get;set;}
    public string BUaccess{get;set;}
    public boolean isTransactonly {get;set;}
    public boolean isContactRoleError {get;set;}
        public list<BtBb_Link__c>SelfServicelinks{
                get{
                        return btbbAuthNavController.getbtbbServicelinks();
                }
                set;
        }
        public list<BtBb_Link__c>Communitylinks{
                get{
                        return btbbAuthNavController.getbtbbCommunitylinks();
                }
                set;
        }
        
        public btbbAnnouncementWrapper AnnouncementData{get;set;}
        public boolean dns{get;set;}
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
    public BtBbHomePageController() 
    {
        u = new List<User>([select ID,ContactID, Name, BTBB_KB_Default_Prod__c from User where ID =: Userinfo.getUserID()]);
        System.debug('u >>>>> 111' +u);
        Map <id,map<string,integer> > accountRoleMap= new    Map <id,map<string,integer> >(); // map<accountid,map<BusinessUnit,Permission>>
        set<string>BusinnesUnitAccess= new set<string>();

        for(List<Contact_Role__c> cr : [Select c.Role__c, c.Code__c,c.Contact__c, c.Account__c,c.BusinessUnit__c,c.accesscode__c From Contact_Role__c c where Contact__c =: u[0].ContactID AND Expire_Role__c = false and role__c != null and BusinessUnit__c!=null AND Contact__c!= NULL])
        {
          for(contact_role__c c : cr)
          {
            for(string s: c.BusinessUnit__c.split(','))
            {
              BusinnesUnitAccess.add(s);
            }
            system.debug('BU--->'+BusinnesUnitAccess);
            if(null != accountRoleMap && (accountRoleMap.size()==0 || !accountRoleMap.containskey(c.Account__c)))
            {
              map<string,integer> tempMap=new map<string,integer>();
              for(string s: c.BusinessUnit__c.split(','))
              {
                tempMap.put(s,integer.valueof(c.Accesscode__c));
              }
              accountRoleMap.put(c.Account__c,tempMap);
            }
            else if(null != accountRoleMap)
            {

                for(string s: c.BusinessUnit__c.split(','))
                {
                  if(accountRoleMap.get(c.Account__c).get(s)!= null)
                  {
                    
                    map<string,integer> tempMap=accountRoleMap.get(c.Account__c);
                    integer tempAccesscode=integer.valueof(accountRoleMap.get(c.Account__c).get(s));
                    accountRoleMap.get(c.Account__c).put(s,tempAccesscode|integer.valueof(c.Accesscode__c));
                  }
                  else
                  {
                    accountRoleMap.get(c.Account__c).put(s,integer.valueof(c.Accesscode__c));
                  }
                }  
            }
          }
        } 
          if(BusinnesUnitAccess.contains('Collaborate')||BusinnesUnitAccess.contains('COLLABORATE')) 
          {
                  isCollabUser=true;
          }  
          
          //Collaborate changes
          if(BusinnesUnitAccess.contains('Learn')||BusinnesUnitAccess.contains('ANGEL')||BusinnesUnitAccess.contains('ANGEL LMS')||BusinnesUnitAccess.contains('CE/Vista')||BusinnesUnitAccess.contains('Xythos'))
                  {
                          BUaccess=BUaccess+',Learn_BU,ANGEL_BU,Xythos_BU,CE_Vista_BU';
                  }
          if(BusinnesUnitAccess.contains('Collaborate'))
                  {
                          BUaccess=BUaccess+',Collaborate';
                  }
          if(BusinnesUnitAccess.contains('Transact'))
                  {
                    BUaccess=BUaccess+',Transact';
                  }
          if(BusinnesUnitAccess.contains('Moodlerooms'))
                  {
                     BUaccess=BUaccess+',Moodlerooms';
                  }
          if(BusinnesUnitAccess.contains('Analytics'))
                  {
                     BUaccess=BUaccess+',Analytics';
                  }
          if(BusinnesUnitAccess.contains('xpLor'))
                  {
                     BUaccess=BUaccess+',xpLor';
                  }       
          if(BUaccess==null)
                  {
                          //BUaccess='';
                          BUaccess=BUaccess+'';
                  }

    if(null != u && u.size() > 0 && u[0].ContactID != null){
            System.debug('u >>>>>' +u);
            String defaultCategory = u[0].BTBB_KB_Default_Prod__c;
             if(BUaccess != null && BUaccess.containsignorecase('Learn'))
                            {
                                if(defaultCategory != null)
                                {
                                    if(defaultCategory.containsignorecase('ANGEL'))
                                        defaultCategory='ANGEL_BU';
                                    else if (defaultCategory.containsignorecase('Vista'))  
                                        defaultCategory='CE_Vista_BU' ;
                                    else if (defaultCategory.containsignorecase('Xythos'))
                                         defaultCategory='Xythos_BU' ;   
                                    else if(defaultCategory.containsignorecase('Learn'))     
                                    defaultCategory = 'Learn_BU';
                                 }
                                 else
                                 {
                                     defaultCategory = 'Learn_BU';
                                 }   
                            }
                          if(BUaccess != null && BUaccess.containsignorecase('Collaborate'))
                            {       if(defaultCategory != null && defaultCategory.containsignorecase('Collaboarte'))
                                    {
                                      defaultCategory = 'Collaborate';
                                    }
                                    else if(defaultCategory == null)
                                    {
                                       defaultCategory = 'Collaborate';
                                    }
                            }
                            
                            if(BUaccess != null && BUaccess.containsignorecase('Moodlerooms'))
                            {       if(defaultCategory != null && defaultCategory.containsignorecase('Moodlerooms'))
                                    {
                                      defaultCategory = 'Moodlerooms';
                                    }
                                    else if(defaultCategory == null)
                                    {
                                       defaultCategory = 'Moodlerooms';
                                    }
                            }                                          
                            if(BUaccess != null && BUaccess.containsignorecase('Analytics'))
                            {       if(defaultCategory != null && defaultCategory.containsignorecase('Analytics'))
                                    {
                                      defaultCategory = 'Analytics';
                                    }
                                    else if(defaultCategory == null)
                                    {
                                       defaultCategory = 'Analytics';
                                    }
                            }    
                            if(BUaccess != null && BUaccess.containsignorecase('xpLor'))
                            {       if(defaultCategory != null && defaultCategory.containsignorecase('xpLor'))
                                    {
                                      defaultCategory = 'xpLor';
                                    }
                                    else if(defaultCategory == null)
                                    {
                                       defaultCategory = 'xpLor';
                                    }
                            }    
            btbbCookieClass.AauthCookie authcookie= new btbbCookieClass.AauthCookie();
                    authcookie.loadcookie();
                     if(authcookie.product != null && authcookie.product!='')
                             {
                                    defaultCategory=authcookie.product;
                             }
            if(defaultCategory != null)
            {
                if(defaultCategory.equals('All Products'))
                { 
                    if(BUaccess != null && BUaccess.containsignorecase('Learn'))
                    {
                      selectedproduct= selectedProduct = 'Learn_BU';
                    }
                    else if(BUaccess != null && BUaccess.containsignorecase('Collaborate'))
                    {
                      selectedProduct = 'Collaborate';
                    }
                     else if(BUaccess != null && BUaccess.containsignorecase('Moodlerooms'))
                    {
                      selectedProduct = 'Moodlerooms';
                    }
                    else if(BUaccess != null && BUaccess.containsignorecase('Analytics'))
                    {
                      selectedProduct = 'Analytics';
                    }
                    else if(BUaccess != null && BUaccess.containsignorecase('xpLor'))
                    {
                      selectedProduct = 'xpLor';
                    }

                    
                    else
                    {
                     selectedProduct = 'Learn_BU';
                   }
                }
                else if(defaultCategory.contains('Vista'))
                   { 
                     selectedProduct='CE_Vista_BU';
                   }
                else
                   {
                    selectedProduct=defaultCategory;
                   }
                   
             }
          
            else
            {
            selectedProduct = 'Learn_BU';        
            }                    
                                       
        
      
    RecentArticles();  
    }
     for(Case c : [SELECT Id, AccountId, IsSelfServiceClosed, Case_Record__c, Account_Name__c, Core_License__r.Name ,ContactId, Contact.Name, CaseNumber, Subject, Status, Customer_Portal_Status__c, Case_Severity__c, LastModifiedDate, Psft_Case_Id__c,Last_activity_update__c FROM Case where AccountID IN: accountRoleMap.Keyset() AND RecordType.Name!='Collaborate End User Open' AND RecordType.Name!='Collaborate End User Closed' ORDER BY Last_activity_update__c DESC LIMIT 100]){
        if(accountRoleMap.get(c.accountid) != null)
        {
          if(accountRoleMap.get(c.accountid).get(c.Core_License__r.Name)!= null)
          {
            if((accountRoleMap.get(c.accountid).get(c.Core_License__r.Name)&1) >0)
            {
              caselist.add(c);
            }

          }
          else if(accountRoleMap.get(c.accountid).get(c.Case_Record__c)!= null)
          {
            if((accountRoleMap.get(c.accountid).get(c.Case_Record__c)&1) >0)
            {
              caselist.add(c);
            }
          }
        }
      }  
  /*    clientID = new List<String>();  
      Set<String> cId = new Set<String>();
      for(List<Account> acc : [select ID,PS_Company_Id__c,Name from Account where ID IN: AccountID ORDER BY NAME DESC]){
          for(Account a : acc){
                  cId.add(a.Name + ' : ' + a.PS_Company_Id__c); 
          }        
      }
      clientID.addAll(cId); 
      
      */
      
      if( BUaccess.contains('Transact') && !BUaccess.containsignorecase('Learn') && !BUaccess.containsignorecase('Collaborate') && !BUaccess.containsignorecase('Moodlerooms'))
          isTransactonly=true;
      else
          isTransactonly = false;
          
      system.debug('TESTING BOOLEAN'+isTransactonly);
      
      
      if(BusinnesUnitAccess.size() == 1 && BusinnesUnitAccess.contains('Xythos'))
         xythosonly = true;
      else    
         xythosonly = false;


      if(BUaccess == null /*|| (BusinnesUnitAccess.size() == 1 && BusinnesUnitAccess.contains('Moodlerooms'))||BUaccess==',Moodlerooms'*/)
      {
        isContactRoleError=true;
      }
      else
      {
        isContactRoleError=false;
      }   
    }
    
 
    public void recentArticles()
    {
        String selectedProductFilter = '';
        if (selectedProduct != null && selectedProduct != '' && !selectedProduct.contains('All'))
        {
            selectedProduct = selectedProduct.replaceAll(' ', '_');
            selectedProduct = selectedProduct.replaceAll('/', '_');
            selectedProductFilter = 'WITH DATA CATEGORY Version__c ABOVE_OR_BELOW ' + selectedProduct + '__c ';
            
            btbbCookieClass.AauthCookie authcookie =new btbbCookieClass.AauthCookie() ;
            authcookie.product=selectedProduct;
            authcookie.createcookie();
        }
        else if(selectedProduct.contains('All'))
        {
            btbbCookieClass.AauthCookie authcookie =new btbbCookieClass.AauthCookie() ;
            authcookie.product=selectedProduct;
            authcookie.createcookie();
        }
        system.debug('Select Title, Summary, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber ' + 
            'From Support_Bulletin_Security_Advisory__kav ' +  
            'Where (PublishStatus = \'online\' And Language = \'en_US\') ' + 
            selectedProductFilter + 'Order by LastPublishedDate desc limit 2');
            
        sbsaList = Database.query('Select Title, Summary, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber ' + 
            'From Support_Bulletin_Security_Advisory__kav ' +  
            'Where (PublishStatus = \'online\' And Language = \'en_US\') ' + 
            selectedProductFilter + 'Order by LastPublishedDate desc limit 2');
            
        announcementList = Database.query('Select Title, Summary, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber ' + 
            'From Announcement__kav ' +  
            'Where (PublishStatus = \'online\' And Language = \'en_US\') ' + 
            selectedProductFilter + 'Order by LastPublishedDate desc limit 2');
            
        releaseList = Database.query('Select Title, Summary, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber ' + 
            'From Release__kav ' +  
            'Where (PublishStatus = \'online\' And Language = \'en_US\') ' + 
            selectedProductFilter + 'Order by LastPublishedDate desc limit 2');
            
        releaseMap = new map<id,Release__kav>(releaseList);  
        
        maintenanceList=Database.query('Select Title, Summary, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber ' + 
            'From Maintenance_Release__kav ' +  
            'Where (PublishStatus = \'online\' And Language = \'en_US\')  ' + 
            selectedProductFilter + 'Order by LastPublishedDate desc limit 2');
            
        maintenanceMap= new map<id,Maintenance_Release__kav>(maintenanceList) ;   
        
        ProductList=QueryKnowledgeArticleListUtility.queryRelease('Release', releasemap.keySet());
        ProductList.addall(QueryKnowledgeArticleListUtility.queryMaintenanceRelease('Maintenance Release',maintenancemap.keySet()));
        
         productList.sort();
            
        generalList = Database.query('Select Title, Summary, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber ' + 
            'From General_Article__kav ' +  
            'Where (PublishStatus = \'online\' And Language = \'en_US\')' + 
            selectedProductFilter + 'Order by LastPublishedDate desc limit 2');
       /* branding code
       if(firstRun == false){    
            btbbAuthNavController.sessionidcheck(selectedProduct);
        }
        firstRun = false;  */ 
    }
            
    public List<CategoryNode> getArticleCategories() {    
    
        return [SELECT Id, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, MasterLabel, ParentId, SortOrder, SortStyle, SystemModstamp 
            FROM CategoryNode
            WHERE ParentId != Null
            ORDER BY MasterLabel DESC];
            
    }
    
    public PageReference Redirect() {
       
       
       
       if(gc.userRedirect == true){
            PageReference pageRedirect = new PageReference(gc.IDMRedirectURL);
            pageRedirect.getParameters().put('TARGET',gc.IDMTargetURL);          
            pageRedirect.setRedirect(true);
            return pageRedirect;
        }
        
        else if(isTransactonly == true) {
            PageReference TransactRedirect = new PageReference('/apex/btbb_redirecttransact');
            TransactRedirect.setRedirect(true);
            return TransactRedirect;
            }
        
        else if(isContactRoleError==true)
        {
          Pagereference Collabredirect = Page.login_success;
          Collabredirect.setredirect(true);
          return Collabredirect;
        }
        
        /*else 
            if(xythosonly == true) {
            PageReference XythosRedirect = new PageReference('/apex/btbb_xythoshome');
            XythosRedirect.setRedirect(true);
            return XythosRedirect;
            } */
            
          
            
            else  
        return null;
        
    }
    
    
    //Added By Shirish On 9-june-11 for conditional display of link    
    public boolean isMHDisplay {
                
        get {                   
                
            if(u != null && u.size() > 0) {
                Integer flag = 0;
                Set<Id> accId = new set<Id>();
                //List<Contact_Role__c> contRoleList = [Select Account__c, Role__c, Id, Contact__c, Contact_Role_Email__c From Contact_Role__c where contact__c = :u[0].ContactId];
                for(Contact_Role__c contRole : [Select Account__c, Role__c, Id, Contact__c From Contact_Role__c where contact__c = :u[0].ContactId AND Contact__c!= NULL]) {
                        if(null != contRole.Role__c && (contRole.Role__c.Contains('LEARN') || contRole.Role__c.Contains('ANGEL')))
                                accId.add(contRole.Account__c);
                }                         
                if(accId != null && accId.size() > 0)
                    for(Asset asset : [Select Managed_Hosting__c, AccountId From Asset where accountId IN :accId]) {
                        //System.debug('asset >>>>>>>>>>> '+ asset.Managed_Hosting__c);
                        if(null != asset.Managed_Hosting__c && (asset.Managed_Hosting__c.Contains('Learn - Managed Hosting'))) {
                                
                                isMHDisplay = true;
                                flag = 1;
                                break;
                        } 
                     
                                                                       
                    }
                    if(flag == 0)
                            isMHDisplay = false;
                                                    
            }
            System.debug('isMHDisplay >>>>>>>>>' +isMHDisplay);
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
                for(Contact_Role__c contRole : [Select Account__c, Role__c, Id, Contact__c From Contact_Role__c where contact__c = :u[0].ContactId AND Contact__c!= NULL]) {
                    if(null != contRole.Role__c && (contRole.Role__c.Contains('LEARN - Read-Only'))) {
                        
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
        set { 
            if(value != null) isMLAAdmin = value;
        }
    }   
    //End of Added By Shirish On 23-August-11 for MLA Admin contact roles
    

      public boolean isLearnAcademicDeveloper {
                
        get {                   
                
            if(u != null && u.size() > 0) {
                Integer flag = 0;                
                for(Contact_Role__c contRole : [Select Account__c, Role__c, Id, Contact__c From Contact_Role__c where contact__c = :u[0].ContactId AND Contact__c!= NULL]) {
                    if(null != contRole.Role__c && contRole.Role__c =='Learn - Academic Developer') {
                        
                        isLearnAcademicDeveloper = true;                      
                    } else {
                        isLearnAcademicDeveloper = false;  
                        break; 
                    }
                }
            }         
            System.debug('isLearnAcademicDeveloper >>>>>>>>>' +isLearnAcademicDeveloper);
            return isLearnAcademicDeveloper;
        }
        set { 
            if(value != null) isLearnAcademicDeveloper = value;
        }
    }   
    
    public boolean isCollabReadOnly {
                
        get {                   
                
            if(u != null && u.size() > 0) {
                Integer flag = 0;                
                for(Contact_Role__c contRole : [Select Account__c, Role__c, Id, Contact__c From Contact_Role__c where contact__c = :u[0].ContactId AND Contact__c!= NULL]) {
                    if(null != contRole.Role__c && contRole.Role__c =='COLLABORATE – Read-Only') {
                        
                        isCollabReadOnly = true;                      
                    } else {
                        isCollabReadOnly = false;  
                        break; 
                    }
                }
            }         
            return isCollabReadOnly;
        }
        set { 
            if(value != null) isCollabReadOnly = value;
        }
    } 
      
    public string getURL1(){
        String retURL;
        system.debug(selectedProduct);
        if (selectedProduct == null || selectedProduct == '' || selectedProduct.contains('All'))
        {
            retURL='../services/xml/BbKnowledge?Productcode=&Product=ALL&Articletype=Support+Bulletin&articletypecode=sbsa';   
        }
        else
        {
           retURL='../services/xml/BbKnowledge?Productcode='+selectedProduct+'&Product='+selectedProduct+'&Articletype=Support+Bulletin&articletypecode=sbsa';
              
        }
        return retURL;
    }
    
    public string getURL2(){
        String retURL;
        if (selectedProduct == null || selectedProduct == '' || selectedProduct.contains('All'))
        {
            retURL='../services/xml/BbKnowledge?Productcode=&Product=ALL&Articletype=Product+Release&articletypecode=Release'; 
        }
        else
        {  
                retURL='../services/xml/BbKnowledge?Productcode='+selectedProduct+'&Product='+selectedProduct+'&Articletype=Product+Release&articletypecode=Release';
        }
        return retURL;
    }
    
    public string getURL3(){
        String retURL;
        if (selectedProduct == null || selectedProduct == '' || selectedProduct.contains('All')){
         retURL='../services/xml/BbKnowledge?Productcode=&Product=ALL&Articletype=Latest+Articles&articletypecode=General';
        }
        else
        {
         retURL='../services/xml/BbKnowledge?Productcode='+selectedProduct+'&Product='+selectedProduct+'&Articletype=Latest+Articles&articletypecode=General';       
        }
        return retURL;
    }
    
    public string getURL4(){
        String retURL;
        if (selectedProduct == null || selectedProduct == '' || selectedProduct.contains('All')){
         retURL='../services/xml/BbKnowledge?Productcode=&Product=ALL&Articletype=Announcements&articletypecode=Announcement';
        }
        else
        {
         retURL='../services/xml/BbKnowledge?Productcode='+selectedProduct+'&Product='+selectedProduct+'&Articletype=Announcements&articletypecode=Announcement';
        }
        return retURL;
    }
    
    public string getURL5(){
        String retURL;
        if (selectedProduct == null || selectedProduct == '' || selectedProduct.contains('All')){
         retURL='../services/xml/All_Articles'; 
        }
        else
        {
            String catName = selectedProduct;
            if(catName.equals('Learn')){
            retURL='../services/xml/All_Learn_Articles';
            }
            else if(catName.equals('ANGEL')){               
            retURL='../services/xml/All_Angel_Articles';
            }
            else if(catName.contains('Vista')){
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
    
          public btbbAnnouncementWrapper getannouncement()
          {
                        AnnouncementData=new btbbAnnouncementWrapper();
                        list<BtBb_Announcement__c> ancmntlist= new list<BtBb_Announcement__c>();
                        string product;
                        map<string,btbbCookieClass.AnnouncementCookie> cookiemap =  new map<string,btbbCookieClass.AnnouncementCookie>();
                        btbbCookieClass.AnnouncementCookie ancmentcookie = new btbbCookieClass.AnnouncementCookie();
                        if(selectedProduct.contains('Vista'))
                        {
                                product='CE_Vista_BU';
                        }
                        else
                        {
                                product=selectedproduct;
                        }
                        ancmntlist =[select name,Corelicense__c,Detail__c,TimeStamp__c,Title__c from BtBb_Announcement__c where Corelicense__c=:product and portal__c ='Authenticated' and isactive__c=true order by timestamp__c desc limit 1];
                        system.debug('test +++'+ancmntlist);
                        if(ancmntlist!=null && ancmntlist.size()>0)
                        {
                                 cookiemap= ancmentcookie.loadcookie();
                                 if(cookiemap != null )
                                 {
                                        if(cookiemap.get(product+'Auth')!=null)
                                        {
                                                ancmentcookie= cookiemap.get(product+'Auth');
                                                if(ancmntlist[0].TimeStamp__c>ancmentcookie.datetimestamp)
                                                {
                                                        AnnouncementData=new btbbAnnouncementWrapper(ancmntlist[0],product);
                                                        return AnnouncementData;
                                                        
                                                }
                                                else
                                                {
                                                        return null;
                                                }
                                        }
                                        else
                                        {
                                                AnnouncementData=new btbbAnnouncementWrapper(ancmntlist[0],product);
                                                return AnnouncementData;
                                        }
                                 }
                                 else
                                 {
                                        AnnouncementData=new btbbAnnouncementWrapper(ancmntlist[0],product);
                                        return AnnouncementData;
                                 }
                        }
                        else
                        {
                                return null;
                        }
                        
          }
          public PageReference closeannouncement()
          {
                if(AnnouncementData != null)
                {
                        
                                map<string,btbbCookieClass.AnnouncementCookie> cookiemap =  new map<string,btbbCookieClass.AnnouncementCookie>();
                                btbbCookieClass.AnnouncementCookie ancmentcookie = new btbbCookieClass.AnnouncementCookie();
                                cookiemap= ancmentcookie.loadcookie();
                                if(ancmentcookie.loadcookie() != null)
                                {
                                        cookiemap = ancmentcookie.loadcookie(); 
                                }
                                else
                                {
                                        cookiemap = new map<string,btbbCookieClass.AnnouncementCookie>();
                                }
                            ancmentcookie.announcementNo=AnnouncementData.a.name;
                            ancmentcookie.Corelicense=AnnouncementData.product;
                            ancmentcookie.datetimestamp=AnnouncementData.a.TimeStamp__c;
                            ancmentcookie.portal=AnnouncementData.product+'Auth';
                            cookiemap.put(AnnouncementData.product+'Auth',ancmentcookie);
                            ancmentcookie.createanouncementcookie(cookiemap);
                }
                return null;
          }
          public class btbbAnnouncementWrapper{
                public  BtBb_Announcement__c a {get;set;}
                public boolean t{get;set;}
                public string product{get;set;}
                public btbbAnnouncementWrapper(BtBb_Announcement__c c,string s) 
                {
                        this.a=c;
                        t=false;
                        this.product=s;
                }
                public btbbAnnouncementWrapper()        
                {
                }
                 
          }
          
       
          
}
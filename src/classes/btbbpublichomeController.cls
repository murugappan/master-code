public class btbbpublichomeController {

    public PageReference SearchInstitutionHelpDesk() {
        return null;
    }
        public publickbarticleview articlecontroller{get;set;}
    public String InstitutionSearchText { get; set; }
    //-------------
    public String tp { get; set; }
    public string dproduct {get;set;}
    public List<Univs__c> alist {get; set;}
    public boolean vld {get; set;}
    public boolean isValid { get; set; }
    public Univs__c htmldisplay {get;set;}
    public string errortext{get;set;}
    public string eText{get;set;}
    public string erText{get;set;}
    public transient list<Announcement__kav> announcementList {get; private set;}
    public transient list<knowledgearticleversion> generalList {get; private set;}
    private integer size;   
    //----------------    
    public List<CategoryNode> catNodeList; 
    List<Solution> results;
    List<User> u;
    private List<Solution> KIArticles;
    private List<Solution> SBSAArticles;
    private List<Solution> PRIArticles;
    private List<Solution> allArticles;
    List<Case> caselist = new List<Case>();
    public List<String> clientID {get;set;}
    //public Boolean loadArticle { get; set; }
    public string searchstring{get;set;}
    public List<Solution> getKIArticles() {
        return KIArticles;
    }
    
    public List<Solution> getSBSAArticles() {
        return SBSAArticles;
    }
    
    public List<Solution> getPRIArticles() {
        return PRIArticles;
    }
    
 
    
    public List<Solution> getAllArticles() {
        return allArticles;
    }
        
    public String selectedProduct {get; set;}
 
    public list<BtBb_Link__c>SelfServicelinks{
        get{
            return btbbUnAuthNavController.getbtbbServicelinks();
        }
        set;
    }
    public list<BtBb_Link__c>Communitylinks{
        get{
            return btbbUnAuthNavController.getbtbbCommunitylinks();
        }
        set;
    }
    public btbbAnnouncementWrapper AnnouncementData{get;set;}
        public boolean dns{get;set;}
       
        public btbbpublichomeController() {
         //ApexPages.currentPage().getParameters().put('id','kAAS0000000CakE');
        //articlecontroller=new publickbarticleview();
         alist = [Select id, Name, Website__c, Account__c, View_Count__c, Client_Id__c, Account__r.Name, Account__r.id, Active__c, Page_Text__c, HTML_Text__c From Univs__c where Active__c = True];    
                
                InstitutionSearchText = 'Enter Institution Name';
                
        
         btbbCookieClass.UnAuthCookie authcookie= new btbbCookieClass.UnAuthCookie();
            authcookie.loadcookie();
            if(authcookie.product != null && authcookie.product!='')
                 {
                    selectedProduct=authcookie.product;
                 }
                if(selectedProduct != null)
                {
                    if(selectedProduct.equals('All Products'))
                        selectedProduct = 'Learn_BU';
                    else if(selectedProduct.contains('Vista'))
                       { 
                         selectedProduct='CE_Vista_BU';
                       }
                }
                else
                {
                selectedProduct = 'Learn_BU';        
                } 
                
       dproduct = ApexPages.currentPage().getParameters().get('dfprod');
       system.debug('Murugappan'+ dproduct);
        
        if (dproduct != null && dproduct == 'learn'){
            selectedProduct = 'Learn_BU';
        } 
        
        else if (dproduct != null && dproduct == 'mobile'){
            selectedProduct = 'Learn_BU';
        } 
        
        else if (dproduct != null && dproduct == 'collaborate'){
            selectedProduct = 'Collaborate';
        } 
                                      
           
       Map<ID,Set<String>> accountmap = new Map<ID,Set<String>>();
       Set<ID> AccountID = new Set<ID>();
       RecentArticles();
       }
         
    
            
    public void recentArticles()
    {
        system.debug('Reent article call-----'+selectedProduct);
        String selectedProductFilter = '';
        if (selectedProduct != null && selectedProduct != '' && !selectedProduct.contains('All'))
        {
            selectedProduct = selectedProduct.replaceAll(' ', '_');
            selectedProduct = selectedProduct.replaceAll('/', '_');
            selectedProductFilter = 'WITH DATA CATEGORY Version__c ABOVE_OR_BELOW ' + selectedProduct + '__c ';
            
            btbbCookieClass.UnAuthCookie authcookie =new btbbCookieClass.UnAuthCookie() ;
            authcookie.product=selectedProduct;
            authcookie.createcookie();
        }
        else if(selectedProduct.contains('All'))
        {
            btbbCookieClass.UnAuthCookie authcookie =new btbbCookieClass.UnAuthCookie() ;
            authcookie.product=selectedProduct;
            authcookie.createcookie();
        }
            
        announcementList = Database.query('Select Title, Summary, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber ' + 
            'From Announcement__kav ' +  
            'Where (PublishStatus = \'online\' And Language = \'en_US\') ' + 
            selectedProductFilter + 'Order by LastPublishedDate desc limit 2');
          
            
       /*  generalList = Database.query('Select Title, Summary, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber ' + 
            'From General_Article__kav ' +  
            'Where (PublishStatus = \'online\' And Language = \'en_US\')' + 
            selectedProductFilter + 'Order by LastPublishedDate desc limit 2');*/
       generalList = Database.query('Select Title, Summary, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber ' + 
            'From knowledgearticleversion ' +  
            'Where (PublishStatus = \'online\' And Language = \'en_US\' and IsVisibleInPkb=true and articletype  in(\'Blackboard_Client_Program__kav\',\'General_Article__kav\',\'Known_Issue__kav\',\'Other_Resource__kav\',\'Product_Documentation__kav\',\'Question_Answer__kav\',\'Support_Bulletin_Security_Advisory__kav\',\'Troubleshooting_Informational__kav\'))' + 
            selectedProductFilter + 'Order by LastPublishedDate desc limit 2');
    }
    

    public List<CategoryNode> getArticleCategories() {    
    
        return [SELECT Id, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, MasterLabel, ParentId, SortOrder, SortStyle, SystemModstamp 
            FROM CategoryNode
            WHERE ParentId != Null
            ORDER BY MasterLabel DESC];
            
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
                                product='CE/Vista';
                        }
                        else
                        {
                                product=selectedproduct;
                        }
                        ancmntlist =[select name,Corelicense__c,Detail__c,TimeStamp__c,Title__c from BtBb_Announcement__c where Corelicense__c=:product and portal__c ='UnAuthenticated' and isactive__c=true order by timestamp__c desc limit 1];
                        system.debug('test +++'+ancmntlist);
                        if(ancmntlist!=null && ancmntlist.size()>0)
                        {
                                 cookiemap= ancmentcookie.loadcookie();
                                 if(cookiemap != null )
                                 {
                                        if(cookiemap.get(product+'UnAuth')!=null)
                                        {
                                                ancmentcookie= cookiemap.get(product+'UnAuth');
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
                            ancmentcookie.portal=AnnouncementData.product+'UnAuth';
                            cookiemap.put(AnnouncementData.product+'UnAuth',ancmentcookie);
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
    public pagereference getsupport(){

        PageReference pageRef;
        
       
        for(Univs__c u: alist)
        {
            system.debug('++++'+u.Account__r.Name);
            system.debug('++++'+tp);
            if(u.Account__r.Name == tp)
             {
                
                if((u.Website__c == null || u.Website__c == '') && (u.HTML_Text__c == null || u.HTML_Text__c == ''))
                {
                    eText = 'Data not found eText';   
                        
                }
                else if(u.Website__c != null && u.HTML_Text__c != null)
                {
                    //erText = 'Data not found erText';
                    isValid = true;
                    u.View_Count__c =  u.View_Count__c +1;
                    update u;
                    pageref = page.btbb_transitionpage;
                    pageref.getParameters().put('web', u.Website__c);
                    pageref.setredirect(true);
                    //pageref = new PageReference(u.Website__c).setredirect(true);
                    
                    
                }
                else if(u.Website__c != null)
                {
                    isValid = true;
                    u.View_Count__c =  u.View_Count__c +1;
                    update u;
                    pageref = page.btbb_transitionpage;
                    pageref.getParameters().put('web', u.Website__c);
                    pageref.setredirect(true);
                    //pageref = new PageReference(u.Website__c).setredirect(true);
                }
                else if(u.HTML_Text__c != null)
                {
                    u.View_Count__c =  u.View_Count__c +1;
                    update u;
                    pageref = page.btbb_htmldisp;
                    pageref.getParameters().put('sid', u.Account__c);
                    pageref.setredirect(true);
                    
                }
            }  
            else 
            {
                //vld = true;
                errortext = 'We could not obtain your institution’s support information. Please contact your institution directly to receive support. Hint: Did you try going to your institution’s website and looking for support there (Links to student helpdesk, IT department, etc.)?';
            } 
            
           
        }
        return pageref;
       }
       
       public pagereference createcaseredirect()
       {
         pagereference casepage = Page.btbb_unauthcase;
         if(searchstring != null)
         {
         casepage.getparameters().put('subject',searchstring);
         }
         casepage.setredirect(true);
         return casepage;
       }
       public pagereference SearchKnowledgeBase()
         {
           pagereference skb = page.publickbsearch;
           skb.getparameters().put('aType','Knowledge');
           skb.getparameters().put('viewAll','Collaborate');
         
         skb.setredirect(true);
         return skb;
       }
            
        public integer getmaxsize()
        {
            return size;
        }
        
        public void refreshSearchResult()
        {
            String qryString = 'SELECT Id, title, UrlName, LastPublishedDate,LastModifiedById FROM KnowledgeArticleVersion WHERE (PublishStatus = \'online\' and Language = \'en_US\')';
                List<KnowledgeArticleVersion> articleList= Database.query(qryString);
                size= articleList.size();
        }
        public pagereference  loadarticle()
        {
            
              articlecontroller=new publickbarticleview();
              return null;
        }
    }
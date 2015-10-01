public class btbbAuthNavController{
    //public List<CategoryNode> catNodeList;
    public String category {get; set;}  
    GlobalComponent globalObj;
    public Boolean isXythosOnly { get; set;}
    public Boolean isMLAAdmin { get; set;}
    public Boolean isLearnAcademicDeveloper {get;set;}
    public Boolean isCollabAdmin{get {
       isCollabAdmin = false;
        btbbCookieClass.AauthCookie authcookie= new btbbCookieClass.AauthCookie();
        authcookie.loadcookie();
        if(authcookie.product != null && authcookie.product!='')
         {
            if (authcookie.product.containsIgnoreCase('collaborate') )
             
             {
               isCollabAdmin=globalObj.isCollabAdmin();
               
             }
         }
         system.debug('collabadmin:' +isCollabAdmin );  
         return isCollabAdmin;}
         set;
    }

    /* branding code
    public String selectedproductvar {
        get{
            try{
                User Userrec =[SELECT Id, ContactId,Session_Id__c,Session_Product__c,BTBB_KB_Default_Prod__c FROM User where Id = :userInfo.getUserId()];
                if(Userrec.Session_Id__c != UserInfo.getSessionId() ){
                    return Userrec.BTBB_KB_Default_Prod__c;
             }
                return Userrec.Session_Product__c ;
            }
            catch(Exception e){
                return '';
            }
        }set;
    } */
    
    public btbbAuthNavController() {
        globalObj = new GlobalComponent();
        isXythosOnly = globalObj.isXythosOnly();
        isMLAAdmin = globalObj.isMLAAdmin();
        isCollabAdmin=globalObj.isCollabAdmin();
        category = globalObj.defaultProduct();
        isLearnAcademicDeveloper = globalObj.isLearnAcademicDeveloper();
     
    }
   
   public boolean isreadonly {get {
    btbbCookieClass.AauthCookie authcookie= new btbbCookieClass.AauthCookie();
        authcookie.loadcookie();
        if(authcookie.product != null && authcookie.product!='')
         {
        return ((authcookie.product.containsIgnoreCase('collaborate')&&!isCollabAdmin)||(authcookie.product.containsIgnoreCase('Learn')&&isMLAAdmin));
         }
         else
         {
           return true;
         }
   }
   set;
   } 
  //populate links

     
     
     public static List<BtBb_Link__c>  getbtbbCommunitylinks()
     {
         List<BtBb_Link__c>  btbbCommunitylinks=new List<BtBb_Link__c>();
         string corelicense='Collaborate';
         btbbCookieClass.AauthCookie authcookie= new btbbCookieClass.AauthCookie();
         authcookie.loadcookie();
         if(authcookie.product != null && authcookie.product!='')
         {
            corelicense=authcookie.product;
         }
         else
         {
            corelicense='ALL';
         }
         
    
          btbbCommunitylinks=[Select id,NAME,LINK_NAME__C,URL__C,LOGO__c,WIDGET__C,CORE_LICENSE__C,target__c,ISAUTH__C,ISUNAUTH__C,ORDER__C from BtBb_Link__c 
                        where WIDGET__C='Community Resources' and CORE_LICENSE__C=:corelicense and isAuth__c=true order by ORDER__C asc];
                        
        return btbbCommunitylinks;              
     }
     
     public static List<BtBb_Link__c>  getbtbbServicelinks()
     {
        
         string corelicense='Collaborate';
         List<BtBb_Link__c>  btbbServicelinks=new List<BtBb_Link__c>(); 
         btbbCookieClass.AauthCookie authcookie= new btbbCookieClass.AauthCookie();
         authcookie.loadcookie();
          if(authcookie.product != null && authcookie.product!='')
         {
            corelicense=authcookie.product;
         }
         else
         {
            corelicense='ALL';
         }
      btbbServicelinks=[Select id,NAME,LINK_NAME__C,URL__C,LOGO__c,WIDGET__C,CORE_LICENSE__C, target__c,ISAUTH__C,ISUNAUTH__C,ORDER__C from BtBb_Link__c 
                        where WIDGET__C='Self Service' and CORE_LICENSE__C=:corelicense and isAuth__c=true order by ORDER__C asc]; 
                        
        return btbbServicelinks;                
     }
     
     /* branding code
     public static void sessionidcheck( string selectedprod){
     
     User Userrec =[SELECT Id, ContactId,Session_Id__c,Session_Product__c FROM User where Id = :userInfo.getUserId()]; 
     
        if(Userrec != null){
             if(Userrec.Session_Id__c != UserInfo.getSessionId() ){
                 Userrec.Session_Id__c = UserInfo.getSessionId();
             }
                  Userrec.Session_Product__c = selectedprod;  
        
        }
       update userrec; 
      
     }
     
     */
       public string getlogoclass()
         { 
            
             string corelicense='Collaborate';
         btbbCookieClass.AauthCookie authcookie= new btbbCookieClass.AauthCookie();
         authcookie.loadcookie();
          if(authcookie.product != null && authcookie.product!='')
         {
            corelicense=authcookie.product;
         }
         else
         {
            corelicense='Learn';
         }
            
            if(corelicense.containsignorecase('Learn'))
                {
                    return 'Learn';
                }
            else if(corelicense.containsignorecase('Collaborate'))
            {   
                return 'Collaborate';
            }
            else if(corelicense.containsignorecase('Vista'))
            {   
                return 'CE/Vista';
            }
            else if(corelicense.containsignorecase('xythos'))
            {   
                return 'Xythos';
            }
            else if(corelicense.containsignorecase('ANGEL'))
            {   
                return 'ANGEL';
            }
            else if(corelicense.containsignorecase('Moodlerooms'))
            {   
                return 'Moodlerooms';
            }
            else if(corelicense.containsignorecase('Analytics'))
            {   
                return 'Analytics';
            }
            else if(corelicense.containsignorecase('xpLor'))
            {   
                return 'xpLor';
            }
            else
            {
                return 'Learn';
            }
         }
}
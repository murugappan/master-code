public class btbb_community{
    
    GlobalComponent gc = new GlobalComponent();
    public string corelicense{get;set;}

    public PageReference Redirect() {
        if(gc.userRedirect == true){
            PageReference pageRedirect = new PageReference(gc.IDMRedirectURL);
            pageRedirect.getParameters().put('TARGET',gc.IDMTargetURL);          
            pageRedirect.setRedirect(true);
            return pageRedirect;
        } else {
            return null;
        }
    }
     
     public  List<BtBb_Link__c>  getbtbbCommunitylinks()
     {
         List<BtBb_Link__c>  btbbCommunitylinks=new List<BtBb_Link__c>();
     //    string corelicense='Collaborate';
         btbbCookieClass.AauthCookie authcookie= new btbbCookieClass.AauthCookie();
         authcookie.loadcookie();
         if(authcookie.product != null && authcookie.product!='')
         {
            corelicense=authcookie.product;
         }
         
         
    
          btbbCommunitylinks=[Select id,NAME,LINK_NAME__C,URL__C,WIDGET__C,CORE_LICENSE__C,ISAUTH__C,ISUNAUTH__C,ORDER__C, target__c,DESCRIPTION__C,ELEMENTID__C from BtBb_Link__c 
                        where WIDGET__C='Community Resources' and CORE_LICENSE__C=:corelicense and ISAUTH__C = true order by ORDER__C asc];
                        
        return btbbCommunitylinks;              
     }
     
    static testMethod void btbb_communityTest() {
    //btbb_community btbb_community = new btbb_community();
    Profile pf1= [select id from Profile where name = 'BTBB Profile'];
        User u2 = new User(LastName = 'Test Usser',Username = 'tuu1@test1.com',Email = 'testuser@test1.com',Alias = 'tu1' ,CommunityNickname= 'tu11' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf1.Id, LanguageLocaleKey = 'en_US');
        insert u2;
         System.runas(u2)
         { 
           btbb_community btbb_community = new btbb_community();
           btbb_community.Redirect();
           List<BtBb_Link__c>  btbbCommunitylinks=btbb_community.getbtbbCommunitylinks();
           btbbCookieClass.AauthCookie authcookie= new btbbCookieClass.AauthCookie();
           authcookie.product='Collaborate';
           authcookie.createcookie();
         }
}



static testMethod void btbb_communityTest1() {
    
           btbb_community btbb_community1 = new btbb_community();
           btbb_community1.Redirect();
           
           btbbCookieClass.AauthCookie authcookie1= new btbbCookieClass.AauthCookie();
           authcookie1.product='Collaborate';
           authcookie1.createcookie();
           List<BtBb_Link__c>  btbbCommunitylinks1=btbb_community1.getbtbbCommunitylinks();
}


}
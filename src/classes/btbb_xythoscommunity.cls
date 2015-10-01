public class btbb_xythoscommunity{
    GlobalComponent gc = new GlobalComponent();
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
    static testMethod void btbb_communityTest() {
   // btbb_xythoscommunity btbb_community = new btbb_xythoscommunity();
    
   // PageReference pageRedirect = new PageReference('http://en.wikipedia.org/wiki/Salesforce.com');
   // pageRedirect.getParameters().put('returnURL',pageRedirect .getUrl());
   Profile pf1= [select id, name from Profile where name = 'BTBB Profile'];   
    User u2 = new User(LastName = 'Test Usser',Username = 'tuu1@test1.com',Email = 'testuser@test1.com',Alias = 'tu1' ,CommunityNickname= 'tu11' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf1.Id, LanguageLocaleKey = 'en_US');
    insert u2;  
   System.runas(u2)
    {   
     btbb_xythoscommunity btbb_community = new btbb_xythoscommunity(); 
    btbb_community.Redirect();
    }
       
}
}
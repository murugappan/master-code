@isTest
private class btbb_publiccommunityTest{

    static testmethod void btbb_publiccommunityTest(){
         
          btbb_publiccommunity comm = new btbb_publiccommunity();
          btbbCookieClass.UnAuthCookie authcookie= new btbbCookieClass.UnAuthCookie();
           
          authcookie.product = 'collaborate';
          authcookie.createcookie();
          comm.getbtbbCommunitylinks();    
         
 }
}
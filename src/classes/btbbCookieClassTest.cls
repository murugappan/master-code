/**
 * This class contains unit tests for validating the behavior of btbbCookieClass.
 *
 */
@isTest(seealldata=true)
public with sharing class btbbCookieClassTest {
	static testMethod void UnitTestforPositiveScenarios1() {
	Profile pf1= [select id from Profile where name = 'SRV - BTBB User'];
	User u1=[select id, Name,contactId,BTBB_KB_Default_Prod__c from user where contactId != null and isactive=true  and profileid = :pf1.id limit 1 ];
	 system.runas(u1)
	 {
		 PageReference pageref= Page.btbb_home;
        Test.setCurrentPage(pageRef);
        btbbCookieClass.AauthCookie authcookie= new btbbCookieClass.AauthCookie();
        authcookie.product='Collaborate';
        authcookie.createcookie();
        btbbCookieClass.AauthCookie authcookie2= new btbbCookieClass.AauthCookie();
        authcookie2.loadcookie();
        system.assert(authCookie.product==authcookie2.product);
	 }
         
  }
	
	static testMethod void UnitTestforNegativeScenarios1() {
		Profile pf1= [select id from Profile where name = 'SRV - BTBB User'];
	 User u1=[select id, Name,contactId,BTBB_KB_Default_Prod__c from user where contactId != null and isactive=true  and profileid = :pf1.id limit 1 ];
	 User u2=[select id, Name,contactId,BTBB_KB_Default_Prod__c from user where contactId != null and isactive=true  and profileid = :pf1.id and id != :u1.id limit 1];	
	 string product1;
	 system.runas(u1)
	 {
		 PageReference pageref= Page.btbb_home;
        Test.setCurrentPage(pageRef);
        btbbCookieClass.AauthCookie authcookie= new btbbCookieClass.AauthCookie();
        authcookie.product='XYZ';
        product1=authcookie.product;
        authcookie.createcookie();
	 }
	 system.runas(u2)
	 {   
	 	PageReference pageref= Page.btbb_home;
        Test.setCurrentPage(pageRef);
        btbbCookieClass.AauthCookie authcookie2= new btbbCookieClass.AauthCookie();
        authcookie2.loadcookie();
        system.assert(product1!=authcookie2.product);
	 }   
         
	}
}
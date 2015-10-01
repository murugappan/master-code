/*
    @author         Nikhil Kumar <nikhil.kumar6@wipro.com>
    @discussion     This is the test Class on  class  'bb_oqe_extension'
*/

@istest
Private class bb_oqe_extensionTest{
    static testMethod void myUnitTest(){
    Test.starttest();
    PageReference testPage = Page.bb_oqe;
    Test.setCurrentPage(testPage);
    List <Opportunity> opp = [Select ID, Customer_Requested_Prod_Delivery_Date__c, PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity where name like '%a' Limit 10];
    bb_oqe_extension myExtension = new bb_oqe_extension(new ApexPages.StandardSetController (opp));
    myExtension.doCancel();
    myExtension.doHome(); 
    myExtension.doCreateView();
    myExtension.refreshPage();
    Test.stoptest(); 
    }
 }
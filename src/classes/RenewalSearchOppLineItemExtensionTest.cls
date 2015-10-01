/*
    @author         Nikhil Kumar <nikhil.kumar6@wipro.com>
    @discussion     This is the test Class on  class  'RenewalSearchOppLineItemExtension'
*/

@istest(seealldata=True)
Private class RenewalSearchOppLineItemExtensionTest{
    static testMethod void myUnitTest(){
    
    Account KAcc1 = new Account(Name = 'Account1');
    insert KAcc1;   
    
    opportunity opp = new opportunity(name = 'nik', AccountId = KAcc1.Id, StageName='Won',CloseDate=Date.today());
    insert opp;
    
   RenewalSearchOppLineItemExtension myExtension = new RenewalSearchOppLineItemExtension(new ApexPages.StandardController(opp));
    myExtension.oppID='006S0000005XYWy';
   myExtension.errorTitle='myerror';
   myExtension.setErrorTitle('nik');
   myExtension.getErrorTitle();
   myExtension.setErrorShow(true);
   myExtension.getErrorShow();
   myExtension.setErrorMessage('error');
   myExtension.getErrorMessage();
   myExtension.setErrorSeverity('erroeser');
   myExtension.getErrorSeverity();
   myExtension.setOppID('006S0000005XYWy');
   myExtension.getOppID();
   myExtension.refreshPage();
   myExtension.setOppName('opportunnity');
  // myExtension.getOppName();
   myExtension.save();
   myExtension.getOpportunityLineItems(); 
  }
  
}
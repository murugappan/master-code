//This is Test class for Trigger :BBW_CreateURL and Object Internal Article link
@istest
Private class BBW_CreateURLTest
 {
   Static TestMethod void CreateURL()
    {
   
     Solution  s = TestMethodUtility.Createsolution(); 
     s.CurrencyIsoCode='GBP';
     s.SolutionName='test3 solution';
     s.Change_Status_12_months__c=False;
     
     insert s;
     
     
     Solution ss =[select Id,SolutionName,SolutionNumber from Solution where id =:s.id];
     
     Test.StartTest();
     KB_Internal_Article_Link__c intartlink = TestMethodUtility.CreateInternalArticlelink();
     intartlink.Name=ss.SolutionNumber;
     intartlink.IsRunFromTestClass__c=True;
     intartlink.Related_Article__c=s.id;
     Insert intartlink;
     
    
    // below part is excute Trigger Adderror Part 
     try
     {
      KB_Internal_Article_Link__c intartlink1 = TestMethodUtility.CreateInternalArticlelink();
      intartlink1.Name='Test Solution';
      intartlink1.IsRunFromTestClass__c=False;
      intartlink1.Related_Article__c=s.id;
      Insert intartlink1;
     }
   Catch(exception e)
   {}  
   Test.StopTest();  
    }
  }
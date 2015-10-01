@istest(seealldata=True)
Private class BbSmallOpportunityExtTest
 {
 
               static testMethod void myUnitTest() 
               {
               
               
                Opportunity Opp =[select id,Accountid from Opportunity  limit 1];
                
                ApexPages.StandardController  std1 = New ApexPages.StandardController(opp);
                BbSmallOpportunityExt std = New BbSmallOpportunityExt(std1);
                
                std.doSave();
                std.getRelatedAssets();
                std.getOpprAssets();
                
                
                }
    
 
 
 }
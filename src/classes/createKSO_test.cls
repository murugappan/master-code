@istest(seeAllData=true)

public class createKSO_test {

static testMethod void myUnitTest(){

    
    
   String pricebookName = 'TEST_PB';
   String accName = 'TEST_ACC';
   String oppName = 'TEST_OPP';
   String quoteName = 'TEST_CAM_QUOTE';
   String attName = 'TEST_ATT_content';
   String prodName = 'CL-TRNOL-GS-WC';
   String sysRecordType = 'Navigation';
    
   Account acc = TestMethodUtility.createAccount();
   insert acc;
   
   Pricebook2 pricebook = new Pricebook2(Name = 'Test Pricebook', IsActive = true);
   insert pricebook;
   
   //Standard pricebook
    Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true limit 1];
    
    

   Pricebook2 spb = [select id from Pricebook2 Where Name = 'Test Pricebook' AND IsActive = true LIMIT 1];
   
   Product2 prod = new Product2(Name = prodName, ProductCode = prodName);
   insert prod;
   
   PricebookEntry pes = TestMethodUtility.createPricebookEntry(standardPB,prod);
   pes.UseStandardPrice = false;
   insert pes;
   
   PricebookEntry pbe = new PricebookEntry();
   
   
            pbe.Pricebook2Id = spb.Id;
            pbe.Product2Id = prod.Id;
            pbe.UnitPrice = 100;
            pbe.IsActive = true;
            pbe.UseStandardPrice = false;
   insert pbe;

   Opportunity opp = new Opportunity(Name = oppName, AccountId = acc.Id, StageName = '(S) Suspect Qualification', CloseDate = Date.today());
   insert opp;
    
   KimbleOne__SalesOpportunity__c Kso = new KimbleOne__SalesOpportunity__c();
   Kso.Name='Test';
   Kso.KimbleCRMInt__Opportunity__c = Opp.id;
   kso.KimbleOne__Account__c=acc.id;
  //Insert Kso;
  
   List<KimbleOne__SalesOpportunity__c> Ksofordel =[select id from KimbleOne__SalesOpportunity__c  where KimbleCRMInt__Opportunity__c =:opp.id];
   
   if(Ksofordel.Size()>0)
   Delete Ksofordel ;
    
   ApexPages.currentPage().getParameters().put('id',opp.id);
    
    
    
   test.startTest();
         ApexPages.StandardController qe = new ApexPages.standardController(new Opportunity());
         CreateKSO controller = new CreateKSO(qe);
         controller.autorun();
        
   test.stopTest();


}



}
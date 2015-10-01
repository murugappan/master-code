/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          TestOpportunityLineItemTriggers
    @abstract       Unit Test for all OpportunityLineItem triggers
    @since          2011.0630
    @discussion     Test Class for OpportunityLineItem triggers
*/

@isTest
public class TestOpportunityLineItemTriggers  {

     private static testMethod void closeOpportunityWith_A_or_R_ContractLineStatusTest(){

 
        PriceBookEntry product1 = [SELECT Id FROM PriceBookEntry 
                                    WHERE Pricebook2.Name = 'Renewals' and CurrencyIsocode='USD'
                                    AND isActive = true
                                    LIMIT 1];

        PriceBookEntry product2 = [SELECT Id FROM PriceBookEntry 
                                    WHERE Pricebook2.Name = 'Renewals' and CurrencyIsoCode='USD'
                                    AND isActive = true
                                    LIMIT 1];

        Id renewalRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Blackboard Opportunity Renewals'].Id;

        //Create TEST Account
        Account account = new Account(Name = 'Name', Industry = 'Higher Ed.', BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'USA');
        insert account;            
        System.assertNotEquals(account.Id, null);            

        //Create TEST Opportunity
        Opportunity opportunity = new Opportunity(CurrencyIsoCode='USD',Name = 'Apex Test', Type = 'Renewal', StageName = '(A) Signature Due', CloseDate = date.today(), AccountID = account.Id, REcordTypeId = renewalRecordTypeId);
        insert opportunity;
        System.assertNotEquals(opportunity.Id, null);

        OpportunityLineItem item1 = new OpportunityLineItem(opportunityId = opportunity.id, PricebookEntryId = product1.Id, Quantity = 1, UnitPrice = 4324);
        insert item1;
        OpportunityLineItem item2 = new OpportunityLineItem(opportunityId = opportunity.id, PricebookEntryId = product2.Id, Quantity = 1, UnitPrice = 4324);
        insert item2;
        
        // TP 2425 - no longer needed - June 13, 2012
     
        item1.CA_Line_Status__c = 'A';
        update item1;

        opportunity = [SELECT Id, StageName FROM Opportunity WHERE Id = :opportunity.Id];
        System.assertNotEquals('(W) Won', opportunity.StageName);

        item2.CA_Line_Status__c = 'R';
        update item2;
        
        opportunity = [SELECT Id, StageName FROM Opportunity WHERE Id = :opportunity.Id];
       // System.assertEquals('(W) Won', opportunity.StageName);
     
        
   } 
   
  public static testMethod void TestforCalculateOppPrice()
   {
    Account a = TestMethodUtility.createAccount();
    insert a;
              
    Contact con = TestMethodUtility.createContact(a);
    insert con;

    Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true limit 1];
                
    Pricebook2 pb = [select Id from pricebook2 where Name='CPQ' limit 1];

    Product2 pr =TestMethodUtility.createProduct();
    pr.Type__c='Services';
    insert pr;
                
    PricebookEntry pes = TestMethodUtility.createPricebookEntry(standardPB,pr);
    pes.UseStandardPrice = false;
    insert pes;
    
    PricebookEntry pe = TestMethodUtility.createPricebookEntry(pb,pr);
    pe.UseStandardPrice = false;
    insert pe;
                
    Opportunity opp = TestMethodUtility.createOpportunity(a,pb);
    //opp1.StageName='(B) Pending Contract';
    //opp.RecordTypeId = '01270000000Hlar';
    insert opp;

    Opportunity opp1 = TestMethodUtility.createOpportunity(a,pb);
    //opp1.StageName='(B) Pending Contract';
    //opp1.RecordTypeId = '01270000000Hlar';
    opp1.CPQ_Previous_Opportunity__c = opp.Id;

    insert opp1;

    List<OpportunityLineItem> listoli = new List<OpportunityLineItem>();

    OpportunityLineItem oli = new OpportunityLineItem(PricebookEntryId = pe.Id);
    oli.OpportunityId=opp.id;
    oli.Quantity=1; 
    oli.CPQ_Delivery_Status__c ='Request Pending';
    oli.Custom_Price__c = 100.00;
    oli.Renewal_Unique_Line_ID__c = '66';
    oli.CPQ_Product_Start_Date__c = System.today();
    oli.CPQ_Product_End_Date__c = System.today() + 30;
    
    OpportunityLineItem oli2 = new OpportunityLineItem(PricebookEntryId = pe.Id);
    oli2.OpportunityId=opp.id;
    oli2.Quantity=1; 
    //oli2.ListPrice=100.00;
    oli2.CPQ_Delivery_Status__c ='Request Pending';
    oli2.bTotalPrice__c = 100.00;
    oli2.Discount_Type__c ='Percent';
    oli2.Renewal_Unique_Line_ID__c = '62';
    oli2.CPQ_Product_Start_Date__c =System.today();
    oli2.CPQ_Product_End_Date__c = System.today() + 30;

    OpportunityLineItem oli3 = new OpportunityLineItem(PricebookEntryId = pe.Id);
    oli3.OpportunityId=opp.id;
    oli3.Quantity=2; 
    oli3.CPQ_Delivery_Status__c ='Request Pending';
    oli3.UnitPrice = 100.00;
    oli3.Discount_Type__c ='Amount';
    oli3.Renewal_Unique_Line_ID__c = '1141';
    oli3.CPQ_Product_Start_Date__c = System.today();
    oli3.CPQ_Product_End_Date__c = System.today() + 30;
    
    listoli.add(oli);
    listoli.add(oli2);
    listoli.add(oli3);

    insert listoli;
    System.debug('Insertion'+Listoli[0].CPQ_Delivery_Status__c);
    System.debug(Listoli[1].CPQ_Delivery_Status__c);
    System.debug(Listoli[2].CPQ_Delivery_Status__c);

    System.debug('Pfin Intgr:'+Listoli[0].PFIN_Intgr_Record_Type__c);

    Core_License__c cl = TestMethodUtility.createCoreLicense();
    insert cl;

    Asset ast = TestMethodUtility.createAsset(a,cl);
    ast.CPQ_Current_Opportunity_ID__c = opp.id;
    ast.Opportunity__c = opp1.Id;
    ast.Status='Request Pending';
    ast.CPQ_LineIdentifier__c = '62';
    ast.CPQ_Contract_Start_Date__c = System.today();
    ast.CPQ_Contract_End_Date__c = System.today() + 30;

    insert ast;
    Asset ass1 = TestMethodUtility.createAsset(a,cl);
    ass1.Opportunity__c = opp.Id;
    ass1.CPQ_Current_Opportunity_ID__c = opp1.id;
    ass1.Status='Request Pending';
    ast.CPQ_LineIdentifier__c = '66';
    ass1.CPQ_Contract_Start_Date__c = System.today();
    ass1.CPQ_Contract_End_Date__c = System.today() + 30;
    
    insert ass1;

    Asset ast2 = TestMethodUtility.createAsset(a,cl);
    ast2.Opportunity__c = opp.Id;
    ast2.CPQ_Current_Opportunity_ID__c = opp.id;
    ast2.Status='Request Pending';
    ast.CPQ_LineIdentifier__c = '1141';
    ast2.CPQ_Contract_Start_Date__c = System.today();
    ast2.CPQ_Contract_End_Date__c = System.today() + 30;
    
    insert ast2;
    
    Listoli[0].CPQ_Delivery_Status__c = 'Installed';
    Listoli[1].CPQ_Delivery_Status__c = 'Installed';
    Listoli[2].CPQ_Delivery_Status__c = 'Installed';

    System.debug('Update1'+Listoli[0].CPQ_Delivery_Status__c);
    System.debug(Listoli[1].CPQ_Delivery_Status__c);
    System.debug(Listoli[2].CPQ_Delivery_Status__c);
    
    BbOpportunityLineItemTriggerHandler.hasAfterUpdateRun = false;
    update listoli; 


   Asset cs=[select id,CPQ_Current_Opportunity_ID__c,Status,Opportunity__c from Asset where id=:ast.id];
      System.debug('@@CPQOPPID--'+cs.CPQ_Current_Opportunity_ID__c);
      System.debug('--OPPID--'+cs.Opportunity__c);
    Asset cs1=[select id,CPQ_Current_Opportunity_ID__c,Opportunity__c,Status from Asset where id=:ass1.id];
      System.debug('@@OPPID--'+cs1.Opportunity__c);
      System.debug('--CPQ--'+cs1.CPQ_Current_Opportunity_ID__c);
   /* Asset as1 = [SELECT Id,Status,CPQ_LineIdentifier__c,AccountId,CPQ_Contract_Start_Date__c,CPQ_Contract_End_Date__c  FROM Asset where CPQ_Current_Opportunity_ID__c =: opp.Id];
        System.debug('AccountId'+as1.AccountId);
        System.debug('CPQ_Contract_Start_Date__c'+as1.CPQ_Contract_Start_Date__c);
        System.debug('CPQ_LineIdentifier__c'+as1.CPQ_LineIdentifier__c);
        System.debug('CPQ_Contract_End_Date__c'+as1.CPQ_Contract_End_Date__c); */

    }
    public static testMethod void TesttoUpdatePreviousYearPrice()
   {

   // id cpqrecordtypeid=Schema.SObjectType.case.getRecordTypeId();

    Account a = TestMethodUtility.createAccount();
    insert a;
              
    Contact con = TestMethodUtility.createContact(a);
    insert con;

    Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true limit 1];
                
    Pricebook2 pb = [select Id from pricebook2 where Name='CPQ' limit 1];

    Product2 pr =TestMethodUtility.createProduct();
    pr.Type__c='Services';
    insert pr;
                
    PricebookEntry pes = TestMethodUtility.createPricebookEntry(standardPB,pr);
    pes.UseStandardPrice = false;
    insert pes;
    
    PricebookEntry pe = TestMethodUtility.createPricebookEntry(pb,pr);
    pe.UseStandardPrice = false;
    insert pe;
                
    Opportunity opp = TestMethodUtility.createOpportunity(a,pb);
    //opp1.StageName='(B) Pending Contract';
    //opp.RecordTypeId = cpqrecordtypeid;
    insert opp;
    opp.CPQ_Previous_Opportunity__c = opp.Id;
    update opp;

    Opportunity opp1 = TestMethodUtility.createOpportunity(a,pb);
    //opp1.StageName='(B) Pending Contract';
    opp1.CPQ_Previous_Opportunity__c = opp.Id;
    //opp1.RecordTypeId  = cpqrecordtypeid ;
    insert opp1;

    List<OpportunityLineItem> listoli = new List<OpportunityLineItem>();

    OpportunityLineItem oli = new OpportunityLineItem(PricebookEntryId = pe.Id);
    oli.OpportunityId=opp.id;
    oli.Quantity=1; 
    oli.CPQ_Delivery_Status__c ='Request Pending';
    oli.Renewal_Unique_Line_ID__c = '66';
    oli.CPQ_Product_Start_Date__c = System.today();
    oli.CPQ_Product_End_Date__c = System.today() + 30;
    oli.UnitPrice = 100.00;
    oli.Discount_Type__c ='Amount';
    //oli.Quota_Renewal_Sales_Adjustment__c = 10;
    
    OpportunityLineItem oli2 = new OpportunityLineItem(PricebookEntryId = pe.Id);
    oli2.OpportunityId=opp.id;
    oli2.Quantity=1; 
    oli2.CPQ_Delivery_Status__c ='Request Pending';
    oli2.Renewal_Unique_Line_ID__c = '62';
    oli2.CPQ_Product_Start_Date__c =System.today();
    oli2.CPQ_Product_End_Date__c = System.today() + 30;
    oli2.UnitPrice = 100.00;
    oli2.Discount_Type__c ='Amount';
    //oli2.Quota_New_Sales_Adjustment__c = 10;
    

    OpportunityLineItem oli3 = new OpportunityLineItem(PricebookEntryId = pe.Id);
    oli3.OpportunityId=opp1.id;
    oli3.Quantity=2; 
    oli3.Renewal_Unique_Line_ID__c = '1141';
    oli3.CPQ_Product_Start_Date__c = System.today();
    oli3.CPQ_Product_End_Date__c = System.today() + 30;
    oli3.Quota_New_Sales_Adjustment__c = -10;
    oli3.Quota_Renewal_Sales_Adjustment__c = 10;
    oli3.UnitPrice = 100.00;
    oli3.Discount_Type__c ='Amount';

    listoli.add(oli);
    listoli.add(oli2);
    listoli.add(oli3);

    insert listoli;
    
    System.debug('listoli[0].OpportunityId'+listoli[0].OpportunityId);
    System.debug('listoli[1].OpportunityId'+listoli[1].OpportunityId);
    System.debug('listoli[2].OpportunityId'+listoli[2].OpportunityId);

    /*oli.Quota_New_Sales_Adjustment__c = -10;
    oli.Quota_Renewal_Sales_Adjustment__c = 10;
    oli2.Quota_Renewal_Sales_Adjustment__c = -10; */
       
    System.debug('Pfin Intgr:'+Listoli[0].PFIN_Intgr_Record_Type__c);

    Core_License__c cl = TestMethodUtility.createCoreLicense();
    insert cl;

    List<Asset> listast = new List<Asset>();

    Asset ast = new Asset();
    ast.Name = 'TestAsset';
    ast.AccountId = a.Id;
    ast.Version__c = '9.1 SPR10';
    ast.Core_License__c = cl.Id;
    ast.CPQ_Current_Opportunity_ID__c = opp1.id;
    ast.Opportunity__c = opp.Id;
    ast.Status='Request Pending';
    ast.CPQ_LineIdentifier__c = '66';
    ast.CPQ_Contract_Start_Date__c = System.today();
    ast.CPQ_Contract_End_Date__c = System.today() + 30;

    Asset ast1 = new Asset();
    ast1.Name = 'TestAsset1';
    ast1.AccountId=a.Id;
    ast1.Core_License__c = cl.Id;
    ast1.Opportunity__c = opp1.Id;
    ast1.CPQ_Current_Opportunity_ID__c = opp1.id;
    ast1.Status ='Request Pending';
    ast1.CPQ_Contract_Start_Date__c = System.today();
    ast1.CPQ_LineIdentifier__c = '1141';
    ast1.CPQ_Contract_End_Date__c = System.today() + 30;
    ast1.Version__c = '9.1 SPR10';

    Asset ast2 = new Asset();
    ast2.Name = 'TestAsset2';
    ast2.AccountId=a.Id;
    ast2.Core_License__c = cl.Id;
    ast2.Opportunity__c = opp.Id;
    ast2.CPQ_Current_Opportunity_ID__c = opp1.id;
    ast2.Status ='Request Pending';
    ast2.CPQ_Contract_Start_Date__c = System.today();
    ast2.CPQ_LineIdentifier__c = '62';
    ast2.CPQ_Contract_End_Date__c = System.today() + 30;
    ast2.Version__c = '9.1 SPR10';

    listast.add(ast);
    listast.add(ast1);
    listast.add(ast2);

    insert listast;
    Asset as1 = [SELECT Id,Status,CPQ_LineIdentifier__c,AccountId,CPQ_Contract_Start_Date__c,CPQ_Contract_End_Date__c,CPQ_Current_Opportunity_ID__c,Opportunity__c  FROM Asset where CPQ_Current_Opportunity_ID__c =: opp1.Id limit 1];
        System.debug('AccountId'+as1.AccountId);
        System.debug('CPQ_Contract_Start_Date__c'+as1.CPQ_Contract_Start_Date__c);
        System.debug('CPQ_LineIdentifier__c'+as1.CPQ_LineIdentifier__c);
        System.debug('CPQ_Contract_End_Date__c'+as1.CPQ_Contract_End_Date__c);
        System.debug('CPQ_Current_Opportunity_ID__c'+as1.CPQ_Current_Opportunity_ID__c);
        System.debug('Opportunity__c'+as1.Opportunity__c);
   
   runrenewaltrigger.NotrunOppl =False;
   update listoli; 
    }

}
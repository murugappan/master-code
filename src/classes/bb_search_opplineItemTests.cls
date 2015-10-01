@istest
public class bb_search_opplineItemTests {
    public static testMethod void bbSearchOppLineItemTest() {
    
        List<OpportunityLineItem> oppLineItemList;
        Opportunity opp;
        String oppName;
        String oppID;
        boolean errorShow;
        String errorTitle;
        String errorMessage;
        String errorSeverity;

         
        PageReference pageRef = Page.OpportunityLineItemMassUpdate;
        Test.setCurrentPage(pageRef);
        opp = [Select Id, Pricebook2Id from Opportunity where Name Like '%a%' and Pricebook2Id != null Limit 1];
        ApexPages.StandardController stdCon = new ApexPages.StandardController(opp);
        SearchOppLineItemExtension controller = new SearchOppLineItemExtension(stdCon);
        
        
        PriceBookEntry priceBookEntryObj = [Select Id from PriceBookEntry where IsActive = true and Pricebook2Id = :opp.Pricebook2Id Limit 1];
        // Add parameters from page URL
        String oppVal = Apexpages.currentPage().getParameters().get('oppVal');
        //ApexPages.currentPage().getParameters().put('qp', 'yyyy');
        // Instantiate a new controller with all parameters in the page
        controller = new SearchOppLineItemExtension();
        controller.setOppName('oppName');
        controller.setOppID(opp.Id);
        controller.setErrorShow(true);
        controller.setErrorTitle('errorTitle');
        controller.setErrorMessage('errorMessage');
        controller.setErrorSeverity('errorSeverity');
               
        controller.getOppName();
        oppID = controller.getOppID();
        errorShow = controller.getErrorShow();
        errorTitle = controller.getErrorTitle();
        errorMessage = controller.getErrorMessage();
        errorSeverity = controller.getErrorSeverity();
        
        pageRef = controller.refreshPage();
        
        System.assertEquals(oppID ,opp.Id);
        oppLineItemList = [SELECT CreatedDate,Transact_Desired_Prod_Date__c, PricebookEntry.Product2.Name,PricebookEntry.Product2.ProductCode,PricebookEntry.Product2.Internal_Long_Description__c ,PricebookEntry.Product2.Type__c,UnitPrice, ACCT_Description__c, Transact_Desired_Live_Date__c, Quantity, Psft_Capture_ID__c, Product_Type__c, Discount_Amount__c, Customer_Price__c, Custom_Price__c, Converted_To_Order__c from OpportunityLineItem where OpportunityId = :opp.Id];
        pageRef = controller.save();
        //update oppLineItemList;
        oppLineItemList = controller.getOpportunityLineItems();
        controller.setOpportunityLineItems(oppLineItemList);

        oppLineItemList = [SELECT Transact_Desired_Prod_Date__c, PricebookEntry.Product2.Name,PricebookEntry.Product2.ProductCode,PricebookEntry.Product2.Internal_Long_Description__c ,PricebookEntry.Product2.Type__c,UnitPrice, ACCT_Description__c, Transact_Desired_Live_Date__c, Quantity, Psft_Capture_ID__c, Product_Type__c, Discount_Amount__c, Customer_Price__c, Custom_Price__c, Converted_To_Order__c from OpportunityLineItem where OpportunityId = :opp.Id];
        pageRef = controller.save();
        //update oppLineItemList; 
     }
}
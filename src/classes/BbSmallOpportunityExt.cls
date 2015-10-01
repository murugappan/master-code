public class BbSmallOpportunityExt{
    // an instance varaible for the standard controller
    private ApexPages.StandardController controller {get; set;}
    private Opportunity opportunity {get; set;}     
  
    // initialize the controller
    public BbSmallOpportunityExt(ApexPages.StandardController controller) {
 
        //initialize the stanrdard controller
        this.controller = controller;
        // load the current record
        this.opportunity = (Opportunity)controller.getRecord();
        
       
    }
 
    // handle the action of the commandButton
    public PageReference doSave() {
        opportunity.last_interaction_dttm__c = System.now();
        update opportunity;
    	return null;
    }
    
    public List<Asset> getRelatedAssets() {
        
        return ([Select Id, Name, Product2.ProductCode, Status, CPQ_Contract_Start_Date__c, CPQ_Contract_End_Date__c, CPQ_Previous_Opportunity_ID__c,  CPQ_Current_Opportunity_ID__c, CPQ_LineIdentifier__c , CreatedDate From Asset Where AccountId = :opportunity.AccountId Order By CreatedDate Desc]);
    }

    public List<Asset> getOpprAssets() {
        
        return ([Select Id, Name, Product2.ProductCode, Status, CPQ_Contract_Start_Date__c, CPQ_Contract_End_Date__c, CPQ_Previous_Opportunity_ID__c,  CPQ_Current_Opportunity_ID__c, CPQ_LineIdentifier__c , CreatedDate From Asset Where CPQ_Current_Opportunity_ID__c = :opportunity.Id Order By CreatedDate Desc]);
    }

/*
    public List<Asset> getChildAssets() {
        return ( [SELECT Id, Name,Product2.ProductCode, Product2.GKEY_Product_Group__c, CPQ_Contract_Start_Date__c, CPQ_Contract_End_Date__c 
                  From Asset Where KEYGEN_Parent_Asset__c = :asset_id ]);
    } 
    
    public List<Asset> getEligibleChildAssets() {
        system.debug('>>>asset.AccountId: ' + account_id );
        return ( [SELECT Id, AccountId, Name, Product2.ProductCode, Product2.GKEY_Product_Group__c, CPQ_Contract_Start_Date__c, CPQ_Contract_End_Date__c  
                  FROM Asset  
                  WHERE AccountId = :account_id  AND isCurrent__c = true  AND KEYGEN_Parent_Asset__c = null  
                  AND Product2.GKEY_Product_Group__c  LIKE 'BB-CHD%'  ]);
    } 
*/
}
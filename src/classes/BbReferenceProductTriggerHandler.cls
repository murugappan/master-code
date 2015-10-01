/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          BlackboardReferenceProductTriggerHandler
    @abstract       handles all the logic for triggers on ReferenceProduct
    @since          2011.0915
    @discussion     Class to execute ReferenceProduct triggers logic
*/
public with sharing class BbReferenceProductTriggerHandler {
    
    // ------------------------------------------------
    // Constructor Method
    // ------------------------------------------------
    public BbReferenceProductTriggerHandler(){
    }
        
    // ------------------------------------------------
    // Triggers Methods
    // ------------------------------------------------
    public void OnBeforeInsert(Bb_Reference_Products__c[] newReferenceProducts){
        linkReferenceProductToAccount(newReferenceProducts);
        preventReferenceProductDuplicate(newReferenceProducts);
    }
    
    public void OnAfterInsert(Bb_Reference_Products__c[] newReferenceProducts, Map<ID, Bb_Reference_Products__c > insertedReferenceProductMap){
        
    }
        
    public void OnBeforeUpdate(Bb_Reference_Products__c[] oldReferenceProducts, Bb_Reference_Products__c[] updatedReferenceProducts, Map<ID, Bb_Reference_Products__c > oldReferenceProductMap, Map<ID, Bb_Reference_Products__c > updatedReferenceProductMap){
        linkReferenceProductToAccount(updatedReferenceProducts);
        preventReferenceProductDuplicate(updatedReferenceProducts);
    }
    
    public void OnAfterUpdate(Bb_Reference_Products__c[] oldReferenceProducts, Bb_Reference_Products__c[] updatedReferenceProducts, Map<ID, Bb_Reference_Products__c > oldReferenceProductMap, Map<ID, Bb_Reference_Products__c > updatedReferenceProductMap){

    }


    // ------------------------------------------------
    // Class Methods
    // ------------------------------------------------
    
    //Links Reference Product to Account
    private void linkReferenceProductToAccount(Bb_Reference_Products__c[] referenceProducts) {

        //Sets the Account Id
        Set<id> referenceProductids = new Set<id>();
        for (Bb_Reference_Products__c rp : referenceProducts)
        {
             if(rp.AccountID__c == null) referenceProductids.add(rp.Bb_References__c);
        }
    
        if(referenceProductids.size() > 0)
        {
      
            Map<Id, Bb_References__c> refMap = new Map<Id, Bb_References__c>([SELECT Account__c FROM Bb_References__c WHERE Id IN :referenceProductids]);
        
            for (Bb_Reference_Products__c prod : referenceProducts)
            {
                 prod.AccountID__c = refMap.get(prod.Bb_References__c).Account__c;
            }
        }
    }
    
    //Prevents from saving a duplicate product reference if one already exist for the same product.
    private void preventReferenceProductDuplicate(Bb_Reference_Products__c[] referenceProducts){
        
        Set<Id> newReferenceProductsAccountIds = new Set<Id>();
    
        for(Bb_Reference_Products__c referenceProduct : referenceProducts)
        {
           if(referenceProduct.AccountID__c != null) newReferenceProductsAccountIds.add(referenceProduct.AccountID__c);
        }
        
        if(newReferenceProductsAccountIds.size() > 0)
        {
            List<Bb_Reference_Products__c> rps = new List<Bb_Reference_Products__c>([SELECT Id, AccountID__c , Line_of_Business__c , Product__c FROM Bb_Reference_Products__c WHERE AccountID__c IN :newReferenceProductsAccountIds]);
            Set<String> existingProducts = new Set<String>();
        
            for (Bb_Reference_Products__c referenceProduct : referenceProducts){
                for(Bb_Reference_Products__c rp : rps)
                {
                    if(referenceProduct.AccountID__c == rp.AccountID__c &&  referenceProduct.Line_of_Business__c == rp.Line_of_Business__c && referenceProduct.Product__c == rp.Product__c)
                    {
                        if(Trigger.isInsert || (Trigger.isUpdate && referenceProduct.Id != rp.Id)) existingProducts.add(rp.AccountID__c + rp.Line_of_Business__c + rp.Product__c);
                    }
                }
            }
            
            for (Bb_Reference_Products__c referenceProduct : referenceProducts){
                if(existingProducts.contains(referenceProduct.AccountID__c + referenceProduct.Line_of_Business__c + referenceProduct.Product__c))
                {
                    referenceProduct.Product__c.addError('Reference Product cannot be created - A Reference Product already exists for ' + referenceProduct.Product__c + ' for this Account');
                } 
            }
        }
    }
}
public with sharing class DeliveryElementAllocationsController {

    ApexPages.StandardController controller;
    private KimbleOne__DeliveryGroup__c deliveryGroup;
    public list<KimbleOne__DeliveryElement__c> TheDeliveryElements{get; set;}
    
    public DeliveryElementAllocationsController (ApexPages.StandardController stdController) 
    {
        controller = stdController;
        
        deliveryGroup = [SELECT Id, KimbleCRMInt__Opportunity__c FROM KimbleOne__DeliveryGroup__c WHERE Id = :controller.getId()];
        
        GetTheDeliveryElements();
    }
    
    private void GetTheDeliveryElements()
    {
        TheDeliveryElements = [SELECT Id, Name, ContractRevPlan__c, ContractBillPlan__c, (SELECT Name FROM OpportunityLineItems__r LIMIT 1)
                                    FROM KimbleOne__DeliveryElement__c
                                    WHERE KimbleOne__DeliveryGroup__c = :deliveryGroup.Id
                                    ORDER BY Name];
                                                                

    }
    
    public KimbleOne__DeliveryElement__c theDeliveryElement {get; set;} 
    
    public list<SelectOption> OppLineItemsForAlloc {get; set;}

    public list<SelectOption> ContractRevenuePlans {get; set;}
    
    public list<SelectOption> ContractBillPlans {get; set;}
    
    public void getElementForAlloc()
    {
        string elementId = ApexPages.currentPage().getParameters().get('deId');
        
        theDeliveryElement = [SELECT Id, Name, ContractRevPlan__c, ContractBillPlan__c, OpportunityLineItem__c, KimbleOne__Product__r.SF_ProductCode__c, KimbleOne__Product__r.KimbleOne__ProductDomain__c FROM KimbleOne__DeliveryElement__c WHERE Id = :elementId][0];
        
        // OpportunityLineItems that have the same PS Product Id and have not been allocated
        OppLineItemsForAlloc = new list<SelectOption>();
        
        OppLineItemsForAlloc.add(new SelectOption('',''));
        for (OpportunityLineItem oppLineItem : [SELECT Id, Name FROM OpportunityLineItem 
                                                    WHERE OpportunityId = :deliveryGroup.KimbleCRMInt__Opportunity__c
                                                    AND PS_Product_ID__c = :theDeliveryElement.KimbleOne__Product__r.SF_ProductCode__c
                                                    AND (DeliveryElement__c = null OR DeliveryElement__c = :theDeliveryElement.id)
                                                    ORDER BY Name])
        {
           OppLineItemsForAlloc.add(new SelectOption(oppLineItem.Id,oppLineItem.Name));
        }
    
        // PS Contract Revenue and Bill Plans for this Element
        KimbleOne__ProductDomain__c productDomain = [SELECT ContractRevPlan__c, ContractBillPlan__c FROM KimbleOne__ProductDomain__c WHERE Id = :theDeliveryElement.KimbleOne__Product__r.KimbleOne__ProductDomain__c][0];
        
        ContractRevenuePlans = new list<SelectOption>();
        for (string revenuePlan : productDomain.ContractRevPlan__c.split(';'))
        {
           ContractRevenuePlans.add(new SelectOption(revenuePlan,revenuePlan));
        }

        ContractBillPlans = new list<SelectOption>();
        for (string billPlan : productDomain.ContractBillPlan__c.split(';'))
        {
           ContractBillPlans.add(new SelectOption(billPlan,billPlan));
        }
    
    }   
        
    public PageReference SaveElementAllocation()
    {
        try 
        {
            KimbleOne__DeliveryElement__c oldElementAlloc = [SELECT OpportunityLineItem__c FROM KimbleOne__DeliveryElement__c WHERE Id = :theDeliveryElement.Id][0];
            
            update theDeliveryElement;
        
            // Save lookup from OpportunityLineItem to Element (based on Id string)
            if (theDeliveryElement.OpportunityLineItem__c != null)
            {
                OpportunityLineItem theOppLineItem = [SELECT Id FROM OpportunityLineItem WHERE Id = :theDeliveryElement.OpportunityLineItem__c][0];
                theOppLineItem.DeliveryElement__c = theDeliveryElement.Id;
                
                update theOppLineItem;
            }
            
            // Remove previous allocation to OpportunityLineItem
            if (oldElementAlloc.OpportunityLineItem__c != null && oldElementAlloc.OpportunityLineItem__c != theDeliveryElement.OpportunityLineItem__c)
            {
                OpportunityLineItem oldOppLineItem = [SELECT Id FROM OpportunityLineItem WHERE Id = :oldElementAlloc.OpportunityLineItem__c][0];
                oldOppLineItem.DeliveryElement__c = null;
                
                update oldOppLineItem;
            }

            GetTheDeliveryElements();
            
            return null;
        }
        catch (Exception e)
        {
            ApexPages.addMessages(e);
            return null;
        }
    }
    
}
@isTest(SeeAllData=true)
private with sharing class DeliveryElementAllocationsCntrllrTests {

    static testMethod void testDeliveryElementAllocation() {
        
        KimbleOne__DeliveryElement__c de = [SELECT KimbleOne__DeliveryGroup__c FROM KimbleOne__DeliveryElement__c LIMIT 1][0];
        KimbleOne__DeliveryGroup__c dg = [SELECT Id FROM KimbleOne__DeliveryGroup__c WHERE Id = :de.KimbleOne__DeliveryGroup__c];
        
        ApexPages.StandardController stdCon = new ApexPages.StandardController(dg);
        DeliveryElementAllocationsController theController = new DeliveryElementAllocationsController(stdCon);
        
        Test.startTest();
        
        // Act
        ApexPages.currentPage().getParameters().put('deId', de.Id);
        
        theController.getElementForAlloc();
        theController.SaveElementAllocation();
        
        Test.stopTest();
            
    }

}
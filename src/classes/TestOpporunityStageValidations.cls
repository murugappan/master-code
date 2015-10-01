/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          TestOpportunityWizards
    @abstract       Unit Test for all Collaborate Opportunity wizards
    @since          2011.0715
    @discussion     Test Class for Opportunity Wizards
*/

@isTest
private class TestOpporunityStageValidations {


    private static testMethod void stageValidationsUnitTest() {

        Id bbCollabRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'CPQ New Sales Opportunity Record Type'].Id;
        
        //Create TEST Account
        Account account = new Account(Name = 'Name', Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'Canada', CMS_Type__c = 'Bb');
        insert account;            
        System.assertNotEquals(account.Id, null);            

        //Create TEST Opportunity
        Opportunity opportunity = new Opportunity(Name = 'Apex Test', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(D) Power Sponsor Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today(), AccountID = account.Id);
        insert opportunity;
        System.assertNotEquals(opportunity.Id, null);

        
        ApexPages.StandardController sc = new ApexPages.StandardController(opportunity);
        /* commenting out 
        
        StageValidationsController svc = new StageValidationsController(sc);
        
        // Call the various Get/Set methods to test these
        // nothing to check for, just want to run the code 
        svc.setSetDebugModeFALSE(true);
        svc.setSetDebugModeTRUE(true);
        svc.getSetDebugModeTRUE();
        svc.getSetDebugModeFALSE();
        svc.getEditMode();
        svc.getOsvList();
        svc.getOsv();
        svc.getOpportunity();        
        svc.getContainsLicenseOrHosting();        
        System.assertEquals(True, svc.getCurrentStageHasValidations());
        
        // Edit
        PageReference svcEdit = svc.edit();
        System.assertEquals(null, svcEdit);
        System.assertEquals(true, svc.getEditMode());
        
        // Save without edits
        PageReference svcSave = svc.save();
        System.assertEquals(false, svc.getEditMode());
        System.assertNotEquals(null, svc.getOsv().Id); // No Opportunity_Stage_Validations__c created yet
        System.assertEquals(null, svcSave);
        
        
        //TEST the second constructor      
        Map<String, Schema.SObjectField> svcFieldMap = Schema.SObjectType.Opportunity_Stage_Validations__c.fields.getMap();
        Schema.DescribeFieldResult F = Schema.SObjectType.Opportunity_Stage_Validations__c.fields.D_Power_Sponsor_Qualification__c;
        List<Schema.PicklistEntry> P = F.getPicklistValues();       
        svc = new StageValidationsController(opportunity,svcFieldMap,P);
        
        // Edit all the stage Stage Validations for (D) Power Sponsor Qualification
        for (StageValidationsController.osvWrapper ow : svc.getOsvList()) {
            ow.setStageLabel(ow.getStageLabel());

            ow.setStageDescription('TEST');
            System.assertEquals('TEST', ow.getStageDescription());

            ow.setselected(true);
            System.assertEquals(true, ow.getselected());
        }
        
        // Save
        svcSave = svc.save();

        // Confirm that the results match the number of contacts added above
        System.assertEquals(false, svc.getEditMode());
        System.assertNotEquals(null, svc.getOsv().Id); // Opportunity_Stage_Validations__c is now created
        System.assertEquals(null, svcSave);

        //The second time we save, it should update instead of insert
        svcSave = svc.save();
        
        Opportunity opp = [SELECT awaiting_Stage_Validations_Verification__c FROM Opportunity WHERE Id = :opportunity.Id];
        System.assertEquals(True, opp.awaiting_Stage_Validations_Verification__c);
        
        commenting out */
    }
  
    private static testMethod void stageValidationsApprovalUnitTest() {

        Id bbCollabRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'CPQ New Sales Opportunity Record Type'].Id;
        
        /* commenting out 
        StageValidationsApprovalController osva = new StageValidationsApprovalController();
        
        
        // Call the various Get/Set methods to test these
        // nothing to check for, just want to run the code 
        osva.setSetDebugModeFALSE(true);
        osva.setSetDebugModeTRUE(true);
        osva.getSetDebugModeTRUE();
        osva.getSetDebugModeFALSE();
        osva.getCurrentUserName();
        osva.getStagePicklistValue();
        osva.setStagePicklistValue('(D) Power Sponsor Qualification');

        System.assertEquals(osva.nextStage('(E) Sponsor Qualification'), '(D) Power Sponsor Qualification');
        System.assertEquals(osva.nextStage('(D) Power Sponsor Qualification'), '(C) Decision Due');
        System.assertEquals(osva.nextStage('(C) Decision Due'), '(B) Pending Contract');
        System.assertEquals(osva.nextStage('(B) Pending Contract'), '(B) Pending Contract');

        //Create TEST Account
        Account account = new Account(Name = 'Name', Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'Canada', CMS_Type__c = 'Bb');
        insert account;            
        System.assertNotEquals(account.Id, null);            

        //Create TEST Opportunity
        Opportunity opportunity = new Opportunity(Name = 'Apex Test', RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(D) Power Sponsor Qualification', CloseDate = date.today(), CMS_Type__c = 'Bb', CMS_Version__c = '8.0', License_Start_Date__c = date.today() ,License_End_Date__c = date.today(), AccountID = account.Id, awaiting_Stage_Validations_Verification__c = true);
        insert opportunity;
        System.assertNotEquals(opportunity.Id, null);

        //Makes sure that the current user can apporve the created Opportunity
        Opportunity opp = [SELECT OwnerId FROM Opportunity WHERE Id = :opportunity.Id];
        User opportunityOwner = [SELECT Id FROM User WHERE isActive = True AND Id = :opp.OwnerId];
        opportunityOwner.Opportunity_Verifier__c = [SELECT Id FROM User WHERE isActive = True AND Id != :opportunityOwner.Id LIMIT 1].Id;
        update opportunityOwner;
        
        User opportunityVerifier = [SELECT Id FROM User WHERE isActive = True AND Id = :opportunityOwner.Opportunity_Verifier__c];
        opportunityVerifier.DelegatedApproverId = UserInfo.getUserId();
        update opportunityVerifier;
        
        //Add the Stage validations for (D) Power Sponsor Qualification
        Opportunity_Stage_Validations__c osc = new Opportunity_Stage_Validations__c(Opportunity__c = opp.Id);
        Schema.DescribeFieldResult F = Schema.SObjectType.Opportunity_Stage_Validations__c.fields.D_Power_Sponsor_Qualification__c; 
        List<Schema.PicklistEntry> P = F.getPicklistValues();
        String picklistValue = '';
        for(Schema.PicklistEntry pe:P)
        {
            if(picklistValue != '') picklistValue += ';';
            picklistValue += pe.getValue();
        }
        osc.D_Power_Sponsor_Qualification__c = picklistValue;
        insert osc;
        

        // do Search
        PageReference osvaDoSearch = osva.doSearch();
        System.assertEquals(null, osvaDoSearch);
        System.assert(osva.getOpportunityList().size()>0);
        


        // do approve with no records     
        List<StageValidationsApprovalController.stageValidationsWrapper> l = osva.getOpportunityList();
        osva.setOpportunityList(new List<StageValidationsApprovalController.stageValidationsWrapper>());
        PageReference osvaDoApprove = osva.doApprove();
        System.assertEquals(null, osvaDoApprove);


        // do approve with no records selected   
        osva.setOpportunityList(l);
        osvaDoApprove = osva.doApprove();
        System.assertEquals(null, osvaDoApprove);
        
        for(StageValidationsApprovalController.stageValidationsWrapper osvw:osva.getOpportunityList())
        {
            osvw.getOpportunityStageValidations();
            osvw.setselected(true);
            osvw.getselected();
        }
        
        // do approve with all records selected   
        osvaDoApprove = osva.doApprove();
        System.assertEquals(null, osvaDoApprove);
        
        commenting out */

    }
    
    private static testMethod void stageValidationsApprovalEmailUnitTest() {   
        /* commenting out 
        Test.startTest();   
        StageValidationsApprovalController.emailVerifier(UserInfo.getUserId());
        Test.stopTest();
        commenting out */
    }
}
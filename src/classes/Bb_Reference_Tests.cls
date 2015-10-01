@isTest
private class Bb_Reference_Tests 
{
    static testMethod void bb_reference_rules_Test() 
    {

        RecordType learn = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Bb_References__c' AND Name = 'Learn' limit 1];
        RecordType transact = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Bb_References__c' AND Name = 'Transact' limit 1];

        //Create test Accounts     
        Account acct1 = new Account (Name='Test Account 1', BillingStreet='a', BillingCity='a', BillingPostalCode='11111', BillingState='dc', BillingCountry='usa' );
        insert acct1;
        Account acct2 = new Account (Name='Test Account 2', BillingStreet='a', BillingCity='a', BillingPostalCode='11111', BillingState='dc', BillingCountry='usa' );
        insert acct2;
        
        //Creating a new Reference
        Bb_References__c ref = new Bb_References__c();  
        ref.Account__c = acct1.Id;
        ref.RecordTypeId = learn.Id;
        
        insert ref;
        System.assertNotEquals(ref.Id, null);
        
        
        //Updates the RecordTypeId for an existing Reference
        //Should throw an exception
        ref.Account__c = acct2.Id;
        ref.RecordTypeId = transact.Id;
        try
        {
            update ref;
        } 
        catch (DmlException e)
        {
            ref = [SELECT Id, Account__c, RecordTypeId FROM Bb_References__c WHERE Id = :ref.Id];
            System.assertEquals(ref.RecordTypeId, learn.Id);
        }

        //Creates to insert a duplicate Reference
        //Should throw an exception       
        Bb_References__c refDupe = new Bb_References__c();  
        refDupe.Account__c = acct1.Id;
        refDupe.RecordTypeId = learn.Id;
        try
        {
            insert refDupe;
        }
        catch ( Exception e )
        {
            System.assertEquals(refDupe.Id, null);
        }
    }


    static testMethod void Bb_Reference_Product_RelateToAccount_Test() 
    {

        RecordType learn = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Bb_References__c' AND Name = 'Learn' limit 1];

        //Create test Accounts     
        Account acct1 = new Account (Name='Test Account 1', BillingStreet='a', BillingCity='a', BillingPostalCode='11111', BillingState='dc', BillingCountry='usa' );
        insert acct1;
        
        //Creating a new Reference
        Bb_References__c ref = new Bb_References__c();  
        ref.Account__c = acct1.Id;
        ref.RecordTypeId = learn.Id;
        
        insert ref;
        System.assertNotEquals(ref.Id, null);
        
                
        //Creating a new Reference Product
        Bb_Reference_Products__c rp = new Bb_Reference_Products__c();
        rp.Bb_References__c = ref.Id;
        rp.Line_of_Business__c = 'Learn';
        rp.Product__c = 'Content';
        rp.Product_Ref_Status__c = 'Referenceable';
        insert rp;
        System.assertNotEquals(rp.Id, null);

        
        Bb_Reference_Products__c np = [SELECT AccountID__c FROM Bb_Reference_Products__c WHERE id = :rp.Id];
        System.assertEquals(np.AccountID__c, ref.Account__c);

        //Creating a duplicate Reference Product
        //Should throw an exception       
        Bb_Reference_Products__c rpDupe = rp.clone(false);
        try
        {
            insert rpDupe;
        }
        catch ( Exception e )
        {
            System.assertEquals(rpDupe.Id, null);
        }                
    }
    
    static testMethod void prepopulateTypeOfSchool_Test() 
    {

        RecordType learn = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Bb_References__c' AND Name = 'Learn' limit 1];

        //Create test Accounts     
        Account acct1 = new Account (Name='Test Account 1', BillingStreet='a', BillingCity='a', BillingPostalCode='11111', BillingState='dc', BillingCountry='usa' );
        insert acct1;
        
        //Fill the Type_of_School__c field on the Account
        acct1.Type_of_School__c = 'Private';
        update acct1; 
        
        //Creating a new Reference
        Bb_References__c ref = new Bb_References__c();  
        ref.Account__c = acct1.Id;
        ref.RecordTypeId = learn.Id;
        
        insert ref;
        System.assertNotEquals(ref.Id, null);

        ref = [SELECT Id, Account__c, RecordTypeId, Type_of_School__c FROM Bb_References__c WHERE Id = :ref.Id];
        System.assertEquals(ref.Type_of_School__c, acct1.Type_of_School__c);

        //Empty the Type_of_School__c field on the Account
        acct1.Type_of_School__c = null;
        update acct1;
        
        //Updates the Reference should fill the Type_of_School__c field on the Account
        update ref;
        acct1 = [SELECT Id, Type_of_School__c FROM Account WHERE Id = :acct1.Id];
        System.assertEquals(ref.Type_of_School__c, acct1.Type_of_School__c);
    }
    
    static testMethod void updateReferencesWhenTypeofSchoolIsUpdated_Test() 
    {

        RecordType learn = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Bb_References__c' AND Name = 'Learn' limit 1];

        //Create test Accounts     
        Account acct1 = new Account (Name='Test Account 1', BillingStreet='a', BillingCity='a', BillingPostalCode='11111', BillingState='dc', BillingCountry='usa' );
        insert acct1;
        
        //Fill the Type_of_School__c field on the Account
        acct1.Type_of_School__c = 'Private';
        update acct1; 
        
        //Creating a new Reference
        Bb_References__c ref = new Bb_References__c();  
        ref.Account__c = acct1.Id;
        ref.RecordTypeId = learn.Id;
        
        insert ref;
        System.assertNotEquals(ref.Id, null);

        ref = [SELECT Id, Account__c, RecordTypeId, Type_of_School__c FROM Bb_References__c WHERE Id = :ref.Id];
        System.assertEquals(ref.Type_of_School__c, acct1.Type_of_School__c);

        //Update the Type_of_School__c field on the Account
        acct1.Type_of_School__c = 'Consortium';
        update acct1;
        
        ref = [SELECT Id, Account__c, RecordTypeId, Type_of_School__c FROM Bb_References__c WHERE Id = :ref.Id];
        System.assertEquals(ref.Type_of_School__c, acct1.Type_of_School__c);

    }   
}
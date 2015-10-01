@isTest
public class BbTestUtility {
	
	public static Account testAccount;
	public static Contact testContact;
	public static Asset testAsset;
	public static Core_License__c testCoreLicense;
	public static Module__c testModule;
	public static Functional_Area__c testFunctionalArea;
	public static Category__c testCategory;
	
	/* Case Test Data Sev 1 + Sev 3 */
	public static Case testSev1Case;
	public static Case testSev3Case;
	
	/* Test Support Workflows */
	private static Support_Workflow__c testWorkflow;
	
	/* Case Note All Case Communication Workflows */
	private static Case_Note__c testCustomerNote;
	private static Case_Note__c testSolAcceptReply;
	private static Case_Note__c testSolDeclineReply;
	private static Case_Note__c testNoteWithoutEmail;
	private static Case_Note__c testSuggestSolution;
	private static Case_Note__c testNoteWithEmail;
	
	/* Call Data in Test Classes Using the Following
	 *
	 * Pattern: BbTestUtility.create'NameofSObjectVariable'();
	 *
	 */
    
    public static Account createTestAccount(){
    	if(testAccount == null){
    		Account test_account = new Account(
	        Name = 'TestClass University',
	        BillingCity = 'Vienna',
	        BillingCountry = 'US',
	        BillingPostalCode = '22066',
	        BillingState = 'VA',
	        BillingStreet = '123 Miller Road',
			Learn_Queue__c = 'Learn Primary Group');
	        insert test_account;
	        return test_account;
    	} else {
    		return testAccount;
    	}
    }
    
    public static Contact createTestContact(){
    	if(testContact == null){
    		Contact test_contact = new Contact(
    		FirstName = 'SRVTEST_FIRSTNAME',
    		LastName = 'SRVTEST_LASTNAME',
    		Email = 'test@email.com',
    		Account = testAccount);
    		insert test_contact;
    		return test_contact;
    	} else {
    		return testContact;
    	}
    }
	
	public static Core_License__c createTestCoreLicense(){
		if(testCoreLicense == null){
			Core_License__c test_corelicense = new Core_License__c(
			Name = 'Learn');
			insert test_corelicense;
			return test_corelicense;	
		} else {
			return testCoreLicense;
		}
	}
	
	public static Module__c createTestModule(){
		if(testModule == null){
			Core_License__c corelic = new Core_License__c(Name='CoreTest');
			insert corelic;
			Module__c test_module = new Module__c(
			Name = 'TestModule',
			Core_Licence__c = corelic.id
			);
			insert test_module;
			return test_module;	
		} else {
			return testModule;
		}
	}
	
	public static Asset createTestAsset(){
		if(testAsset == null){
			Core_License__c corelic = new Core_License__c(Name='CoreTest');
			insert corelic;
			Asset test_asset = new Asset(
			Name = 'TestAsset',
			Core_License__c = corelic.id,
			Status = 'Installed',
			AccountId = testAccount.id);
			insert test_asset;
			return test_asset;
		} else {
			return testAsset;
		}
	}
	
	public static Case createTestSev1Case(){
    	if(testSev1Case == null){
    		
    		Core_License__c test_corelicense = new Core_License__c(
			Name = 'Learn');
			insert test_corelicense;
    		
    		Module__c test_module = new Module__c(
			Name = 'TestModule',
			Core_Licence__c = test_corelicense.id
			);
    		
    		Account test_account = new Account(
	        Name = 'TestClass University',
	        BillingCity = 'Vienna',
	        BillingCountry = 'US',
	        BillingPostalCode = '22066',
	        BillingState = 'VA',
	        BillingStreet = '123 Miller Road',
			Learn_Queue__c = 'Learn Primary Group');
	        insert test_account;
	        
	        Contact test_contact = new Contact(
    		FirstName = 'SRVTEST_FIRSTNAME',
    		LastName = 'SRVTEST_LASTNAME',
    		Email = 'test@email.com',
    		Account = testAccount);
    		insert test_contact;
	        
	        Asset test_asset = new Asset(
			Name = 'TestAsset',
			Core_License__c = test_corelicense.id,
			Status = 'Installed',
			AccountId = test_account.id);
			insert test_asset;
	        
    		Case test_sev1case = new Case(
    		ContactId = test_contact.id,
    		AccountId = test_account.id,
    		Subject = 'subject',
    		Description = 'description',
    		Steps_to_Replicate__c = 'steps to replicate',
    		Core_License__c = test_corelicense.id,
    		Module__c = test_module.id,
    		Status = 'New',
    		Case_Severity__c = '1',
    		Origin = 'Web');
    		insert test_sev1case;
    		return test_sev1case;
    	} else {
    		return testSev1Case;
    	}
    }
    
    public static Case createTestSev3Case(){
    	if(testSev3Case == null){
    		Case test_sev3case = new Case(
    		ContactId = testContact.id,
    		AccountId = testAccount.id,
    		Subject = 'subject',
    		Description = 'description',
    		Steps_to_Replicate__c = 'steps to replicate',
    		Core_License__c = testCoreLicense.id,
    		Status = 'New',
    		Case_Severity__c = '3',
    		Origin = 'Web');
    		insert test_sev3case;
    		return test_sev3case;
    	} else {
    		return testSev3Case;
    	}
    }
	
    public static Support_Workflow__c createTestWorkflow() {
        if(testWorkflow == null) {
			Support_Workflow__c test_workflow = new Support_Workflow__c(
	        Name = 'Email Test',
	        Publish_to_BTBB__c = false,
	        Send_Email_to_Case_Owner__c = false,
	        Send_Email_to_Customer__c = true,
	        Active__c = true,
	        Active_Open_Status__c = false,
	        Active_Closed_Status__c = true,
	        Email_Introduction__c = 'intro',
	        Email_Signature__c = 'signature',
	        Email_Subject__c = 'email subject',
	        Case_Status_Update__c = 'Pending User',
	        Portal_Status_Update__c = 'Pending User',
	        Reply_Status_Update__c = 'Needs Attention',
	        Reply_Portal_Status_Update__c = 'Work In Progress',
	        Support_Response_Event__c = true);        
	        insert test_workflow;
	      	return test_workflow;
			} else {
	      	return testWorkflow;
		}
	}
	
	/*
		Core_License__c cl = new Core_License__c();
        cl.Name = 'Learn';
        insert cl;
        
        Module__c mod = new Module__c();
        mod.name = 'Learn Module';
        mod.Core_Licence__c = cl.id;
        insert mod;
        
        Functional_Area__c fa = new Functional_Area__c();
        fa.Name = 'Learn Functional Area';
        fa.Module__c = mod.id;
        insert fa;
        
        Category__c cat = new Category__c();
        cat.name = 'Learn Cat';
        cat.Functional_Area__c = fa.id;
        insert cat;
        
        Asset a = new Asset();
        a.Core_License__c = cl.id;
        a.Name = 'Bb Support Test Asset 1';
        a.Status = 'Installed';
        a.AccountId = ac.id;
        insert a;

        Case c  = new Case();
        c.AccountID = ac.Id;
        c.ContactID = ct.Id;
        c.AssetId = a.Id;
        c.Case_Severity__c = '1';
        c.Subject = 'Test Case Subject';
        c.Description = 'Test Case Description';
        c.Steps_to_Replicate__c = 'Test S2R';
        c.Module__c = mod.id;
        c.Functional_Area__c = fa.id;
        c.Category__c = cat.id;
        c.Status = 'New';
        c.Core_License__c = cl.id;
        insert c;
	*/
}
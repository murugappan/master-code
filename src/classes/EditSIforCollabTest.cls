@isTest
public class EditSIforCollabTest {
	
	public static testMethod void EditSIforCollabTest() {
		Account ac = TestMethodUtility.createAccount();
        ac.Name = 'BC';
        ac.BillingCity = 'BC';
        ac.BillingCountry = 'USA';
        ac.BillingPostalCode = 'BC';
        ac.BillingState = 'BC';
        ac.BillingStreet = 'BC';

        insert ac;

        Contact ct=TestMethodUtility.createContact(ac);
        ct.LastName='AB';
        insert ct;
        
        Core_License__c cr =TestMethodUtility.createCoreLicense(); 
        insert cr;
        
        Module__c md = TestMethodUtility.createModule(cr) ;
        insert md;
        
        Functional_Area__c fa = TestMethodUtility.createFunctionalArea(md);
        insert fa;
        
        Category__c ca = TestMethodUtility.createCategory(fa);
        insert ca;
        
        Asset asset=TestMethodUtility.createAsset(ac,cr);
        asset.Name = 'Test Asset 111';
	    asset.Installed_Product_ID__c = '123';
	    asset.Status = 'Installed'; 
	    asset.version__c = '9.1';
	    asset.Psft_Product_Id__c = 'AS-LS';
	    asset.Version_Build__c = '9.1.X';
        insert asset;
        
        Case c  =TestMethodUtility.createCase1(ac,asset);
        c.ContactID = ct.ID;
        insert c;
        
        learnJIRA__c lj =TestMethodUtility.createSupportIncident(c);
        insert lj;
		
		//ApexPages.currentPage().getParameters().put('id', lj.Id);
		ApexPages.StandardController controller = new ApexPages.StandardController(lj);  
        EditSIforCollab esi = new EditSIforCollab(controller);
        esi.sourcebuild = asset.Version_Build__c;
        esi.module = md.id;
        esi.functionalarea = fa.Id;
        esi.category = ca.Id;
        
        List<SelectOption> sblist = esi.sblist;
        List<SelectOption> modules = esi.modules;
        List<SelectOption> functionalareas = esi.functionalareas;
        List<SelectOption> categories = esi.categories;
        
        esi.s();
	}
}
@isTest(SeeAllData=True)
public class KiarticlecreateTest{

    static testMethod void myUnitTest() {
    
    
        
        Account a = TestMethodUtility.createAccount();
        insert a;
        
        Core_License__c cl = TestMethodUtility.createCoreLicense();
        insert cl;
        
        Contact con = TestMethodUtility.createContact(a);
        insert con;
        
        Module__c m = TestMethodUtility.createModule(cl);
        insert m;
        
        Case c = TestMethodUtility.createCase(con, cl, a, m);
        insert c;
        
        
        
        
        test.startTest();
        
        
            learnJIRA__c lj = TestMethodUtility.createSupportIncident(c);
            insert lj;
            Case c2 = TestMethodUtility.createCase(con, cl, a, m);
            c2.LearnJIRA_SI__c = lj.Id;
            insert c2;
            update lj;
        
            ApexPages.currentPage().getParameters().put('id',lj.id);
            kiarticlecreate sendtoC = new kiarticlecreate(new ApexPages.StandardController(lj));
            sendtoC.autorun();
            
        
        
        
       
        
        
        
        test.stopTest();

    
    
    }
}
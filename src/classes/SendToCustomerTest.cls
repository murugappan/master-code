@isTest(SeeAllData=True)
public class SendToCustomerTest{

    static testMethod void myUnitTest() {
    
    
        KimbleOne__BusinessUnit__c BU1 = [Select ID From KimbleOne__BusinessUnit__c Where KimbleOne__IsOperatingEntity__c = TRUE LIMIT 1];
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.KimbleOne__IsCustomer__c = true;
        
        insert acc;
        
        
        Contact con = new Contact();
        con.LastName = 'Test Contact';
        con.FirstName = 'Contact Test';
        con.Email = 'test@yahoo.com';
        con.AccountId = acc.Id;
        con.PS_Person_Id__c='9438434';
        insert con;
        
        Account acc1 = new Account();
        acc1.Name = 'Test Account';
        acc1.KimbleOne__IsCustomer__c = true;
        acc1.KimbleOne__InvoicingCurrencyIsoCode__c = 'USD';
        acc1.KimbleOne__BusinessUnit__c = BU1.Id;
        insert acc1;  
    
        
        Opportunity opp = new Opportunity();        
        opp.Name = 'Test Sales Opp';
        opp.AccountId = acc.Id;
        opp.KimbleCRMInt__BusinessUnit__c = BU1.Id;
        opp.StageName = 'Initial Stage';
        opp.Probability = 30;
        opp.CloseDate = date.today();
        opp.End_Date__c = date.today();
        insert opp;
        
        Contact_Role__c  conRole=TestMethodUtility.createContactRole(acc);
        conRole.contact__c=con.id; 
        conRole.Role__c ='LEARN - Academic Developer';
        Insert conRole;
        
        
        List<contact> conList = [select id,name,email,LastName from contact where id =:con.Id];


        ApexPages.currentPage().getParameters().put('id',opp.id);
        
        
        
        test.startTest();
        
        
        ApexPages.currentPage().getParameters().put('id',opp.id);
        SendToCustomer sendtoC = new SendToCustomer(new ApexPages.StandardController(opp));
        sendtoC.itemId= con.id;
        sendtoC.sendEmailToContact();
        sendtoC.sendEmail();
        
        
       
        
        
        
        test.stopTest();

    
    
    }
}
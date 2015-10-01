public class Clone_Case{

    public Clone_Case(ApexPages.StandardController controller) {
    }

    public PageReference autoRun(){
        ID caseid = ApexPages.Currentpage().getParameters().get('id');
        if(caseid == null)
            return null;
       
        Schema.DescribeSObjectResult r = Case.sObjectType.getDescribe(); 
        system.debug('Fields---'+r.fields.getMap());
      
        Map<String,Schema.SObjectField> M =new Map<string,Schema.SObjectField>( r.fields.getMap()); 
      
        String SOQL = 'Select '; 
        for(String fieldName : M.keySet()){
            if(!M.get(fieldname).getdescribe().isAutoNumber() && !M.get(fieldname).getdescribe().isCalculated())
            SOQL += fieldName + ','; 
        } 

        SOQL = SOQL.substring(0,SOQL.length()-1); 
        SOQL += ' From Case where id=\''+ caseid +'\' LIMIT 1' ; 
system.debug('SOQL---'+SOQL);
     //   Case C = Database.query(SOQL);
       Case C = [Select id,recordtypeid,Business_Unit__c,Accountid,Contactid,Psft_Product_Id__c,Case_Severity__c,Priority,Ownerid,Primary_Group_Name__c,Initial_Case_Owner__c,BusinessHoursid,Type,Core_License__c,Version_on_Case__c,
                 Source_Build_on_Case__c,Subject,Description,Steps_to_Replicate__c,Module__c,Functional_Area__c,Category__c,Assetid,Entitlementid,MR_Case_Type__c,Client_OS__c,Browser__c,URL_Access__c from case where id=:caseid];

        Case C1 = (Case)C;
        Case newcase = C1.clone(false,true,false,false);
        newcase.Psft_Case_Id__c = '';
        //newcase.ClosedDate = null;
        insert newcase; 
        PageReference pageRef = new PageReference('/' + newcase.Id );
        pageRef.setRedirect(true);
        return pageRef;

    }
    
 public PageReference Cancel(){
 PageReference pageRef = new PageReference('/' + ApexPages.Currentpage().getParameters().get('id'));
        pageRef.setRedirect(true);
        return pageRef;
 }
    static testmethod void Clone_Case_test(){
    
       Account ac = new Account();
    ac.Name = 'Testing1 Account';
    ac.BillingStreet = 'Testing1 Street';
    ac.BillingCity = 'Testing1 City';
    ac.BillingState = 'Testing1 State';
    ac.BillingCountry = 'Testing1 country';        //for Angel account level queue
    ac.BillingPostalCode = 'Testing Code';
    ac.Angel_Queue__c = 'ANGEL - Midwest Engagement Team';
    
    insert ac;
    
    Contact c1 = new Contact();
    c1.FirstName = 'Test1';
    c1.LastName = 'Contact1';
    c1.Email = 'test@test1.com';
    c1.AccountID = ac.ID;
    
    insert c1;
    
    Core_License__c cr = new  Core_License__c();
    cr.Name = 'ANGEL';
    insert cr;    
    
    Asset aset = new Asset();
    aset.Name = 'Test Asset 111';
    aset.Core_License__c = cr.ID;
    aset.AccountID = ac.ID;
    aset.Installed_Product_ID__c = '123';
    aset.Status = 'Installed'; 
    aset.version__c = '9.1';
    aset.Psft_Product_Id__c = 'AS-LS';
    aset.Version_Build__c = '9.1.X';
    insert aset;
        
    Case cassoftsol = new Case();        //for angel software solutions
    cassoftsol.AccountID = ac.ID;
    cassoftsol.ContactID = c1.ID;
    cassoftsol.Case_Severity__c = '1';
    cassoftsol.Subject = 'test';
    cassoftsol.Description = 'test';
    cassoftsol.assetID = aset.ID;
    insert cassoftsol;
    
    ApexPages.CurrentPage().getParameters().put('id',cassoftsol.id);
    ApexPages.StandardController controller = new ApexPages.StandardController(cassoftsol);
    Clone_Case cc = new Clone_Case(controller);
    cc.autoRun();
    cc.Cancel();
    ApexPages.CurrentPage().getParameters().put('id',null);
    cc.autoRun();
    }
}
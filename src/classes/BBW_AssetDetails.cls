public class BBW_AssetDetails {
    private ApexPages.StandardController controller {get; set;}
    public string assetAppSerOS{get;set;}
    public string assetDBSerOS{get;set;}
    public boolean moodleroom{get;set;}
    public string assetDb{get;set;}
    public string psftProdId{get;set;}
    public string assetJDKVersion{get;set;}
    public string assetFrntBkAccess{get;set;}
    public string assetExtName{get;set;}
    public string assetInsProdId{get;set;}
    public string assetVersion{get;set;}
    public string AssetId{get;set;}
    public string assetfrontback{get;set;}
    public string assetname{get;set;}
    public string assetsoftwareURL{get;set;}
    public Asset ast{get; set;}
    public string local{get;set;}
    private Case cas;
  public BBW_AssetDetails(ApexPages.StandardController controller) {
  this.controller = controller;
  this.cas = (Case)controller.getRecord();
  ID CaseID = this.cas.id;
  Case cs=[Select c.id,c.Asset.name,c.Asset.Psft_Product_Id__c,c.RecordType.Name, c.Asset.Front_Back_Access__c, c.Asset.JDK_Version__c,Asset.Version__c,c.Asset.Database__c, c.Asset.Database_Server_OS__c, c.Asset.Application_Server_OS__c, c.Asset.Id,c.Asset.External_Asset_Name__c,c.Asset.Installed_Product_ID__c,c.Asset.Software_URL__c From Case c WHERE c.id=:Caseid];
   local = cs.RecordType.Name;
   if(local =='Moodlerooms'){
   moodleroom = true;
   }
   if(cs.Asset.id!=null){     
    string str=cs.Asset.id;     
    ast = [select Front_Back_Access__c from Asset Where id =: str];
    string astfrontback = ast.Front_Back_Access__c;  
    assetfrontback=astfrontback;
    assetAppSerOS=cs.Asset.Application_Server_OS__c;
    assetDBSerOS=cs.Asset.Database_Server_OS__c;
    assetname=cs.Asset.name;
    assetDb=cs.Asset.Database__c;
    assetJDKVersion=cs.Asset.JDK_Version__c;
    assetFrntBkAccess=cs.Asset.Front_Back_Access__c;
    assetExtName=cs.Asset.External_Asset_Name__c;
    assetInsProdId=cs.Asset.Installed_Product_ID__c;
    assetVersion=cs.Asset.Version__c;
    AssetId=cs.Asset.Id;
    psftProdId=cs.Asset.Psft_Product_Id__c;
    assetsoftwareURL=cs.Asset.Software_URL__c;
    }
    }
    static testmethod void BBW_AssetDetailtest(){
    
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
    
     Asset aset = new Asset();
    aset.Name = 'Test Asset 111';
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
    cassoftsol.assetID  = aset.ID;
    insert cassoftsol;
    
    ApexPages.currentPage().getParameters().put('id',cassoftsol.ID);
    ApexPages.StandardController controller = new ApexPages.StandardController(cassoftsol);
    BBW_AssetDetails  ca = new BBW_AssetDetails(controller);
    }
}
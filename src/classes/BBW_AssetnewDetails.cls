public class BBW_AssetnewDetails {
public string a{get;set;}
public string b{get;set;}
public string c{get;set;}

public string d{get;set;}

public string e{get;set;}
public string f{get;set;}
public string g{get;set;}
public string h{get;set;}
public string AssetId{get;set;}
public string AssetName{get;set;}



    public BBW_AssetnewDetails(ApexPages.StandardController controller) {
   // PageReference pageRef = ApexPages.CurrentPage.getUrl();
  //string pageRef = PageReference.getURL();
  Id Caseid = System.currentPageReference().getParameters().get('id');
  Case cs=[Select c.id,c.Asset.Name,c.Asset.Front_Back_Access__c, c.Asset.JDK_Version__c,Asset.Version__c,c.Asset.Database__c, c.Asset.Database_Server_OS__c, c.Asset.Application_Server_OS__c, c.Asset.Id,c.Asset.External_Asset_Name__c,c.Asset.Installed_Product_ID__c From Case c where c.id=:caseid];
    if(cs.Asset.id!=null)
    {
    string str=cs.Asset.id;
    
    system.debug('-------------' + str);
    List<Asset__c> custAsset= new List<Asset__c>([select id,account__c,Asset_Name__c,Product_ID__c,Name,Application_Server_OS__c,Database__c,
Database_Server_OS__c,External_Asset_Name__c,Front_Back_Access__c,Managed_Hosting__c,Installed_Product_ID__c,
JDK_Version__c,Network__c,Nickname__c,Platform__c,Software_URL__c,Version_Build__c from Asset__c where Product_ID__c=:str]);
      system.debug('asasa');
     if(custAsset != null && custAsset.size() > 0){ 
         a=custAsset[0].Application_Server_OS__c;
         b=custAsset[0].Database_Server_OS__c;
         c=custAsset[0].Database__c;
         d=custAsset[0].JDK_Version__c;
         e=custAsset[0].Front_Back_Access__c;
        f=custAsset[0].External_Asset_Name__c;
        g=custAsset[0].Installed_Product_ID__c;
        //h=custAsset.Version__c;
        AssetId=custAsset[0].Id;
        AssetName=custAsset[0].Asset_Name__c;
        //system.debug('url--'+pageRef);
        }
      }  
    }
    
    static testmethod void BBW_AssetNewDetailtest(){
    
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
    
    Asset__c as1 = new Asset__c();
    as1.Product_ID__c = aset.ID;
    insert as1;
    
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
    BBW_AssetnewDetails ca = new BBW_AssetnewDetails(controller);
    }

}
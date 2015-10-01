/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          CollaborateAssetUpdater
    @abstract       updates Assets with Wimba Classroom and Wimba Voice information, such as produt version, or server location.
    @since          2011.0715
    @discussion     Class to update Assets
*/
global class CollaborateAssetUpdater {

/* commenting out 

    //Credentials for Collaborate XML page
    private static final String username = 'salesforce';
    private static final String password = '3taA8MGbE1';
    private static final String url = 'https://sfad.wimba.com/assets.xml';

    private static Map<String,SysOpsAsset> sysOpsAssets;
    
    @future(callout=true)
    public static void main(Id[] ids)
    {   
        Http h = new Http();
        HttpRequest req = buildWebServiceRequest();

        //Second, invoke web service call 
        HttpResponse res = invokeWebService(h, req);

        //Third, handling the response
        sysOpsAssets = parseResponseDom(res.getBodyDocument());
        
        //Last, update Assets
        updateAssets(ids);
    }


    // ------------------------------------------------
    // DML Methods
    // ------------------------------------------------          
    private static void updateAssets(Id[] ids)
    {
        Asset[] assets = [SELECT Id, Instance_URL__c, Hosting_Server__c, Version__c, Product2.Product_Category__c FROM Asset WHERE Psft_Product_Id__c = null AND Id in :ids];  

        //Pattern to retrieve DLS Name out of Server URL
        Pattern emailPattern = Pattern.compile('(^https?://)|(\\..*)');

        for(Asset asset:assets)
        {
            Matcher matcher = emailPattern.matcher(asset.Instance_URL__c);
            String dlsNameKey = asset.Product2.Product_Category__c == 'Wimba Classroom'? 'WC':'WV';
            dlsNameKey += matcher.replaceAll('');
            
            SysOpsAsset tmp = sysOpsAssets.get(dlsNameKey);
            if(tmp != null)
            {
                asset.Version__c = tmp.version;
                asset.Hosting_Server__c = tmp.server;
                asset.Virtual_IP__c = tmp.instanceIP;               
            }
        }
        update assets;
   }

  
    // ------------------------------------------------
    // WebService Methods
    // ------------------------------------------------          

    //Build HTTP Request object
    private static HttpRequest buildWebServiceRequest(){

        HttpRequest req = new HttpRequest();
         
        req.setEndpoint(url);
        req.setMethod('GET');
        
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        return req;
    }

    //Invoke Web Service
    private static HttpResponse invokeWebService(Http h, HttpRequest req){
         
         HttpResponse res = h.send(req);
         return res;
    }
    
    
    // ------------------------------------------------
    // XML Dom Parsing Methods
    // ------------------------------------------------          
    private static Map<String,SysOpsAsset> parseResponseDom(Dom.Document doc){
        Map<String,SysOpsAsset> tmp = new Map<String,SysOpsAsset>();
        
        //Retrieve the root element for this document.  
        Dom.XMLNode root = doc.getRootElement();
        for(Dom.XMLNode datacenter : root.getChildElements())
        {
            String dataCenterName = datacenter.getAttribute('dccode',null);
            for(Dom.XMLNode host:datacenter.getChildElements())
            {
                String hostname = host.getAttribute('hostname',null);
                for(Dom.XMLNode product:host.getChildElements())
                {
                    String productName = product.getAttribute('type',null);
                    for(Dom.XMLNode instance:product.getChildElements())
                    {
                        SysOpsAsset sysOpsAsset = new SysOpsAsset();
                        sysOpsAsset.dlsname = instance.getAttribute('dlsname',null);   
                        sysOpsAsset.server = hostname;
                        sysOpsAsset.version = instance.getChildElement('version', null).getText();
                        sysOpsAsset.instanceIP = instance.getChildElement('ip', null).getText();
                        tmp.put(productName + sysOpsAsset.dlsname,sysOpsAsset);
                    }
                }
            }
        }
        return tmp;       
    } 
   
    // Create a class SysOpsAsset for processing  
    public class SysOpsAsset {
        String dlsname;
        String server;
        String version;
        String instanceIP;
   }

   
    // ------------------------------------------------
    // Test Method
    // ------------------------------------------------        
    static testMethod void testSysOpsAssetsParser() {
        
        //Create TEST Account
        Account account = new Account(Name = 'Name', Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'Canada', CMS_Type__c = 'Bb');
        insert account;            
        System.assertNotEquals(account.Id, null);            
        
        Asset asset = new Asset(AccountId = account.Id, Name = 'Test Asset', CMS_Type__c = 'Bb', CMS_Version__c = '8.0', Version__c = '1.5', Type__c = 'ASP', Instance_URL__c = 'http://test.wimba.com/test' , Status = 'Installed and Verified');
        asset.Product2Id = [Select Id from Product2 where Product_Category__c = 'Wimba Classroom' AND isActive = true limit 1 ].Id;
        insert asset;

        String str = '<?xml version="1.0" encoding="UTF-8"?><dc:datacenters xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"xsi:schemaLocation="http://www.wimba.com/2010/datacenter datacenters.xsd"xmlns:dc="http://www.wimba.com/2010/datacenter"><datacenter dccode="dataCenter"><host hostname="hostname"><!--Although most of our hosts are purpose build (i.e. WV host, WC host,etc), making product an element under host allows flexibility forthat in the future--><product type="WC"><instance dlsname="test"><version>6.0.1</version><size>2648</size><expires>2010-10-26</expires><ip>1.2.3.4</ip></instance></product></host></datacenter></dc:datacenters>';

        Dom.Document doc = new Dom.Document();
        doc.load(str);
        
        //Decompose main() into steps that do not require webservices callouts
        HttpRequest req = CollaborateAssetUpdater.buildWebServiceRequest();
        CollaborateAssetUpdater.sysOpsAssets = CollaborateAssetUpdater.parseResponseDom(doc);
        CollaborateAssetUpdater.updateAssets(new Id[]{asset.Id});

        Test.startTest();
            CollaborateAssetUpdater.main(new Id[]{asset.Id});
        Test.stopTest();
    }
    commenting out */
}
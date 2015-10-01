/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(SeeAllData=true)
private class SupportIncidentChangeDetailsControlTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
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
        
        Asset aset=TestMethodUtility.createAsset(ac,cr);
        insert aset;
        
        Case c  =TestMethodUtility.createCase1(ac,aset);
        c.ContactID = ct.ID;
        insert c;
        
        id LNrecordtypeid=Schema.SObjectType.learnJIRA__c.getRecordTypeInfosByName().get('Learn').getRecordTypeId();
        learnJIRA__c lj =TestMethodUtility.createSupportIncident(c);
        lj.recordtypeid=LNrecordtypeid;
        insert lj;
        
        
        Bb_Prod_Version__c pv = new Bb_Prod_Version__c(name='LMS-ARCHIVE_6.3',CurrencyIsoCode='USD');
        insert pv;
        
        ApexPages.CurrentPage().getParameters().Put('Id',lj.Id);
        
        ApexPages.StandardController stdcontroller = new ApexPages.StandardController(lj);
        
        SupportIncidentChangeDetailsController extension = new SupportIncidentChangeDetailsController(stdcontroller); 
        extension.s();
     }
     static testMethod void myUnitTest1() {
     
        Account a = TestMethodUtility.createAccount();
        insert a;
        
        Contact c = TestMethodUtility.createContact(a);
        insert c;
        
        Core_License__c cr = new  Core_License__c();
        cr.Name = 'Moodlerooms';
        insert cr;
           
        Asset aset=TestMethodUtility.createAsset(a,cr);
        insert aset;
         
        Case ca  =TestMethodUtility.createCase1(a,aset);
        ca.ContactID = ca.ID;
        insert ca;
        
        id MRrecordtypeid=Schema.SObjectType.learnJIRA__c.getRecordTypeInfosByName().get('Moodlerooms').getRecordTypeId();
        learnJIRA__c lj =TestMethodUtility.createSupportIncident(ca);
        lj.recordtypeid=MRrecordtypeid;
        insert lj;
   
        ApexPages.CurrentPage().getParameters().Put('Id',lj.Id);
        ApexPages.StandardController stdcontroller = new ApexPages.StandardController(lj);
        
        SupportIncidentChangeDetailsController ext = new SupportIncidentChangeDetailsController(stdcontroller); 
        
        ext.statusvalue = 'Closed';
        ext.resolutionvalue = '';
        ext.s();
       
      }
      static testMethod void myUnitTest2() {
     
        Account a = TestMethodUtility.createAccount();
        insert a;
        
        Contact c = TestMethodUtility.createContact(a);
        insert c;
        
        Core_License__c cr = new  Core_License__c();
        cr.Name = 'Moodlerooms';
        insert cr;
        
       // Module__c  m = TestMethodUtility.createModule(cr);
       // insert m;
       
        Module__c m = new Module__c (Name = 'Test Module',Core_Licence__c = cr.Id);
        insert m;   
           
        Asset aset = TestMethodUtility.createAsset(a,cr);
        insert aset;
        
        Version__c v = new Version__c( Version__c = 'test', Psft_Product_Id__c = '123456777');
        insert v;
        
        MoodleroomsBuild__c  MB =new MoodleroomsBuild__c ( Name = 'test');
        insert MB;
        
        
         
        Case ca = new Case( AccountId = a.Id,ContactId = c.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate', AssetId = aset.Id, Core_License__c = cr.Id,Module__c = m.Id,Status = 'New',Case_Severity__c = '1');
        insert ca;
        
        id MRrecordtypeid=Schema.SObjectType.learnJIRA__c.getRecordTypeInfosByName().get('Moodlerooms').getRecordTypeId();
        learnJIRA__c lj =TestMethodUtility.createSupportIncident(ca);
        lj.recordtypeid=MRrecordtypeid;
        insert lj;
        
        
   
        ApexPages.CurrentPage().getParameters().Put('Id',lj.Id);
        ApexPages.StandardController stdcontroller = new ApexPages.StandardController(lj);
       
        SupportIncidentChangeDetailsController ext = new SupportIncidentChangeDetailsController(stdcontroller); 
         
        
        List<SelectOption> lo = ext.moduleList;
        List<SelectOption> lo1 = ext.targetBuildList;
        List<SelectOption> lo2 = ext.fixedBuildList;
        List<SelectOption> brk = ext.brokenBuildList;
        ext.s();
      }

      static testMethod void AnalyticsSI()
      {

        Account acc = TestMethodUtility.createAccount();
        insert acc;
        
        Contact con = TestMethodUtility.createContact(acc);
        insert con;
        
        Core_License__c cr = new  Core_License__c();
        cr.Name = 'Analytics';
        insert cr;

        Module__c m = new Module__c (Name = 'Test Module',Core_Licence__c = cr.Id);
        insert m; 

        Product2 prod=[select id,GKEY_Product_Group__c  from product2 where GKEY_Product_Group__c != null and isactive=true limit 1] ;   
           
        Asset aset = TestMethodUtility.createAsset(acc,cr);
        aset.Product2Id = prod.Id;
        aset.Version__c = '9.2';
        aset.Version_Build__c = '9.1.110';
        insert aset;
        
        Version__c v = new Version__c( Version__c = 'test', Psft_Product_Id__c = '123456777');
        insert v;

        Case ca = new Case( AccountId = acc.Id,ContactId = con.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate', AssetId = aset.Id, Core_License__c = cr.Id,Module__c = m.Id,Status = 'New',Case_Severity__c = '1');
        insert ca;
        
        id ANrecordtypeid=Schema.SObjectType.learnJIRA__c.getRecordTypeInfosByName().get('Analytics').getRecordTypeId();
        
        learnJIRA__c Si =TestMethodUtility.createSupportIncident(ca);
        si.recordtypeid=ANrecordtypeid;
        insert Si;
        
        ApexPages.CurrentPage().getParameters().Put('Id',Si.Id);
        ApexPages.StandardController stdcontroller = new ApexPages.StandardController(Si);
        SupportIncidentChangeDetailsController ctr = new SupportIncidentChangeDetailsController(stdcontroller); 

        ctr.statusvalue = 'Closed';
        ctr.resolutionvalue = '';
        ctr.version = '9.2';
        ctr.sourcebuild = '9.1.110';

        version_build_tree__c vr1=new version_build_tree__c(Version__c='9.2',Version_Build__c='9.1.110',Active_Flag__c=true,GKEY_Product_Group__c=prod.GKEY_Product_Group__c);
        insert vr1;
        version_build_tree__c vr2=new version_build_tree__c(Version__c='9.2',Version_Build__c='9.1.220',Active_Flag__c=true,GKEY_Product_Group__c=prod.GKEY_Product_Group__c);
        insert vr2;
        version_build_tree__c vr3=new version_build_tree__c(Version__c='9.2',Version_Build__c='10.2.220',Active_Flag__c=true,GKEY_Product_Group__c=prod.GKEY_Product_Group__c);
        insert vr3;
        
        List<SelectOption> fa  = ctr.functionalareas;
        List<SelectOption> ver = ctr.versions;
        List<SelectOption> sb  = ctr.sblist;
        ctr.s();
        ctr.clearsb();

      }
   
}
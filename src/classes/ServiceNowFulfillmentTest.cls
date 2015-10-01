@isTest
public without sharing class ServiceNowFulfillmentTest{
  public static TestMethod void TestMethod1()
    {
     Account ac=TestMethodUtility.createAccount();
     ac.ownerid=userinfo.getuserid();
        ac.PS_Company_ID__c='78907';
        insert ac;
        
        
       system.debug('account id'+ac.id);
     Core_License__c cl = TestMethodUtility.createCoreLicense();
     
     insert cl;
       system.debug('corelicense id'+cl .id);
     
     Asset a=TestMethodUtility.createAsset(ac,cl);
     a.Fulfillment_Requested__c=true;
     a.Fulfillment_Action_Counter__c=null;
     insert a;
     system.debug('asset id'+a.id);
     
     Asset a1=TestMethodUtility.createAsset(ac,cl);
     insert a1;
     
     Asset a2=TestMethodUtility.createAsset(ac,cl);
     insert a2;
    
    
     
     Profile pf1= [select id from Profile where name = 'SRV - System Administrator'];
     User u1 = TestMethodUtility.createUser(pf1);
      
    
     system.runas(u1)
     {
     Asset currentAsset = [select id,Asset_ID_18__c,name,Status,CPQ_Current_Opportunity_ID__c,accountid,Fulfillment_Requested__c,SN_Fulfillment_Complete__c,FulFillment_Prior_Action__c,Fulfillment_Action__c,Top_Level_Asset__c,Prior_Top_Level_Asset__c,Fulfillment_Action_Counter__c from Asset where id=:a.id];
      
  
     
      PageReference pageRef = Page.ServiceNowFullfillment;
      test.setcurrentpage(pageRef);
      ApexPages.StandardController stdcon = new ApexPages.StandardController(currentAsset);
      ServiceNowFulfillment srf = new ServiceNowFulfillment(stdcon);
  
      
      String sortExpression ='';
      String sortExp='name';
      String sortDirection='DESC';
      srf.sortExpression=sortExp;
      
      srf.ViewData();
      srf.submit();
      srf.getupdatelist();
      srf.confirm();
      srf.getAssets();
      srf.save();
      srf.setSortDirection('ASC');
      srf.getTopLevelAssets();
      srf.getSortDirection();
      srf.cancelsubmit();
      srf.cancel();
      //srf.assetlist[0].Top_Level_Asset__c=srf.assetlist[1].id;
      //srf.assetlist[2].Top_Level_Asset__c=srf.assetlist[2].id;
      srf.submit();
      //srf.assetlist[0].Top_Level_Asset__c=srf.assetlist[0].id;
      srf.save();
      //srf.assetlist[0].Top_Level_Asset__c=srf.assetlist[0].id;
      srf.confirm();
      srf.sortExpression='';
      srf.getSortDirection();
     }
     }
     
    
     
    
      
       
}
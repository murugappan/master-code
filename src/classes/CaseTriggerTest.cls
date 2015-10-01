@istest

Private class CaseTriggerTest 
 {
   static testmethod void CloseMileStone()
    {
     Profile p =[Select Id,Name from Profile where Name='System Administrator']; 
     User u = TestMethodUtility.CreateUser(p);
     u.Integration_User__c=False;
     insert u;
    
     system.Runas(u)
      {
         Account acc =TestMethodUtility.createAccount();
         insert acc;
         
         Contact cc=TestMethodUtility.createContact(acc);
         insert cc; 
   
         Core_License__c cr1=TestMethodUtility.createCoreLicense();
         cr1.Name = 'Xythos';
         insert cr1; 
   
         Asset ss = TestMethodUtility.createAsset(acc,cr1);
         insert ss;
         
         List<case> lc = new List<case>();
         
         Case c=TestMethodUtility.createCase1(acc,ss);
         c.Escalated_Tier_2__c =False;
         lc.add(c);
         
         Case c1=TestMethodUtility.createCase1(acc,ss);
         c1.Escalated_Tier_3__c =False;
         lc.add(c1);
         
         insert lc;
         
         lc.clear();
         c.Escalated_Tier_2__c =True;
         c1.Escalated_Tier_3__c =True;
         lc.add(c);
         lc.add(c1);
         update lc;
         
         
         }
      }
    static testmethod void AddMilestones()
    {
     Profile p =[Select Id,Name from Profile where Name='System Administrator']; 
     User u = TestMethodUtility.CreateUser(p);
     u.Integration_User__c=False;
     insert u;
    
     system.Runas(u)
      {
         Account acc =TestMethodUtility.createAccount();
         insert acc;
         
         Contact cc=TestMethodUtility.createContact(acc);
         insert cc; 
   
         Core_License__c cr1=TestMethodUtility.createCoreLicense();
         cr1.Name = 'Angel';
         insert cr1; 
   
      
         List<Asset> last = new List<Asset>();
         
         Asset ss = TestMethodUtility.createAsset(acc,cr1);
         ss.Support_Level__c ='ANGEL Premium Support';
         
          
         Asset ss1 = TestMethodUtility.createAsset(acc,cr1);
         ss1.Support_Level__c ='Xythos Support';
         
         Asset ss2 = TestMethodUtility.createAsset(acc,cr1);
         ss2.Support_Level__c ='ANGEL Basic Support';
         ss2.Managed_Hosting__c = 'ANGEL - Managed Hosting';

         Asset ss3 = TestMethodUtility.createAsset(acc,cr1);
         ss3.Support_Level__c ='Basic Support';
         
         Asset ss4 = TestMethodUtility.createAsset(acc,cr1);
         ss4.Support_Level__c ='Enterprise Support';
         
         Asset ss5 = TestMethodUtility.createAsset(acc,cr1);
         
           last.add(ss);
           last.add(ss1);
           last.add(ss2);
           last.add(ss3);
           last.add(ss4);
           last.add(ss5);
         
         insert last;
        
         List<Entitlement>   let = new List<Entitlement>();
         
         Entitlement etl = new Entitlement();
         etl.Name='Test';
         etl.AccountId=acc.id;
         etl.AssetId=ss.id;
         etl.Outside_Business_Hours_ANGEL_Premium__c = true;
         etl.Case_Severity__c='2';
         
         Entitlement et2 = new Entitlement();
         et2.Name='Test';
         et2.AccountId=acc.id;
         et2.AssetId=ss.id;
         et2.Outside_Business_Hours_ANGEL_Premium__c = False;
         et2.Case_Severity__c='2';
         
         Entitlement et3 = new Entitlement();
         et3.Name='Test';
         et3.ANGEL_Hosted__c = true;
         et3.AccountId=acc.id;
         et3.AssetId=ss2.id;
         et3.Outside_Business_Hours_ANGEL_Premium__c = False;
         et3.Case_Severity__c='1';
         
         Entitlement et4 = new Entitlement();
         et4.Name='Test';
         et4.AccountId=acc.id;
         et4.AssetId=ss4.id;
         et4.Outside_Business_Hours_ANGEL_Premium__c = False;
         et4.Case_Severity__c='1';
         
         Entitlement et5 = new Entitlement();
         et5.Name='Test';
         et5.AccountId=acc.id;
         et5.AssetId=ss1.id;
         et5.Outside_Business_Hours_ANGEL_Premium__c = False;
         et5.Case_Severity__c='1';
         
         Entitlement et6 = new Entitlement();
         et6.Name='Test';
         et6.AccountId=acc.id;
         et6.AssetId=ss3.id;
         et6.Outside_Business_Hours_ANGEL_Premium__c = False;
         et6.Case_Severity__c='1';
             
         let.add(etl);
         let.add(et2);
         let.add(et3);
         let.add(et4);
         let.add(et5);
         
         insert let;
         
         
         Test.StartTest();
         
         Case c=TestMethodUtility.createCase1(acc,ss);
         c.Invoke_Premium_Support__c = True;
         c.Case_Severity__c='2';
         insert c;
         
         
         Case c1=TestMethodUtility.createCase1(acc,ss1);
         c1.Invoke_Premium_Support__c = True;
         c1.Case_Severity__c='1';
         insert c1;
          
         
         Case c2=TestMethodUtility.createCase1(acc,ss2);
         c2.Invoke_Premium_Support__c = True;
         c2.Case_Severity__c='1';
         insert c2;
         
         
         Case c3=TestMethodUtility.createCase1(acc,ss3);
         c3.Invoke_Premium_Support__c = True;
         c3.Case_Severity__c='1';
         insert c3;
         
         
         Case c4=TestMethodUtility.createCase1(acc,ss4);
         c4.Invoke_Premium_Support__c = True;
         c4.Case_Severity__c='1';
         insert c4;
         
         Case c5=TestMethodUtility.createCase1(acc,ss);
         c5.Case_Severity__c='1';
         insert c5;
         
         
         Test.stopTest();
         
        
         
         
         }
      }       
   }
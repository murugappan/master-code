@istest
Public class Non_Time_based_AlertsTest{

   static testMethod void myUnitTest(){
   
    Profile p= [Select Id,Name from Profile where Name='System Administrator'];
    
    User u=TestMethodUtility.createUser(p);
    
    insert u; 
    
     Group grp = [select Id,Name,Type from Group where Name = 'ANGEL - Managed Hosting'];
    
    Account ac = TestMethodUtility.createAccount(); 
    ac.Name = 'Testing1 Account';
    ac.BillingStreet = 'Testing1 Street';
    ac.BillingCity = 'Testing1 City';
    ac.BillingState = 'Testing1 State';
    ac.BillingCountry = 'India';        //for Angel account level queue
    ac.BillingPostalCode = 'Testing Code';
    ac.Angel_Queue__c = 'ANGEL - Midwest Engagement Team';
    
    insert ac;
    
    Contact c1 = TestMethodUtility.createContact(ac);
    c1.FirstName = 'Test1';
    c1.LastName = 'Contact1';
    c1.Email = 'test@test1.com';
    
    insert c1;
    
    Core_License__c cr = TestMethodUtility.createCoreLicense();
    cr.Name = 'Xythos';
    insert cr; 
    
    Core_License__c cr1 =TestMethodUtility.createCoreLicense();
    cr1.Name = 'ANGEL';
    insert cr1; 
    
    Module__c  m1=TestMethodUtility.createModule(cr);
    insert m1;
    
    Module__c  m2=TestMethodUtility.createModule(cr1);
    insert m2;   
  
   List<asset> assetlist = new List<asset>();  
    Asset aset = TestMethodUtility.createAsset(ac,cr);
    aset.Name = 'Test Asset 111';
    aset.Installed_Product_ID__c = '123';
    aset.Status = 'Installed'; 
    aset.version__c = '9.1';
    aset.Psft_Product_Id__c = 'AS-LS';
    aset.Version_Build__c = '9.1.X';
    assetlist.add(aset);
    
    Asset aset1 =TestMethodUtility.createAsset(ac,cr1);
    aset1.Name = 'Test Asset 1111';
    aset1.Installed_Product_ID__c = '243';
    aset1.Status = 'Installed'; 
    aset1.version__c = '9.1';
    aset1.Psft_Product_Id__c = 'AS-LS';
    aset1.Version_Build__c = '9.1.X';
    aset1.Managed_Hosting__c='ANGEL - Managed Hosting';
    assetlist.add(aset1);
    
    
    Asset aset2 = TestMethodUtility.createAsset(ac,cr1);
    aset2.Name = 'Test Asset 1111';
    aset2.Installed_Product_ID__c = '263';
    aset2.Status = 'Installed'; 
    aset2.version__c = '9.1';
    aset2.Psft_Product_Id__c = 'AS-LS';
    aset2.Version_Build__c = '9.1.X';
    assetlist.add(aset2);
     
    insert assetlist;
        
    List<Case> caslist = new List<Case>();
    Set<ID> tmpid = new Set<ID>();
    
   
  System.Runas(u)
   {
   
  // these cases belongs to Angel
    
    Case cassoftsol = TestMethodUtility.createCase(c1,cr1,ac,m2);       
    cassoftsol.Case_Severity__c = '1';
    cassoftsol.Subject = 'test';
    cassoftsol.Description = 'test';
    cassoftsol.assetID = aset1.ID;
    cassoftsol.Status = 'New';
    caslist.add(cassoftsol);
    
    
    Case cassoftsol3 = TestMethodUtility.createCase(c1,cr1,ac,m2);        // this case group is owner id
    cassoftsol3.Case_Severity__c = '1';
    cassoftsol3.Subject = 'test';
    cassoftsol3.Description = 'test';
    cassoftsol3.assetID = aset1.ID;
    cassoftsol3.Status = 'New';
    cassoftsol3.OwnerID = grp.ID;
    caslist.add(cassoftsol3);
    
    
    Case cassoftsol2 = TestMethodUtility.createCase(c1,cr1,ac,m2);         //for ANGEL - Managed Hosting
    cassoftsol2.Case_Severity__c = '1';
    cassoftsol2.Subject = 'test';
    cassoftsol2.Description = 'test';
    cassoftsol2.assetID = aset1.ID;
    cassoftsol2.Primary_Group_Name__c = 'ANGEL - Managed Hosting';
    cassoftsol2.Status = 'New';
    cassoftsol2.Invoke_Premium_Support__c =true;
    caslist.add(cassoftsol2);
    
    
    Case cassoftsol1 =TestMethodUtility.createCase(c1,cr1,ac,m2);         //for ANGEL - Managed Hosting
    cassoftsol1.Case_Severity__c = '1';
    cassoftsol1.Subject = 'test';
    cassoftsol1.Description = 'test';
    cassoftsol1.assetID = aset1.ID;
    cassoftsol1.Primary_Group_Name__c = 'ANGEL - Managed Hosting';
    cassoftsol1.Status = 'New';
    cassoftsol1.Invoke_Premium_Support__c = true;
   // cassoftsol1.OwnerID = grp.ID;
   // insert cassoftsol1;
    caslist.add(cassoftsol1);
    
    
    Case cassoftsol4 = TestMethodUtility.createCase(c1,cr1,ac,m2);        
    cassoftsol4.Description = 'test';
    cassoftsol4.assetID = aset1.ID;
    cassoftsol4.Status = 'Needs Attention';
    caslist.add(cassoftsol4);
   
    
    
     
    Case cassoftsol5 = TestMethodUtility.createCase(c1,cr1,ac,m2);         //for angel software solutions
    cassoftsol5.Case_Severity__c = '1';
    cassoftsol5.Subject = 'test';
    cassoftsol5.Description = 'test';
    cassoftsol5.assetID = aset2.ID;
    cassoftsol5.Primary_Group_Name__c = 'ANGEL - Software Solutions';
    cassoftsol5.Status = 'Escalated';
    caslist.add(cassoftsol5);
  
  
    Case cassoftsol6 = TestMethodUtility.createCase(c1,cr1,ac,m2);         //for ANGEL - Development
    cassoftsol6.Case_Severity__c = '1';
    cassoftsol6.Subject = 'test';
    cassoftsol6.Description = 'test';
    cassoftsol6.assetID = aset2.ID;
    cassoftsol6.Primary_Group_Name__c = 'ANGEL - Development';
    cassoftsol6.Status = 'Needs Attention';
    caslist.add(cassoftsol6);
    
    
    Case cassoftsol7 =TestMethodUtility.createCase(c1,cr1,ac,m2);         //for ANGEL - Development
    cassoftsol7.Case_Severity__c = '1';
    cassoftsol7.Subject = 'test';
    cassoftsol7.Description = 'test';
    cassoftsol7.assetID = aset2.ID;
    cassoftsol7.Primary_Group_Name__c = 'ANGEL - Development';
    cassoftsol7.Status = 'Escalated';
    caslist.add(cassoftsol7);
    
    
    
    Case cassoftsol8 = TestMethodUtility.createCase(c1,cr1,ac,m2);       
    cassoftsol8.Case_Severity__c = '1';
    cassoftsol8.Subject = 'test';
    cassoftsol8.Description = 'test';
    cassoftsol8.assetID = aset2.ID;
    cassoftsol8.Invoke_Premium_Support__c = true;
    caslist.add(cassoftsol8);
    
    Case cassoftsol9 =TestMethodUtility.createCase(c1,cr1,ac,m2);         //for ICM Support
    cassoftsol9.Case_Severity__c = '1';
    cassoftsol9.Subject = 'test';
    cassoftsol9.Description = 'test';
    cassoftsol9.assetID = aset2.ID;
    cassoftsol9.Primary_Group_Name__c = 'ICM Support';
    cassoftsol9.Status = 'Needs Attention';
    caslist.add(cassoftsol9);
    
    
    Case cassoftsol10 =TestMethodUtility.createCase(c1,cr1,ac,m2);  
    cassoftsol10.assetID = aset2.ID;
    cassoftsol10.Status = 'Reopened';
    caslist.add(cassoftsol10);
 
    
    Case cassoftsol11 =TestMethodUtility.createCase(c1,cr1,ac,m2);  
    cassoftsol11.assetID = aset2.ID;
    cassoftsol11.Case_Severity__c ='1';
    cassoftsol11.Status = 'New';
    caslist.add(cassoftsol11);
    
    Case cassoftsol12 =TestMethodUtility.createCase(c1,cr1,ac,m2);  
    cassoftsol12.assetID = aset2.ID;
    cassoftsol12.Status = 'Needs Attention';
    caslist.add(cassoftsol12);
    
   // below cases for Xythos 
    
    Case cassoftsol13 =TestMethodUtility.createCase(c1,cr,ac,m1);  
    cassoftsol13.assetID = aset.ID;
    cassoftsol13.Case_Severity__c ='1';
    cassoftsol13.Status = 'New';
    caslist.add(cassoftsol13);
    
    Case cassoftsol14 =TestMethodUtility.createCase(c1,cr,ac,m1);
    cassoftsol14.assetID = aset.ID;
    cassoftsol14.Case_Severity__c ='3';
    cassoftsol14.Status = 'Needs Attention';
    caslist.add(cassoftsol14);
    
    insert caslist;
   
    cassoftsol1.OwnerID = grp.ID;
    update cassoftsol1;
    
    
    Set<ID> casID = new Set<ID>();
    Set<ID> casID1 = new Set<ID>();
    for(Case c111 : caslist){
        casID.add(c111.ID);
    }
   casID1.add(cassoftsol10.id);
   //query the field that is not inserted like owner etc
   List<case> caselist = [select ID,CreatedDate,Type,Owner.Name,Subject,Escalated_Tier_3__c,Reopen_comment__c,Case_Age__c,Core_License__r.Name,Asset_Database__c,Functional_Area_Name__c,Module_Name__c,Account_Complex_Hosting__c,AccountID,ContactId,Managed_Hosting__c,RecordTypeID,OwnerID,Invoke_Premium_Support__c,Account_Name__c,Contact_Name__c,Description,Contact_Email__c,Primary_Group_Name__c,Case_Severity__c,CaseNumber,Status,Case_record__c,Account_Id__c from Case where ID IN: casID];
  //caselist1 has been created to make body and subject null
    
   List<case> caselist1= new List<case>();
   caselist1.add(cassoftsol11);
   caselist1.add(cassoftsol12); 
   set<id> caseid = new set<id>();
   For(case cc : caselist1) 
   caseid.add(cc.id);
   
   List<case> caselist2 = [select ID,CreatedDate,Type,Owner.Name,Subject,Escalated_Tier_3__c,Reopen_comment__c,Case_Age__c,Core_License__r.Name,Asset_Database__c,Functional_Area_Name__c,Module_Name__c,Account_Complex_Hosting__c,AccountID,ContactId,Managed_Hosting__c,RecordTypeID,OwnerID,Invoke_Premium_Support__c,Account_Name__c,Contact_Name__c,Description,Contact_Email__c,Primary_Group_Name__c,Case_Severity__c,CaseNumber,Status,Case_record__c,Account_Id__c from Case where ID IN: caseid]; 
   
    Non_Time_based_Alerts ntb = new Non_Time_based_Alerts();
    
    tmpID.add(cassoftsol.ID);
    ntb.Thirtyminmail(tmpID);
    test.starttest();
    ntb.FortyFiveminmail(tmpID);
    test.stoptest();
    ntb.ntb_alerts(caselist2,casID1);
    
    ntb.ntb_alerts(caselist,casID);
    ntb.ntb_alerts(caselist,casID1);
 //   ntb.sixtyminmail(casID);
 //   ntb.sendHourlyEmail(caselist);
 //   ntb.Thirtyminmail(casID);

   // ntb.sendHourlyEmail(caslist);
    
    String s = ntb.getBody('19',cassoftsol);
    String s10 = ntb.getBody('16',cassoftsol);
    String s11 = ntb.getBody('20',cassoftsol);
    String s12 = ntb.getBody('21',cassoftsol);
    String s13 = ntb.getBody('23',cassoftsol);
    String s14 = ntb.getBody('22',cassoftsol);
    String s15 = ntb.getBody('24',cassoftsol);
    String s16 = ntb.getBody('6',cassoftsol);
    String s17 = ntb.getBody('7',cassoftsol);
    String s18 = ntb.getBody('11',cassoftsol);
    String s19 = ntb.getBody('10',cassoftsol);
    String s100 = ntb.getBody('15',cassoftsol);
    String s111 = ntb.getBody('8',cassoftsol);
    String s122 = ntb.getBody('5',cassoftsol);
    String s133 = ntb.getBody('9',cassoftsol);
    String s144 = ntb.getBody('25000_161',cassoftsol);
    String s145 = ntb.getBody('25000_162',cassoftsol);
    String s155 = ntb.getBody('HC1',cassoftsol);
    String s166 = ntb.getBody('HC2',cassoftsol);
    String s167 = ntb.getBody('HC3',cassoftsol);
    String s177 = ntb.getBody('HC5',cassoftsol);
    String s188 = ntb.getBody('HC4',cassoftsol);
    String s199 = ntb.getBody('HC6',cassoftsol);  
    String s191 = ntb.getBody('HC8',cassoftsol);     
    String s1000 = ntb.getBody('HC9',cassoftsol);    
    String s1001 = ntb.getBody('Reopened',cassoftsol);    
    
   }
   
  } 
   
    static testMethod void myUnitTest1(){
   
       Profile p= [Select Id,Name from Profile where Name='System Administrator'];
    
    User u=TestMethodUtility.createUser(p);
    
    insert u; 
    
     Group grp = [select Id,Name,Type from Group where Name = 'ANGEL - Managed Hosting'];
    
    Account ac = TestMethodUtility.createAccount(); 
    ac.Name = 'Testing1 Account';
    ac.BillingStreet = 'Testing1 Street';
    ac.BillingCity = 'Testing1 City';
    ac.BillingState = 'Testing1 State';
    ac.BillingCountry = 'India';        //for Angel account level queue
    ac.BillingPostalCode = 'Testing Code';
    ac.Angel_Queue__c = 'ANGEL - Midwest Engagement Team';
    
    insert ac;
    
    Contact c1 = TestMethodUtility.createContact(ac);
    c1.FirstName = 'Test1';
    c1.LastName = 'Contact1';
    c1.Email = 'test@test1.com';
    
    insert c1;
    
    Core_License__c cr = TestMethodUtility.createCoreLicense();
    cr.Name = 'Xythos';
    insert cr; 
    
    Core_License__c cr1 =TestMethodUtility.createCoreLicense();
    cr1.Name = 'ANGEL';
    insert cr1; 
    
    Module__c  m1=TestMethodUtility.createModule(cr);
    insert m1;
    
    Module__c  m2=TestMethodUtility.createModule(cr1);
    insert m2;   
  
   List<asset> assetlist = new List<asset>();  
    Asset aset = TestMethodUtility.createAsset(ac,cr);
    aset.Name = 'Test Asset 111';
    aset.Installed_Product_ID__c = '123';
    aset.Status = 'Installed'; 
    aset.version__c = '9.1';
    aset.Psft_Product_Id__c = 'AS-LS';
    aset.Version_Build__c = '9.1.X';
    assetlist.add(aset);
    
    Asset aset1 =TestMethodUtility.createAsset(ac,cr1);
    aset1.Name = 'Test Asset 1111';
    aset1.Installed_Product_ID__c = '243';
    aset1.Status = 'Installed'; 
    aset1.version__c = '9.1';
    aset1.Psft_Product_Id__c = 'AS-LS';
    aset1.Version_Build__c = '9.1.X';
    aset1.Managed_Hosting__c='ANGEL - Managed Hosting';
    assetlist.add(aset1);
    
    
    Asset aset2 = TestMethodUtility.createAsset(ac,cr1);
    aset2.Name = 'Test Asset 1111';
    aset2.Installed_Product_ID__c = '263';
    aset2.Status = 'Installed'; 
    aset2.version__c = '9.1';
    aset2.Psft_Product_Id__c = 'AS-LS';
    aset2.Version_Build__c = '9.1.X';
    assetlist.add(aset2);
     
    insert assetlist;
        
    List<Case> caslist = new List<Case>();
    Set<ID> tmpid = new Set<ID>();
    
   
  System.Runas(u)
   {
   
  // these cases belongs to Angel
    
    Case cassoftsol = TestMethodUtility.createCase(c1,cr1,ac,m2);       
    cassoftsol.Case_Severity__c = '1';
    cassoftsol.Subject = 'test';
    cassoftsol.Description = 'test';
    cassoftsol.assetID = aset1.ID;
    cassoftsol.Status = 'New';
    caslist.add(cassoftsol);
    

    
    Case cassoftsol1 =TestMethodUtility.createCase(c1,cr1,ac,m2);         //for ANGEL - Managed Hosting
    cassoftsol1.Case_Severity__c = '1';
    cassoftsol1.Subject = 'test';
    cassoftsol1.Description = 'test';
    cassoftsol1.assetID = aset1.ID;
    cassoftsol1.Primary_Group_Name__c = 'ANGEL - Managed Hosting';
    cassoftsol1.Status = 'New';
    cassoftsol1.Invoke_Premium_Support__c = true;
   // cassoftsol1.OwnerID = grp.ID;
   // insert cassoftsol1;
    caslist.add(cassoftsol1);      
    
    Case cassoftsol4 = TestMethodUtility.createCase(c1,cr1,ac,m2);        
    cassoftsol4.Description = 'test';
    cassoftsol4.assetID = aset1.ID;
    cassoftsol4.Status = 'Needs Attention';
    caslist.add(cassoftsol4);
   
    
    
     
    Case cassoftsol5 = TestMethodUtility.createCase(c1,cr1,ac,m2);         //for angel software solutions
    cassoftsol5.Case_Severity__c = '1';
    cassoftsol5.Subject = 'test';
    cassoftsol5.Description = 'test';
    cassoftsol5.assetID = aset2.ID;
    cassoftsol5.Primary_Group_Name__c = 'ANGEL - Software Solutions';
    cassoftsol5.Status = 'Escalated';
    caslist.add(cassoftsol5);
  
  
    Case cassoftsol6 = TestMethodUtility.createCase(c1,cr1,ac,m2);         //for ANGEL - Development
    cassoftsol6.Case_Severity__c = '1';
    cassoftsol6.Subject = 'test';
    cassoftsol6.Description = 'test';
    cassoftsol6.assetID = aset2.ID;
    cassoftsol6.Primary_Group_Name__c = 'ANGEL - Development';
    cassoftsol6.Status = 'Needs Attention';
    caslist.add(cassoftsol6);
    
    
    Case cassoftsol7 =TestMethodUtility.createCase(c1,cr1,ac,m2);         //for ANGEL - Development
    cassoftsol7.Case_Severity__c = '1';
    cassoftsol7.Subject = 'test';
    cassoftsol7.Description = 'test';
    cassoftsol7.assetID = aset2.ID;
    cassoftsol7.Primary_Group_Name__c = 'ANGEL - Development';
    cassoftsol7.Status = 'Escalated';
    caslist.add(cassoftsol7);
 
     
    
    Case cassoftsol10 =TestMethodUtility.createCase(c1,cr1,ac,m2);  
    cassoftsol10.assetID = aset2.ID;
    cassoftsol10.Status = 'Reopened';
    caslist.add(cassoftsol10);  
 
    
    Case cassoftsol11 =TestMethodUtility.createCase(c1,cr1,ac,m2);  
    cassoftsol11.assetID = aset2.ID;
    cassoftsol11.Case_Severity__c ='1';
    cassoftsol11.Status = 'New';
    caslist.add(cassoftsol11);
    
    Case cassoftsol12 =TestMethodUtility.createCase(c1,cr1,ac,m2);  
    cassoftsol12.assetID = aset2.ID;
    cassoftsol12.Status = 'Needs Attention';
    caslist.add(cassoftsol12);
    
  
  
    
    insert caslist;
   
    cassoftsol1.OwnerID = grp.ID;
    update cassoftsol1;
    
    
    Set<ID> casID = new Set<ID>();
    Set<ID> casID1 = new Set<ID>();
    for(Case c111 : caslist){
        casID.add(c111.ID);
    }
   casID1.add(cassoftsol10.id);
   //query the field that is not inserted like owner etc
   List<case> caselist = [select ID,CreatedDate,Type,Owner.Name,Subject,Escalated_Tier_3__c,Reopen_comment__c,Case_Age__c,Core_License__r.Name,Asset_Database__c,Functional_Area_Name__c,Module_Name__c,Account_Complex_Hosting__c,AccountID,ContactId,Managed_Hosting__c,RecordTypeID,OwnerID,Invoke_Premium_Support__c,Account_Name__c,Contact_Name__c,Description,Contact_Email__c,Primary_Group_Name__c,Case_Severity__c,CaseNumber,Status,Case_record__c,Account_Id__c from Case where ID IN: casID];
  //caselist1 has been created to make body and subject null
    
   List<case> caselist1= new List<case>();
   caselist1.add(cassoftsol11);
   caselist1.add(cassoftsol12); 
   set<id> caseid = new set<id>();
   For(case cc : caselist1) 
   caseid.add(cc.id);
   
   List<case> caselist2 = [select ID,CreatedDate,Type,Owner.Name,Subject,Escalated_Tier_3__c,Reopen_comment__c,Case_Age__c,Core_License__r.Name,Asset_Database__c,Functional_Area_Name__c,Module_Name__c,Account_Complex_Hosting__c,AccountID,ContactId,Managed_Hosting__c,RecordTypeID,OwnerID,Invoke_Premium_Support__c,Account_Name__c,Contact_Name__c,Description,Contact_Email__c,Primary_Group_Name__c,Case_Severity__c,CaseNumber,Status,Case_record__c,Account_Id__c from Case where ID IN: caseid]; 
   
    Non_Time_based_Alerts ntb = new Non_Time_based_Alerts();
   
      tmpID.add(cassoftsol.ID); 
      test.starttest();
      ntb.sixtyminmail(casID);
      test.stoptest();
      ntb.sendHourlyEmail(caselist);
      ntb.Thirtyminmail(casID);
      
      
    String s = ntb.getBody('19',cassoftsol);
    String s10 = ntb.getBody('16',cassoftsol);
    String s11 = ntb.getBody('20',cassoftsol);
    String s12 = ntb.getBody('21',cassoftsol);
    String s13 = ntb.getBody('23',cassoftsol);
    String s14 = ntb.getBody('22',cassoftsol);
    String s15 = ntb.getBody('24',cassoftsol);
    String s16 = ntb.getBody('6',cassoftsol);
    String s17 = ntb.getBody('7',cassoftsol);
    String s18 = ntb.getBody('11',cassoftsol);
    String s19 = ntb.getBody('10',cassoftsol);
    String s100 = ntb.getBody('15',cassoftsol);
    String s111 = ntb.getBody('8',cassoftsol);
    String s122 = ntb.getBody('5',cassoftsol);
    String s133 = ntb.getBody('9',cassoftsol);
    String s144 = ntb.getBody('25000_161',cassoftsol);
    String s145 = ntb.getBody('25000_162',cassoftsol);
    String s155 = ntb.getBody('HC1',cassoftsol);
    String s166 = ntb.getBody('HC2',cassoftsol);
    String s167 = ntb.getBody('HC3',cassoftsol);
    String s177 = ntb.getBody('HC5',cassoftsol);
    String s188 = ntb.getBody('HC4',cassoftsol);
    String s199 = ntb.getBody('HC6',cassoftsol);  
    String s191 = ntb.getBody('HC8',cassoftsol);     
    String s1000 = ntb.getBody('HC9',cassoftsol);    
    String s1001 = ntb.getBody('Reopened',cassoftsol);  
   
   }
   
  } 

}
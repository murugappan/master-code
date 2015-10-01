global class processSolutionResponseEmail implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,Messaging.InboundEnvelope env) {
    
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
    
        List<String> SolutionAttributes = String.valueOf(email.Subject).split(':');
        EmailMessage inboundemail = new EmailMessage();
        Datetime t = System.now();
     try {    
        /*Solution Decline = 0, Solution Accept = 1*/
        /*Case Number:01234567:Response:0:Solution Id:{!solution_detail__c.id}*/
        String CaseId = SolutionAttributes[1];
        String SolutionResponse = SolutionAttributes[3];
        String SolutionId = SolutionAttributes[5];
        String SolutionComments = email.plainTextbody;
        
        Decimal sla;
        
        BusinessHours b1 = [select ID from BusinessHours where Name = 'Default']; 
        List<Solution_Detail__c> relatedSolutions = [Select Id, Status__c, Comments__c From Solution_Detail__c Where Id = :SolutionId Limit 1];
        List<Case> relatedCases = [Select Id,casenumber,subject, BusinessHoursID, Case_Severity__c,Case_Reopened__c, Customer_Portal_Status__c, Case_record__c,Primary_Group_Name__c,owner.name,OwnerId, Status,Send_email_client_case_team__c From Case Where CaseNumber = :CaseId Limit 1];        

        if(relatedCases.size()>0){
                
         if(relatedCases[0].Case_record__c != null && relatedCases[0].Case_record__c.contains('ANGEL')) 
              sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: relatedCases [0].Case_Severity__c AND Core_License__c = 'ANGEL'].SLA__c;
         else if(relatedCases[0].Case_record__c != null && relatedCases[0].Case_record__c.contains('Learn'))
              sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: relatedCases [0].Case_Severity__c AND Core_License__c = 'Learn'].SLA__c;
         else if(relatedCases[0].Case_record__c != null && relatedCases[0].Case_record__c.contains('CE'))
              sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: relatedCases [0].Case_Severity__c AND Core_License__c = 'CE'].SLA__c;
         else if(relatedCases[0].Case_record__c != null && relatedCases[0].Case_record__c.contains('Xythos'))
              sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: relatedCases [0].Case_Severity__c AND Core_License__c = 'Xythos'].SLA__c;
         else if(relatedCases[0].Case_record__c != null && relatedCases[0].Case_record__c.contains('Transact'))
              sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: relatedCases [0].Case_Severity__c AND Core_License__c = 'Transact'].SLA__c;
         else if(relatedCases[0].Case_record__c != null && relatedCases[0].Case_record__c.containsignorecase('Collaborate'))
              sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: relatedCases [0].Case_Severity__c AND Core_License__c = 'Collaborate'].SLA__c;     
         else if(relatedCases[0].Case_record__c != null && relatedCases[0].Case_record__c.containsignorecase('Moodlerooms'))
              sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: relatedCases [0].Case_Severity__c AND Core_License__c = 'Moodlerooms'].SLA__c;
         else if(relatedCases[0].Case_record__c != null && relatedCases[0].Case_record__c.containsignorecase('Analytics'))
              sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: relatedCases [0].Case_Severity__c AND Core_License__c = 'Analytics'].SLA__c;
         else if(relatedCases[0].Case_record__c != null && relatedCases[0].Case_record__c.containsignorecase('xpLor'))
              sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: relatedCases [0].Case_Severity__c AND Core_License__c = 'xpLor'].SLA__c;
    


        
        if(SolutionResponse != '-1'){
            if(SolutionResponse == '1'){
                relatedCases[0].Status='Closed';
              //  relatedCases[0].Portal_Status__c='Closed';
                relatedCases[0].Closed_Comments__c=SolutionComments;
                relatedSolutions[0].Status__c = 'Successful Resolution';
                relatedSolutions[0].Comments__c = SolutionComments;
            }    
            if(SolutionResponse == '0'){
                relatedCases[0].Status='Reopened';
              //  relatedCases[0].Portal_Status__c='Work In Progress';
                relatedCases[0].Case_Reopened__c = true;// Added for TP 1231
                relatedCases[0].Reopen_comment__c = SolutionComments;
                
                
                // added by Muru for Case History 360
                Case_Note__c cnn = new Case_Note__c(); 
                cnn.Details__c = 'TTTT';
                //cnn.Details__c = 'Case Reopened at: ' + system.now()+'<br/>'+relatedCases[0].Reopen_comment__c;
                cnn.Details__c = 'Case Reopened and Solution Declined';
                cnn.Type__c = 'Case Reopened';
                cnn.Public__c = true;
                cnn.From_Type__c = 'Customer';
                cnn.Case__c = relatedCases[0].Id;
                cnn.Is_Email__c = false;
                Insert cnn; 
                     
                
                
                if(SolutionComments != null && SolutionComments.length()>=32768)
                 relatedCases[0].AssignTo_Comment__c = SolutionComments.substring(0,32768);
                 
                 else
                 relatedCases[0].AssignTo_Comment__c = SolutionComments;
                 
            
           
                 
                 
                 
                 
                 if(relatedCases[0].Send_email_client_case_team__c != null)
                 {
                relatedCases[0].Send_email_client_case_team__c=relatedCases[0].Send_email_client_case_team__c+1;
                }
                else
                {
                relatedCases[0].Send_email_client_case_team__c=1;
                }
                Non_Time_based_Alerts NTB= new Non_Time_based_Alerts ();
                string body=NTB.getBody('clientcomment',relatedCases[0]);
                string subject='Case#'+relatedCases[0].casenumber+'  has been updated by the client';
                emailviaworkflow.mailStaffCaseTeam(relatedCases[0],body,subject );
                Responsiveness__c res_sol_dec = new Responsiveness__c();   
                relatedSolutions[0].Status__c = 'Failed Resolution';
                relatedSolutions[0].Comments__c = SolutionComments;
                res_sol_dec.Case__c = relatedCases [0].ID;
                res_sol_dec.Start_Time__c = System.now();
                res_sol_dec.Start_Event__c = 'Solution Declined';
                res_sol_dec.Event_Type__c= 'Follow Up';
                if(String.valueof(relatedCases[0].OwnerId).substring(0,3) == '005'){
                   User u1 = [select Name,Primary_Group__c from User where ID =: relatedCases[0].OwnerId]; 
                   res_sol_dec.Event_Owner__c = u1.Name;
                   res_sol_dec.Event_Owner_Primary_Group__c = u1.Primary_Group__c;
                }else{
                   res_sol_dec.Event_Owner__c = relatedCases[0].Primary_Group_Name__c;
                }  res_sol_dec.Event_Owner_Primary_Group__c = relatedCases[0].Primary_Group_Name__c;
                if(sla != null){
                   if(relatedCases[0].Case_Severity__c == '1' || relatedCases[0].Case_Severity__c == '2')    
                       res_sol_dec.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), Integer.valueof(sla) * 60 * 60 * 1000L);
                   else{
                       String day = System.now().format('EEE');
                       if(day == 'Fri')
                           res_sol_dec.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), (Integer.valueof(sla) + 48) * 60 * 60 * 1000L);
                       else if(day == 'Sat')
                           res_sol_dec.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), (Integer.valueof(sla) + 24) * 60 * 60 * 1000L);
                       else
                           res_sol_dec.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), Integer.valueof(sla) * 60 * 60 * 1000L);
                   }
                }
                Insert res_sol_dec;
            }
            try{     
                relatedCases[0].Last_Activity_Date_Time__c = System.now();       
                update relatedCases;
                update relatedSolutions;  
            }
            catch (Exception e){
            }
            // Case Email
            try
            {
                inboundemail.MessageDate = t;
                inboundemail.fromAddress = email.fromAddress;
                inboundemail.subject  = email.subject;
                if(email.HtmlBody != null && email.HtmlBody != '')
                    inboundemail.HtmlBody = email.HtmlBody;
                else if (email.plainTextBody != null && email.plainTextBody != '')
                {
                string temp = email.plainTextBody;
                    inboundemail.HtmlBody = temp.replaceAll('[\\n]|[\\r]','<br/>');
                    }
                inboundemail.fromName = email.fromName;
                inboundemail.ParentId = relatedCases[0].Id;
                inboundemail.Incoming = true;
                insert inboundemail;
                result.success = true;
            }
            catch (Exception e){
            
            result.success = false;            
            }
            
            // Attachment
            try
            {
            if (email.textAttachments!= null) 
                {      
                    System.debug('<<<<<<final'); 
                }
            if(email.textAttachments != null && email.textAttachments.size() > 0){    
                for (Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments) {
                    Attachment attachment = new Attachment();
                    attachment.Name = tAttachment.fileName;
                    attachment.Body = Blob.valueOf(tAttachment.body);
                    attachment.ParentId =  CaseId;
                    insert attachment;
                }
            }        
            if(email.binaryAttachments != null && email.binaryAttachments.size() > 0){
                for (Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments) {
                    Attachment attachment = new Attachment();     
                    attachment.Name = bAttachment.fileName;
                    attachment.Body = bAttachment.body;
                    System.debug('<<<<<<<<Before Insert 222>>>>>>>>>>');
                    attachment.ParentId = CaseId;
                    insert attachment;   
                }
           } 
      }
              catch (Exception e){
           
            }
        }
    
    }
    return result;  
  }catch (Exception e){
  ///final catch
  Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
  String[] toAddresses = new String[] {email.fromAddress};
  mail.setToAddresses(toAddresses);
 OrgWideEmailAddress od =[select id,Address from OrgWideEmailAddress where Address='no-reply@blackboard.com' limit 1];
 mail.setSubject('Unable to process your response');
 mail.setOrgWideEmailAddressId(od.id);
 string body='Hello,<br/><br/>We were unable to process your email response into the appropriate support case.  A possible reason is that the subject line has been changed or truncated.<br/>'+
 'Please login to Behind the Blackboard, navigate to the desired case, and re-submit your response either by clicking on the Add Comment button or, if a solution<br/>'+
 'has been suggested on your case, by clicking on "Accept" or "Decline" from within the solution comment.<br/><br/>'+
 'Best regards,<br/> Client Support';
  mail.setHTMLBody(body);
  Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            result.success = true;
            return result;
            }
 }
 
 static testmethod void processSolutionResponseEmailtest(){
 
  Profile p =[select id, Name from Profile where Name='System Administrator'];
  User u =TestMethodUtility.createUser(p);
  insert u; 
  
   System.Runas(u)
   {  
     
    Account ac =  TestMethodUtility.createAccount(); 
    ac.Angel_Queue__c = 'ANGEL - Midwest Engagement Team';
    
    insert ac;
    
    Contact c1 = TestMethodUtility.createContact(ac);
    insert c1;
    
    
    
    Core_License__c cr2 = TestMethodUtility.createCoreLicense();
    cr2.Name = 'Learn';
    insert cr2;   
     
   // Assets 
   list<asset> asset_list = new list<asset>();
    
    Asset aset1 =TestMethodUtility.createAsset(ac,cr2);
    aset1.Name = 'Test Asset 111';
    aset1.Installed_Product_ID__c = '1234';
    aset1.Status = 'Installed'; 
    aset1.version__c = '9.1';
    aset1.Psft_Product_Id__c = 'AS-LS';
    aset1.Version_Build__c = '9.1.X';
    asset_list.add(aset1);
     
    insert asset_list;
    
  ////// 
  
 
  list<case> caselist = new list<case>();
    Case cassoftsol = new Case();        
    cassoftsol.AccountID = ac.ID;
    cassoftsol.ContactID = c1.ID;
    cassoftsol.Case_Severity__c = '1';
    cassoftsol.Subject = 'test';
    cassoftsol.Description = 'test';
    
    caselist.add(cassoftsol);
  
  //case with Assets
     
   Case cassoftsol2 =TestMethodUtility.createCase1(ac,aset1);       
    cassoftsol2.ContactID = c1.ID;
    cassoftsol2.Case_Severity__c = '1';
    cassoftsol2.Subject = 'test';
    cassoftsol2.Description = 'test';
   caselist.add(cassoftsol2);
   
  insert caselist;
  

   
     list<Solution_Detail__c>  sol_list = new  list<Solution_Detail__c>();
        
    Solution_Detail__c sd =TestMethodUtility.CreateSolutionDetail(); 
    sd.Case__c = cassoftsol.ID;
    sd.Status__c = 'In Consideration';
    sol_list.add(sd);
    
    Solution_Detail__c sd2 =TestMethodUtility.CreateSolutionDetail(); 
    sd2.Case__c = cassoftsol2.ID;
    sd2.Status__c = 'In Consideration';
    sol_list.add(sd2);
    
     
     insert sol_list;
    
    Case cas1 = [select CaseNumber from Case where ID =: cassoftsol.ID];
    Case cas2 = [select CaseNumber from Case where ID =: cassoftsol2.ID];
 //   Case cas5 = [select CaseNumber from Case where ID =: cassoftsol5.ID];
    
    Messaging.InboundEmail inemail = new Messaging.InboundEmail();
    inemail.fromAddress = 'prakashb6687@gmail.com';
    inemail.htmlBody = 'hello';
    
    inemail.subject = 'Case CaseNumber:'+cas1.CaseNumber+':Response:0:Solution Id:'+sd.ID;
    
    Messaging.InboundEmail inemail1 = new Messaging.InboundEmail();
    inemail1.fromAddress = 'prakashb6687@gmail.com';
    
    inemail.plainTextBody='test i123';
    inemail1.subject = 'Case CaseNumber:'+cas1.CaseNumber+':Response:1:Solution Id:'+sd.ID;
    
     Messaging.InboundEmail inemail3 = new Messaging.InboundEmail();
    inemail3.fromAddress = 'prakashb6687@gmail.com';
    inemail3.htmlBody = 'hello';
    Messaging.Inboundemail.TextAttachment test_aatch = new  Messaging.Inboundemail.TextAttachment();
    test_aatch.filename='test.txt';
    test_aatch.body='test';
    inemail3.textattachments = new Messaging.Inboundemail.TextAttachment[]{test_aatch};
    inemail3.subject = 'Case CaseNumber:'+cas2.CaseNumber+':Response:1:Solution Id:'+sd2.ID;
    
     
     test.starttest();
    
    Messaging.InboundEmail inemail2 = new Messaging.InboundEmail();
    inemail2.fromAddress = 'prakashb6687@gmail.com';
    inemail2.htmlBody = 'hello';
    inemail2.subject = 'Test error';

    Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
    env.fromAddress = 'prakashb6687@gmail.com';
    
    processSolutionResponseEmail emailtocase = new processSolutionResponseEmail();
    emailtocase.handleInboundEmail(inemail,env);
   
    processSolutionResponseEmail emailtocase1 = new processSolutionResponseEmail();
    emailtocase1.handleInboundEmail(inemail1,env);
     
    processSolutionResponseEmail emailtocase2 = new processSolutionResponseEmail();
     
    emailtocase2.handleInboundEmail(inemail2,env);
    emailtocase2.handleInboundEmail(inemail3,env);
    test.stoptest();  
    }
 }
 
 static testmethod void processSolutionResponseEmailtest1(){
 
  Profile p =[select id, Name from Profile where Name='System Administrator'];
  User u =TestMethodUtility.createUser(p);
  insert u;
  
   System.Runas(u)
   {   
     
    Account ac = TestMethodUtility.createAccount();
    ac.Name = 'Testing1 Account';
    ac.BillingStreet = 'Testing1 Street';
    ac.BillingCity = 'Testing1 City';
    ac.BillingState = 'Testing1 State';
    ac.BillingCountry = 'Testing1 country';        //for Angel account level queue
    ac.BillingPostalCode = 'Testing Code';
    ac.Angel_Queue__c = 'ANGEL - Midwest Engagement Team';
    
    insert ac;
    
    Contact c1 = TestMethodUtility.createContact(ac);
    c1.FirstName = 'Test1';
    c1.LastName = 'Contact1';
    c1.Email = 'test@test1.com';
    c1.AccountID = ac.ID;
    
    insert c1;
    
   //core license
    
    Core_License__c cr3 = TestMethodUtility.createCoreLicense();
    cr3.Name = 'CE/Vista';
    insert cr3;
    
    
    Core_License__c cr4 = TestMethodUtility.createCoreLicense();
    cr4.Name = 'Xythos';
    insert cr4;
    

     
   // Assets 
   list<asset> asset_list = new list<asset>(); 
   
    Asset aset2 = TestMethodUtility.createAsset(ac,cr3);
    aset2.Name = 'Test Asset 111';
    aset2.Installed_Product_ID__c = '1235';
    aset2.Status = 'Installed'; 
    aset2.version__c = '9.1';
    aset2.Psft_Product_Id__c = 'AS-LS';
    aset2.Version_Build__c = '9.1.X';
    asset_list.add(aset2);
     
    
    Asset aset3 = TestMethodUtility.createAsset(ac,cr4);
    aset3.Name = 'Test Asset 111';
    aset3.Installed_Product_ID__c = '1236';
    aset3.Status = 'Installed'; 
    aset3.version__c = '9.1';
    aset3.Psft_Product_Id__c = 'AS-LS';
    aset3.Version_Build__c = '9.1.X';
    asset_list.add(aset3);
   
   insert asset_list;
    
    
  ////// 
  
 
  list<case> caselist = new list<case>();
    
    Case cassoftsol3 = TestMethodUtility.createCase1(ac,aset2);          
    cassoftsol3.ContactID = c1.ID;
    cassoftsol3.Case_Severity__c = '1';
    cassoftsol3.Subject = 'test';
    cassoftsol3.Description = 'test';
   caselist.add(cassoftsol3);
    
    
   Case cassoftsol4 = TestMethodUtility.createCase1(ac,aset3);        
    cassoftsol4.ContactID = c1.ID;
    cassoftsol4.Case_Severity__c = '1';
    cassoftsol4.Subject = 'test';
    cassoftsol4.Description = 'test';
   caselist.add(cassoftsol4);
   
  insert caselist;
  

   
    list<Solution_Detail__c>  sol_list = new  list<Solution_Detail__c>();
    
    Solution_Detail__c sd3 = TestMethodUtility.CreateSolutionDetail(); 
    sd3.Case__c = cassoftsol3.ID;
    sd3.Status__c = 'In Consideration';
    sol_list.add(sd3);
        
    
    
    Solution_Detail__c sd4 = TestMethodUtility.CreateSolutionDetail(); 
    sd4.Case__c = cassoftsol4.ID;
    sd4.Status__c = 'In Consideration';
    sol_list.add(sd4);
     
     insert sol_list;
    
    Case cas3 = [select CaseNumber from Case where ID =: cassoftsol3.ID];
    Case cas4 = [select CaseNumber from Case where ID =: cassoftsol4.ID];
    
    
    Messaging.InboundEmail inemail4 = new Messaging.InboundEmail();
    inemail4.fromAddress = 'prakashb6687@gmail.com';
    inemail4.htmlBody = 'hello';
    Messaging.Inboundemail.binaryAttachment bin_aatch = new  Messaging.Inboundemail.binaryAttachment();
    bin_aatch.filename='test.txt';
   bin_aatch.body=blob.valueof('test');
   inemail4.binaryattachments = new Messaging.Inboundemail.binaryAttachment[]{bin_aatch};
    inemail4.subject = 'Case CaseNumber:'+cas3.CaseNumber+':Response:1:Solution Id:'+sd3.ID;
     
    Messaging.InboundEmail inemail5 = new Messaging.InboundEmail();
    inemail5.fromAddress = 'prakashb6687@gmail.com';
    inemail5.htmlBody = 'hello';
    inemail5.subject = 'Case CaseNumber:'+cas4.CaseNumber+':Response:1:Solution Id:'+sd4.ID;
    

    Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
    env.fromAddress = 'prakashb6687@gmail.com';
    
     
    processSolutionResponseEmail emailtocase2 = new processSolutionResponseEmail();
     
    Test.startTest();
    emailtocase2.handleInboundEmail(inemail4,env);
    emailtocase2.handleInboundEmail(inemail5,env);
    test.stoptest();  
    }
 }
 static testmethod void processSolutionResponseEmailtest2()
 {
    user sysuser=[select id,name from user where username like 'tsg@blackboard.com%' and isactive =true limit 1];
    system.runas(sysuser){

  Profile p =[select id, Name from Profile where Name='System Administrator'];
  User u =TestMethodUtility.createUser(p);
  insert u;
  
   System.Runas(u)
   {   
     
    Account ac = TestMethodUtility.createAccount();
    ac.Name = 'Testing1 Account';
    ac.BillingStreet = 'Testing1 Street';
    ac.BillingCity = 'Testing1 City';
    ac.BillingState = 'Testing1 State';
    ac.BillingCountry = 'Testing1 country';        
    ac.BillingPostalCode = 'Testing Code';
    ac.Analytics_Queue__c = 'Analytics: L1';
    ac.xpLor_Queue__c='Moodlerooms: Territory 1 Engagement Team';
    insert ac;
    
    Contact c1 = TestMethodUtility.createContact(ac);
    c1.FirstName = 'Test1';
    c1.LastName = 'Contact1';
    c1.Email = 'test@test1.com';
    c1.AccountID = ac.ID;
    
    insert c1;
    
   //core license
    
    Core_License__c cr3 = TestMethodUtility.createCoreLicense();
    cr3.Name = 'Analytics';
    insert cr3;
    
    
    Core_License__c cr4 = TestMethodUtility.createCoreLicense();
    cr4.Name = 'xpLor';
    insert cr4;
    

     
   // Assets 
   list<asset> asset_list = new list<asset>(); 
   
    Asset aset2 = TestMethodUtility.createAsset(ac,cr3);
    aset2.Name = 'Test Asset 111';
    aset2.Installed_Product_ID__c = '1235';
    aset2.Status = 'Installed'; 
    aset2.version__c = '9.1';
    aset2.Psft_Product_Id__c = 'AS-LS';
    aset2.Version_Build__c = '9.1.X';
    asset_list.add(aset2);
     
    
    Asset aset3 = TestMethodUtility.createAsset(ac,cr4);
    aset3.Name = 'Test Asset 111';
    aset3.Installed_Product_ID__c = '1236';
    aset3.Status = 'Installed'; 
    aset3.version__c = '9.1';
    aset3.Psft_Product_Id__c = 'AS-LS';
    aset3.Version_Build__c = '9.1.X';
    asset_list.add(aset3);
   
   insert asset_list;
    
    
  ////// 
  
 
  list<case> caselist = new list<case>();
    
    Case cassoftsol3 = TestMethodUtility.createCase1(ac,aset2);          
    cassoftsol3.ContactID = c1.ID;
    cassoftsol3.Case_Severity__c = '1';
    cassoftsol3.Subject = 'test';
    cassoftsol3.Description = 'test';
   caselist.add(cassoftsol3);
    
    
   Case cassoftsol4 = TestMethodUtility.createCase1(ac,aset3);        
    cassoftsol4.ContactID = c1.ID;
    cassoftsol4.Case_Severity__c = '1';
    cassoftsol4.Subject = 'test';
    cassoftsol4.Description = 'test';
   caselist.add(cassoftsol4);
   
  insert caselist;
  

   
    list<Solution_Detail__c>  sol_list = new  list<Solution_Detail__c>();
    
    Solution_Detail__c sd3 = TestMethodUtility.CreateSolutionDetail(); 
    sd3.Case__c = cassoftsol3.ID;
    sd3.Status__c = 'In Consideration';
    sol_list.add(sd3);
        
    
    
    Solution_Detail__c sd4 = TestMethodUtility.CreateSolutionDetail(); 
    sd4.Case__c = cassoftsol4.ID;
    sd4.Status__c = 'In Consideration';
    sol_list.add(sd4);
     
     insert sol_list;
    
    Case cas3 = [select CaseNumber from Case where ID =: cassoftsol3.ID];
    Case cas4 = [select CaseNumber from Case where ID =: cassoftsol4.ID];
    
    
    Messaging.InboundEmail inemail4 = new Messaging.InboundEmail();
    inemail4.fromAddress = 'prakashb6687@gmail.com';
    inemail4.htmlBody = 'hello';
    Messaging.Inboundemail.binaryAttachment bin_aatch = new  Messaging.Inboundemail.binaryAttachment();
    bin_aatch.filename='test.txt';
   bin_aatch.body=blob.valueof('test');
   inemail4.binaryattachments = new Messaging.Inboundemail.binaryAttachment[]{bin_aatch};
    inemail4.subject = 'Case CaseNumber:'+cas3.CaseNumber+':Response:1:Solution Id:'+sd3.ID;
     
    Messaging.InboundEmail inemail5 = new Messaging.InboundEmail();
    inemail5.fromAddress = 'saisaranyagotrala@blackboard.com';
    inemail5.htmlBody = 'hello';
    inemail5.subject = 'Case CaseNumber:'+cas4.CaseNumber+':Response:1:Solution Id:'+sd4.ID;
    

    Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
    env.fromAddress = 'saranya.gotrala@blackboard.com';
    
     
    processSolutionResponseEmail emailtocase2 = new processSolutionResponseEmail();
     
    Test.startTest();
    emailtocase2.handleInboundEmail(inemail4,env);
    emailtocase2.handleInboundEmail(inemail5,env);
    test.stoptest();  
    }
 }
}
}
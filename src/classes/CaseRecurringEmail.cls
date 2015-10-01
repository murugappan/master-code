public class CaseRecurringEmail{

     Map<String,String> usr_mailid = new Map<String,String>();
     Map<String,String> con_mailid = new Map<String,String>();
     Map<String,Set<String>> q_mailid = new Map<String,Set<String>>();  
     Set<ID> usrID = new Set<ID>();
     Set<ID> qID = new Set<ID>();
     Set<ID> cID = new Set<ID>();
     List<Case_Recurring_Email__c> crlist = new List<Case_Recurring_Email__c>();
     
     public void getQueuemembers(){
        
        if(qId.size() > 0){
            for(List<GroupMember> grpmem : [select ID,UserOrGroupId,GroupId from GroupMember where GroupID IN: qID]){
                  System.debug(grpmem);
                  for(GroupMember grp1 : grpmem){
                      if(grp1.UserOrGroupId != null){
                         usrID.add(grp1.UserOrGroupId); 
                         if(q_mailid.containsKey(grp1.GroupId)){                         
                            Set<String> grpID = new Set<String>();
                            grpID = q_mailid.get(grp1.GroupId);
                            grpID.add(grp1.UserOrGroupId); 
                            q_mailid.put(grp1.GroupId,grpID);
                         }else{
                            Set<String> grpID = new Set<String>();
                            grpID.add(grp1.UserOrGroupId); 
                            q_mailid.put(grp1.GroupId,grpID);
                         }
                     } 
                 }  
             }    
        }
        
        if(usrID.size() > 0){
            for(List<User> u : [select Id,Email from User where ID IN: usrID]){
                for(User usr : u){
                    usr_mailid.put(usr.ID,usr.Email);
                }
            }    
        }
    }    
    
    
    
    public void sendCaseEmail(List<Case> caslist,Set<ID> cID){
        
        Non_Time_based_Alerts ntb = new Non_Time_based_Alerts();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setOrgWideEmailAddressId('0D270000000Gmrt');
        String sub;
        String body;
        String[] toAddresses = new String[]{};
        for(Case c : caslist){
           if(String.valueof(c.OwnerID).substring(0,3) == '005')
                 usrID.add(c.OwnerID);
           if(String.valueof(c.OwnerID).substring(0,3) == '00G')
                 qID.add(c.OwnerID); 
                
        }
        getQueuemembers();
        //for(Case c : [select ID,Primary_Group_Name__c,Invoke_Premium_Support__c,Contact_Name__c,Description,Subject, Case_Severity__c,Account_Name__c,Case_Record__c,Status,Contact_Email__c,Owner.Email,CaseNumber,createddate from Case where ID IN: caslist]){
              for (Case c:caslist){
                string caserecordtype=Case.sObjectType.getdescribe().getRecordTypeInfosById().get(c.recordtypeid).getname();
                mail = new Messaging.SingleEmailMessage();
              if((null != c.Case_Record__c && !c.Case_Record__c.contains('Transact') && c.Status == 'Pending User' &&(c.createddate.addhours(1)<system.now()||test.isrunningtest()))||(c.Status == 'Pending User' && caserecordtype.containsignorecase('end user')) ){
                  if(cID != null && cID.size() > 0 &&cID.contains(c.ID)){
                          
                          List<String> emails1 = new List<String>();    
                          if(c.Contact_Email__c!=null)
                          emails1.add(c.Contact_Email__c);
                          if(c.end_user_email__c !=null)
                          {
                           emails1.add(c.end_user_email__c);
                          }
                          toAddresses = emails1; 
                          c.Status = 'Closed'; // Added for TP 1969  
                          sub =  'Case ID: ' + c.CaseNumber + ' Closed due to lack of response.';
                          mail.setSubject(sub);
                          if((caserecordtype.containsignorecase('end user')))  
                          {
                            body = ntb.getBody('EU19',c); 
                          } 
                          else
                          {  
                          body = ntb.getBody('19',c); 
                          } 
                          mail.setHtmlBody(body);
                          mail.setToAddresses(emails1);
                          /****************** For QAX************/
                         // mail.setOrgWideEmailAddressId('0D2V00000008Oe1');
                          /******************** For Production ***********/
                          mail.setOrgWideEmailAddressId('0D270000000Gmzn');
                          
                          Case_Note__c note = new Case_Note__c();
                          note.Case__c = c.ID;
                          note.Public__c = true;
                          note.From_Type__c = 'Employee';
                          note.Details__c = body;
                          note.Type__c = 'Case Closure - Pending with User';

                          insert note;

                          Solution_Detail__c solution = new Solution_Detail__c();
                          solution.Status__c = 'Successful Resolution';
                          solution.Description__c = body;
                          solution.Subject__c = 'Case Closure - Pending with User';
                          solution.Case__c = c.ID;
                          insert solution;
                      
                  }else{  
                    system.debug('Pass--5'); 
                      List<String> emails1 = new List<String>();    
                      if(c.Contact_Email__c!=null)
                          emails1.add(c.Contact_Email__c);
                       if(c.end_user_email__c !=null)
                          {
                           emails1.add(c.end_user_email__c);
                          }
                      toAddresses = emails1;   
                      sub ='Case ID: '+c.CaseNumber+' Case needs attention Subject: '+c.Subject+'%'+c.CaseNumber+'%Case needs attention%';
                      system.debug('c.Subject');
                      mail.setSubject(sub); 
                      if((caserecordtype.containsignorecase('end user')))  
                          {
                            body = ntb.getBody('EU16',c);
                          } 
                      else{        
                      body = ntb.getBody('16',c);
                      }  
                      mail.setHtmlBody(body);
                      mail.setToAddresses(emails1);
                      system.debug('mail--'+c.casenumber+'--'+mail.subject);
                      Case_Note__c note = new Case_Note__c();
                      note.Case__c = c.ID;
                      note.Public__c = true;
                      note.From_Type__c = 'Employee';
                      note.Details__c = body;
                      note.Type__c = 'Case Pending with User';

                      insert note;
                  }
              }else if((null != c.Case_Record__c /*&& c.Case_Record__c.contains('ANGEL')*/ && c.Status == 'Solution Suggested' &&(c.createddate.addhours(1)<system.now()||test.isrunningtest()))||(c.Status == 'Solution Suggested' && caserecordtype.containsignorecase('end user'))){
                  c.Status = 'Closed';
                  List<String> emails1 = new List<String>();    
                  if(c.Contact_Email__c!=null)
                          emails1.add(c.Contact_Email__c);
                   if(c.end_user_email__c !=null)
                          {
                           emails1.add(c.end_user_email__c);
                          }
                  toAddresses = emails1;   
                  sub =  'Case Number=' + c.CaseNumber + ' Moving case from Solution Suggested to Closed';
                  mail.setSubject(sub);    
                    if((caserecordtype.containsignorecase('end user')))  
                          {
                            body = ntb.getBody('EU20',c);  
                   } 
                   else  {       
                        body = ntb.getBody('20',c);
                   }  
                  mail.setHtmlBody(body);
                  mail.setToAddresses(emails1);
                  
                  Case_Note__c note = new Case_Note__c();
                  note.Case__c = c.ID;
                  note.Public__c = true;
                  note.From_Type__c = 'Employee';
                  note.Details__c = body;
                  note.Type__c = 'Case Closure - Solution not Accepted';

                  insert note;
                  
              }else if(null != c.Case_Record__c && c.Case_Record__c.contains('ANGEL') && c.Invoke_Premium_Support__c == true){
                  if(String.valueof(c.OwnerID).substring(0,3) == '005'){
                       toAddresses = new String[] {usr_mailid.get(c.OwnerID)};
                       mail.setToAddresses(toAddresses);
                   }else if(String.valueof(c.OwnerID).substring(0,3) == '00G'){
                       List<String> emails = new List<String>();
                       System.debug(retmailID(c.OwnerID));
                       if(retmailID(c.OwnerID) != null)
                           emails.addAll(retmailID(c.OwnerID));
                       List<String> emails1 = new List<String>();    
                       emails1.add(c.Contact_Email__c);
                       emails.addAll(emails1);    
                       toAddresses = emails;   
                       mail.setToAddresses(toAddresses);
                        
                  }  
            //      toAddresses = new String[] {c.Owner.Email};
                  List<ANGELPremiumTB__c> tbe = ANGELPremiumTB__c.getall().values(); 
                  List<String> hardemails = new List<String>();
                  for(ANGELPremiumTB__c tb : tbe){
                        hardemails.add(tb.Name); 
                  }
                  toAddresses.addAll(hardemails);
                  mail.setToAddresses(toAddresses);
                  sub =  'Case Number='+ c.CaseNumber + ' NEW Premium Support Case';
                  mail.setSubject(sub);     
                  body = ntb.getBody('21',c);  
                  mail.setHtmlBody(body);
                  List<Case_Recurring_Email__c> deletecrlist = new List<Case_Recurring_Email__c>([select ID from Case_Recurring_Email__c where Case__c =: c.ID]);
                  delete deletecrlist;                     
                  Case_Recurring_Email__c cr = new Case_Recurring_Email__c();
                  cr.Case__c = c.ID; 
                  crlist.add(cr);
              }else if(c.Case_Severity__c != '1' && c.Primary_Group_Name__c == 'ANGEL - Managed Hosting'){
                 if(String.valueof(c.OwnerID).substring(0,3) == '005'){
                       toAddresses = new String[] {usr_mailid.get(c.OwnerID)};
                       mail.setToAddresses(toAddresses);
                   }else if(String.valueof(c.OwnerID).substring(0,3) == '00G'){
                       List<String> emails = new List<String>();
                       System.debug(retmailID(c.OwnerID));
                       if(retmailID(c.OwnerID) != null)
                           emails.addAll(retmailID(c.OwnerID));
                       toAddresses = emails;   
                       mail.setToAddresses(emails);
                  }  
              //    toAddresses = new String[] {c.Owner.Email};
                  sub =  'Case # ' + c.CaseNumber+ ' Unassigned AHS SEV 1';
                  mail.setSubject(sub);     
                  body = ntb.getBody('23',c);  
                  mail.setHtmlBody(body);
                  mail.setOrgWideEmailAddressId('0D270000000Gmrt');
                  List<Case_Recurring_Email__c> deletecrlist = new List<Case_Recurring_Email__c>([select ID from Case_Recurring_Email__c where Case__c =: c.ID]);
                  delete deletecrlist;                     
                  Case_Recurring_Email__c cr = new Case_Recurring_Email__c();
                  cr.Case__c = c.ID; 
                  crlist.add(cr);
              }else if((c.Case_Severity__c == '1' && null != c.Case_Record__c && c.Case_Record__c.contains('ANGEL')&&c.status=='New')){
                  if(String.valueof(c.OwnerID).substring(0,3) == '005'){
                       toAddresses = new String[] {usr_mailid.get(c.OwnerID)};
                       mail.setToAddresses(toAddresses);
                   }else if(String.valueof(c.OwnerID).substring(0,3) == '00G'){
                       List<String> emails = new List<String>();
                       System.debug(retmailID(c.OwnerID));
                       if(retmailID(c.OwnerID) != null)
                           emails.addAll(retmailID(c.OwnerID));
                       
                       toAddresses = emails;   
                       mail.setToAddresses(emails);
                  }  
                //  toAddresses = new String[] {c.Owner.Email};
                  if(c.Case_Severity__c == '1' && c.Primary_Group_Name__c == 'ANGEL - Managed Hosting'){
                       List<ANGELHostedSev1TB__c> tbe = ANGELHostedSev1TB__c.getall().values(); 
                       List<String> hardemails = new List<String>();
                       for(ANGELHostedSev1TB__c tb : tbe){
                           hardemails.add(tb.Name); 
                       }
                       toAddresses.addAll(hardemails);
                       mail.setToAddresses(toAddresses);  
                  }     
                  sub =  'Case # '+c.CaseNumber+' Unassigned SEV 1 Case';
                  mail.setSubject(sub);     
                  body = ntb.getBody('22',c);  
                  mail.setHtmlBody(body);
                  List<Case_Recurring_Email__c> deletecrlist = new List<Case_Recurring_Email__c>([select ID from Case_Recurring_Email__c where Case__c =: c.ID]);
                  delete deletecrlist;                     
                  Case_Recurring_Email__c cr = new Case_Recurring_Email__c();
                  cr.Case__c = c.ID; 
                  crlist.add(cr);
            }
                    Boolean check = true;
               
                if(toAddresses != null){
                        for(Integer i=0; i<toAddresses.size(); i++){
                            if(toAddresses[i] == null)
                                check = false;
                         }
                  }
               
             //   try{
             system.debug('Pass1--1');
                        if(body != null && toAddresses != null && sub != null && check == true && toAddresses.size() != 0)
                        {
                            system.debug('Pass1--2');
                           //   EmailviaWorkflow.sendworflowemail(mail);// Added for TP:3186
                               if(c.Status == 'Pending User' || c.Status == 'Solution Suggested' ||c.status=='Closed')
                               {
                                system.debug('Pass1--3');
                                    emailviaworkflow.sendcaseteamemailTrigger(c,mail.htmlbody,mail.subject);
                               }
                               else
                               {
                                system.debug('Pass1--4');
                                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); //TP:3186(commented)
                               }
                    }   
             //   }catch(Exception e){
             //       System.debug('Exception' + e); 
             //   }
        }
       
        if(crlist.size() > 0)
            Upsert crlist;
    }
    
    
    public Set<String> retmailID(ID grpID){
       
        List<String> memberID = new List<String>();
        Set<String> emailIDs = new Set<String>();
        Set<String> tmp1 = new Set<String>();
        if(q_mailid != null && q_mailid.size() > 0){
            tmp1 = q_mailid.get(grpID);
            memberId.addAll(tmp1);
            for(ID i : memberID){
                emailIDs.add(usr_mailid.get(i));
                System.debug(i);
                System.debug(usr_mailid.get(i));    
            }
            Set<String> emailIDSsend = new Set<String>();
            emailIDSsend.addAll(emailIDs); 
            return emailIDSsend;
        }
        return null;
    }    
    
     static testmethod void CaseRecurringEmailTest(){
        Account ac=TestMethodUtility.createAccount();
        ac.Name='bucknell university';
        ac.BillingCity='abc';
        ac.BillingCountry='USA';
        ac.BillingPostalCode='abc';
        ac.BillingState='abc';
        ac.BillingStreet='abc';
    
        insert ac;
    
        Contact ct=TestMethodUtility.createContact(ac);
        ct.Account=ac;
        ct.LastName='abc';
        insert ct;
    
        Core_License__c cl=TestMethodUtility.createCoreLicense();
        cl.Name='ANGEL';
        insert cl;
        
        Core_License__c c2=TestMethodUtility.createCoreLicense();
        c2.Name='Learn';
        insert c2;
        
        Core_License__c c3=TestMethodUtility.createCoreLicense();
        c3.Name='Transact';
        insert c3;
        
        
        Core_License__c c4=TestMethodUtility.createCoreLicense();
        c4.Name = 'CE/Vista';
        insert c4;
        
        
        Asset a=TestMethodUtility.createAsset(ac,cl);
        a.Name='abc';
        a.Contact=ct;
        a.Account=ac;
        insert a;
        
        Asset a1=TestMethodUtility.createAsset(ac,c2);
        a1.Name='abc';
        a1.Contact=ct;
        a1.Account=ac;
        insert a1;
        
        Asset a2=TestMethodUtility.createAsset(ac,c3);
        a2.Name='abc';
        a2.Core_License__c=c3.id;
        a2.AccountId=ac.id;
        a2.Contact=ct;
        a2.Account=ac;
        insert a2;
        
        Asset a3=TestMethodUtility.createAsset(ac,c4);
        a3.Name='abc';
        a3.Contact=ct;
        a3.Account=ac;
        insert a3;
        
        List<Case> caselist = new List<Case>();
        Set<ID> cID = new Set<ID>();
        
        Group g = [select ID,NAme from Group where Name = 'ANGEL - Development'];
        
        Case cs=TestMethodUtility.createCase1(ac,a1);
        cs.Status='Pending User' ;
        cs.Description='this case has to be resolved';
        cs.Type='abc';
        cs.Subject='abc';
        cs.Case_Severity__c='sev 1';
        cs.Primary_Group_Name__c='Learn - L2 - EMEA';
        cs.Previous_Owner__c='yyyy';
        cs.Account=ac;
        cs.Contact=ct;
        cs.Replication_in_the_Case__c = 'Test';
        cs.OwnerId = g.ID;
        
        
        insert cs;
        
        caselist = [select ID,End_User_Email__c,RecordTypeId,Primary_Group_Name__c,Invoke_Premium_Support__c,Contact_Name__c,Description,Subject, Case_Severity__c,Account_Name__c,Case_Record__c,Status,Contact_Email__c,Owner.Email,CaseNumber,createddate from Case where ID =: cs.ID];
        cID.add(cs.ID);
        
        CaseRecurringEmail cr = new CaseRecurringEmail();
        
        Test.Starttest();
        cr.sendCaseEmail(caselist,cID);
        
        caselist.clear();
        
        Case cs1=TestMethodUtility.createCase1(ac,a);
        cs1.Status='Solution Suggested';
        cs1.Description='this case has to be resolved';
        cs1.Type='abc';cs1.Subject='abc';
        cs1.Case_Severity__c='sev 1';
        cs1.Primary_Group_Name__c='ANGEL - Development';
        cs1.Previous_Owner__c='yyyy';
        cs1.Account=ac;
        cs1.Contact=ct;
        cs1.Replication_in_the_Case__c = 'Test';
        insert cs1;
        
        cId.clear();
        caselist.clear();
        caselist = [select ID,RecordTypeId,End_User_Email__c,Primary_Group_Name__c,Invoke_Premium_Support__c,Contact_Name__c,Description,Subject, Case_Severity__c,Account_Name__c,Case_Record__c,Status,Contact_Email__c,Owner.Email,CaseNumber,createddate from Case where ID =: cs1.ID];
        CaseRecurringEmail cr1 = new CaseRecurringEmail();
        cr1.sendCaseEmail(caselist,cID);
        
        Case cs2=TestMethodUtility.createCase1(ac,a);
        cs2.Status='Pending User';
        cs2.Description='this case has to be resolved';
        cs2.Type='abc';cs.Subject='abc';
        cs2.Case_Severity__c='sev 1';
        cs2.Primary_Group_Name__c='Learn - L1 - Windows';
        cs2.Previous_Owner__c='rrrrr';
        cs2.Account=ac;
        cs2.Contact=ct;
        cs2.Replication_in_the_Case__c = 'Test';
        insert cs2;
        
        cId.clear();
        caselist.clear();
        caselist = [select ID,Primary_Group_Name__c,RecordTypeId,End_User_Email__c,Invoke_Premium_Support__c,Contact_Name__c,Description,Subject, Case_Severity__c,Account_Name__c,Case_Record__c,Status,Contact_Email__c,Owner.Email,CaseNumber,createddate from Case where ID =: cs2.ID];
        CaseRecurringEmail cr2 = new CaseRecurringEmail();
        cr2.sendCaseEmail(caselist,cID); 
         
        Case cs3=TestMethodUtility.createCase1(ac,a);
        cs3.Status='New';
        cs3.Description='this case has to be resolved';
        cs3.Type='abc';
        cs.Subject='abc';
        cs3.Case_Severity__c='4';
        cs3.Primary_Group_Name__c='Learn - L2 - EMEA';
        cs3.Previous_Owner__c='iiii';
        cs3.Account=ac;
        cs3.Contact=ct;
        cs3.Invoke_Premium_Support__c= true;
        cs3.OwnerId = g.ID;
        insert cs3;
        
        cId.clear();
        caselist.clear();
        caselist = [select ID,RecordTypeId,End_User_Email__c,Primary_Group_Name__c,Invoke_Premium_Support__c,Contact_Name__c,Description,Subject, Case_Severity__c,Account_Name__c,Case_Record__c,Status,Contact_Email__c,Owner.Email,CaseNumber,createddate from Case where ID =: cs3.ID];
        CaseRecurringEmail cr3 = new CaseRecurringEmail();
        cr3.sendCaseEmail(caselist,cID); 
        
        Test.stopTest();
            }
        static testmethod void CaseRecurringEmailTest1(){
        
        Account ac=TestMethodUtility.createAccount();
        ac.Name='bucknell university';
        ac.BillingCity='abc';
        ac.BillingCountry='USA';
        ac.BillingPostalCode='abc';
        ac.BillingState='abc';
        ac.BillingStreet='abc';
        insert ac;
        
        Contact ct=TestMethodUtility.createContact(ac);
        ct.AccountId=ac.id;
        ct.Account=ac;
        ct.LastName='abc';
        insert ct;
            
        Core_License__c cl=TestMethodUtility.createCoreLicense();
        cl.Name='ANGEL';
        insert cl;
        
        Asset a=TestMethodUtility.createAsset(ac,cl);
        a.Name='abc';
        a.Contact=ct;
        a.Account=ac;
        insert a;
        
        List<Case> caselist = new List<Case>();
        Set<ID> cID = new Set<ID>();
        
        Group g = [select ID,NAme from Group where Name = 'ANGEL - Development'];
        Case cs=new Case();
        cs.Case_Severity__c='2';
        cs.Primary_Group_Name__c ='ANGEL - Managed Hosting';
        insert cs;
        
        cID.add(cs.ID);
        
        Case cs1=TestMethodUtility.createCase1(ac,a);
        cs1.Case_Severity__c='1';
        cs1.Primary_Group_Name__c ='ANGEL - Managed Hosting';
        insert cs1;
        cID.add(cs1.id);
        
        caselist = [select ID,RecordTypeId,Primary_Group_Name__c,Invoke_Premium_Support__c,Contact_Name__c,Description,Subject, Case_Severity__c,Account_Name__c,Case_Record__c,Status,Contact_Email__c,Owner.Email,CaseNumber,createddate from Case where ID IN : cID];
        
        
        CaseRecurringEmail cr = new CaseRecurringEmail();
        
        Test.Starttest();
        cr.sendCaseEmail(caselist,cID);
        Test.stopTest();
            }  
}
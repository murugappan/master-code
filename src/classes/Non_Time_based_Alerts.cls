public class Non_Time_based_Alerts{
  
    List<String> mailids = new List<String>();
    Set<ID> usrID = new Set<ID>();
    Set<ID> qID = new Set<ID>();
    Map<String,String> con_mailid = new Map<String,String>();  
    Map<String,String> usr_mailid = new Map<String,String>();
    Map<String,Set<String>> q_mailid = new Map<String,Set<String>>();        
    
    public void getQueuemembers(){
        
        System.debug(qId);
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
    
    public void ntb_alerts(List<Case> caslist,Set<ID> castat){
        
        Map<String,ID> tmpmap = new Map<String,ID>();
        
        for(Case c : caslist){
            System.debug(c.OwnerID); 
            if(String.valueof(c.OwnerID).substring(0,3) == '005')
                usrID.add(c.OwnerID);
            if(String.valueof(c.OwnerID).substring(0,3) == '00G')
                qID.add(c.OwnerID); 
            if(String.valueof(c.Contact_Email__c) != null)     
                con_mailid.put(c.ContactID,c.Contact_Email__c);  
        }    
    
        getQueuemembers();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setOrgWideEmailAddressId('0D270000000Gmrt');
        String sub;
        String body;
        String[] toAddresses = new String[]{};
        for(Case c: caslist){
            List<ID> casId = new List<ID>();
            casID.add(c.ID);
            
            if(String.valueof(c.OwnerID).substring(0,3) == '005'){
                toAddresses = new String[] {usr_mailid.get(c.OwnerID)};
                mail.setToAddresses(toAddresses);
            }else if(String.valueof(c.OwnerID).substring(0,3) == '00G'){
                List<String> emails = new List<String>();
                System.debug(c.OwnerID);
                if(retmailID(c.OwnerID) != null)
                     emails.addAll(retmailID(c.OwnerID));
                     System.debug(emails); 
                     toAddresses = emails;   
                     mail.setToAddresses(emails);
            }
            if(c.Case_Record__c != null){
                  if(castat != null && castat.contains(c.ID)){
                       sub = 'Alert : A ' + c.Case_Severity__c + ' Case ' + c.CaseNumber + ' has been assigned to you.';
                       mail.setSubject(sub);
                       body = getBody('HC2',c);
                       mail.setHtmlBody(body); 
                  }else if(c.Case_Record__c.contains('ANGEL')){
                       System.debug('+++++++'+c.Primary_Group_Name__c);
                       if(c.Managed_Hosting__c == 'ANGEL - Managed Hosting'){
                            System.debug('hello'+c.Status);
                            if(c.Status == 'New' && c.Invoke_Premium_Support__c == true){
                                sub = 'Case # ' + c.CaseNumber + ' Premium Suport Case';
                                mail.setSubject(sub);
                                body = getBody('24',c);
                                mail.setHtmlBody(body);
                                List<ANGELHostedPremiumNTB__c> tbe = ANGELHostedPremiumNTB__c.getall().values(); 
                                List<String> hardemails = new List<String>();
                                for(ANGELHostedPremiumNTB__c tb : tbe){
                                   hardemails.add(tb.Name); 
                                }
                                toAddresses.addAll(hardemails);
                                mail.setToAddresses(toAddresses);
                           }else if(c.Case_Severity__c == '1' && c.Status == 'New'){
                                sub = 'Case # ' + c.CaseNumber + ' Update to AHS Sev 1';
                                mail.setSubject(sub);
                                body = getBody('7',c);
                                mail.setHtmlBody(body);
                                List<ANGELHostedSev1TB__c> tbe = ANGELHostedSev1TB__c.getall().values(); 
                                List<String> hardemails = new List<String>();
                                for(ANGELHostedSev1TB__c tb : tbe){
                                   hardemails.add(tb.Name); 
                                }
                                toAddresses.addAll(hardemails);
                                mail.setToAddresses(toAddresses); 
                            }else if(c.Status == 'Needs Attention'){
                                sub = 'Case # ' + c.CaseNumber + ' AHS Open Needs Attention';
                                mail.setSubject(sub);
                                body = getBody('6',c);
                                mail.setHtmlBody(body);
                            }
                       }else if(c.Primary_Group_Name__c == 'ANGEL - Software Solutions'){
                            if((c.Status == 'Escalated' || c.status =='Escalating') && c.Case_Severity__c == '1'){
                                 sub = 'Case # ' + c.CaseNumber + ' Elevated to SS - c.Case_Age__c';
                                 mail.setSubject(sub);
                                 body = getBody('15',c);
                                 mail.setHtmlBody(body);
                            }
                       }else if(c.Primary_Group_Name__c == 'ANGEL - Development'){
                            if(c.Status == 'Needs Attention'){
                                sub = 'Case # ' + c.CaseNumber + ' In T-3 Needs Attention';
                                mail.setSubject(sub);
                                body = getBody('10',c);
                                mail.setHtmlBody(body);
                            }else if((c.Status == 'Escalated' || c.status =='Escalating')){
                                sub = 'Case # ' + c.CaseNumber + ' Esclated - c.Case_Age__c';
                                mail.setSubject(sub);
                                body = getBody('8',c);
                                mail.setHtmlBody(body);
                            }
                       }else if(c.Primary_Group_Name__c == 'ICM Support'){
                            if(c.Status == 'Needs Attention'){
                                sub = 'Case # ' + c.CaseNumber + ' Consulting Open Needs Attention';
                                mail.setSubject(sub);
                                body = getBody('5',c);
                                mail.setHtmlBody(body);
                            }
                       }else if(c.Invoke_Premium_Support__c == true){
                            sub = 'Case # ' + c.CaseNumber + ' Premium Suport Case';
                            mail.setSubject(sub);
                            body = getBody('24',c);
                            mail.setHtmlBody(body);
                            List<ANGELPremiumNTB__c> tbe = ANGELPremiumNTB__c.getall().values(); 
                            List<String> hardemails = new List<String>();
                            for(ANGELPremiumNTB__c tb : tbe){
                               hardemails.add(tb.Name); 
                            }
                            toAddresses.addAll(hardemails);
                            mail.setToAddresses(toAddresses);
                       }
                       if(body == null && sub == null){
                           if((c.Case_Severity__c == '1' || c.Case_Severity__c == '2') && (c.Case_Record__c.contains('ANGEL') || c.Case_Record__c.contains('Xythos'))){
                                if(c.Status == 'New'){
                                   String day = c.CreatedDate.format('EEE');
                                   String hour = c.CreatedDate.format('k');
                                   if(day == 'Sat' || day == 'Sun' || (day == 'Fri' && Integer.valueof(hour) >= 16) || (day == 'Mon' && Integer.valueof(hour) <= 8)){
                                       sub = 'Alert  : A '+ c.Case_Severity__c + ' Case ' + c.CaseNumber +  ' has assigned to you.';
                                       mail.setSubject(sub);
                                       body = getBody('HC3',c);
                                       mail.setHtmlBody(body);
                                       List<SEV1or2AfterHoursNTB__c> tbe = SEV1or2AfterHoursNTB__c.getall().values(); 
                                       List<String> hardemails = new List<String>();
                                       for(SEV1or2AfterHoursNTB__c tb : tbe){
                                          hardemails.add(tb.Name); 
                                       }
                                       toAddresses.addAll(hardemails);
                                       mail.setToAddresses(toAddresses);
                                   }else{
                                       sub = 'Alert : A  ' + c.Case_Severity__c + ' Case ' + c.CaseNumber +  ' has assigned to you.';
                                       mail.setSubject(sub);
                                       body = getBody('HC1',c);
                                       mail.setHtmlBody(body);   
                                   }
                               }
                          }else if(c.Status == 'Needs Attention'){
                               sub = 'Case # ' + c.CaseNumber + ' Needs Attention';
                               mail.setSubject(sub);
                               body = getBody('NA',c);
                               mail.setHtmlBody(body);
                          } 
                              
                     }
                }else{
                    if((c.Case_Severity__c == '1' || c.Case_Severity__c == '2') && (c.Case_Record__c.contains('ANGEL') || c.Case_Record__c.contains('Xythos'))){
                        if(c.Status == 'New'){
                           String day = c.CreatedDate.format('EEE');
                           String hour = c.CreatedDate.format('k');
                           if(day == 'Sat' || day == 'Sun' || (day == 'Fri' && Integer.valueof(hour) >= 16) || (day == 'Mon' && Integer.valueof(hour) <= 8)){
                               sub = 'Alert  : A '+ c.Case_Severity__c + ' Case ' + c.CaseNumber +  ' has assigned to you.';
                               mail.setSubject(sub);
                               body = getBody('HC3',c);
                               mail.setHtmlBody(body);
                               List<SEV1or2AfterHoursNTB__c> tbe = SEV1or2AfterHoursNTB__c.getall().values(); 
                               List<String> hardemails = new List<String>();
                               for(SEV1or2AfterHoursNTB__c tb : tbe){
                                    hardemails.add(tb.Name); 
                               }
                               toAddresses.addAll(hardemails);
                               mail.setToAddresses(toAddresses);
                           }else{
                               sub = 'Alert : A  ' + c.Case_Severity__c + ' Case ' + c.CaseNumber +  ' has assigned to you.';
                               mail.setSubject(sub);
                               body = getBody('HC1',c);
                               mail.setHtmlBody(body);   
                            }
                        }
                    }else if(c.Status == 'Needs Attention'){
                         sub = 'Case # ' + c.CaseNumber + ' Needs Attention';
                         mail.setSubject(sub);
                         body = getBody('NA',c);
                         mail.setHtmlBody(body);
                    } 
                }
            }  
        }
        Boolean check = true;
        if(toAddresses != null){
            System.debug('Inside if ' + toAddresses);
            for(Integer i=0; i<toAddresses.size(); i++){
                if(toAddresses[i] == null)
                    check = false;
            }
        }
        System.debug(body);
        System.debug(sub);
        System.debug(toAddresses);
        /*try{
            if(body != null && toAddresses != null && sub != null && check == true && toAddresses.size() != 0)
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }catch(Exception e){
            System.debug('+++'+e);
        }*/
        
         Messaging.SingleEmailMessage mail2 = new Messaging.SingleEmailMessage();
         mail2.setOrgWideEmailAddressId('0D270000000Gmrt');
              String sub2;
              String body2;
              String[] toAddresses2 = new String[]{};   
        
         for(Case c: caslist){
              toAddresses2 = new String[] {con_mailid.get(c.ContactID)};
              System.debug(con_mailid.get(c.ContactID));
              System.debug(c.ContactID);
              mail2.setToAddresses(toAddresses2);
              if(c.Case_Record__c != null){
                  if(c.Case_Record__c.contains('Xythos') && c.Status == 'New' && c.Type != 'ASP Change Request'){
                       sub2 = 'Case Number=' + c.CaseNumber + ',Subject =' + c.Subject + ' Xythos case creation message.';
                       mail2.setSubject(sub2);
                       body2 = getBody('25000_162',c);
                       mail2.setHtmlBody(body2);
                  }else if(!c.Case_Record__c.contains('Xythos') && c.Status == 'New' && c.Type != 'ASP Change Request'){
                       sub2 = 'Case Number=' + c.CaseNumber + ',Subject =' + c.Subject + ' Case Creation email from CRM and BtBb';
                       mail2.setSubject(sub2);
                       body2 = getBody('25000_161',c);
                       mail2.setHtmlBody(body2); 
                  }else if(c.Status == 'Reopened'){
                       sub2 = 'Case Number=' + c.CaseNumber + ' has been Reopened.';
                       mail2.setSubject(sub2);
                       body2 = getBody('Reopened',c);
                       mail2.setHtmlBody(body2); 
                  }else if((c.Status == 'Escalated' || c.status =='Escalating') && c.Escalated_Tier_3__c == false){
                       sub2 = 'Client Support has escalated case ' + c.CaseNumber + ' - ' + c.Case_Age__c;
                       mail2.setSubject(sub2);
                       body2 = getBody('Escal',c);
                       mail2.setHtmlBody(body2);
                  }
            }
        } 
        Boolean check2 = true;
        if(toAddresses2 != null){
            System.debug('Inside if ' + toAddresses2);
            for(Integer i=0; i<toAddresses2.size(); i++){
                if(toAddresses2[i] == null)
                    check2 = false;
            }
        }
        System.debug(body2);
        System.debug(sub2);
        System.debug(toAddresses2);
        /*try{
            if(body2 != null && toAddresses2 != null && sub2 != null && check2 == true && toAddresses2.size() != 0)
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail2 });
        }catch(Exception e){
            System.debug('+++'+e);
        }*/
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

    public void Thirtyminmail(Set<ID> cID){
    
        List<Case> clist = new List<Case>();
        for(List<Case> c1 : [select Owner.Name,Status, Subject,ID,OwnerId,Type ,Primary_Group_Name__c,Contact_Name__c,AccountId ,Description,CreatedDate,Account_Name__c ,CaseNumber,Case_Severity__c,Core_License__r.name,Case_Age__c,RecordTypeId,RecordType.Name from Case where ID IN: cID]){
            for(Case c : c1){
                if(String.valueof(c.OwnerID).substring(0,3) == '005')
                    usrID.add(c.OwnerID);
                if(String.valueof(c.OwnerID).substring(0,3) == '00G')
                    qID.add(c.OwnerID); 
            clist.add(c);  
            } 
        }
        getQueuemembers();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setOrgWideEmailAddressId('0D270000000Gmrt');
        String sub;
        String body;
        //String[] toAddresses = new String[]{};
        
        for(Case c: clist){
           List<string> email = new list<string>();
           string caserecordtype = Case.sObjectType.getdescribe().getRecordTypeInfosById().get(c.recordtypeid).getname();
           string corelicense = c.Core_License__r.name;
           if(String.valueof(c.OwnerID).substring(0,3) == '005' && (!caserecordtype.containsignorecase('end user'))){

              //   toAddresses = new String[] {usr_mailid.get(c.OwnerID)};
                 email.add(usr_mailid.get(c.ownerID));
                 mail.setToAddresses(email);
             //    mail.setToAddresses(toAddresses);
                 system.debug('30co'+ email);
                 
           }else if(String.valueof(c.OwnerID).substring(0,3) == '00G'){
                 List<String> emails = new List<String>();
                 if(retmailID(c.OwnerID) != null){
                       email.addAll(retmailID(c.OwnerID));
                  }          
                // toAddresses = emails;
                
                 mail.setToAddresses(email);
                 
           }

           
           mail.setToAddresses(email);
           
           //sub = 'Alert :  A  ' + c.Case_Severity__c + ' Case ' + c.CaseNumber + ' has assigned to you.';
           sub = 'Case #' + c.CaseNumber +' ('+c.Status+')'+ ' needs a response (SEV: ' + c.Case_Severity__c + ' Client: ' + c.Account_Name__c + ' - '+ c.Case_Age__c + ' Subject: ' + c.Subject + ')  **ESCALATING ALERT**';
           mail.setSubject(sub);
           body = getBody('HC7',c);
           mail.setHtmlBody(body);
          
        Boolean check = true;
        if(email != null){
            for(Integer i=0; i<email.size(); i++){
                if(email[i] == null)
                    check = false;
            }
        }
        try{
            if(body != null && email != null && sub != null && check == true && email.size() > 0)
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }catch(Exception e){
            System.debug('+++'+e);
        }
      }
        
    }    
    
    public void FortyFiveminmail(Set<ID> cID){
    
        List<Case> clist = new List<Case>();
        for(List<Case> c1 : [select Owner.Name,Status, Subject,ID,OwnerId,Description ,AccountId,Type,Contact_Name__c,CreatedDate,Account_Name__c,Primary_Group_Name__c,CaseNumber,Case_Severity__c,Core_License__r.name,Case_Age__c,RecordTypeId,RecordType.Name from Case where ID IN: cID]){
            for(Case c : c1){
                if(String.valueof(c.OwnerID).substring(0,3) == '005')
                    usrID.add(c.OwnerID);
                if(String.valueof(c.OwnerID).substring(0,3) == '00G')
                    qID.add(c.OwnerID); 
            clist.add(c);  
            } 
        }
        getQueuemembers();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setOrgWideEmailAddressId('0D270000000Gmrt');
        Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
        mail1.setOrgWideEmailAddressId('0D270000000Gmrt');
        String sub;
        String body;
        String sub1;
        String body1;
    //    String[] toAddresses = new String[]{};
        
        for(Case c: clist){
         List<string> email = new List<string>(); 
         string caserecordtype=Case.sObjectType.getdescribe().getRecordTypeInfosById().get(c.recordtypeid).getname();
         string corelicense = c.Core_License__r.name;
           if(String.valueof(c.OwnerID).substring(0,3) == '005' && (!caserecordtype.containsignorecase('end user'))){
             //    toAddresses = new String[] {usr_mailid.get(c.OwnerID)};
                 email.add(usr_mailid.get(c.ownerID));
                 
                 mail.setToAddresses(email);
                 
           }else if(String.valueof(c.OwnerID).substring(0,3) == '00G' && (!caserecordtype.containsignorecase('end user'))){
                 List<String> emails = new List<String>();
                 if(retmailID(c.OwnerID) != null)
                       email.addAll(retmailID(c.OwnerID));
                   
             //    toAddresses = emails;
                 mail.setToAddresses(email); 
           }

      if(URL.getsalesforcebaseurl().toexternalform().contains('na5')||URL.getsalesforcebaseurl().toexternalform().contains('blackboard.force.com')||URL.getsalesforcebaseurl().toexternalform().containsignorecase('blackboard.my.salesforce'))
      {
           
           string Emaildistro;

           if((corelicense.containsignorecase('Learn') || corelicense.containsignorecase('CE/Vista') || corelicense.containsignorecase('Analytics')) &&  (ServiceCloudUtility__c.getInstance('Learn 45mint') != null) ){
               
               Emaildistro = ServiceCloudUtility__c.getInstance('Learn 45mint').Link__c;
               if(Emaildistro != null)
               email.add(Emaildistro);

           }
           else if(corelicense.containsignorecase('Moodlerooms') && (ServiceCloudUtility__c.getInstance('Moodlerooms 45mint') != null) ){

                Emaildistro = ServiceCloudUtility__c.getInstance('Moodlerooms 45mint').Link__c;
                if(Emaildistro != null)
                email.add(Emaildistro);
                
           }
           else if(corelicense.containsignorecase('ANGEL LMS') && (ServiceCloudUtility__c.getInstance('ANGEL LMS 45mint') != null) ){

                Emaildistro = ServiceCloudUtility__c.getInstance('ANGEL LMS 45mint').Link__c;
                if(Emaildistro != null)
                email.add(Emaildistro);
                
           }    
           else if(corelicense.containsignorecase('Xythos') && (ServiceCloudUtility__c.getInstance('Xythos 45mint') != null) ){

                 Emaildistro = ServiceCloudUtility__c.getInstance('Xythos 45mint').Link__c;
                 if(Emaildistro != null)
                 email.add(Emaildistro);
                
           }
           else if(corelicense.containsignorecase('Collaborate') && (ServiceCloudUtility__c.getInstance('Collaborate 45mint') != null) ){

                Emaildistro = ServiceCloudUtility__c.getInstance('Collaborate 45mint').Link__c;
                if(Emaildistro != null)
                email.add(Emaildistro);
                
           }
           else if(corelicense.containsignorecase('xpLor') && (ServiceCloudUtility__c.getInstance('xpLor 45mint') != null) ){

                Emaildistro = ServiceCloudUtility__c.getInstance('xpLor 45mint').Link__c;
                if(Emaildistro != null)
                email.add(Emaildistro);
           }
           
         }

         else{
           
           string Emaildistro;
           string TestEmailaddress;
             
           if( (corelicense.containsignorecase('Learn') || corelicense.containsignorecase('CE/Vista') || corelicense.containsignorecase('Analytics')) && (ServiceCloudUtility__c.getInstance('Learn 45mint') != null) && (ServiceCloudUtility__c.getInstance('Testing Email Address') != null) ){

               Emaildistro = ServiceCloudUtility__c.getInstance('Learn 45mint').Link__c +'.test';
               if(Emaildistro != null)
               email.add(Emaildistro);
               
               TestEmailaddress = ServiceCloudUtility__c.getInstance('Testing Email Address').Link__c;
               if(TestEmailaddress !=null)
               email.add(TestEmailaddress);

           }
           else if(corelicense.containsignorecase('Moodlerooms') && (ServiceCloudUtility__c.getInstance('Moodlerooms 45mint') != null) && (ServiceCloudUtility__c.getInstance('Testing Email Address') != null) ){

                Emaildistro = ServiceCloudUtility__c.getInstance('Moodlerooms 45mint').Link__c+'.test';
                if(Emaildistro != null)
                email.add(Emaildistro);

                TestEmailaddress = ServiceCloudUtility__c.getInstance('Testing Email Address').Link__c;
                if(TestEmailaddress !=null)
                email.add(TestEmailaddress);
                
           }
           else if(corelicense.containsignorecase('ANGEL LMS') && (ServiceCloudUtility__c.getInstance('ANGEL LMS 45mint') != null) && (ServiceCloudUtility__c.getInstance('Testing Email Address') != null) ){
                
                Emaildistro = ServiceCloudUtility__c.getInstance('ANGEL LMS 45mint').Link__c+'.test';
                if(Emaildistro != null)
                email.add(Emaildistro);

                TestEmailaddress = ServiceCloudUtility__c.getInstance('Testing Email Address').Link__c;
                if(TestEmailaddress !=null)
                email.add(TestEmailaddress);
                
           }    
           else if(corelicense.containsignorecase('Xythos') && (ServiceCloudUtility__c.getInstance('Xythos 45mint') != null) && (ServiceCloudUtility__c.getInstance('Testing Email Address') != null) ){
                 
                 Emaildistro = ServiceCloudUtility__c.getInstance('Xythos 45mint').Link__c+'.test';
                 if(Emaildistro != null)
                 email.add(Emaildistro);

                 TestEmailaddress = ServiceCloudUtility__c.getInstance('Testing Email Address').Link__c;
                 if(TestEmailaddress !=null)
                 email.add(TestEmailaddress);
                
           }
           else if(corelicense.containsignorecase('Collaborate') && (ServiceCloudUtility__c.getInstance('Collaborate 45mint') != null) && (ServiceCloudUtility__c.getInstance('Testing Email Address') != null) ){
                
                Emaildistro = ServiceCloudUtility__c.getInstance('Collaborate 45mint').Link__c+'.test';
                if(Emaildistro != null)
                email.add(Emaildistro);

                TestEmailaddress = ServiceCloudUtility__c.getInstance('Testing Email Address').Link__c;
                if(TestEmailaddress !=null)
                email.add(TestEmailaddress);
                
           }
           else if(corelicense.containsignorecase('xpLor') && (ServiceCloudUtility__c.getInstance('xpLor 45mint') != null) && (ServiceCloudUtility__c.getInstance('Testing Email Address') != null) ){
                
                Emaildistro = ServiceCloudUtility__c.getInstance('xpLor 45mint').Link__c+'.test';
                if(Emaildistro != null)
                email.add(Emaildistro);

                TestEmailaddress = ServiceCloudUtility__c.getInstance('Testing Email Address').Link__c;
                if(TestEmailaddress !=null)
                email.add(TestEmailaddress);
           }
         }
           mail.setToAddresses(email);
           
           //sub = 'Alert : A  ' + c.Case_Severity__c + ' Case ' + c.CaseNumber + ' has assigned to you.';
           sub ='Case #'+ c.CaseNumber+' ('+c.Status+')' +' ESCALATING to Client Support' + ' needs a response (SEV: ' + c.Case_Severity__c + ' Client: ' + c.Account_Name__c + ' - '+ c.Case_Age__c + ' Subject: ' + c.Subject + ')  **ESCALATING ALERT**';
           mail.setSubject(sub);
           body = getBody('HC7',c);
           mail.setHtmlBody(body);
           sub1 = 'Alert :  A  ' + c.Case_Severity__c + ' Case ' + c.CaseNumber + ' has assigned to you.';
           mail1.setSubject(sub);
           body1 = getBody('25000_163',c);
           mail1.setHtmlBody(body);

            Boolean check = true;
        if(email != null){
            for(Integer i=0; i<email.size(); i++){
                if(email[i] == null)
                    check = false;
            }
        }
        try{
            if(body != null && email != null && sub != null &&  check == true && email.size() > 0)
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }catch(Exception e){
            System.debug('++++'+e);
          }
      }
        
    }  
    
    public void sixtyminmail(Set<ID> cID)
    {
    List<Case> clist = new List<Case>();
        for(List<Case> c1 : [select Owner.Name,Status, Subject,ID,OwnerId,Description ,AccountId,Type,Contact_Name__c,CreatedDate,Account_Name__c,Primary_Group_Name__c,CaseNumber,Case_Severity__c,Core_License__r.Name,Case_Age__c,RecordTypeId,RecordType.Name from Case where ID IN: cID]){
            for(Case c : c1){
                if(String.valueof(c.OwnerID).substring(0,3) == '005')
                    usrID.add(c.OwnerID);
                if(String.valueof(c.OwnerID).substring(0,3) == '00G')
                    qID.add(c.OwnerID); 
            clist.add(c);  
            } 
        }
        getQueuemembers();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setOrgWideEmailAddressId('0D270000000Gmrt');
        Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
        mail1.setOrgWideEmailAddressId('0D270000000Gmrt');
        String sub;
        String body;
        String sub1;
        String body1;
     //   String[] toAddresses = new String[]{};
        
        for(Case c: clist){

           List<string> email = new List<string>();
           string corelicense;
           corelicense = c.Core_License__r.Name; 
        
           if(String.valueof(c.OwnerID).substring(0,3) == '005'){
              //   toAddresses = new String[] {usr_mailid.get(c.OwnerID)};
                 email.add(usr_mailid.get(c.ownerID));
                 
                 mail.setToAddresses(email);
           }else if(String.valueof(c.OwnerID).substring(0,3) == '00G'){
                 List<String> emails = new List<String>();
                 if(retmailID(c.OwnerID) != null)
                       email.addAll(retmailID(c.OwnerID));
                 
            //     toAddresses = emails;      
                 mail.setToAddresses(email);
           }
     if(URL.getsalesforcebaseurl().toexternalform().contains('na5')||URL.getsalesforcebaseurl().toexternalform().contains('blackboard.force.com')||URL.getsalesforcebaseurl().toexternalform().containsignorecase('blackboard.my.salesforce'))

     {
           string Emaildistro;

           if( (corelicense.containsignorecase('Learn') || corelicense.containsignorecase('CE/Vista') || corelicense.containsignorecase('Analytics')) && ServiceCloudUtility__c.getInstance('Learn 60mint') != null ){
              
               Emaildistro = ServiceCloudUtility__c.getInstance('Learn 60mint').Link__c;
               if(Emaildistro != null)
               email.add(Emaildistro);
              
           }
           else if(corelicense.containsignorecase('Moodlerooms') && ServiceCloudUtility__c.getInstance('Moodlerooms 60mint') != null ){

                Emaildistro = ServiceCloudUtility__c.getInstance('Moodlerooms 60mint').Link__c;
                if(Emaildistro != null)
                email.add(Emaildistro);
               
           }
           else if(corelicense.containsignorecase('ANGEL LMS') && ServiceCloudUtility__c.getInstance('ANGEL LMS 60mint') != null ){

                Emaildistro = ServiceCloudUtility__c.getInstance('ANGEL LMS 60mint').Link__c;
                if(Emaildistro != null)
                email.add(Emaildistro);
                
           }    
           else if(corelicense.containsignorecase('Xythos') && ServiceCloudUtility__c.getInstance('Xythos 60mint') != null ){

                 Emaildistro = ServiceCloudUtility__c.getInstance('Xythos 60mint').Link__c;
                 if(Emaildistro != null)
                 email.add(Emaildistro);
                 
           }
           else if(corelicense.containsignorecase('Collaborate') && ServiceCloudUtility__c.getInstance('Collaborate 60mint') != null ){

                Emaildistro = ServiceCloudUtility__c.getInstance('Collaborate 60mint').Link__c;
                if(Emaildistro != null)
                email.add(Emaildistro);
                
           }
           else if(corelicense.containsignorecase('xpLor') && ServiceCloudUtility__c.getInstance('xpLor 60mint') != null ){

                Emaildistro = ServiceCloudUtility__c.getInstance('xpLor 60mint').Link__c;
                if(Emaildistro != null)
                email.add(Emaildistro);
                
           }
          
        }
    
        else{
           
           string Emaildistro;
           string TestEmailaddress;

           if( (corelicense.containsignorecase('Learn') || corelicense.containsignorecase('CE/Vista') || corelicense.containsignorecase('Analytics')) && (ServiceCloudUtility__c.getInstance('Learn 60mint') != null) && (ServiceCloudUtility__c.getInstance('Testing Email Address') != null)){

               Emaildistro = ServiceCloudUtility__c.getInstance('Learn 60mint').Link__c+ '.test';
               if(Emaildistro != null)
               email.add(Emaildistro);
               
               TestEmailaddress = ServiceCloudUtility__c.getInstance('Testing Email Address').Link__c;
               if(TestEmailaddress !=null)
               email.add(TestEmailaddress);
           }
           else if(corelicense.containsignorecase('Moodlerooms') && (ServiceCloudUtility__c.getInstance('Moodlerooms 60mint') != null) && (ServiceCloudUtility__c.getInstance('Testing Email Address') != null)){

                Emaildistro = ServiceCloudUtility__c.getInstance('Moodlerooms 60mint').Link__c+ '.test';
                if(Emaildistro != null)
                email.add(Emaildistro);

                TestEmailaddress = ServiceCloudUtility__c.getInstance('Testing Email Address').Link__c;
                if(TestEmailaddress !=null)
                email.add(TestEmailaddress);
               
           }
           else if(corelicense.containsignorecase('ANGEL LMS') && (ServiceCloudUtility__c.getInstance('ANGEL LMS 60mint') != null) && (ServiceCloudUtility__c.getInstance('Testing Email Address') != null)){

                Emaildistro = ServiceCloudUtility__c.getInstance('ANGEL LMS 60mint').Link__c+ '.test';
                if(Emaildistro != null)
                email.add(Emaildistro);

                TestEmailaddress = ServiceCloudUtility__c.getInstance('Testing Email Address').Link__c;
                if(TestEmailaddress !=null)
                email.add(TestEmailaddress);
                
           }    
           else if(corelicense.containsignorecase('Xythos') && (ServiceCloudUtility__c.getInstance('Xythos 60mint') != null) && (ServiceCloudUtility__c.getInstance('Testing Email Address') != null)){

                 Emaildistro = ServiceCloudUtility__c.getInstance('Xythos 60mint').Link__c+ '.test';
                 if(Emaildistro != null)
                 email.add(Emaildistro);

                 TestEmailaddress = ServiceCloudUtility__c.getInstance('Testing Email Address').Link__c;
                 if(TestEmailaddress !=null)
                 email.add(TestEmailaddress);
                 
           }
           else if(corelicense.containsignorecase('Collaborate') && (ServiceCloudUtility__c.getInstance('Collaborate 60mint') != null) && (ServiceCloudUtility__c.getInstance('Testing Email Address') != null)){

                Emaildistro = ServiceCloudUtility__c.getInstance('Collaborate 60mint').Link__c+ '.test';
                if(Emaildistro != null)
                email.add(Emaildistro);
                
                TestEmailaddress = ServiceCloudUtility__c.getInstance('Testing Email Address').Link__c;
                if(TestEmailaddress !=null)
                email.add(TestEmailaddress);
           }
           else if(corelicense.containsignorecase('xpLor') && (ServiceCloudUtility__c.getInstance('xpLor 60mint') != null) && (ServiceCloudUtility__c.getInstance('Testing Email Address') != null)){

                Emaildistro = ServiceCloudUtility__c.getInstance('xpLor 60mint').Link__c+ '.test';
                if(Emaildistro != null)
                email.add(Emaildistro);
                
                TestEmailaddress = ServiceCloudUtility__c.getInstance('Testing Email Address').Link__c;
                if(TestEmailaddress !=null)
                email.add(TestEmailaddress);
           }
           
         }
        
           mail.setToAddresses(email);
           //sub = 'Alert : A  ' + c.Case_Severity__c + ' Case ' + c.CaseNumber + ' has assigned to you.';
           sub ='Case #'+ c.CaseNumber+' ('+c.Status+')'+' ESCALATING to Support Managers' +' needs a response (SEV: ' + c.Case_Severity__c + ' Client: ' + c.Account_Name__c + ' - '+ c.Case_Age__c + ' Subject: ' + c.Subject + ')  **ESCALATING ALERT**';
           mail.setSubject(sub);
           body = getBody('HC7',c);
           mail.setHtmlBody(body);
           sub1 = 'Alert :  A  ' + c.Case_Severity__c + ' Case ' + c.CaseNumber + ' has assigned to you.';
           mail1.setSubject(sub);
           body1 = getBody('25000_163',c);
           mail1.setHtmlBody(body);

           Boolean check = true;
        if(email != null){
            for(Integer i=0; i<email.size(); i++){
                if(email[i] == null)
                    check = false;
            }
        }
        try{
            if(body != null && email != null && sub != null &&  check == true && email.size() > 0)
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            /*if(body1 != null && toAddresses != null && sub1 != null && check == true & toAddresses.size() > 0)
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail1 });*/
        }catch(Exception e){
            System.debug('++++'+e);
        }
      } 
    }
    
    public void sendHourlyEmail(List<Case> caslist){
        
        for(Case c : caslist){
            if(c.OwnerID != null){
                if(String.valueof(c.OwnerID).substring(0,3) == '005')
                    usrID.add(c.OwnerID);
                if(String.valueof(c.OwnerID).substring(0,3) == '00G')
                    qID.add(c.OwnerID);
            }
        }
        getQueuemembers();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setOrgWideEmailAddressId('0D270000000Gmrt');
        String sub;
        String body;
        String[] toAddresses = new String[]{};
        for(Case c : caslist){
            if(c.Case_Record__c.contains('ANGEL') && c.Status == 'New'){
                 if(c.Primary_Group_Name__c == 'ANGEL - Managed Hosting'){
                    if(String.valueof(c.OwnerID).substring(0,3) == '005'){
                        toAddresses = new String[] {usr_mailid.get(c.OwnerID)};
                        mail.setToAddresses(toAddresses);
                    }else if(String.valueof(c.OwnerID).substring(0,3) == '00G'){
                        List<String> emails = new List<String>();
                        if(retmailID(c.OwnerID) != null)
                           emails.addAll(retmailID(c.OwnerID));
                        mail.setToAddresses(emails);
                     }
                     //sub = 'Case # ' + c.CaseNumber + ' Unassigned AHS SEV 1';
                     sub = 'Case #' + c.CaseNumber + ' needs a response (SEV: ' + c.Case_Severity__c + ' Client: ' + c.Account_Name__c + ' - '+ c.Case_Age__c + ' Subject: ' + c.Subject + ')  **ESCALATING ALERT**';
                     mail.setSubject(sub);
                     body = getBody('HC7',c);
                     mail.setHtmlBody(body);
                 }else if(c.Case_Severity__c == '1'){
                     if(String.valueof(c.OwnerID).substring(0,3) == '005'){
                        toAddresses = new String[] {usr_mailid.get(c.OwnerID)};
                        mail.setToAddresses(toAddresses);
                     }else if(String.valueof(c.OwnerID).substring(0,3) == '00G'){
                        List<String> emails = new List<String>();
                        if(retmailID(c.OwnerID) != null)
                           emails.addAll(retmailID(c.OwnerID));
                       
                        toAddresses = emails;
                        mail.setToAddresses(emails);
                     }
                     //sub = 'Case # ' + c.CaseNumber + ' Unassigned SEV 1 Case';
                     sub = 'Case #' + c.CaseNumber + ' needs a response (SEV: ' + c.Case_Severity__c + ' Client: ' + c.Account_Name__c + ' - '+ c.Case_Age__c + ' Subject: ' + c.Subject + ')  **ESCALATING ALERT**';
                     mail.setSubject(sub);
                     body = getBody('HC7',c);
                     mail.setHtmlBody(body);
                }
            }
        }
        Boolean check = true;
        if(toAddresses != null){
            for(Integer i=0; i<toAddresses.size(); i++){
                if(toAddresses[i] == null)
                    check = false;
            }
        }
        try{
            if(body != null && toAddresses != null && sub != null && check == true)
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }catch(Exception e){
            System.debug('++++'+e);
        }
    }
  
    
    public String getBody(String emailno,Case c){
        String body;
        if(emailno == '19'){
            body = '<br/> Since we have not had an update to the case we are placing it in closed status at this time.  You may re-open the case if needed.<br/><br/> Thank you,<br/><br/> Blackboard Support' +
                   '<br/> CASE : ' + c.CaseNumber +
                   '<br/> Company : ' + c.Account_Name__c + 
                   '<br/> Contact : ' + c.Contact_Name__c +
                   //'<br/> Case Summary : ' + c.Description + 
                   '<br/> Case Summary : ' + c.Subject + 
                   '<br/> Case Severity : ' + c.Case_Severity__c + 
                   '<br/> Case Status : ' + c.Status + 
                   '<br/> http://blackboard.force.com/btbb_caseview?id=' + c.ID; 
        }else if(emailno == 'EU19'){
            body = '<br/> Since we have not had an update to the case we are placing it in closed status at this time. You may re-open the case if needed by replying to this email.<br/><br/> Thank you,<br/><br/> Blackboard Support' +
                   '<br/> CASE : ' + c.CaseNumber + 
                   '<br/> Company : ' + c.Account_Name__c + 
                   '<br/> Contact : ' + c.Contact_Name__c +
                   '<br/> Case Summary : ' + c.Subject + 
                   '<br/> Case Status : ' + c.Status;
        }else if(emailno == '16'){
            body = '<br/> Your case has been in pending status for a couple of days.  We hope that you can provide us the information we requested so that we can solve your issue quickly. <br/><br/> Thank you.' +
                   '<br/> CASE : ' + c.CaseNumber + 
                   '<br/> Company : ' + c.Account_Name__c + 
                   '<br/> Contact : ' + c.Contact_Name__c +
                   '<br/> Case Summary : ' + c.Subject + 
           //      '<br/> Case Summary : ' + c.Description +      TP2766 
                   '<br/> Case Severity : ' + c.Case_Severity__c + 
                   '<br/> Case Status : ' + c.Status +
                   '<br/> http://blackboard.force.com/btbb_caseview?id=' + c.ID; 
        }else if(emailno == 'EU16'){
            body = '<br/> Your case has been in pending status for a couple of days. We hope that you can provide us the information we requested so that we can solve your issue quickly.  Please refer to the information requested in our last email to you.  You can reply either to this email or to the earlier email.  If you are unable to reply by email or prefer to talk with one of our Support professionals, please either call 877-382-2293 or initiate a Live Chat session by navigating to http://blackboard.force.com/btbb_publichome.'+' <br/><br/> Thank you,<br/>Blackboard Client Support.' +
                   '<br/> CASE : ' + c.CaseNumber + 
                   '<br/> Company : ' + c.Account_Name__c + 
                   '<br/> Contact : ' + c.Contact_Name__c +
                   '<br/> Case Summary : ' + c.Subject + 
                   '<br/> Case Status : ' + c.Status; 
        }else if(emailno == '20'){
            body = '<br/> We are changing the status of this case to closed as it has not been updated to accept solution.  You may re-open case if required.<br/><br/> Thank you, <br/><br/> Blackboard Support' +
                   '<br/> CASE : '+ c.CaseNumber + 
                   '<br/> Company : ' + c.Account_Name__c+
                   '<br/> Contact : ' + c.Contact_Name__c +
                   '<br/> Case Summary : ' + c.Description + 
                   '<br/> Case Severity: ' + c.Case_Severity__c + 
                   '<br/> Case Status : ' + c.Status +
                   '<br/> http://blackboard.force.com/btbb_caseview?id=' + c.ID; 
        }else if(emailno == 'EU20'){
            body = '<br/> We are changing the status of this case to closed as it has not been updated to accept solution.  You may re-open case if required.<br/><br/> Thank you, <br/><br/> Blackboard Support' +
                   '<br/> CASE : ' + c.CaseNumber + 
                   '<br/> Company : ' + c.Account_Name__c + 
                   '<br/> Contact : ' + c.Contact_Name__c +
                   '<br/> Case Summary : ' + c.Subject + 
                   '<br/> Case Status : ' + c.Status; 
        }
        else if(emailno == '21'){
            body = '<br/> This premium support case is in NEW status and has not been acknowledged.  Please update case and let the Premium support team know.<br/>' +
                   '<br/> CASE : ' + c.CaseNumber +
                   '<br/> Company : ' + c.Account_Name__c+ 
                   '<br/> Contact : ' + c.Contact_Name__c +
                   '<br/> Case Summary : '+ c.Description +
                   '<br/> Case Severity : '+c.Case_Severity__c +
                   '<br/> Case Status : ' +c.Status + 
                   '<br/> http://blackboard.force.com/btbb_caseview?id=' + c.ID; 
        }else if(emailno == '23'){
            body = '<br/> This case is assigned to the AHS provider group but is still in NEW status.<br/>' +
                   '<br/> CASE : '+ c.caseNumber +
                   '<br/> Company : ' + c.Account_Name__c +
                   '<br/> Contact : ' + c.Contact_Name__c +
                   '<br/> Case Summary : ' + c.Description +
                   '<br/> Case Severity: ' + c.Case_Severity__c +
                   '<br/> Case Status:  ' + c.Status;
        }else if(emailno == '22'){
             body = '<br/>This case is in NEW status' + 
                    '<br/>Case : ' + c.CaseNumber +
                    '<br/>Company : ' + c.Account_Name__c + 
                    '<br/>Contact : ' + c.Contact_Name__c + 
                    '<br/>Case Summary :  ' + c.Description +
                    '<br/>Case Severity : ' + c.Case_Severity__c + 
                    '<br/>Case Status : ' + c.Status ;
        }else if(emailno == '24'){
            body = '<br/>Premium Support Case Created CASE - '+ c.CaseNumber + 
                   '<br/>Alert Case Id : ' + c.CaseNumber + 
                   '<br/>Company : ' + c.Account_Name__c + 
                   '<br/>Contact : ' + c.Contact_Name__c + 
                   '<br/>Case Summary :  ' + c.Description +
                   '<br/>Case Severity : ' + c.Case_Severity__c + 
                   '<br/>Case Status : ' + c.Status ;
        }else if(emailno == '6'){
             body = '<br/>AHS Case : ' + c.CaseNumber +  
                    '<br/>Alert Case Id : ' + c.CaseNumber + 
                    '<br/>Company : ' + c.Account_Name__c + 
                    '<br/>Contact : ' + c.Contact_Name__c + 
                    '<br/>Case Summary :  ' + c.Description +
                    '<br/>Case Severity : ' + c.Case_Severity__c + 
                    '<br/>Case Status : ' + c.Status ;
        }else if(emailno == 'NA'){
             body = '<br/>Case : ' + c.CaseNumber +  
                    '<br/>Alert Case Id : ' + c.CaseNumber + 
                    '<br/>Company : ' + c.Account_Name__c + 
                    '<br/>Contact : ' + c.Contact_Name__c + 
                    '<br/>Case Summary :  ' + c.Description +
                    '<br/>Case Severity : ' + c.Case_Severity__c + 
                    '<br/>Case Status : ' + c.Status ;
        }else if(emailno =='7'){
            body = '<br/>AHS SEV 1 -  '+ c.CaseNumber +  
                   '<br/>Alert Case Id : ' + c.CaseNumber + 
                   '<br/>Company : ' + c.Account_Name__c + 
                   '<br/>Contact : ' + c.Contact_Name__c + 
                   '<br/>Case Summary :  ' + c.Description +
                   '<br/>Case Severity : ' + c.Case_Severity__c + 
                   '<br/>Case Status : ' + c.Status ;
                      
         }else if(emailno =='11'){
            body = '<br/>AHS Escalated CASE - '+ c.CaseNumber + 
                   '<br/>Alert Case Id : ' + c.CaseNumber + 
                   '<br/>Company : ' + c.Account_Name__c + 
                   '<br/>Contact : ' + c.Contact_Name__c + 
                   '<br/>Case Summary :  ' + c.Description +
                   '<br/>Case Severity : ' + c.Case_Severity__c + 
                   '<br/>Case Status : ' + c.Status ;
          }else if(emailno =='15'){
            body = '<br/>SS SEV 1 CASE - '+ c.CaseNumber + 
                   '<br/>Alert Case Id : ' + c.CaseNumber  + 
                   '<br/>Company : ' + c.Account_Name__c + 
                   '<br/>Contact : ' + c.Contact_Name__c + 
                   '<br/>Case Summary :  ' + c.Description +
                   '<br/>Case Severity : ' + c.Case_Severity__c + 
                   '<br/>Case Status : ' + c.Status +
                   '<br/>Case Age : ' + c.Case_Age__c ;
          }else if(emailno =='10'){
            body = '<br/>T-3 Needs Attention - '+ c.CaseNumber  + 
                   '<br/>Alert Case Id : ' + c.CaseNumber + 
                   '<br/>Company : ' + c.Account_Name__c + 
                   '<br/>Contact : ' + c.Contact_Name__c + 
                   '<br/>Case Summary :  ' + c.Description +
                   '<br/>Case Severity : ' + c.Case_Severity__c + 
                   '<br/>Case Status : ' + c.Status ;
          }else if(emailno =='8'){
            body = '<br/>T-3 Escalated CASE  - '+ c.CaseNumber + 
                   '<br/>Alert Case Id : ' + c.CaseNumber + 
                   '<br/>Company : ' + c.Account_Name__c + 
                   '<br/>Contact : ' + c.Contact_Name__c + 
                   '<br/>Case Summary :  ' + c.Description +
                   '<br/>Case Severity : ' + c.Case_Severity__c + 
                   '<br/>Case Status : ' + c.Status +
                   '<br/>Case Age : ' + c.Case_Age__c ;
          }else if(emailno =='5'){
            body = '<br/>Consulting  CASE  - '+ c.CaseNumber + 
                   '<br/>Alert Case Id : ' + c.CaseNumber + 
                   '<br/>Company : ' + c.Account_Name__c + 
                   '<br/>Contact : ' + c.Contact_Name__c + 
                   '<br/>Case Summary :  ' + c.Description +
                   '<br/>Case Severity : ' + c.Case_Severity__c + 
                   '<br/>Case Status : ' + c.Status ;
          }else if(emailno =='9'){
            body = '<br/>Consulting Escalated CASE - '+ c.CaseNumber + 
                   '<br/>Alert Case Id : ' + c.CaseNumber + 
                   '<br/>Company : ' + c.Account_Name__c + 
                   '<br/>Contact : ' + c.Contact_Name__c + 
                   '<br/>Case Summary :  ' + c.Description +
                   '<br/>Case Severity : ' + c.Case_Severity__c + 
                   '<br/>Case Status : ' + c.Status ;
          }else if(emailno =='25000_161'){
            body = '<br/>Thank you for contacting Client Support.  Your request has been received and will be routed to the appropriate technical support representative.<br/><br/>' +
                   '<br/>Case Id : ' + c.CaseNumber + 
                   '<br/>Case Summary :  ' + c.Description +
                   '<br/><br/>If you have questions about the status of this request please either visit http://blackboard.force.com/btbb_caseview?id=' + c.ID + '  or call our Client Support organization (https://blackboard.secure.force.com/btbb_articleview?id=50170000000Wc5uAAC).';
          }else if(emailno =='25000_162'){
            body = '<br/> Thank you for contacting Xythos Support.  Your request has been received and will be routed to the appropriate technical support representative.' +
                   '<br/>Case Id : ' + c.CaseNumber + 
                   '<br/>Case Summary :  ' + c.Description +
                   '<br/><br/>If you have questions about the status of this request please either visit http://blackboard.force.com/btbb_caseview?id=' + c.Id + 'or call Xythos Support (http://www.xythos.com/about/contact_support.html)';
          }else if(emailno =='25000_163'){ 
            body = '<br/> Alert : A' + c.Case_Severity__c + 'Case' + c.CaseNumber + 'has assigned to you' + 
                   '<br/>Provider Group Id: ' + c.Primary_Group_Name__c +
                   '<br/>Created at:' + ((c.CreatedDate != null)?c.CreatedDate.formatGMT('yyyy-MM-dd hh:mm'):'') + 'GMT' +
                   '<br/> Case Id: ' + c.CaseNumber +  
                   '<br/>Client Segment: ' + Account.Customer_Level__c +
                   '<br/>Customer Name:' + c.Account_Name__c +
                   '<br/>Customer Id:' + c.AccountId +
                   '<br/>Contact:' + c.Contact_Name__c +
                   '<br/>Severity: ' + c.Case_Severity__c +
                   '<br/>Case Type: ' + c.Type +
                   '<br/>Summary: ' + c.Description +
                   '<br/>Description:' + c.Description ;
          }else if(emailno =='HC1'){
            body = '<br/> Alert : A' + c.Case_Severity__c + 'Case' + c.CaseNumber + 'has assigned to you' + 
                   '<br/>Provider Group Id: ' + c.Primary_Group_Name__c +
                   '<br/>Created at:' + ((c.CreatedDate != null)?c.CreatedDate.formatGMT('yyyy-MM-dd hh:mm'):'') + 'GMT' +
                   '<br/> Case Id: ' + c.CaseNumber +  
                   '<br/>Client Segment: ' + Account.Customer_Level__c +
                   '<br/>Customer Name:' + c.Account_Name__c +
                   '<br/>Customer Id:' + c.AccountId +
                   '<br/>Contact:' + c.Contact_Name__c +
                   '<br/>Severity: ' + c.Case_Severity__c +
                   '<br/>Case Type: ' + c.Type +
                   '<br/>Summary: ' + c.Description +
                   '<br/>Description:' + c.Description ;
           }else if(emailno =='HC2'){
             body = '<br/> Alert : A' + c.Case_Severity__c + 'Case' + c.CaseNumber + 'has assigned to you' + 
                    '<br/>Provider Group Id: ' + c.Primary_Group_Name__c +
                    '<br/>Created at:' + ((c.CreatedDate != null)?c.CreatedDate.formatGMT('yyyy-MM-dd hh:mm'):'') + 'GMT' +
                    '<br/> Case Id: ' + c.CaseNumber +  
                    '<br/>Client Segment: ' + Account.Customer_Level__c +
                    '<br/>Customer Name:' + c.Account_Name__c +
                    '<br/>Customer Id:' + c.AccountId +
                    '<br/>Contact:' + c.Contact_Name__c +
                    '<br/>Severity: ' + c.Case_Severity__c +
                    '<br/>Case Type: ' + c.Type +
                    '<br/>Summary: ' + c.Description +
                    '<br/>Description:' + c.Description ;
           }else if(emailno =='HC3'){
             body = '<br/> Alert : A' + c.Case_Severity__c + 'Case' + c.CaseNumber + 'has assigned to you' + 
                    '<br/>Provider Group Id: ' + c.Primary_Group_Name__c +
                    '<br/>Created at:' + ((c.CreatedDate != null)?c.CreatedDate.formatGMT('yyyy-MM-dd hh:mm'):'') + 'GMT' +
                    '<br/> Case Id: ' + c.CaseNumber +  
                    '<br/>Client Segment: ' + Account.Customer_Level__c +
                    '<br/>Customer Name:' + c.Account_Name__c +
                    '<br/>Customer Id:' + c.AccountId +
                    '<br/>Contact:' + c.Contact_Name__c +
                    '<br/>Severity: ' + c.Case_Severity__c +
                    '<br/>Case Type: ' + c.Type +
                    '<br/>Summary: ' + c.Description +
                    '<br/>Description:' + c.Description ;              
           }else if(emailno =='HC4'){
             body = '<br/> Alert  : A' + c.Case_Severity__c + 'Case' + c.CaseNumber + 'has assigned to you' + 
                    '<br/>Provider Group Id: ' + c.Primary_Group_Name__c +
                    '<br/>Created at:' + ((c.CreatedDate != null)?c.CreatedDate.formatGMT('yyyy-MM-dd hh:mm'):'') + 'GMT' +
                    '<br/> Case Id: ' + c.CaseNumber +  
                    '<br/>Client Segment: ' + Account.Customer_Level__c +
                    '<br/>Customer Name:' + c.Account_Name__c +
                    '<br/>Customer Id:' + c.AccountId +
                    '<br/>Contact:' + c.Contact_Name__c +
                    '<br/>Severity: ' + c.Case_Severity__c +
                    '<br/>Case Type: ' + c.Type +
                    '<br/>Summary: ' + c.Description +
                    '<br/>Description:' + c.Description ; 
           }else if(emailno =='HC5'){
             body = '<br/> Alert' + c.Case_Severity__c + 'Case' + c.CaseNumber + 'has been placed after hours' + c.Id +  
                    '<br/>Case Id:' + c.CaseNumber +
                    '<br/>Severity: ' + c.Case_Severity__c +
                    '<br/>Date/Time Placed:' + ((c.CreatedDate != null)?c.CreatedDate.formatGMT('yyyy-MM-dd hh:mm'):'') + 'GMT' +
                    '<br/>Customer Name:' + c.Account_Name__c +
                    '<br/>Customer Id:' + c.AccountId +
                    '<br/>Provider Group Id: ' + c.Primary_Group_Name__c +
                    '<br/>Contact:' + c.Contact_Name__c +
                    '<br/>Contact Phone:' + c.SuppliedPhone +
                    '<br/>Contact Email:' + c.SuppliedEmail +
                    '<br/>Case Type: ' + c.Type +
                    '<br/>Case Summary: ' + c.Description ;
           }else if(emailno =='HC6'){
             body = '<br/> Alert' + c.Case_Severity__c + 'Case' + c.CaseNumber + 'has been placed after hours' + c.Id +  
                    '<br/>Case Id:' + c.CaseNumber +
                    '<br/>Severity: ' + c.Case_Severity__c +
                    '<br/>Date/Time Placed:' + ((c.CreatedDate != null)?c.CreatedDate.formatGMT('yyyy-MM-dd hh:mm'):'') + 'GMT' +
                    '<br/>Customer Name:' + c.Account_Name__c +
                    '<br/>Customer Id:' + c.AccountId +
                    '<br/>Provider Group Id: ' + c.Primary_Group_Name__c +
                    '<br/>Contact:' + c.Contact_Name__c +
                    '<br/>Contact Phone:' + c.SuppliedPhone +
                    '<br/>Contact Email:' + c.SuppliedEmail +
                    '<br/>Case Type: ' + c.Type +
                    '<br/>Case Summary: ' + c.Description ;
           }else if(emailno =='HC7'){
               body = '<br/> *** CASE NEEDS A RESPONSE *** '+
                    '<br/>Case #:' +  c.CaseNumber +
                    '<br/>Core License: '+c.Core_License__r.Name+
                    '<br/>Case Status: '+c.Status+
                    '<br/>Contact:' + c.Contact_Name__c +
                    '<br/>Client:' + c.Account_Name__c +
                    '<br/>Severity: ' + c.Case_Severity__c +
                    '<br/>Case Age : ' + c.Case_Age__c +
                    '<br/>Subject: '+ c.Subject +
                    '<br/>Case Owner: '+ c.Owner.Name +
                    '<br/>Primary Group: '+c.Primary_Group_Name__c+
                    '<br/>Created at:' + ((c.CreatedDate != null)?c.CreatedDate.formatGMT('yyyy-MM-dd hh:mm'):'') + 'GMT' +
                    '<br/><p>Sev1 cases must be responded to within 1 hour, and Sev2 cases within 4 hours.Please be sure to respond promptly to this high severity case.'+
                    '<br/><p>If the case owner is not an individual, please ensure that someone within the primary group takes on the case.'+
                    '<br/><p>If you are not the case owner and are receiving this email, at least 30 minutes have passed since the case was created without anyone taking ownership and responding to the case.'+
                    '<br/><p>If you are a manager receiving this mail, at least 45 minutes have passed since the creation of this case without anyone responding to it. </p>' +
                    '<br/>**************************************************** ' +
                    '<br/>' + c.Description + 
                    '<br/>**************************************************** '+
                    '<br/>Click on the link to access the case: ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + c.Id;
             /*body = '<br/> Alert : A ' + c.Case_Severity__c + ' Case ' + c.CaseNumber + ' has assigned to you' + 
                    '<br/>Provider Group Id: ' + c.Primary_Group_Name__c +
                    '<br/>Created at:' + ((c.CreatedDate != null)?c.CreatedDate.formatGMT('yyyy-MM-dd hh:mm'):'') + 'GMT' +
                    '<br/> Case Id: ' + c.CaseNumber +  
                    '<br/>Customer Name:' + c.Account_Name__c +
                    '<br/>Customer Id:' + c.AccountId +
                    '<br/>Contact:' + c.Contact_Name__c +
                    '<br/>Severity: ' + c.Case_Severity__c +
                    '<br/>Case Type: ' + c.Type +
                    '<br/>Summary: ' + c.Description +
                    '<br/>Description:' + c.Description ; */
          }else if(emailno =='HC8'){
          body = '<br/> *** CASE NEEDS A RESPONSE *** '+
                    '<br/>Case #:' +  c.CaseNumber +
                    '<br/>Contact:' + c.Contact_Name__c +
                    '<br/>Client:' + c.Account_Name__c +
                    '<br/>Severity: ' + c.Case_Severity__c +
                    '<br/>Subject:'+ c.Subject +
                    '<br/>Case Owner: '+ c.Owner.Name +
                    '<br/>Primary Group: '+c.Primary_Group_Name__c+
                    '<br/>Created at:' + ((c.CreatedDate != null)?c.CreatedDate.formatGMT('yyyy-MM-dd hh:mm'):'') + 'GMT' +
                    '<br/><p>Sev1 cases must be responded to within 1 hour, and Sev2 cases within 4 hours.Please be sure to respond promptly to this high severity case.'+
                    '<br/><p>If the case owner is not an individual, please ensure that someone within the primary group takes on the case.'+
                    '<br/><p>If you are not the case owner and are receiving this email, at least 30 minutes have passed since the case was created without anyone taking ownership and responding to the case.'+
                    '<br/><p>If you are a manager receiving this mail, at least 45 minutes have passed since the creation of this case without anyone responding to it.</p> ' +
                    
                    '<br/>**************************************************** ' +
                    '<br/>' + c.Description +
                    '<br/>**************************************************** '+
                    '<br/>Click on the link to access the case: ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + c.Id;
            /*body = '<br/> Alert : A ' + c.Case_Severity__c + ' Case ' + c.CaseNumber + ' has assigned to you' + 
                   '<br/>Provider Group Id: ' + c.Primary_Group_Name__c +
                   '<br/>Created at:' + ((c.CreatedDate != null)?c.CreatedDate.formatGMT('yyyy-MM-dd hh:mm'):'') + 'GMT' +
                   '<br/> Case Id: ' + c.CaseNumber +  
                   '<br/>Customer Name:' + c.Account_Name__c +
                   '<br/>Customer Id:' + c.AccountId +
                   '<br/>Contact:' + c.Contact_Name__c +
                   '<br/>Severity: ' + c.Case_Severity__c +
                   '<br/>Case Type: ' + c.Type +
                   '<br/>Summary: ' + c.Description +
                   '<br/>Description:' + c.Description ; */
          }else if(emailno =='HC9'){
            body = '<br/>Client Support has closed case '  + c.Id +
                   '<br/>Case Details:' + c.Description +
                   '<br/> Case Id: ' + c.CaseNumber +  
                   '<br/>Summary: ' + c.Description +
                   '<br/>Description:' + c.Description +
                   '<br/>instprodid:' + Asset.Product_ID__c +
                   '<br/>custid:' + c.AccountId +
                   '<br/>personid: ' + User.Person_Id__c ;
          }else if(emailno =='Escal'){
              body = '<br/>The following case has been escalated to a Tier 2 member of the Client Support team.  A Client Support Engineer will review your case and follow up with you directly with any additional questions, a status update or an immediate resolution.'+
                   '<br/><br/>Case ID:' + c.Casenumber +
                   '<br/>Case Age : ' + c.Case_Age__c +
                   '<br/> Case Summary: ' + c.Subject +
                   '<br/><br/>' + c.Description +
                   '<br/><br/> If you have questions about the status of this request please either visit http://blackboard.force.com/btbb_caseview?id='+c.ID + ' or call our Client Support organization (https://blackboard.secure.force.com/btbb_articleview?id=50170000000Wc5uAAC).';
          }else if(emailno =='Reopened'){
              body = '<br/>The following Client Support case has been re-opened:'+
                   '<br/><br/>Case ID:' + c.Casenumber +
                   '<br/> Case Summary: ' + c.Subject +
                   '<br/><br/>' + c.Reopen_comment__c  +
                   '<br/><br/> If you have questions about the status of this request please either visit http://blackboard.force.com/btbb_caseview?id='+c.ID + ' or call our Client Support organization (https://blackboard.secure.force.com/btbb_articleview?id=50170000000Wc5uAAC).';
          } 
         else if(emailno=='clientcomment')
         {
          body='<br/><br/>'+'Case Details:'+
                '<br/><br/>'+'<p>'+'Case ID: '+c.casenumber+
                '<br/>'+'Contact: '+c.Contact.Name+
                '<br/>'+'Client: '+c.Account.Name+  
                '<br/>'+'Case Status: '+c.Status+ 
                '<br/>'+'Case Summary: '+c.subject+
                
                
                
                
                '<br/><br/>'+'Client Comment:<br/>'+
                c.AssignTo_Comment__c;
         } 
      return body;
   }
   
/*  static testmethod void Non_Time_based_Alerts_test(){
   
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
    ntb.sixtyminmail(casID);
    ntb.sendHourlyEmail(caselist);
    ntb.Thirtyminmail(casID);

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
   }  */
     
}
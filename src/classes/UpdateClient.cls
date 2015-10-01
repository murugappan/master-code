global class UpdateClient{

    Webservice static String redirect(String CaseID,String con){
        ID cID;
        Case c;
        List<EmailMessage> e = new List<EmailMessage>();
        cID = CaseID; 
        c = [select ID,ContactId from Case where ID =: cID];
        e = [Select ParentId,Id,CcAddress,ToAddress,LastModifiedDate,BccAddress From EmailMessage where ParentID =: cID ORDER By LastModifiedDate DESC Limit 1]; 
        EmailTemplate et = [select ID,Name from EmailTemplate where Name =: 'BBW_CustomerUpdate' limit 1];
        String s;
        if(e.size() != 0){
            if(con == 'FALSE'){
                if(e[0].ToAddress != null && e[0].CcAddress == null && e[0].BccAddress == null) 
                    s = '/_ui/core/email/author/EmailAuthor?retURL=/'+c.Id+'&p26=support@blackboard.com&p3_lkid='+c.Id+'&rtype=003&p2_lkid='+c.ContactId+'&template_id='+et.ID+'&p24='+e[0].ToAddress;
                else if(e[0].ToAddress == null && e[0].CcAddress != null && e[0].BccAddress == null) 
                    s = '/_ui/core/email/author/EmailAuthor?retURL=/'+c.Id+'&p26=support@blackboard.com&p3_lkid='+c.Id+'&rtype=003&p2_lkid='+c.ContactId+'&template_id='+et.ID+'&p4='+e[0].CcAddress;
                else if(e[0].ToAddress == null && e[0].CcAddress == null && e[0].BccAddress != null) 
                    s = '/_ui/core/email/author/EmailAuthor?retURL=/'+c.Id+'&p26=support@blackboard.com&p3_lkid='+c.Id+'&rtype=003&p2_lkid='+c.ContactId+'&template_id='+et.ID+'&p5='+e[0].BccAddress;
                else if(e[0].ToAddress != null && e[0].CcAddress != null && e[0].BccAddress == null) 
                    s = '/_ui/core/email/author/EmailAuthor?retURL=/'+c.Id+'&p26=support@blackboard.com&p3_lkid='+c.Id+'&rtype=003&p2_lkid='+c.ContactId+'&template_id='+et.ID+'&p24='+e[0].ToAddress+'&p4='+e[0].CcAddress;
                else if(e[0].ToAddress != null && e[0].CcAddress == null && e[0].BccAddress != null) 
                   s = '/_ui/core/email/author/EmailAuthor?retURL=/'+c.Id+'&p26=support@blackboard.com&p3_lkid='+c.Id+'&rtype=003&p2_lkid='+c.ContactId+'&template_id='+et.ID+'&p24='+e[0].ToAddress+'&p5='+e[0].BccAddress;
                else if(e[0].ToAddress == null && e[0].CcAddress != null && e[0].BccAddress != null) 
                    s = '/_ui/core/email/author/EmailAuthor?retURL=/'+c.Id+'&p26=support@blackboard.com&p3_lkid='+c.Id+'&rtype=003&p2_lkid='+c.ContactId+'&template_id='+et.ID+'&p4='+e[0].CcAddress+'&p5='+e[0].BccAddress;
                else 
                    s = '/_ui/core/email/author/EmailAuthor?retURL=/'+c.Id+'&p26=support@blackboard.com&p3_lkid='+c.Id+'&rtype=003&p2_lkid='+c.ContactId+'&template_id='+et.ID+'&p24='+e[0].ToAddress+'&p4='+e[0].CcAddress+'&p5='+e[0].BccAddress;
            }else if(con == 'TRUE'){
                if(e[0].ToAddress != null && e[0].CcAddress == null && e[0].BccAddress == null) 
                    s = '/_ui/core/email/author/EmailAuthor?isdtp=vw&retURL=/'+c.Id+'&p26=support@blackboard.com&p3_lkid='+c.Id+'&rtype=003&p2_lkid='+c.ContactId+'&template_id='+et.ID+'&p24='+e[0].ToAddress;
                else if(e[0].ToAddress == null && e[0].CcAddress != null && e[0].BccAddress == null) 
                    s = '/_ui/core/email/author/EmailAuthor?isdtp=vw&retURL=/'+c.Id+'&p26=support@blackboard.com&p3_lkid='+c.Id+'&rtype=003&p2_lkid='+c.ContactId+'&template_id='+et.ID+'&p4='+e[0].CcAddress;
                else if(e[0].ToAddress == null && e[0].CcAddress == null && e[0].BccAddress != null) 
                    s = '/_ui/core/email/author/EmailAuthor?isdtp=vw&retURL=/'+c.Id+'&p26=support@blackboard.com&p3_lkid='+c.Id+'&rtype=003&p2_lkid='+c.ContactId+'&template_id='+et.ID+'&p5='+e[0].BccAddress;
                else if(e[0].ToAddress != null && e[0].CcAddress != null && e[0].BccAddress == null) 
                    s = '/_ui/core/email/author/EmailAuthor?isdtp=vw&retURL=/'+c.Id+'&p26=support@blackboard.com&p3_lkid='+c.Id+'&rtype=003&p2_lkid='+c.ContactId+'&template_id='+et.ID+'&p24='+e[0].ToAddress+'&p4='+e[0].CcAddress;
                else if(e[0].ToAddress != null && e[0].CcAddress == null && e[0].BccAddress != null) 
                   s = '/_ui/core/email/author/EmailAuthor?isdtp=vw&retURL=/'+c.Id+'&p26=support@blackboard.com&p3_lkid='+c.Id+'&rtype=003&p2_lkid='+c.ContactId+'&template_id='+et.ID+'&p24='+e[0].ToAddress+'&p5='+e[0].BccAddress;
                else if(e[0].ToAddress == null && e[0].CcAddress != null && e[0].BccAddress != null) 
                    s = '/_ui/core/email/author/EmailAuthor?isdtp=vw&retURL=/'+c.Id+'&p26=support@blackboard.com&p3_lkid='+c.Id+'&rtype=003&p2_lkid='+c.ContactId+'&template_id='+et.ID+'&p4='+e[0].CcAddress+'&p5='+e[0].BccAddress;
                else 
                    s = '/_ui/core/email/author/EmailAuthor?isdtp=vw&retURL=/'+c.Id+'&p26=support@blackboard.com&p3_lkid='+c.Id+'&rtype=003&p2_lkid='+c.ContactId+'&template_id='+et.ID+'&p24='+e[0].ToAddress+'&p4='+e[0].CcAddress+'&p5='+e[0].BccAddress;
            }
        }else
            if(con == 'FALSE')
                s = '/_ui/core/email/author/EmailAuthor?retURL=/'+c.Id+'&p3_lkid='+c.Id+'&p26=support@blackboard.com&rtype=003&p2_lkid='+c.ContactId+'&template_id='+et.ID;
            else
                s = '/_ui/core/email/author/EmailAuthor?isdtp=vw&retURL=/'+c.Id+'&p26=support@blackboard.com&p3_lkid='+c.Id+'&rtype=003&p2_lkid='+c.ContactId+'&template_id='+et.ID;            
        return s;
    }
    
    static testmethod void UpdateClienttest(){
    
    Account ac = TestMethodUtility.createAccount();
    insert ac;
    
    Contact c1 = TestMethodUtility.createContact(ac);
    insert c1;
    
    Core_License__c cr =TestMethodUtility.createCoreLicense();
    cr.Name = 'ANGEL';
    insert cr;    
    
    Asset aset = TestMethodUtility.createAsset(ac,cr);
    insert aset;
    
    List<Case> lcase =new List<case>();
  
  //below inserted 6 cases for  6-different Email messages      
    
    Case cassoftsol =TestMethodUtility.createCase1(ac,aset);       
    cassoftsol.ContactID = c1.ID;
    cassoftsol.Case_Severity__c = '1';
    cassoftsol.Subject = 'test';
    cassoftsol.Description = 'test';
    lcase.add(cassoftsol);
    
    Case cassoftsol1 =TestMethodUtility.createCase1(ac,aset);       
    cassoftsol1.ContactID = c1.ID;
    cassoftsol1.Case_Severity__c = '1';
    cassoftsol1.Subject = 'test';
    cassoftsol1.Description = 'test';
    lcase.add(cassoftsol1);
    
    Case cassoftsol2 =TestMethodUtility.createCase1(ac,aset);       
    cassoftsol2.ContactID = c1.ID;
    cassoftsol2.Case_Severity__c = '1';
    cassoftsol2.Subject = 'test';
    cassoftsol2.Description = 'test';
    lcase.add(cassoftsol2);
    
    Case cassoftsol3 =TestMethodUtility.createCase1(ac,aset);       
    cassoftsol3.ContactID = c1.ID;
    cassoftsol3.Case_Severity__c = '1';
    cassoftsol3.Subject = 'test';
    cassoftsol3.Description = 'test';
    lcase.add(cassoftsol3);
    
    Case cassoftsol4 =TestMethodUtility.createCase1(ac,aset);       
    cassoftsol4.ContactID = c1.ID;
    cassoftsol4.Case_Severity__c = '1';
    cassoftsol4.Subject = 'test';
    cassoftsol4.Description = 'test';
    lcase.add(cassoftsol4);
    
    Case cassoftsol5 =TestMethodUtility.createCase1(ac,aset);       
    cassoftsol5.ContactID = c1.ID;
    cassoftsol5.Case_Severity__c = '1';
    cassoftsol5.Subject = 'test';
    cassoftsol5.Description = 'test';
    lcase.add(cassoftsol5);
    
    Case cassoftsol6 =TestMethodUtility.createCase1(ac,aset);       
    cassoftsol6.ContactID = c1.ID;
    cassoftsol6.Case_Severity__c = '1';
    cassoftsol6.Subject = 'test';
    cassoftsol6.Description = 'test';
    lcase.add(cassoftsol6);
    
    Insert lcase;
    
    List<EmailMessage> lem = new List<EmailMessage>();
    
    
// Email message where CcAddress and BccAddress is null
    
    EmailMessage em = new EmailMessage();
    em.ParentId = cassoftsol.ID;
    em.ToAddress = 'abc@test.com';
    em.subject = 'Suggest Solution';
    lem.add(em);
    

 // Email message where ToAddress and BccAddress is null   
    
    EmailMessage em1 = new EmailMessage();
    em1.ParentId = cassoftsol1.ID;
    em1.CcAddress = 'abc@test.com';
    em1.subject = 'Suggest Solution';
    lem.add(em1);
  
  //Email message where ToAddress and ccAddress is null   
    
    EmailMessage em2 = new EmailMessage();
    em2.ParentId = cassoftsol2.ID;
    em2.BccAddress = 'abc@test.com';
    em2.subject = 'Suggest Solution';
    lem.add(em2);
 
  
  //Email message where  BccAddress is null   
    
    EmailMessage em3 = new EmailMessage();
    em3.ParentId = cassoftsol3.ID;
    em3.ToAddress = 'abc@test.com';
    em3.CcAddress = 'abc@test.com';
    em3.subject = 'Suggest Solution';
    lem.add(em3);
 
  // Email message where ccAddress is null   
    
    EmailMessage em4 = new EmailMessage();
    em4.ParentId = cassoftsol4.ID;
    em4.ToAddress = 'abc@test.com';
    em4.BccAddress = 'abc@test.com';
    em4.subject = 'Suggest Solution';
    lem.add(em4);
 
  // Email message where ToAddress  is null   
    
    EmailMessage em5 = new EmailMessage();
    em5.ParentId = cassoftsol5.ID;
    em5.BccAddress = 'abc@test.com';
    em5.CcAddress = 'abc@test.com';
    em5.subject = 'Suggest Solution';
    lem.add(em5);
    
    Insert lem;
    Test.StartTest();
    
    String s = UpdateClient.redirect(cassoftsol.ID,'TRUE');
    String s1 = UpdateClient.redirect(cassoftsol.ID,'False');
    
    String s2 = UpdateClient.redirect(cassoftsol1.ID,'TRUE');
    String s3 = UpdateClient.redirect(cassoftsol1.ID,'FALSE');
    
    String s4 = UpdateClient.redirect(cassoftsol2.ID,'TRUE');
    String s5 = UpdateClient.redirect(cassoftsol2.ID,'FALSE');
    
    String s6 = UpdateClient.redirect(cassoftsol3.ID,'TRUE');
    String s7 = UpdateClient.redirect(cassoftsol3.ID,'FALSE');
    
    String s8 = UpdateClient.redirect(cassoftsol4.ID,'TRUE');
    String s9 = UpdateClient.redirect(cassoftsol4.ID,'FALSE');
    
    String s11 = UpdateClient.redirect(cassoftsol5.ID,'TRUE');
    String s12 = UpdateClient.redirect(cassoftsol5.ID,'FALSE');
    
    String s13 = UpdateClient.redirect(cassoftsol6.ID,'TRUE');
    String s14 = UpdateClient.redirect(cassoftsol6.ID,'FALSE');
    
    Test.StopTest();
 
    }
}
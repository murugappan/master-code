@Istest
Private class EmailviaWorkflowTest
 {
         
           Private static  testmethod void unittest()
           {
     
                  // Insert Account   
                  Account acc =TestMethodUtility.createAccount();
                   Insert acc;
                
               // Insert Core License
                 Core_License__c  Cr=TestMethodUtility.createCoreLicense();
                 Insert Cr;
               
                //insert Assest
                 Asset aset = TestMethodUtility.createAsset(acc,Cr);
                 Insert aset;
               
               //insert Case
                Case cs= TestMethodUtility.createCase1(acc,aset);
                 cs.send_email_internal__c=null;
                 cs.send_email_external__c=null;
                 insert cs;

                 list<Messaging.SingleEmailMessage> mails = new list<Messaging.SingleEmailMessage>();
 
                 list <string> emailaddress = new list <string>();
                 emailaddress .Add('nikhil886846@Wipro.com');
                 emailaddress .Add('nikhil.kumar@blackboard.com');
                 emailaddress .Add('nikhil.kumar6@wipro.com');
                 emailaddress .Add('nikhil.kumar1@blackboard.com');
                 emailaddress .Add('nikhil.kumar2@blackboard.com');
                 emailaddress .Add('nikhil.kumar3@blackboard.com');


                   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                  String[] toAddresses = new String[] {'nikhil.kumar6@wipro.com'};
                  String[] ccAddresses = new String[]{'nikhil886846@gmail.com'};
                  mail.setToAddresses(toAddresses);
                  mail.setSubject('Test Class mail send');
                 mail.setPlainTextBody('Test Class');
                 mail.setBccAddresses(ccAddresses );
                  mail.setCcAddresses(ccAddresses );
   //    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
              mails.Add(mail);
             EmailviaWorkflow.sendworflowemail(mail);
          EmailviaWorkflow.sendworflowemail(mail,cs);
          EmailviaWorkflow.sendworflowemail(mails);
        Test.StartTest();
            cs.send_email_internal__c=null;
         Update cs;
          EmailviaWorkflow.sendcaseteamemail(cs,emailaddress,'Test class','Test Method');
         EmailviaWorkflow.sendcaseteamemail(cs,'Test class','Test Method');
        EmailviaWorkflow.mailStaffCaseTeam(cs,'Test class','Test Method');
        EmailviaWorkflow.sendcaseteamemailTrigger(cs,'Test class','Test Method');
        EmailviaWorkflow.sendowneremail(cs,emailaddress,'Test class','Test Method');
     Test.Stoptest();

}
Private static  testmethod void unittest1()
           {
     
                  // Insert Account   
                  Account acc =TestMethodUtility.createAccount();
                   Insert acc;
                
               // Insert Core License
                 Core_License__c  Cr=TestMethodUtility.createCoreLicense();
                 Insert Cr;
               
                //insert Assest
                 Asset aset = TestMethodUtility.createAsset(acc,Cr);
                 Insert aset;
               
               //insert Case
                Case cs= TestMethodUtility.createCase1(acc,aset);
                  cs.send_email_internal__c=2;
                 cs.send_email_external__c=3;
               cs.send_email_owner__c=null;
                 insert cs;

                 list<Messaging.SingleEmailMessage> mails = new list<Messaging.SingleEmailMessage>();
 
                 list <string> emailaddress = new list <string>();
                 emailaddress .Add('nikhil886846@Wipro.com');
                 emailaddress .Add('nikhil.kumar@blackboard.com');
                 emailaddress .Add('nikhil.kumar6@wipro.com');
                 emailaddress .Add('nikhil.kumar1@blackboard.com');
                 emailaddress .Add('nikhil.kumar2@blackboard.com');
                 emailaddress .Add('nikhil.kumar3@blackboard.com');


                   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                  String[] toAddresses = new String[] {'nikhil.kumar6@wipro.com'};
                  String[] ccAddresses = new String[]{'nikhil886846@gmail.com'};
                  mail.setToAddresses(toAddresses);
                  mail.setSubject('Test Class mail send');
                 mail.setPlainTextBody('Test Class');
                 mail.setBccAddresses(ccAddresses );
                  mail.setCcAddresses(ccAddresses );
   //    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
              mails.Add(mail);
             EmailviaWorkflow.sendworflowemail(mail);
          EmailviaWorkflow.sendworflowemail(mail,cs);
          EmailviaWorkflow.sendworflowemail(mails);
Test.StartTest();
          EmailviaWorkflow.sendcaseteamemail(cs,emailaddress,'Test class','Test Method');
         EmailviaWorkflow.sendcaseteamemail(cs,'Test class','Test Method');
        EmailviaWorkflow.mailStaffCaseTeam(cs,'Test class','Test Method');
        EmailviaWorkflow.sendcaseteamemailTrigger(cs,'Test class','Test Method');
        EmailviaWorkflow.sendowneremail(cs,emailaddress,'Test class','Test Method');
  Test.Stoptest();


}
}
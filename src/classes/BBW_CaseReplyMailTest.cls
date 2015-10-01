@istest
Public class BBW_CaseReplyMailTest{
    
    public static testMethod void ProcessApplicantTest(){
       
    Account ac=new Account();
    ac.Name='bucknell university';
    ac.BillingCity='abc';
    ac.BillingCountry='USA';
    ac.BillingPostalCode='abc';
    ac.BillingState='abc';
    ac.BillingStreet='abc';

    insert ac;

    Contact ct= new Contact ();
    ct.AccountId=ac.id;
    ct.Account=ac;
    ct.LastName='abc';
    ct.Email = 'atul.singhal1@wipro.com';
    insert ct;
    
    Contact ct1= new Contact ();
    ct1.AccountId=ac.id;
    ct1.Account=ac;
    ct1.LastName='abc';
    ct1.Email = 'test@wipro.com';
    insert ct1;
    
    Core_License__c cl=new Core_License__c();
    cl.Name='ANGEL';
    insert cl;
    
    Asset a=new Asset();
    a.Name='abc';
    a.Core_License__c=cl.id;
    a.AccountId=ac.id;
    a.Contact=ct;
    a.Account=ac;
    insert a;
    
    Case cs1=new Case();
    cs1.Status='Closed';
    cs1.Description='this case has to be resolved';
    cs1.Type='abc';
    cs1.Subject='abc';
    cs1.Case_Severity__c='1';
    cs1.Primary_Group_Name__c='ANGEL - Development';
    cs1.Previous_Owner__c='yyyy';
    cs1.AccountId=ac.id;
    cs1.Account=ac;
    cs1.Contact=ct;
    cs1.AssetID=a.ID;
    cs1.Replication_in_the_Case__c = 'Test';
    insert cs1;
     Case cc = [select id, CaseNumber from case limit 1];
    System.debug('++++++'+cs1.CaseNumber);
    string ss = cc.CaseNumber;
    //system.debug('++SS'+SS.length());  
    string sss1 ='test subject='+cc+'agh';
    system.debug('++S1S'+SsS1.length());      
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
       
        Case position = [Select Id,OwnerId,Status From Case  Limit 1];

        email.subject = sss1;
        email.fromName = 'test test';
        email.fromAddress='atul.singhal1@wipro.com';
        email.plainTextBody = 'Hello, this a test email body. for testing purposes only.Phone:123456 Bye';
        Messaging.InboundEmail.BinaryAttachment[] binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[1]; 
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
        binaryAttachment.Filename = 'test.txt';
        String algorithmName = 'HMacSHA1';
        Blob b = Crypto.generateMac(algorithmName, Blob.valueOf('test'),
        Blob.valueOf('test_key'));
        binaryAttachment.Body = b;
        binaryAttachments[0] =  binaryAttachment ;
        email.binaryAttachments = binaryAttachments ;
        envelope.fromAddress = 'atul.singhal1@wipro.com';
       


        // setup controller object
        BBW_CaseReplyMail catcher = new BBW_CaseReplyMail();
        Messaging.InboundEmailResult result = catcher.handleInboundEmail(email, envelope);
        System.assertEquals( result.success  ,true);   

      }
    public static testMethod void ProcessApplicantTest2(){
       
    Account ac=new Account();
    ac.Name='bucknell university';
    ac.BillingCity='abc';
    ac.BillingCountry='USA';
    ac.BillingPostalCode='abc';
    ac.BillingState='abc';
    ac.BillingStreet='abc';

    insert ac;

    Contact ct= new Contact ();
    ct.AccountId=ac.id;
    ct.Account=ac;
    ct.LastName='abc';
    ct.Email = 'atul.singhal1@wipro.com';
    insert ct;
    
    Contact ct1= new Contact ();
    ct1.AccountId=ac.id;
    ct1.Account=ac;
    ct1.LastName='abc';
    ct1.Email = 'test@wipro.com';
    insert ct1;
    
    Core_License__c cl=new Core_License__c();
    cl.Name='ANGEL';
    insert cl;
    
    Asset a=new Asset();
    a.Name='abc';
    a.Core_License__c=cl.id;
    a.AccountId=ac.id;
    a.Contact=ct;
    a.Account=ac;
    insert a;
    
    Case cs1=new Case();
    cs1.Status='Closed';
    cs1.Description='this case has to be resolved';
    cs1.Type='abc';
    cs1.Subject='abc';
    cs1.Case_Severity__c='1';
    cs1.Primary_Group_Name__c='ANGEL - Development';
    cs1.Previous_Owner__c='yyyy';
    cs1.AccountId=ac.id;
    cs1.Account=ac;
    cs1.Contact=ct;
    cs1.AssetID=a.ID;
    cs1.Replication_in_the_Case__c = 'Test';
    insert cs1;
     Case cc = [select id, CaseNumber from case limit 1];
    System.debug('++++++'+cs1.CaseNumber);
    string ss = cc.CaseNumber;
    //system.debug('++SS'+SS.length());  
    string sss1 ='test subject='+cc+'agh';
    system.debug('++S1S'+SsS1.length());      
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
       
        Case position = [Select Id,OwnerId,Status From Case  Limit 1];

        email.subject = sss1;
        email.fromName = 'test test';
        email.fromAddress='atul.singhal1@wipro.com';
        email.plainTextBody = 'Test class body';
        Messaging.InboundEmail.BinaryAttachment[] binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[1]; 
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
        binaryAttachment.Filename = 'test.txt';
        String algorithmName = 'HMacSHA1';
        Blob b = Crypto.generateMac(algorithmName, Blob.valueOf('test'),
        Blob.valueOf('test_key'));
        binaryAttachment.Body = b;
        binaryAttachments[0] =  binaryAttachment ;
        email.binaryAttachments = binaryAttachments ;
        envelope.fromAddress = 'atul.singhal1@wipro.com';
       


        // setup controller object
        BBW_CaseReplyMail catcher = new BBW_CaseReplyMail();
        Messaging.InboundEmailResult result = catcher.handleInboundEmail(email, envelope);
        System.assertEquals( result.success  ,true);   

      }   
      
      
      
      
    public static testMethod void ProcessApplicantTest1(){
       
    Account ac=new Account();
    ac.Name='bucknell university';
    ac.BillingCity='abc';
    ac.BillingCountry='USA';
    ac.BillingPostalCode='abc';
    ac.BillingState='abc';
    ac.BillingStreet='abc';

    insert ac;

    Contact ct= new Contact ();
    ct.AccountId=ac.id;
    ct.Account=ac;
    ct.LastName='abc';
    ct.Email = 'atul.singhal1@wipro.com';
    insert ct;
    
    Contact ct1= new Contact ();
    ct1.AccountId=ac.id;
    ct1.Account=ac;
    ct1.LastName='abc';
    ct1.Email = 'test@wipro.com';
    insert ct1;
    
    Core_License__c cl=new Core_License__c();
    cl.Name='ANGEL';
    insert cl;
    
    Asset a=new Asset();
    a.Name='abc';
    a.Core_License__c=cl.id;
    a.AccountId=ac.id;
    a.Contact=ct;
    a.Account=ac;
    insert a;
    
    Case cs1=new Case();
    cs1.Status='Solution Suggested';
    cs1.Description='this case has to be resolved';
    cs1.Type='abc';
    cs1.Subject='abc';
    cs1.Case_Severity__c='1';
    cs1.Primary_Group_Name__c='ANGEL - Development';
    cs1.Previous_Owner__c='yyyy';
    cs1.AccountId=ac.id;
    cs1.Account=ac;
    cs1.Contact=ct;
    cs1.AssetID=a.ID;
    cs1.Replication_in_the_Case__c = 'Test';
    insert cs1;
     Case cc = [select id, CaseNumber from case limit 1];
    System.debug('++++++'+cs1.CaseNumber);
    string ss = cc.CaseNumber;
    //system.debug('++SS'+SS.length());  
    string sss1 ='test subject='+cc+'agh';
    system.debug('++S1S'+SsS1.length());      
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
       
        Case position = [Select Id,OwnerId,Status From Case  Limit 1];

        email.subject = sss1;
        email.fromName = 'test test';
        email.fromAddress='tserst1@wipro.com';
        email.plainTextBody = 'Test class body';
        Messaging.InboundEmail.BinaryAttachment[] binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[1]; 
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
        binaryAttachment.Filename = 'test.txt';
        String algorithmName = 'HMacSHA1';
        Blob b = Crypto.generateMac(algorithmName, Blob.valueOf('test'),
        Blob.valueOf('test_key'));
        binaryAttachment.Body = b;
        binaryAttachments[0] =  binaryAttachment ;
        email.binaryAttachments = binaryAttachments ;
        envelope.fromAddress = 'tsrst@wipro.com';
        
       


        // setup controller object
        BBW_CaseReplyMail catcher = new BBW_CaseReplyMail();
        Messaging.InboundEmailResult result = catcher.handleInboundEmail(email, envelope);
        System.assertEquals( result.success  ,true);   

      }   
    public static testMethod void ProcessApplicantTest3(){
       
    Account ac=new Account();
    ac.Name='bucknell university';
    ac.BillingCity='abc';
    ac.BillingCountry='USA';
    ac.BillingPostalCode='abc';
    ac.BillingState='abc';
    ac.BillingStreet='abc';

    insert ac;

    Contact ct= new Contact ();
    ct.AccountId=ac.id;
    ct.Account=ac;
    ct.LastName='abc';
    ct.Email = 'atul.singhal1@wipro.com';
    insert ct;
    
    Contact ct1= new Contact ();
    ct1.AccountId=ac.id;
    ct1.Account=ac;
    ct1.LastName='abc';
    ct1.Email = 'test@wipro.com';
    insert ct1;
    
    Core_License__c cl=new Core_License__c();
    cl.Name='ANGEL';
    insert cl;
    
    Asset a=new Asset();
    a.Name='abc';
    a.Core_License__c=cl.id;
    a.AccountId=ac.id;
    a.Contact=ct;
    a.Account=ac;
    insert a;
    
    Case cs1=new Case();
    cs1.Status='Solution Suggested';
    cs1.Description='this case has to be resolved';
    cs1.Type='abc';
    cs1.Subject='abc';
    cs1.Case_Severity__c='1';
    cs1.Primary_Group_Name__c='ANGEL - Development';
    cs1.Previous_Owner__c='yyyy';
    cs1.AccountId=ac.id;
    cs1.Account=ac;
    cs1.Contact=ct;
    cs1.AssetID=a.ID;
    cs1.Replication_in_the_Case__c = 'Test';
    insert cs1;
     Case cc = [select id, CaseNumber from case limit 1];
    System.debug('++++++'+cs1.CaseNumber);
    string ss = cc.CaseNumber;
    //system.debug('++SS'+SS.length());  
    string sss1 ='test subject='+cc+'agh';
    system.debug('++S1S'+SsS1.length());      
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
       
        Case position = [Select Id,OwnerId,Status From Case  Limit 1];

        email.subject = sss1;
        email.fromName = 'test test';
        email.fromAddress='tserst1@wipro.com';
        email.plainTextBody = 'Test class body,HELLO';
        Messaging.InboundEmail.BinaryAttachment[] binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[1]; 
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
        binaryAttachment.Filename = 'test.txt';
        String algorithmName = 'HMacSHA1';
        Blob b = Crypto.generateMac(algorithmName, Blob.valueOf('test'),
        Blob.valueOf('test_key'));
        binaryAttachment.Body = b;
        binaryAttachments[0] =  binaryAttachment ;
        email.binaryAttachments = binaryAttachments ;
        envelope.fromAddress = 'tsrst@wipro.com';
        
       


        // setup controller object
        BBW_CaseReplyMail catcher = new BBW_CaseReplyMail();
        Messaging.InboundEmailResult result = catcher.handleInboundEmail(email, envelope);
        System.assertEquals( result.success  ,true);   

      } 
    public static testMethod void ProcessApplicantTest4(){
       
    Account ac=new Account();
    ac.Name='bucknell university';
    ac.BillingCity='abc';
    ac.BillingCountry='USA';
    ac.BillingPostalCode='abc';
    ac.BillingState='abc';
    ac.BillingStreet='abc';

    insert ac;

    Contact ct= new Contact ();
    ct.AccountId=ac.id;
    ct.Account=ac;
    ct.LastName='abc';
    ct.Email = 'atul.singhal1@wipro.com';
    insert ct;
    
    Contact ct1= new Contact ();
    ct1.AccountId=ac.id;
    ct1.Account=ac;
    ct1.LastName='abc';
    ct1.Email = 'test@wipro.com';
    insert ct1;
    
    Core_License__c cl=new Core_License__c();
    cl.Name='ANGEL';
    insert cl;
    
    Asset a=new Asset();
    a.Name='abc';
    a.Core_License__c=cl.id;
    a.AccountId=ac.id;
    a.Contact=ct;
    a.Account=ac;
    insert a;
    
    Case cs1=new Case();
    cs1.Status='Solution Suggested';
    cs1.Description='this case has to be resolved';
    cs1.Type='abc';
    cs1.Subject='abc';
    cs1.Case_Severity__c='1';
    cs1.Primary_Group_Name__c='ANGEL - Development';
    cs1.Previous_Owner__c='yyyy';
    cs1.AccountId=ac.id;
    cs1.Account=ac;
    cs1.Contact=ct;
    cs1.AssetID=a.ID;
    cs1.Replication_in_the_Case__c = 'Test';
    insert cs1;
     Case cc = [select id, CaseNumber from case limit 1];
    System.debug('++++++'+cs1.CaseNumber);
    string ss = cc.CaseNumber;
    //system.debug('++SS'+SS.length());  
    string sss1 ='test subject='+cc+'agh';
    system.debug('++S1S'+SsS1.length());      
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
       
        Case position = [Select Id,OwnerId,Status From Case  Limit 1];

        email.subject = 'tsest';
        email.fromName = 'test test';
        email.fromAddress='tserst1@wipro.com';
        email.plainTextBody = 'Test class body,HELLO';
        Messaging.InboundEmail.BinaryAttachment[] binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[1]; 
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
        binaryAttachment.Filename = 'test.txt';
        String algorithmName = 'HMacSHA1';
        Blob b = Crypto.generateMac(algorithmName, Blob.valueOf('test'),
        Blob.valueOf('test_key'));
        binaryAttachment.Body = b;
        binaryAttachments[0] =  binaryAttachment ;
        email.binaryAttachments = binaryAttachments ;
        envelope.fromAddress = 'tsrst@wipro.com';
        
       


        // setup controller object
        BBW_CaseReplyMail catcher = new BBW_CaseReplyMail();
        Messaging.InboundEmailResult result = catcher.handleInboundEmail(email, envelope);
        System.assertEquals( result.success  ,true);   

      }         
           
    }
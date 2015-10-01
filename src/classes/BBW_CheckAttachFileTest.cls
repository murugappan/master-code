@isTest
private class BBW_CheckAttachFileTest {

    static testMethod void myUnitTest()  
    {
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
    insert ct;
    
    Task t = new Task ();
    t.Subject = 'Email: SFDC: Please Approve Quote for Jon Lal';
    t.Status = 'Completed';
    t.Priority = 'Normal';
    t.WhatId = ac.Id;
    t.WhoId = ct.Id;
    insert t;
     Attachment attach=new Attachment();    
     attach.Name='Unit Test Attachment';
     Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
     attach.body=bodyBlob;
     attach.parentId=t.id;
     insert attach;
    
    update t;
    }
    static testMethod void myUnitTest1(){
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
    insert ct;
    
    Task t = new Task ();
    t.Subject = 'Email: SFDC: Please Approve Quote for Jon Lal';
    t.Status = 'Completed';
    t.Priority = 'Normal';
    t.WhatId = ac.Id;
    t.WhoId = ct.Id;
    insert t;
    update t;
    } 
  }
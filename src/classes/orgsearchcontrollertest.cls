@istest
private class orgsearchcontrollertest{

   static testMethod void unittest1()
    {
          Account ac=TestMethodUtility.createAccount();
        ac.Name='Widget university';
        ac.BillingCity='abc';
        ac.BillingCountry='USA';
        ac.BillingPostalCode='abc';
        ac.BillingState='abc';
        ac.BillingStreet='abc';
        ac.CustomerofCollaborate__c=true;
        insert ac;
        
         PageReference pageRef = Page.orgsearch;
         pageref.getparameters().put('term','Widget');
         test.setcurrentpage(pageref);
         orgsearchcontroller controller= new orgsearchcontroller();
         controller.parseJson();
    }
}
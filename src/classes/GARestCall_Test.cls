@isTest
private class GARestCall_Test {

static testmethod void dotestmethod(){
       
            /*Account a=TestMethodUtility.createAccount();
            insert a;*/ 
            
                
        // do request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/GARestCall';
        //req.addParameter('source_url', '/'+a.Id);
        req.addParameter('source_url', '/0017000000lXxeF');

        
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.response = res;
        
        String returnValue = gaanalytics.doReply();
        
        //System.assertEquals('{"dimension1" : "murugappan.alagappan@blackboard.com.dvx", "dimension2" : "System Administrator"}',returnValue);
}



/////



static testmethod void dotestmethod3(){
       
            Account a=TestMethodUtility.createAccount();
            insert a; 
            
            /*KimbleOne__BusinessUnit__c BU1 = [Select ID From KimbleOne__BusinessUnit__c Where KimbleOne__IsOperatingEntity__c = TRUE LIMIT 1];
            
                Opportunity opp = new Opportunity();        
                opp.Name = 'Test Sales Opp';
                opp.AccountId = a.Id;
                opp.StageName = 'Initial Stage';
                opp.KimbleCRMInt__BusinessUnit__c = BU1.Id;
                opp.Probability = 30;
                opp.CloseDate = date.today();
                insert opp;*/
                
             
        // do request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/GARestCall';
        //req.addParameter('source_url', '/'+Opp.Id);
        req.addParameter('source_url', '/0067000000aENX1');

        
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.response = res;
        
        String returnValue = gaanalytics.doReply();
        
        //System.assertEquals('{"dimension1" : "murugappan.alagappan@blackboard.com.dvx", "dimension2" : "System Administrator"}',returnValue);
        

}


////////



static testmethod void dotestmethod4(){
       
            /*Account a=TestMethodUtility.createAccount();
            insert a; 
            
                Core_License__c cl=TestMethodUtility.createCoreLicense();
                cl.Name='Angel';
                insert cl;
                                
                
                Asset ast = TestMethodUtility.createAsset(a,cl);
                insert ast;
                
                Case cs=TestMethodUtility.createCase1(a,ast);*/
        
       
       
       
       
        // do request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/GARestCall';
        //req.addParameter('source_url', '/'+cs.Id);
        req.addParameter('source_url', '/5007000000Lza9y');
        

        
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.response = res;
        
        String returnValue = gaanalytics.doReply();
        
        //System.assertEquals('{"dimension1" : "murugappan.alagappan@blackboard.com.dvx", "dimension2" : "System Administrator"}',returnValue);
        //System.assertEquals('{"dimension1" : "murugappan.alagappan@blackboard.com.qax", "dimension2" : "System Administrator", "dimension5" : "00001002"}',returnValue);

}



static testmethod void dotestmethod2(){
        // do request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/GARestCall';
        req.addParameter('source_url', '/006');
        

        
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.response = res;
        
        String returnValue = gaanalytics.doReply();
        
        //System.assertEquals('{"dimension1" : "murugappan.alagappan@blackboard.com.dvx", "dimension2" : "System Administrator"}',returnValue);
}






  

}
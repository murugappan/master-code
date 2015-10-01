global class WebService_CTI 
{
    global class Inputs 
    {
        webservice String input;
        webservice String clientid;
    }

    // Output Variables for queryInput
    global class queryInput 
    {
        webservice String screenpopid;
        webservice String clientid;
        webservice Boolean Done;
        webservice Boolean isCase;
        webservice Boolean isAccount;
        webservice String debugMessage;
        webservice Boolean success;
        webservice String primarygroup;
        webservice String userid;
        webservice List<String> productKeys;
    }

    /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
        @name: queryInputsMethod
        @returns:  list<string> productkeys, boolean case, boolean account, clientid
        @abstract: Webservice that accepts client id or case number
                   returns a list of products (by key) if a client or
                   returns the primarygroup and userid if a case.
                   If a valid clientid is given and the client only has one product,
                   the query will return the primarygroup to route the incoming
                   call.
        @productKey definitions
        ============================================
                            L(Learn)
                            LH(Learn Hosted)
                            LX(Learn Complex)
                            LS(Learn SaaS)
                            A(ANGEL)
                            AH(ANGEL HOSTED)
                            V(CE/VISTA)
                            VH(CE/VISTA HOSTED)
                            X(XYTHOS)
                            CL(Collaborate)
                            MR(Moodlerooms)
                            AN(Analytics)
        ============================================
    * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */ 
    
    webservice static queryInput queryInputsMethod(String input) 
    {
        boolean success = false;
        boolean iscase = false;
        boolean isaccount = false;
        boolean done = false;
        String primarygroup = ' ';
        String debugMessage1 = ' ';
        String clientid = ' ';
        String userid = ' ';      
        Account a;
        Case c;
        User u;
        List<string> productkeys = null;
        String screenpopid = ' ';
        if(input != null)
        {
            try 
            {
                a = [Select PS_Company_Id__c, Angel_Queue__c, Moodlerooms_Queue__c, CE_Vista_Hosted__c, CE_Vista_Queue__c, Collaborate_Queue__c, Learn_Complex_Queue__c, Learn_Hosted_Queue__c, Learn_Queue__c, 
                            Transact_Queue__c, Xythos_Queue__c, Analytics_Queue__c, Learn_SaaS_Queue__c 
                     FROM Account 
                     WHERE PS_Company_Id__c =: input];
            }
            catch(exception ex) 
            {
                debugMessage1 = ex.getmessage();
                success = false;
            }
            if(a == null)
            {
                try 
                {
                    c = [select id, accountid, primary_group_name__c, ownerid, Asset.Primary_Group__c, AssetId From Case where casenumber = :input];
                    
                    try
                    {
                        u = [Select Id, Name, Avaya_Agent_Id__c From User Where Id =: c.OwnerId limit 1];
                    }
                    catch (Exception e)
                    {
                        //debugMessage1 = e.getMessage();
                    }
                }
                catch(exception ex) 
                {
                    debugMessage1 = ex.getMessage();
                    success = false;
                }
            }   
            if(a != null)
            {
                screenpopid = a.id;
                clientid = a.ps_company_id__c;
                isaccount = true;
                productkeys = new list<string>();
                if(a.learn_queue__c != null)
                    productkeys.add('L');
                if(a.learn_hosted_queue__c != null)
                    productkeys.add('LH');
                if(a.Collaborate_Queue__c != null)
                    productkeys.add('CL');
                if(a.Moodlerooms_Queue__c != null)
                    productkeys.add('MR');       
                if(a.learn_complex_queue__c != null)
                    productkeys.add('LX');
                if(a.angel_queue__c != null)
                    productkeys.add('A');
                if(a.ce_vista_queue__c != null)
                    productkeys.add('V');
                if(a.ce_vista_hosted__c != null)
                    productkeys.add('VH');
                if(a.xythos_queue__c != null)
                    productkeys.add('X');
                if(a.Analytics_Queue__c != null)
                    productkeys.add('AN');
                if(a.Learn_SaaS_Queue__c != null)
                    productkeys.add('LS');    
                if(productkeys.size() >= 1 && productkeys.size() != null)
                {
                    success = true;
                    isaccount = true;
                    if(productkeys.size() == 1)
                    {
                        if(productkeys[0] == 'L')
                            primarygroup = a.learn_queue__c;
                        else if(productkeys[0] == 'LH')
                            primarygroup = a.learn_hosted_queue__c;
                        else if(productkeys[0] == 'CL')
                            primarygroup = a.Collaborate_Queue__c;
                        else if(productkeys[0] == 'MR')
                            primarygroup = a.Moodlerooms_Queue__c;
                        else if(productkeys[0] == 'LX')
                            primarygroup = a.learn_complex_queue__c;
                        else if(productkeys[0] == 'A')
                            primarygroup = a.angel_queue__c;
                        else if(productkeys[0] == 'V')
                            primarygroup = a.ce_vista_queue__c;
                        else if(productkeys[0] == 'VH')
                            primarygroup = a.ce_vista_hosted__c;
                        else if(productkeys[0] == 'X')
                            primarygroup = a.xythos_queue__c;
                        else if(productkeys[0] == 'AN')
                            primarygroup = a.Analytics_Queue__c;
                        else if(productkeys[0] == 'LS')
                            primarygroup = a.Learn_SaaS_Queue__c;
                        if(primarygroup != null)
                            done = true;
                    } 
                    else 
                    {
                        done = false;
                    }
                }
            }
            if(c != null)
            {
                screenpopid = c.id;
                iscase = true;
                success = true;
                if (c.Asset.Primary_Group__c != null)
                {
                    primarygroup = c.Asset.Primary_Group__c;
                }
                if (u != null && u.Avaya_Agent_Id__c != null)
                {
                    userid = u.Avaya_Agent_Id__c;
                }
                done = true;
            }
        }

        queryInput output = new queryInput();
        output.success = success;
        output.screenpopid = screenpopid;
        output.iscase = iscase;
        output.isaccount = isaccount;
        output.done = done;
        output.primarygroup = primarygroup;
        output.userid = userid;
        if(productkeys != null)
        output.productkeys = productkeys;
        else
        output.productkeys = new List<String>();
        output.clientid = clientid;
        output.debugMessage = DebugMessage1 + '////Was I successful??? ' + success + ' What productkeys do I have? [productkeys] = '+ productkeys + ' AM I A CASE = ' + iscase + ' AM I AN ACCOUNT = ' + isaccount + ' IF ACCOUNT MY CLIENT ID IS: ' + clientid;
        system.debug(output);
        return output;
    }


    global class queryPrimaryGroup 
    {
        webservice String screenpopid;
        webservice String debugMessage;
        webservice Boolean success;
        webservice String primarygroup;
     }


    /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
        @methodname : queryPrimaryGroupMethod
        @returnvalue: String primarygroup
        @description: Service takes a product key with a valid client id and returns the name of the appropriate queue for call routing
        @definitions: Valid ProductKeys are (L,LH,CL,LX,A,AH,V,VH,X)
    * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */     
    webservice static queryPrimaryGroup queryPrimaryGroupMethod(String productKey, String clientId) 
    {
        String primarygroup;
        Boolean success;
        String accountid;
        if(productKey != null && clientId != null)
        {
            account a;
            try
            {
                a = [Select Angel_Queue__c, Moodlerooms_Queue__c, CE_Vista_Hosted__c,Collaborate_Queue__c, CE_Vista_Queue__c, Learn_Complex_Queue__c, Learn_Hosted_Queue__c, Learn_Queue__c, Transact_Queue__c, Xythos_Queue__c,Analytics_Queue__c, Xythos_ChannelPartnerPlatform__c,Learn_SaaS_Queue__c FROM Account WHERE PS_Company_Id__c =: clientid];
            }
            catch (Exception e)
            {
                a = null;
            }
            if(a != null) 
            {
                 accountid = a.id;
                 if(productKey == 'L')
                    primarygroup = a.learn_queue__c;
                 else if(productKey == 'LH')
                    primarygroup = a.learn_hosted_queue__c;
                 else if(productKey == 'LX')
                    primarygroup = a.learn_complex_queue__c;
                 else if(productKey == 'CL')
                    primarygroup = a.Collaborate_Queue__c;
                 else if(productKey == 'MR')
                    primarygroup = a.Moodlerooms_Queue__c;
                 else if(productKey == 'A')
                    primarygroup = a.angel_queue__c;
                 else if(productKey == 'V')
                    primarygroup = a.ce_vista_queue__c;
                else if(productKey == 'VH')
                    primarygroup = a.ce_vista_hosted__c;
                else if(productKey == 'X')
                    primarygroup = a.xythos_queue__c;
                else if(productKey == 'AN')
                    primarygroup = a.Analytics_Queue__c;
                else if(productKey == 'LS')
                    primarygroup = a.Learn_SaaS_Queue__c;    
                else if(productKey == null)
                    primarygroup = 'ERROR';
                    
                success = true;
            }
            else 
            {
                success = false;
            }
        }
        
        queryPrimaryGroup output = new queryPrimaryGroup();
        output.success = success;
        output.primarygroup = primarygroup;
        output.screenpopid = accountid;
        output.debugMessage = 'What primary group will I be routed to? >>>> ' + primarygroup;
        return output;
    } 
        
   public static testMethod void testWebService()
    {
    
     list<account> acc = new  list<account>();
    Account ac=new Account();
    ac.Name='bucknell university';
    ac.BillingCity='abc';
    ac.BillingCountry='USA';
    ac.BillingPostalCode='abc';
    ac.BillingState='abc';
    ac.BillingStreet='abc';
    ac.PS_Company_Id__c='test';
    ac.Learn_Queue__c='test data';
    ac.Learn_Hosted_Queue__c='test data1';
    ac.Learn_Hosted_Queue__c='test data2';
    ac.angel_queue__c='test data3';
    ac.ce_vista_queue__c='test data4';
    ac.ce_vista_hosted__c='test data5';
    ac.Xythos_Queue__c='test data5'; 
    acc.add(ac);
    Account ac1=new Account();
    ac1.Name='bucknell university';
    ac1.BillingCity='abc';
    ac1.BillingCountry='USA';
    ac1.BillingPostalCode='abc';
    ac1.BillingState='abc';
    ac1.BillingStreet='abc';
    ac1.PS_Company_Id__c='test1';
    ac1.Learn_Queue__c='test data';
   acc.add(ac1);
   
     Account ac2=new Account();
    ac2.Name='bucknell university';
    ac2.BillingCity='abc';
    ac2.BillingCountry='USA';
    ac2.BillingPostalCode='abc';
    ac2.BillingState='abc';
    ac2.BillingStreet='abc';
    ac2.PS_Company_Id__c='test3';
    ac2.Learn_Hosted_Queue__c='test data2';
    acc.add(ac2);
    insert acc;
     
    Contact ct= new Contact ();
    ct.AccountId=ac.id;
    ct.Account=ac;
    ct.LastName='abc';
    insert ct;
    
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
    cs1.Case_Severity__c='2';
    cs1.Primary_Group_Name__c='ANGEL - Development';
    cs1.Previous_Owner__c='yyyy';
    cs1.AccountId=ac.id;
    cs1.Account=ac;
    cs1.Contact=ct;
    cs1.AssetID=a.ID;
    cs1.Replication_in_the_Case__c = 'Test';
    insert cs1;
    case cc = [select id, casenumber from case where id =: cs1.id]; 
   
    string ss =cc.casenumber;
    
        WebService_CTI.queryInputsMethod('test');
        WebService_CTI.queryInputsMethod('test1');
        WebService_CTI.queryInputsMethod('test3');
        WebService_CTI.queryInputsMethod(ss);
        WebService_CTI.queryPrimaryGroupMethod('test key','test');
    } 
    
   public static testMethod void testWebService1()
    {
    WebService_CTI.queryInputsMethod('test');
    WebService_CTI.queryPrimaryGroupMethod('test key','test');
    }
}
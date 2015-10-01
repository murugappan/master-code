@istest(seealldata=True)
Private class BbLeadTriggerHandlerTest
 {
            
               static testMethod void myUnitTest1() 
               {
               Lead L1 = new Lead(LastName='LeadTest', Company='Test Company', Status='New', Industry='Higher Ed.');
               Insert L1;
               L1.Country ='USA';
               Update L1;
               }
               static testMethod void myUnitTest2() 
               {
               Lead L2 = new Lead(LastName='LeadTest',Country ='USA',Company='Test Company', Status='New', Industry='Individual Consumer');
               Insert L2;
               }
               static testMethod void myUnitTest3() 
               {
               Lead L3 = new Lead(LastName='LeadTest',Country ='Canada',Company='Test Company', Status='New', Industry='K12');
               Insert L3;
               } 
               static testMethod void myUnitTest4() 
               {
               Lead L4 = new Lead(LastName='LeadTest',Country ='Canada',Company='Test Company', Status='New', Industry='Government');
               Insert L4;
               } 
               static testMethod void myUnitTest5() 
               {
               Lead L5 = new Lead(LastName='LeadTest',Country ='Canada',Company='Test Company', Status='New', Industry='Non-Corporate Organization');
               Insert L5;
               }
               static testMethod void myUnitTest6() 
               {
               Lead L6 = new Lead(LastName='LeadTest',Country ='Canada',Company='Test Company', Status='New', Industry='Corporate');
               Insert L6;
               }
              
               static testMethod void myUnitTest7() 
               {
               // Account a=TestMethodUtility.createAccount();
               // insert a;                                                            
                
                Profile p=[Select Id from Profile where Name= 'Bb - API User' Limit 1];
                User u1 = TestMethodUtility.CreateUser(p);
                u1.SalesReportingGroup__c='Learn - NAHE';
                insert u1;
               
                List<KimbleOne__Resource__c> TheRes = [Select ID From KimbleOne__Resource__c Where KimbleOne__User__c = :UserInfo.getUserId()];
                
                if(TheRes.Size() < 1)
                {
               
                KimbleOne__BusinessUnit__c BU1 = [Select ID, KimbleOne__Calendar__c From KimbleOne__BusinessUnit__c Where KimbleOne__IsOperatingEntity__c = TRUE][0];
               
               KimbleOne__ResourceType__c RT1 = [Select ID From KimbleOne__ResourceType__c][0];
                KimbleOne__Grade__c GRADE1 = [Select ID From KimbleOne__Grade__c][0];
                
                KimbleOne__Resource__c RES1 = New KimbleOne__Resource__c();
                RES1.KimbleOne__FirstName__c = 'Test';
                RES1.KimbleOne__LastName__c = 'User';
                RES1.KimbleOne__BusinessUnit__c = BU1.Id;        
                RES1.KimbleOne__ResourceType__c = RT1.Id;
                RES1.KimbleOne__User__c = UserInfo.getUserId();
                RES1.KimbleOne__StandardCost__c = 100;
                RES1.KimbleOne__Grade__c = GRADE1.Id;
                RES1.KimbleOne__Calendar__c = BU1.KimbleOne__Calendar__c;
        
                Insert RES1;   
                }                               
               

               //User u1 =[Select id from User where SalesReportingGroup__c!=NULL and ProfileId='00e70000000rsumAAA' and IsActive=true   limit 1];
              System.runas(u1)
               {
                   Lead L7 = new Lead(LastName='LeadTest',Country ='USA',Company='Test Company', Status='New', Industry='Internal Bb Account');
                   L7.Ownerid=u1.id;
                   L7.isconverted=false;
                   Insert L7;
                   Database.LeadConvert l = new database.LeadConvert();
                   l.setLeadId(l7.id);
                   l.setDoNotCreateOpportunity(false);
                   l.setConvertedStatus('Converted');
                   Database.LeadConvertResult lcr = Database.convertLead(l);
               }
              /* Opportunity o = new Opportunity(Name = 'Test Opportunity', CloseDate = system.now().date(),  
               StageName = '(S) Suspect Qualification', AccountId = a.Id,LeadSource ='Inbound Call',Ownerid=u1.id);
               insert o;*/
               }
                
               static testMethod void myUnitTestLeadfire() 
               {
               Lead L6 = new Lead(LastName='LeadTest',Country ='Canada',Company='Test Company', Status='Nurture',Rejection_Reason__c = 'PAIN insufficient' ,Industry='Corporate');
               Insert L6;
               L6.Country = 'Finland';
               L6.Status = 'New';
               Update L6;
               }
               static testMethod void myUnitTestLeadfire2() 
               {
               Lead L7 = new Lead(LastName='LeadTest',Country ='Canada',Company='Test Company', Status='Rejected', Rejection_Reason__c ='Wrongly assigned - Turn Back to Marketing',Industry='Corporate');
               Insert L7;
               L7.Country = 'Finland';
               L7.Status = 'New';
               Update L7;
               }
               
 }
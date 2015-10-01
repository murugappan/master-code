@istest(seealldata=True)
Private class BbAssetTriggerHandlerTest
 {
            
               static testMethod void myUnitTest() 
               {
               Asset ast =[Select id,Accountid,Product2Id,KEYGEN_License_XML__c from asset where  Accountid!=Null and Product2Id !=Null limit 1];
               Asset ast2 =[Select id,Accountid,Product2Id,KEYGEN_License_XML__c from asset where  Accountid!=Null and Product2Id !=Null limit 1];
               
               
               ast.KEYGEN_License_XML__c='jdwjdiwqj7318271';
               
               Update ast;
               Update ast2;
               
               }
               Static testMethod void myUnitTest2()
               {
                Account a = TestMethodUtility.createAccount();
                insert a;

                Account a1 = TestMethodUtility.createAccount();
                insert a1;
                    
                Contact con = TestMethodUtility.createContact(a);
                insert con;

                //Standard pricebook
                Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true limit 1];
                
                Pricebook2 pb = [select Id from pricebook2 where Name='CPQ' limit 1];

                Product2 pr =TestMethodUtility.createProduct();
                pr.Type__c='Services';
                insert pr;
                
                PricebookEntry pes = TestMethodUtility.createPricebookEntry(standardPB,pr);
                pes.UseStandardPrice = false;
                insert pes;
    
                PricebookEntry pe = TestMethodUtility.createPricebookEntry(pb,pr);
                pe.UseStandardPrice = false;
                insert pe;
                
                Date dt = System.today();
                Date startdt = dt.addDays(1);

                Opportunity opp = TestMethodUtility.createOpportunity(a,pb);
                opp.StageName='(W) Won';
                opp.Start_Date__c= startdt;
                opp.End_Date__c=startdt+7;
                opp.CPQ_PO_Required__c ='No';
                opp.CPQ_PO_Validated__c=True;
                insert opp;

                Opportunity opp1 = TestMethodUtility.createOpportunity(a1,pb);
                opp1.StageName='(W) Won';
                opp1.Start_Date__c= startdt;
                opp1.End_Date__c=startdt+7;
                opp1.CPQ_PO_Required__c ='Yes';
                opp1.CPQ_PO_Validated__c=True;
                insert opp1;

                Opportunity opp12 = TestMethodUtility.createOpportunity(a1,pb);
                //opp1.StageName='(B) Pending Contract';
                insert opp12;


                Opportunity opp2 = TestMethodUtility.createOpportunity(a,pb);
                opp2.StageName='(B) Pending Contract';
                opp2.CPQ_Previous_Opportunity__c = opp12.id;
                insert opp2;


                OpportunityLineItem oli = new OpportunityLineItem(PricebookEntryId = pe.Id);
                oli.OpportunityId=opp2.id;
                oli.Quantity=1; 
                insert oli;   
             

                List<Asset> asslist = new List<Asset>();
                                
                Asset ass1 = new Asset(Name ='TestAsset',Status = 'Installed', AccountId = a.Id,CPQ_Net_Price__c=100.00,CPQ_Selling_Exchange_Rate__c=1,CPQ_forCPQ__c=True,CPQ_isRenewable__c= True,CPQ_Contract_Start_Date__c= startdt+8);
                Asset ass2 = new Asset(Name ='TestAsset',Status = 'Obsolete', AccountId = a.Id,CPQ_Net_Price__c=100.00,CPQ_Selling_Exchange_Rate__c=1,CPQ_forCPQ__c=True,CPQ_isRenewable__c= True,CPQ_Contract_Start_Date__c= startdt,CPQ_Contract_End_Date__c=startdt+7);
                Asset ass3 = new Asset(Name ='TestAsset',Status = 'Obsolete', AccountId = a.Id,CPQ_Net_Price__c=100.00,CPQ_Selling_Exchange_Rate__c=1,CPQ_forCPQ__c=True,CPQ_isRenewable__c= True,CPQ_Contract_Start_Date__c= startdt,CPQ_Contract_End_Date__c=startdt+7);
                Asset ass4 = new Asset(Name ='TestAsset',Status = 'Installed', AccountId = a.Id,CPQ_Net_Price__c=100.00,CPQ_Selling_Exchange_Rate__c=1,CPQ_forCPQ__c=True,CPQ_isRenewable__c= True,CPQ_Contract_Start_Date__c= startdt+8);
                Asset ass5 = new Asset(Name ='TestAsset',Status = 'Installed', AccountId = a1.Id,CPQ_Net_Price__c=100.00,CPQ_Selling_Exchange_Rate__c=1,CPQ_Current_Opportunity_ID__c = Opp1.Id,CPQ_forCPQ__c=True,CPQ_isRenewable__c= True,CPQ_Contract_Start_Date__c= startdt,CPQ_Contract_End_Date__c=startdt+7);
                Asset ass6 = new Asset(Name ='TestAsset',Status = 'Installed', AccountId = a1.Id,CPQ_Net_Price__c=100.00,CPQ_Selling_Exchange_Rate__c=1,CPQ_Current_Opportunity_ID__c = Opp.Id,CPQ_forCPQ__c=True,CPQ_isRenewable__c= True,CPQ_Contract_Start_Date__c= startdt,CPQ_Contract_End_Date__c=startdt+7);
                //Asset ass7 = new Asset(Name ='TestAsset',Status = 'Installed', AccountId = a1.Id,CPQ_Current_Opportunity_ID__c = Opp2.Id,CPQ_Net_Price__c=100.00,CPQ_Selling_Exchange_Rate__c=1);
                asslist.add(ass1);
                asslist.add(ass2);
                asslist.add(ass3);
                asslist.add(ass4);
                asslist.add(ass5);
                asslist.add(ass6);
                //asslist.add(ass7);
                insert asslist;

                update ass2;
                update ass4;
                ass5.CPQ_Net_Price__c=200.00;
                //ass5.Opportunity__r.StageName='(A) Signature Due';
                Update ass5;
               // ass7.CPQ_Net_Price__c=200.00;
                //Update ass7;

                List<Asset_Version_History__c> avhlist = new List<Asset_Version_History__c>();

                Asset_Version_History__c avh1 = new Asset_Version_History__c(Asset__c = asslist[0].id); //Installed Asset
                Asset_Version_History__c avh2 = new Asset_Version_History__c(Asset__c = asslist[0].id); //Installed
                Asset_Version_History__c avh3 = new Asset_Version_History__c(Asset__c = asslist[1].id); //Obsolete Asset
                Asset_Version_History__c avh4 = new Asset_Version_History__c(Asset__c = asslist[2].id); //Obs
                Asset_Version_History__c avh5 = new Asset_Version_History__c(Asset__c = asslist[3].id);

                avhlist.add(avh1);
                avhlist.add(avh2);
                avhlist.add(avh3);
                avhlist.add(avh4);
                avhlist.add(avh5);

                insert avhlist;

                update avh1;
                update avh2;
                //update avh3;

               }
 }
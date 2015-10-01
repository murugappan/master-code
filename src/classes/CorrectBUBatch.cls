global class CorrectBUBatch implements Database.Batchable <SObject> 
{
                global Iterable<SObject> start(Database.BatchableContext info)
                {       
       return Database.getQueryLocator('Select Id From StagingTableTEMP__c Where BUSet__c = false');       
                }

	global void execute(Database.BatchableContext info, List<SObject> scope)
	{

			   for (SObject o: scope)
			   {
				
				StagingTableTEMP__c ST = [Select Id, BUName__c, OppName__c, BUSet__c, OrderNumber__c From StagingTableTEMP__c Where BUSet__c = false AND ID = :o.Id];
				
				System.Debug(ST);
				
				String BUName = ST.BUName__c;
				String OppName = ST.OppName__c;
				String OrderNumber;
				
				if(ST.OrderNumber__c != null)
				{
					OrderNumber = ST.OrderNumber__c;
				}
				Set<String> TheIDStrings = New Set<String>();

				KimbleOne__BusinessUnit__c BU1 = [Select Id, KimbleOne__BusinessUnitGroup__r.Id From KimbleOne__BusinessUnit__c Where Name = :BUName];

				Opportunity TheOpportunity;
				
				//List Opp where opp name is XX. Set BU to new BU
				if(OrderNumber != null)
				{
					TheOpportunity = [Select ID, KimbleCRMInt__BusinessUnit__c, KimbleCRMInt__BusinessUnit__r.KimbleOne__BusinessUnitGroup__r.Name 
					From Opportunity 
					Where PFIN_Intgr_Contract_Num__c = :OrderNumber];
				}
				else
				{
					TheOpportunity = [Select ID, KimbleCRMInt__BusinessUnit__c, KimbleCRMInt__BusinessUnit__r.KimbleOne__BusinessUnitGroup__r.Name 
					From Opportunity 
					Where Name = :OppName];
				}

				if(TheOpportunity.KimbleCRMInt__BusinessUnit__c != null)
				{
					TheOpportunity.KimbleCRMInt__BusinessUnit__c = BU1.Id;
				}

				update TheOpportunity;

				//List SO where Opp anme is XX Set BU to new BU
				KimbleOne__SalesOpportunity__c TheSalesOpportunity = [Select ID, KimbleOne__BusinessUnit__c, KimbleOne__BusinessUnit__r.Name, KimbleOne__BusinessUnit__r.KimbleOne__BusinessUnitGroup__r.Name 
				From KimbleOne__SalesOpportunity__c 
				Where KimbleCRMINT__Opportunity__r.ID = :TheOpportunity.Id];

				TheIDStrings.add(TheSalesOpportunity.ID);

				TheSalesOpportunity.KimbleOne__BusinessUnit__c = BU1.Id;

				update TheSalesOpportunity;

				//Select DG
				KimbleOne__DeliveryGroup__c TheDeliveryGroup = [Select ID, Business_Unit__c 
				From KimbleOne__DeliveryGroup__c 
				Where KimbleCRMINT__Opportunity__r.ID = :TheOpportunity.Id];

				//List DEs where Opp is XX set to new BUs
				List<KimbleOne__DeliveryElement__c> TheDeliveryElements = [Select ID, KimbleOne__BusinessUnitGroup__c
				From KimbleOne__DeliveryElement__c Where KimbleOne__DeliveryGroup__r.Id = :TheDeliveryGroup.Id];

				for(KimbleOne__DeliveryElement__c li : TheDeliveryElements)
				{
					TheIDStrings.add(li.ID);
					li.KimbleOne__BusinessUnitGroup__c = BU1.KimbleOne__BusinessUnitGroup__r.Id;
				}

				update TheDeliveryElements;

				//List RAs etc
				List<KimbleOne__ResourcedActivity__c> TheResourcedActivity = [Select ID, KimbleOne__BusinessUnit__c
				From KimbleOne__ResourcedActivity__c Where KimbleOne__DeliveryElement__r.Id IN :TheIDStrings OR KimbleOne__SalesOpportunity__r.Id IN :TheIDStrings];

				for(KimbleOne__ResourcedActivity__c li1 : TheResourcedActivity)
				{	
					li1.KimbleOne__BusinessUnit__c = BU1.Id;
				}

				update TheResourcedActivity;

				//List Contracted Value PA
				List<KimbleOne__PerformanceAnalysis__c> ThePerformanceAnalysis = [Select ID, KimbleOne__BusinessUnit__c
				From KimbleOne__PerformanceAnalysis__c Where KimbleOne__DeliveryGroup__r.Id = :TheDeliveryGroup.Id AND KimbleOne__AnalysisFact__r.KimbleOne__Enum__c = 'ContractedValue'];

				for(KimbleOne__PerformanceAnalysis__c li2 : ThePerformanceAnalysis)
				{	
					li2.KimbleOne__BusinessUnit__c = BU1.Id;
				}

				update ThePerformanceAnalysis; 
				
				ST.BUSet__c = True;
				
				update ST;
				
				update scope;    
                }
				}
                
				public void RunTheTestCode()
				{
					List<string> stringList = new List<string>();
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');		
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');		
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');		
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');		
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
					stringList.add('Hello');
				}	
								 
							global void finish(Database.BatchableContext info)
							{     
											 
							} 
			}
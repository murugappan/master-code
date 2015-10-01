trigger approvalFillProductList on Bb_Approvals__c (after insert, after update) 
{

	// This trigger is used to fill the Product related list on the Bb Approvals object.	
	for(Bb_Approvals__c a: Trigger.new) 
  	{    
  		if ( trigger.isInsert || a.Approval_Status__c == 'Pending')
		{  		
  		
  			// If this is an update to an existing approval object
			if ( trigger.isUpdate)
			{
				// remove any existing product lines/descrs
				List<Approval_Product__c> toDelete = new List<Approval_Product__c> ( [Select Id From Approval_Product__c Where Bb_Approvals__c = :a.Id] );			
				if(! toDelete.isEmpty() ) 
				{
					delete toDelete;
				}
			}

			// create a list of line items
			List<OpportunityLineItem> oppLines = [Select Id, OpportunityId, PricebookEntryId, Quantity, Start_Price__c, Discount_Amount__c, Customer_Price__c, Unused_Credit__c, Backout_Value__c, TotalPrice From OpportunityLineItem Where OpportunityId = :a.Opportunity__c];
	
		   	Set<Id> pbeIds = new Set<Id>();
		   	for (OpportunityLineItem l :  oppLines )
		   	{
		    	pbeIds.add(l.PricebookEntryId);		  
		   	}
	   	
	   	
		   	// find the name of the products
		   	Map<Id, PricebookEntry> names = new Map<Id, PricebookEntry>( [Select Product2.Name From PricebookEntry where Id IN :pbeIds] );


			// create a list of products from the opp to add to the approval related list
			List<Approval_Product__c> listOfProducts = new List<Approval_Product__c>();
			for (OpportunityLineItem eachline : oppLines )
			{
			
				Approval_Product__c p = new Approval_Product__c ();
				p.Name = names.get(eachline.PricebookEntryId).Product2.Name;
				p.Bb_Approvals__c = a.Id;
				p.Quantity__c = eachline.Quantity;
				p.OpportunityId__c = eachline.OpportunityId;
				p.OpportunityLineItemId__c = eachline.Id;
				p.Start_Price__c = eachline.Start_Price__c;
				P.Discount_Amount__c = eachline.Discount_Amount__c;
				p.Customer_Price__c = eachline.Customer_Price__c;
				p.Backout_Value__c = eachline.Backout_Value__c;
				p.Unused_Credit__c = eachline.Unused_Credit__c;
				p.Total_Sales_Credit__c = eachline.TotalPrice;
				listOfProducts.add(p);
  			}

		  		
  			// insert all the products if the list is not empty
  			// There is a limit of 100 DML actions per trigger.  
  			if (!listOfProducts.isEmpty())
  			{
  				insert listOfProducts;
  			}
  		}
	}
}
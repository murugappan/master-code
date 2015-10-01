/*
Author:  Jon Lal
Date:    July 17, 2013
Descr:   This is the extension that controlls the functionality of the LicenseKeyGenerator VF page



Changelog:
2013-09-09: [LaL] Change criteria of eligible childs to include installed or isCurrent

*/
public class LicenseKeyGeneratorExt{
    // an instance varaible for the standard controller
    private ApexPages.StandardController controller {get; set;}
     
    // the object being referenced via url
    private Asset asset {get;set;}
    public Asset a {get; set;}
    public Id account_id {get; set;}
    public Id asset_id {get; set;}
    public Id parent_id {get;set;}
    public Account account {get;set;}


	// <apex:param sent from the page />
    public Id childAssetID {
        get;
        
        set{
        	childAssetId = value;  
        }
    
    }
   
    // initialize the controller
    public LicenseKeyGeneratorExt(ApexPages.StandardController controller) {
 
        //initialize the stanrdard controller
        this.controller = controller;
        // load the current record
        this.asset = (Asset)controller.getRecord();
        
        List<Asset> li = [SELECT  Id, AccountId, KEYGEN_Parent_Asset__c FROM Asset  WHERE Id = :asset.Id];
        if (li.size() > 0 ) {
            account_id = li[0].AccountId;
            asset_id = li[0].Id;
            parent_id = li[0].KEYGEN_Parent_Asset__c;
        }
    }
 
    // for child, get the selected parent information        
    public List<Asset> getSelectedParentAsset() {
        if ( parent_id != null ){
	        return ( [SELECT Id, Name, Product2.ProductCode, Product2.GKEY_Product_Group__c, Status,
    	              True_ID__c, Original_True_ID__c
        	          From Asset Where Id = :parent_id Limit 1]);
        }
        else{
            return null;
        }
    }
    
    // boolean does it have a parent selectec
    public Boolean getHasParent() {
		Boolean has = false;
		if ( [SELECT Id FROM Asset WHERE Id = :parent_id].size() > 0 ){
        	has = true;
        }
        return has;    
    }

    // for child, get the elilgible parent information        
    public List<Asset> getEligibleParentAssets() {
       return ( [SELECT Id, Name, Product2.ProductCode, Product2.GKEY_Product_Group__c, Status,
                 True_ID__c, Original_True_ID__c
                 From Asset Where AccountId = :asset.AccountId 
                 And Product2.GKEY_Product_Group__c like 'BB-LS%'
                 And Id != :parent_id
                 Limit 20]);
    } 

    
    // handle the action of the generate commandButton
    public PageReference doGenerate() {
        asset.KEYGEN_Webservice_Msg_Status__c = 'Message Sent';
        update asset;
    	return null;    
    }
    
    // this will associate the child to the parent and then reload the screen
    public PageReference doMakeChild() {
		childAssetId = ApexPages.currentPage().getParameters().get('childAssetId');
        if (childAssetId != null ){
			Asset[] childAsset = [Select Id, Name, KEYGEN_Parent_Asset__c From Asset Where Id = :childAssetId Limit 1];
            if (childAsset[0] != null ){
            	childAsset[0].KEYGEN_Parent_Asset__c = asset.Id;
        		update childAsset;
            }
        }
    	return null;    
    }    
    
    // this will remove a child from the parent and then reload the screen
    public PageReference doRemoveChild() {
		childAssetId = ApexPages.currentPage().getParameters().get('childAssetId');
        if (childAssetId != null ){
			Asset[] childAsset = [Select Id, Name, KEYGEN_Parent_Asset__c From Asset Where Id = :childAssetId Limit 1];
            if (childAsset[0] != null ){
            	childAsset[0].KEYGEN_Parent_Asset__c = null;
        		update childAsset;
            }
        }
    	return null;    
    }    
    
    
    // this is to retrieve the list of current Child assets and the other eligible child assets and make the UI pretty
    public List<Asset> getChildAssets() {
        return ( [SELECT Id, Name,Product2.ProductCode, Product2.GKEY_Product_Group__c, 
                  CPQ_Contract_Start_Date__c, CPQ_Contract_End_Date__c,
                  True_ID__c, Original_True_ID__c
                  From Asset Where KEYGEN_Parent_Asset__c = :asset_id ]);
    } 

    public Boolean getHasChildAssets() {
		Boolean has = false;
		if ( getChildAssets().size() > 0 ){
        	has = true;
        }
        return has;    
    }
    
    public List<Asset> getEligibleChildAssets() {
        return ( [SELECT Id, AccountId, Name, Product2.ProductCode, Product2.GKEY_Product_Group__c, 
                  CPQ_Contract_Start_Date__c, CPQ_Contract_End_Date__c,
                  True_ID__c, Original_True_ID__c
                  FROM Asset  
                  WHERE AccountId = :account_id  
                  AND (Status = 'Installed' or isCurrent__C = true)   
                  AND KEYGEN_Parent_Asset__c = null  
                  AND Product2.GKEY_Product_Group__c  LIKE 'BB-CHD%' 
                 ]
               );
    } 
    
    public Boolean getHasEligibleChildAssets() {
		Boolean has = false;
		if ( getEligibleChildAssets().size() > 0  ){ 
            has = true; 
        }
        return has;
    }
}
trigger UpdatePsftProductID on Case (before insert, before update) {
	
   if(globalcomponent.getapiuser(userinfo.getuserid()) != true && !casetriggerhandler.hasupdatePsftProductIdRun){
    Set<ID> assetid = new Set<ID>();
    Map<Id,String> psftmap = new Map<Id,String>();
 
    for(Case c : Trigger.New){
        if(c.AssetID != null)
            assetID.add(c.AssetID);
    }
    
    for(List<Asset> alist : [select ID,Psft_Product_Id__c from Asset where ID IN: assetID]){
        for(Asset a : alist){
            psftmap.put(a.ID,a.Psft_Product_Id__c);
        }
    }
    
    for(Case c : Trigger.New){
        if(Trigger.isInsert){
            if(c.AssetID != null)
                c.Psft_Product_Id__c = psftmap.get(c.AssetID);
        }else if(Trigger.isUpdate){
            Case oldc = Trigger.oldMap.get(c.ID);
            if(c.AssetID != null && c.AssetID != oldc.AssetID)
                c.Psft_Product_Id__c = psftmap.get(c.AssetID);
        }
    }
    casetriggerhandler.hasupdatePsftProductIdRun=true;
    }
}
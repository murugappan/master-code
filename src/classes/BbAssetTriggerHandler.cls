public class BbAssetTriggerHandler{
 // ------------------------------------------------
    // Constructor Method
    // ------------------------------------------------
    public BbAssetTriggerHandler(){
    }
    //Declare Boolean variable to prevant recursive call
     public static Boolean hasAfterUpdateRun {get {if (hasAfterUpdateRun == null) return false; return hasAfterUpdateRun;} set;}    
        
        
        
        
    // ------------------------------------------------
    // Triggers Methods
    // ------------------------------------------------
    public void OnBeforeInsert(Asset[] newAssets){
    
        
      
    }
    
    public void OnAfterInsert(Asset[] newAssets, Map<ID, Asset> insertedAssetMap){
        
    }
        
    public void OnBeforeUpdate(Asset[] oldAssets, Asset[] updatedAssets, Map<ID, Asset> oldAssetMap, Map<ID, Asset> updatedAssetMap){
        createLicenseAttachment (oldAssets, updatedAssets, oldAssetMap, updatedAssetMap);
        RelatedAssetwithOpportunity(oldAssets, updatedAssets, oldAssetMap, updatedAssetMap);
      
       
    }
    
    public void OnAfterUpdate(Asset[] oldAssets, Asset[] updatedAssets, Map<ID, Asset> oldAssetMap, Map<ID, Asset> updatedAssetMap){
     hasAfterUpdateRun = true;
     InsertAssetVersion(oldAssets,updatedAssets,oldAssetMap,updatedAssetMap); 
     // Added By Nikhil
     // commenting for testing UpdatePreviuosYearNetpriceOnline(oldAssets,updatedAssets,oldAssetMap,updatedAssetMap);
     //PreviousYearNetprice(oldAssets,updatedAssets,oldAssetMap,updatedAssetMap);
     //sneha's code 
     PreviuosYearNetprice2(oldAssets,updatedAssets,oldAssetMap,updatedAssetMap);
     
     
    }

    // ------------------------------------------------
    // Class Methods
    // ------------------------------------------------    
    private void createLicenseAttachment (Asset[] oldAssets, Asset[] updatedAssets, Map<ID, Asset> oldAssetMap, Map<ID, Asset> updatedAssetMap) {
        
        // Only process when not a bulk load and there is large content in the XML field.
        if (updatedAssets.size() == 1 && updatedAssets[0].KEYGEN_License_XML__c != null ) {
            Asset asset = updatedAssets[0];
            Asset[] a ;
            String ProductName;
            String AccountName;
            String sDate = String.valueOf( Date.Today() );

            if (asset.AccountId != null && asset.Product2Id != null ){
                 a =  [Select Id, Account.Name, Product2.Name From Asset Where Id = :asset.Id LIMIT 1];
            }
            
            if (a[0] != null)
            {
                ProductName = a[0].Product2.Name;
                AccountName = a[0].Account.Name;
            }
                
            // Only when there is a change to the license XML field.
            if ( updatedAssetMap.get(asset.Id).KEYGEN_License_XML__c != oldAssetMap.get(asset.Id).KEYGEN_License_XML__c ) {
                Blob txtBlob = Blob.valueOf(asset.KEYGEN_License_XML__c); //Convert it to a blob

                String fileName = AccountName+'_'+ ProductName + '_' + asset.KEYGEN_Product_Name__c + + '_' + sDate +  '.xml';  
                Attachment attach = new Attachment(); //Make an attachment
                attach.Name = fileName;
                attach.Body = txtBlob;
                attach.ContentType= 'application/octet-stream'; //Signal what the file's MIME type is
                attach.ParentID = asset.Id;
                try {
                    insert attach; 
                } catch ( DMLException e){
                    asset.KEYGEN_Webservice_Msg_Status__c = 'Unable to create XML attachment: ' + e;
                    try {
                        update asset;
                    } catch ( DMLException f ){
                        System.Debug('big error >>>LAL<<<' + f);
                    }
                        
                }
                if ( attach.Id != null ) {
                    asset.KEYGEN_Latest_License_File__c = attach.Id;
                    asset.KEYGEN_Latest_License_Filename__c = attach.Name;
                    
                    try {
                        system.debug('updating asset with AttachmentID field');
                        //update asset;
                    } catch ( DMLException e ) {
                        system.debug('>>>LAL<<<:  error updating License File Id: ' + e );
                    }
                }
            }            
        }
    } 
 private void InsertAssetVersion(Asset[] oldAssets, Asset[] updatedAssets, Map<ID, Asset> oldAssetMap, Map<ID, Asset> updatedAssetMap) {

  Set<id> Accid = New Set<id>();
  Set<id> Asetid = New Set<id>();
  List<date> datestr= New List<date>();
  For(Asset aset : updatedAssets)
    {
        if(aset.Status =='Obsolete' && aset.CPQ_Contract_End_Date__c != null)
         {
             Asetid.Add(aset.id); 
             Accid.add(aset.Accountid);
             datestr.Add(aset.CPQ_Contract_End_Date__c +1);
         }
    
    }

  if(Accid.Size()>0)
  { 
    
     
      List<Asset> Laset =[SELECT AccountId,API_Login__c,API_Password__c,Application_Server_OS__c,ASP_Location__c,Asset_Type__c,BbIM_SAS_Integrated__c,Bugzilla_Bug_Number__c,Clustering_of_Servers__c,CL_Test_API_Login__c,CL_Test_API_Password__c,CMS_Type__c,CMS_Version__c,Comments__c,ContactId,Core_License__c,CPQ_Active__c,CPQ_contractLength__c,CPQ_Contract_End_Date__c,CPQ_Contract_Start_Date__c,CPQ_currentYear__c,CPQ_Current_Opportunity_ID__c,CPQ_forCPQ__c,CPQ_Intergrated_System__c,CPQ_isCoreItem__c,CPQ_isMultiyear__c,CPQ_ISO_Currency_Code__c,CPQ_isRenewable__c,CPQ_LineIdentifier__c,CPQ_Net_Price__c,CPQ_NumQty__c,CPQ_Package_Id__c,CPQ_Package__c,CPQ_Parent_Item__c,CPQ_Previous_Opportunity_ID__c,CPQ_Product_Platform__c,CPQ_Selling_Exchange_Rate__c,CPQ_User_Band__c,CreatedById,CreatedDate,CurrencyIsoCode,Customer_Value__c,Database_Server_OS__c,Database__c,Date_Ordered__c,Date_Registered__c,Date_Shipped__c,Days_to_Expiration__c,Description,Development_Server_URL__c,DNS_Servers__c,Domain_Name__c,Eportfolio_Enabled__c,Eportfolio_of_Seats__c,External_Asset_Name__c,External_Description__c,External_Order_Id__c,Force_SSL__c,Front_Back_Access__c,FTE__c,Gateway_IP_Address__c,Grace_Period__c,Hardware_Key__c,Hardware_Option__c,Hosting_Contact__c,Hosting_Option__c,Hosting_Server__c,Hostname__c,IC_Custom__c,Id,Implementation_Consultant_Email__c,Implementation_Consultant__c,InstallDate,Installed_Product_ID__c,Installed_Product_Note__c,Instance_URL__c,Integration_Component__c,IsCompetitorProduct,IsDeleted,I_and_C_Support__c,JDK_Version__c,LastModifiedById,LastModifiedDate,Last_Upgrade_Date__c,License_Expiration_Date__c,License_Key__c,Login_Styles__c,Maintenance_Level__c,Managed_Hosting__c,Manager_Login__c,Manager_Password__c,Moderator_Link__c,Name,Network__c,New_Users_this_month__c,New_Users_this_week__c,Nickname__c,Number_of_Institutions_Hosted__c,Number_of_Seats__c,Number_of_Users__c,Old_Product_Id__c,Opportunity_Owner_Email__c,Opportunity_Owner_Phone__c,Opportunity_Owner_Title__c,Opportunity_Owner__c,Opportunity__c,Order_Id__c,Participant_Link__c,Phone_End_Date__c,Phone_Service_Type__c,Phone_Simulcast_Number__c,Phone_Start_Date__c,Platform__c,Price,Primary_IP__c,Product2Id,Production_Server_URL__c,Product_Category__c,Product_ID__c,Product_Type__c,Psft_Product_Id__c,PurchaseDate,Purchase_Order__c,QPQ_Reseller__c,Quantity,Recording_Link__c,Secondary_Contact_Email__c,Secondary_Contact__c,SerialNumber,Server_Customization__c,Server_Network_Mask__c,Server_OS__c,Software_URL__c,Status,Support_Email__c,Support_Level__c,Support_Phone__c,SystemModstamp,Time_Zone__c,Total_Users__c,Type__c,Upgraded_from_Product_ID__c,Upgraded__c,Upgrade_Flag__c,UsageEndDate,User_Limit__c,Version_Build__c,Version_Effective_Date__c,Version__c,Virtual_IP__c,Voice_Direct_Enabled__c,Warm_Standby_IP__c,Warranty_End_Date__c,Warranty_Name__c,Warranty_Start_Date__c,Warranty_Status__c,WebCT_Instance__c,WebCT_IP_Address__c from Asset WHERE (Status='Installed') AND CPQ_forCPQ__c=true AND CPQ_isRenewable__c=true AND CPQ_Contract_Start_Date__c IN : datestr AND Accountid IN :Accid];
    
      List<Asset_Version_History__c> Lversion =[Select id,Name,Asset__c,Current_Build__c,Current_Version__c,Effective_Date__c  from Asset_Version_History__c Where Asset__c IN :Asetid];
   
      
      // Map of Account id and newly list of Asset
      Map<id,List<Asset>> accAsset = New Map<id,List<Asset>>();
      
      For(Asset ast : Laset )
      {
          
          if(accAsset.containsKey(ast.Accountid))
          {
          
          List<Asset> last =accAsset.get(ast.Accountid);
          last.add(ast);
          accAsset.put(ast.Accountid,last);
          
          }
          else
          {
            List<Asset> Lasst = New List<Asset>();
            Lasst.Add(ast);
            accAsset.put(ast.Accountid,Lasst);
          
          
          
          
          }
      
      
      
      
      
      }
      
      
    
    
    
      Map<id,List<Asset_Version_History__c>> AsetAndVersion= New  Map<id,List<Asset_Version_History__c>>(); 
  
  
      For(Asset_Version_History__c  AsetVer : Lversion)
      {
         if(AsetAndVersion.ContainsKey(AsetVer.Asset__c))
         {
           
           List<Asset_Version_History__c> tempvrsion = New List<Asset_Version_History__c>();
           tempvrsion=AsetAndVersion.get(AsetVer.Asset__c);
           tempvrsion.add(AsetVer);
           AsetAndVersion.put(AsetVer.Asset__c,tempvrsion);
         
         }
         Else
         {
          
         List<Asset_Version_History__c> tempversion = New List<Asset_Version_History__c>();
         tempversion.Add(AsetVer);
         AsetAndVersion.put(AsetVer.Asset__c,tempversion);
         
         
         }
       
      }
  
  
  
  
  
    
    
  List<Asset_Version_History__c> forinsert = New  List<Asset_Version_History__c>(); 
    
    For(Asset Aset: updatedAssets) 
    {
       
        if(aset.Status =='Obsolete')
         { 
       
             if(accAsset.containskey(aset.Accountid))
               {
                 
                  for(Asset st : accAsset.get(aset.Accountid))
                  {
                      
                       if(Aset.Psft_Product_Id__c == st.Psft_Product_Id__c && Aset.CPQ_LineIdentifier__c ==st.CPQ_LineIdentifier__c)
                        {
                        
                             if(AsetAndVersion.Containskey(Aset.id))
                             {
                                 for(Asset_Version_History__c asver : AsetAndVersion.get(Aset.id))
                                   {
                                   
                                     Asset_Version_History__c astver = asver.clone(false,true,false,false);
                                     astver.Asset__c=st.id;
                                     forinsert.add(astver);
                                   
                                   
                                   
                                   } 
                             
                             
                             }
                        
                        
                        }
                  
                  
                  
                  
                  
                  
                  }
                  
               
               
               
               
               
               }
    
    
    
    
    
    
         }
    }      
        
  
  Insert forinsert;
  
  
  
  
  
  
  
  
  
  
  
  
  
  

  
  
  
            
  
  
  
  
  
  }
   
  


}
// To relate old assets with opportunities
private void RelatedAssetwithOpportunity (Asset[] oldAssets, Asset[] updatedAssets, Map<ID, Asset> oldAssetMap, Map<ID, Asset> updatedAssetMap) {


        //Current Opportunities ids
        Set<id> Oppid = New Set<id>();
        
        For(Asset ast : updatedAssets)
        {
            if(ast.Opportunity__c== Null && ast.CPQ_Current_Opportunity_ID__c!=Null)
            {
                
                // Add all the current opportunities
                Oppid.Add(ast.CPQ_Current_Opportunity_ID__c);
            
            }
        
        
        }
        
        If(Oppid.Size() >0)
        { 

            Map<id,Opportunity> Mopp =  new Map<id,Opportunity>([Select id, Start_Date__c,End_Date__c,StageName from Opportunity Where Id IN : Oppid and StageName='(W) Won']);

            For(Asset ast : updatedAssets)
            {
                if(ast.Opportunity__c== Null && ast.CPQ_Current_Opportunity_ID__c!=Null && Mopp.ContainsKey(ast.CPQ_Current_Opportunity_ID__c) && Mopp.get(ast.CPQ_Current_Opportunity_ID__c).Start_Date__c!= Null && ast.CPQ_Contract_Start_Date__c==Mopp.get(ast.CPQ_Current_Opportunity_ID__c).Start_Date__c && Mopp.get(ast.CPQ_Current_Opportunity_ID__c).End_Date__c!= Null && ast.CPQ_Contract_End_Date__c==Mopp.get(ast.CPQ_Current_Opportunity_ID__c).End_Date__c)
                {
                    
                    ast.Opportunity__c=ast.CPQ_Current_Opportunity_ID__c;
                
                }
            
            
            }
        }





}
// Added BY Nikhil Date:- 7/14/2014
private void UpdatePreviuosYearNetpriceOnline(Asset[] oldAssets, Asset[] updatedAssets, Map<ID, Asset> oldAssetMap, Map<ID, Asset> updatedAssetMap) {

    //Current Opportunities ids
    Set<id> Oppid = New Set<id>();
    
    // Only we can edit Asset where current Opportunity should be Won.
    
    // Asset Current opportunities
    For(Asset ast : updatedAssets)
    {   
        If(ast.CPQ_Current_Opportunity_ID__c!=Null && ast.CPQ_Current_Opportunity_ID__c!='' && ast.CPQ_Current_Opportunity_ID__c.length()==18 && ast.Local_Price_Calculation__c !=oldAssetMap.get(ast.id).Local_Price_Calculation__c)
        {
            //Add all the current opportunities
            Oppid.Add(ast.CPQ_Current_Opportunity_ID__c);
        }
    
    }
    
    If(Oppid.Size() >0)
    { 
        
        //Set of Won opportunities Only
       set<id> OppWid = New set<id>();
        
        
       Map<id,Opportunity> Mopp =  new Map<id,Opportunity>([Select id,StageName from Opportunity Where Id IN : Oppid and StageName='(W) Won']);
       
       //Set of future opportunties id
       Set<id> futureOppid = New Set<id>();
       
       For(Opportunity Opp : [Select id,CPQ_Previous_Opportunity__c,StageName from Opportunity Where CPQ_Previous_Opportunity__c IN :Oppid])
       {
                if(Opp.StageName !='(W) Won')
                {
                futureOppid.Add(Opp.id); 
                }
       }
        
        if(Mopp.Keyset().Size()>0)
        {
                // Map of LineItems
                Map<string,OpportunityLineItem> PrdKey = New Map<String,OpportunityLineItem>();
                
                
                
                // Create a Map for Key and OpportunityLineItem
                For(OpportunityLineItem Oppl : [Select id,Opportunity.CPQ_Previous_Opportunity__c,PriorYearPrice__c,CPQ_Previous_Year_Net_Price__c,Renewal_Unique_Line_ID__c,Opportunity.recordtype.Name,CPQ_Product_End_Date__c,CPQ_Product_Start_Date__c,Opportunityid,Product_Instance__c,PricebookEntry.ProductCode from OpportunityLineItem Where Opportunityid IN :futureOppid])
                {   
                        // Need to work only on Renewal opportunity
                        PrdKey.Put(Oppl.Opportunity.CPQ_Previous_Opportunity__c+Oppl.PricebookEntry.ProductCode+Oppl.CPQ_Product_Start_Date__c+Oppl.Renewal_Unique_Line_ID__c,Oppl);
                    
                    
                }
                
                //List of OpportunityLineItem
                List<OpportunityLineItem> Oppll = New List<OpportunityLineItem>();

                // Set of opportunity product id to avoid multiple add of same record in the list
                Set<id> opplid = New Set<id>();
                
                For(Asset ast : updatedAssets)
                {   
                    If(ast.CPQ_Current_Opportunity_ID__c!=Null&&ast.CPQ_Current_Opportunity_ID__c!='' && ast.CPQ_Current_Opportunity_ID__c.length()==18 && ast.Local_Price_Calculation__c !=oldAssetMap.get(ast.id).Local_Price_Calculation__c && Mopp.containsKey(ast.CPQ_Current_Opportunity_ID__c)&& Mopp.get(ast.CPQ_Current_Opportunity_ID__c).StageName=='(W) Won')
                    {
                        
                       
                            // This will work as Key
                            if(ast.CPQ_Current_Opportunity_ID__c!=Null &&ast.CPQ_Contract_End_Date__c!=Null && PrdKey.ContainsKey(ast.CPQ_Current_Opportunity_ID__c+ast.Psft_Product_Id__c+ast.CPQ_Contract_End_Date__c.addDays(1)+ast.CPQ_LineIdentifier__c) && !opplid.contains(PrdKey.get(ast.CPQ_Current_Opportunity_ID__c+ast.Psft_Product_Id__c+ast.CPQ_Contract_End_Date__c.addDays(1)+ast.CPQ_LineIdentifier__c).id))
                            {
                            //PrdKey.get(ast.CPQ_Current_Opportunity_ID__c+ast.Psft_Product_Id__c+ast.CPQ_Contract_End_Date__c.addDays(1)+ast.CPQ_LineIdentifier__c).PriorYearPrice__c=ast.Local_Price_Calculation__c;
                            Oppll.Add(PrdKey.get(ast.CPQ_Current_Opportunity_ID__c+ast.Psft_Product_Id__c+ast.CPQ_Contract_End_Date__c.addDays(1)+ast.CPQ_LineIdentifier__c));
                            opplid.add(PrdKey.get(ast.CPQ_Current_Opportunity_ID__c+ast.Psft_Product_Id__c+ast.CPQ_Contract_End_Date__c.addDays(1)+ast.CPQ_LineIdentifier__c).id);
                            }
              
                        
                        
                        
                    }
                
                }
                 If(Oppll.Size()>0)
                 Update Oppll;
                
        
        
        }
        
    }


}
private void PreviuosYearNetprice2(Asset[] oldAssets, Asset[] updatedAssets, Map<ID, Asset> oldAssetMap, Map<ID, Asset> updatedAssetMap) {

set<Id> Idset = new set<Id>();

for(Asset ast : updatedAssets){

    if(ast.CPQ_Current_Opportunity_ID__c != null && ast.CPQ_Current_Opportunity_ID__c!='' && ast.CPQ_Current_Opportunity_ID__c.length()==18 && ast.Local_Price_Calculation__c !=oldAssetMap.get(ast.id).Local_Price_Calculation__c){
        Idset.add(ast.CPQ_Current_Opportunity_ID__c);
    }
    else if(ast.Opportunity__c != null && ast.Local_Price_Calculation__c !=oldAssetMap.get(ast.id).Local_Price_Calculation__c)
    {
      Idset.add(ast.Opportunity__c);
    }
    
}

list<Opportunity> oppList = [Select id,Opportunity_ID_18__c, CPQ_Previous_Opportunity__c from Opportunity Where Id IN: Idset ];
System.debug('Opplist'+Opplist);
list<Opportunity> oppListUpdate = [Select id,Opportunity_ID_18__c, CPQ_Previous_Opportunity__c from Opportunity Where CPQ_Previous_Opportunity__c IN: Idset ];
System.debug('oppListUpdate'+oppListUpdate);
set<Id> currentoppsIdset = new set<Id>();
set<string> renewaloppsIdset = new set<string>();

if(oppList.size() > 0){
    for(Opportunity opp: oppList){
        
        if(opp.CPQ_Previous_Opportunity__c == null){
            currentoppsIdset.add(opp.Opportunity_ID_18__c);
            system.debug('Current Opps'+currentoppsIdset);
            
        }
    }

}

if(oppListUpdate.size() > 0){
    for(Opportunity opp: oppListUpdate){
        
        //if(opp.CPQ_Previous_Opportunity__c == null){
            renewaloppsIdset.add(opp.Opportunity_ID_18__c);
            system.debug('Renewal Opps'+renewaloppsIdset);
        //}
    }
}


Map<string, OpportunityLineItem> CurrentOppLineMap = new Map<string, OpportunityLineItem>();

list<OpportunityLineItem> CurrentoppLineItemlist = [Select id,Opportunity.CPQ_Previous_Opportunity__c,PriorYearPrice__c,CPQ_Previous_Year_Net_Price__c,Renewal_Unique_Line_ID__c,Opportunity.recordtype.Name,CPQ_Product_End_Date__c,CPQ_Product_Start_Date__c,Opportunityid,
                                             Product_Instance__c,PricebookEntry.ProductCode from OpportunityLineItem
                                             Where OpportunityId IN: currentoppsIdset ];                                           
                                     
for(OpportunityLineItem CurrentoppLine: CurrentoppLineItemlist){
    CurrentOppLineMap.put(CurrentoppLine.Renewal_Unique_Line_ID__c,CurrentoppLine );
}   



Map<string, OpportunityLineItem> RenewalOppLineMap = new Map<string, OpportunityLineItem>();

list<OpportunityLineItem> RenewaloppLineItemlist = [Select id,Opportunity.CPQ_Previous_Opportunity__c,PriorYearPrice__c,CPQ_Previous_Year_Net_Price__c,Renewal_Unique_Line_ID__c,Opportunity.recordtype.Name,CPQ_Product_End_Date__c,CPQ_Product_Start_Date__c,Opportunityid,
                                             Product_Instance__c,PricebookEntry.ProductCode from OpportunityLineItem
                                             Where OpportunityId IN: renewaloppsIdset ];
                                                                
                                     
                                    
for(OpportunityLineItem RenewaloppLine: RenewaloppLineItemlist){
    RenewalOppLineMap.put(RenewaloppLine.Renewal_Unique_Line_ID__c,RenewaloppLine );
}   


List<OpportunityLineItem> OppLinetoUpdate = New List<OpportunityLineItem>();
List<OpportunityLineItem> RenewalOppLinetoUpdate = New List<OpportunityLineItem>();


for(Asset ast : updatedAssets)
                {   
                    
                   
                   
                   if(ast.CPQ_Current_Opportunity_ID__c != null && ast.CPQ_Current_Opportunity_ID__c!='' && ast.CPQ_Current_Opportunity_ID__c.length()==18 && ast.Local_Price_Calculation__c != oldAssetMap.get(ast.id).Local_Price_Calculation__c)
                    { 
                       if (CurrentoppLineMap.containsKey(ast.CPQ_LineIdentifier__c)){
                       OpportunityLineItem oppLineUpdate = new OpportunityLineItem();
                       oppLineUpdate.PriorYearPrice__c = ast.Local_Price_Calculation__c;
                       oppLineUpdate.Id = (CurrentoppLineMap.get(ast.CPQ_LineIdentifier__c).id);
                       OppLinetoUpdate.add(oppLineUpdate);
                       } 
                    } 
                    
                    
                   if(ast.CPQ_Current_Opportunity_ID__c != null && ast.CPQ_Current_Opportunity_ID__c!='' && ast.CPQ_Current_Opportunity_ID__c.length()==18 && ast.Local_Price_Calculation__c != oldAssetMap.get(ast.id).Local_Price_Calculation__c)
                    { 
                       if (RenewalOppLineMap.containsKey(ast.CPQ_LineIdentifier__c)){
                       OpportunityLineItem RenewaloppLineUpdate = new OpportunityLineItem();
                       RenewaloppLineUpdate.PriorYearPrice__c = ast.Local_Price_Calculation__c;
                       RenewaloppLineUpdate.Id = (RenewalOppLineMap.get(ast.CPQ_LineIdentifier__c).id);
                       RenewalOppLinetoUpdate.add(RenewaloppLineUpdate);
                       } 
                    } 
                    
                   
                    
                    
                }
                
                if(OppLinetoUpdate.size() > 0)
                 Update OppLinetoUpdate;
                
                if(RenewalOppLinetoUpdate.size() > 0)
                 Update RenewalOppLinetoUpdate; 
                 
}






///////

      
}
trigger UpdateCustomAsset on Asset(after insert,after update,after delete,Before insert,Before Update) {

List<Asset> stdAsset=new List<Asset>();
List<Asset__c> custAsset=new List<Asset__c>();

// This is for CPQ trigger 

Map<String,id> MCore = New Map<String,id>();

    
    
  if(updationAsset.Beforeinsertflag==false)
  {
    
     if (Trigger.IsBefore && (Trigger.Isupdate || Trigger.IsInsert))
      {
           updationAsset.Beforeinsertflag=True;
              For(Core_License__c cor : [Select id,Name,product__c from Core_License__c])
                {
                  
                  MCore.put(cor.Name+cor.product__c,Cor.id);
                  
                }
                
               //Set Product 
               Set<id> Prdid = New Set<id>();
               For(Asset Ast : Trigger.New)
                {
                 
                  Prdid.Add(Ast.Product2Id);
                
                }
              
              // Map of Product id to BTBB_Product_Group__c.
              Map<id,Product2> Mprd = New Map<id,Product2>([Select id,BTBB_Product_Group__c from product2 where id IN :Prdid]); 
                
           
               For(Asset Aset : Trigger.New)
                {
                  
                  if(Aset.Product2id != Null)
                    {
                       
                        if(Mprd.get(Aset.Product2id).BTBB_Product_Group__c != Null)
                         {
                       
                            if(AssetProducttoCore__c.getAll().ContainsKey(Mprd.get(Aset.Product2id).BTBB_Product_Group__c))
                               {
                               
                               
                               Aset.Core_License__c=MCore.get(AssetProducttoCore__c.getAll().get(Mprd.get(Aset.Product2id).BTBB_Product_Group__c).Core_License__c+AssetProducttoCore__c.getAll().get(Mprd.get(Aset.Product2id).BTBB_Product_Group__c).Product__c);
                               
                               
                               }
                         }
                    }
                }  
                  
                
                
           
      }      
              
           
  }       
      













//Asset__c custAsset1=new Asset__c();
if(updationAsset.deletionFlag==false)
{
    if(trigger.isDelete)
    {
        updationAsset.deletionFlag=true;
        List<Asset> seldelAsset=Trigger.old;
        List<Id> sid=new List<Id>();
        integer i;
        for(i=0;i<seldelAsset.size();i++)
        {
            sid.add(seldelAsset[i].id);
        }
        
        List<Asset__c> existingCustomAsset=[select id,account__c,Product_ID__c from Asset__c where Product_ID__c in :sid];
        for(Asset sa:trigger.old)
        {
            for(Asset__c ca:existingCustomAsset)
            {
            //system.debug('Update Trigger1'+'Standard Asset'+sa.name+'Custom Asset'+ca.Name);
                if(sa.id==ca.Product_ID__c)
                {
                    custAsset.add(ca);
                    system.debug('Custom Asset Id'+ca.id);
                }
            }
        }         
        Delete custAsset;   
    } 
}





if(UpdationAsset.insertFlag==false)
{
    if(trigger.isInsert && trigger.IsAfter)
    {
        UpdationAsset.insertFlag=true;
        for(Asset a: trigger.new)
        {       
            Asset__c custAsset1=new Asset__c();
            System.debug('insertion');
            custAsset1.Account__c=a.AccountId;    
            // custAsset1.Contact__c=a.ContactId;    
            custAsset1.Product_ID__c=a.id;
            custAsset1.nickname__c=a.nickname__c;
            custAsset1.Asset_Name__c=a.Name;
            custAsset1.Application_Server_OS__c=a.Application_Server_OS__c;
            custAsset1.Database__c=a.Database__c;
            custAsset1.Database_Server_OS__c=a.Database_Server_OS__c;
            //stdAsset1.External_Asset_Name__c=a.External_Asset_Name__c;
            custAsset1.Front_Back_Access__c=a.Front_Back_Access__c;
            custAsset1.Managed_Hosting__c=a.Managed_Hosting__c;   
            custAsset1.Installed_Product_ID__c=a.Installed_Product_ID__c;
            custAsset1.JDK_Version__c=a.JDK_Version__c;
            custAsset1.Network__c=a.Network__c;
            custAsset1.Platform__c=a.Platform__c;
            custAsset1.Software_URL__c=a.Software_URL__c;
            custAsset1.Version_Build__c=a.Version_Build__c;
    
            custAsset1.Product__c =  a.Product2.Description;
            custAsset1.Type__c =  a.Type__c;
            custAsset1.Psft_Product_Id__c = a.Psft_Product_Id__c;
            custAsset1.License_Expiration_Date__c = a.License_Expiration_Date__c;
            custAsset1.External_Description__c = a.External_Description__c;    
            custAsset1.Core_License__c = a.Core_License__c;    
            custAsset1.Version__c = a.Version__c;    
            custAsset1.Version_Effective_Date__c = a.Version_Effective_Date__c;    
            custAsset1.Serial_Number__c = a.SerialNumber;    
            custAsset1.Comments__c = a.Comments__c;    
            custAsset1.Status__c = a.Status;    
            custAsset1.Quantity__c = a.Quantity;    
            custAsset1.Install_Date__c = a.InstallDate;    
            custAsset1.Date_Registered__c = a.Date_Registered__c;    
            custAsset1.Customer_Value__c = a.Customer_Value__c;    
            custAsset1.I_and_C_support__c = a.I_and_C_support__c;    
            custAsset1.Support_Level__c = a.Support_Level__c;    
            custAsset1.Upgraded__c = a.Upgraded__c;    
            custAsset1.Days_to_Expiration__c = a.Days_to_Expiration__c;    
            custAsset1.Upgrade_Flag__c = a.Upgrade_Flag__c;    
            custAsset1.Last_Upgrade_Date__c = a.Last_Upgrade_Date__c;    
            custAsset.add(custAsset1);
        }    
        insert custAsset;
    
    //UpdationAsset.insertFlag=true;
    }
}

if(UpdationAsset.updateFlag==false)
{
    if(trigger.isUpdate && Trigger.Isafter)
    {
        UpdationAsset.updateFlag=true;
        system.debug('Update Trigger');
        List<Asset> selAsset=Trigger.new;
        List<Id> sid=new List<Id>();
        integer i;
        for(i=0;i<selAsset.size();i++)
        {
            sid.add(selAsset[i].id);
        }
        List<Asset__c> existingCustomAsset=[select id,account__c,Product_ID__c,Name,Application_Server_OS__c,Database__c,
        Database_Server_OS__c,External_Asset_Name__c,Front_Back_Access__c,Managed_Hosting__c,Installed_Product_ID__c,
        JDK_Version__c,Network__c,Nickname__c,Platform__c,Software_URL__c,Version_Build__c from Asset__c where Product_ID__c in :sid];
        for(Asset sa:trigger.new)
        {
            for(Asset__c ca:existingCustomAsset)
            {
                system.debug('Update Trigger1'+'Standard Asset'+sa.name+'Custom Asset'+ca.Name);
                if(sa.id==ca.Product_ID__c)
                {
                    //sp.id=sa.id;            
                    ca.Account__c=sa.accountId;           
                    // ca.Contact__c=sa.contactId;            
                    ca.Asset_Name__c=sa.Name;
                    ca.Nickname__c=sa.NickName__c;
                    ca.Application_Server_OS__c=sa.Application_Server_OS__c;
                    ca.Database__c=sa.Database__c;
                    ca.Database_Server_OS__c=sa.Database_Server_OS__c;
                    //stdAsset1.External_Asset_Name__c=a.External_Asset_Name__c;
                    ca.Front_Back_Access__c=sa.Front_Back_Access__c;
                    ca.Managed_Hosting__c=sa.Managed_Hosting__c;
                    ca.Installed_Product_ID__c=sa.Installed_Product_ID__c;
                    ca.JDK_Version__c=sa.JDK_Version__c;
                    ca.Network__c=sa.Network__c;
                    ca.Platform__c=sa.Platform__c;
                    ca.Software_URL__c=sa.Software_URL__c;
                    ca.Version_Build__c=sa.Version_Build__c;
            
                    ca.Product__c =  sa.Product2.Description;
                    ca.Type__c =  sa.Type__c;
                    ca.Psft_Product_Id__c = sa.Psft_Product_Id__c;
                    ca.License_Expiration_Date__c = sa.License_Expiration_Date__c;
                    ca.External_Description__c = sa.External_Description__c;    
                    ca.Core_License__c = sa.Core_License__c;    
                    ca.Version__c = sa.Version__c;    
                    ca.Version_Effective_Date__c = sa.Version_Effective_Date__c;    
                    ca.Serial_Number__c = sa.SerialNumber;    
                    ca.Comments__c = sa.Comments__c;    
                    ca.Status__c = sa.Status;    
                    ca.Quantity__c = sa.Quantity;    
                    ca.Install_Date__c = sa.InstallDate;    
                    ca.Date_Registered__c = sa.Date_Registered__c;    
                    ca.Customer_Value__c = sa.Customer_Value__c;    
                    ca.I_and_C_support__c = sa.I_and_C_support__c;    
                    ca.Support_Level__c = sa.Support_Level__c;    
                    ca.Upgraded__c = sa.Upgraded__c;    
                    ca.Days_to_Expiration__c = sa.Days_to_Expiration__c;    
                    ca.Upgrade_Flag__c = sa.Upgrade_Flag__c;    
                    ca.Last_Upgrade_Date__c = sa.Last_Upgrade_Date__c;    
                    custAsset.add(ca);
                    system.debug('Update Trigger2');

                }
            }
        }
    //system.debug('Update Trigger');

    update custAsset;
   //UpdationAsset.updateFlag=true;     
    
    }
}
}
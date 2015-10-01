trigger UpdateAsset on Asset__c (after insert,after update,after delete) {
List<Asset> stdAsset=new List<Asset>();
List<Asset__c> custAsset=new List<Asset__c>();
Asset stdAsset1=new Asset();

if(updationAsset.deletionFlag==false)
{
if(trigger.isDelete)
{
updationAsset.deletionFlag=true;
List<Id> sid=new List<Id>();
integer i;
List<Asset__c> dumy=Trigger.old;

for(i=0;i<dumy.size();i++)
    {   if(dumy[i].Product_ID__c!=null)
        {
         sid.add(dumy[i].Product_ID__c);
         }

    }
List<Asset> existingstdAsset=[select id from Asset where id in :sid];
 for(Asset__c ca:trigger.old)
  {
        for(Asset sa:existingstdAsset)
         {
        //system.debug('Update Trigger1'+'Standard Asset'+sa.name+'Custom Asset'+ca.Name);
              string str=sa.id;
              if(str==ca.Product_ID__c)
               {
               stdAsset.add(sa);
               }
         }
     }       
Delete stdAsset;   
} 
}






 if(trigger.isInsert)
 {
if(UpdationAsset.insertFlag==false)
{
               UpdationAsset.insertFlag=true;
                for(Asset__c a: trigger.new)
                {
                stdAsset1.accountId=a.account__c;
                //stdAsset1.contactId=a.contact__c;
                stdAsset1.Name=a.Asset_Name__c;
                stdAsset1.Nickname__c=a.Nickname__c;
                stdAsset1.Application_Server_OS__c=a.Application_Server_OS__c;
                stdAsset1.Database__c=a.Database__c;
                stdAsset1.Database_Server_OS__c=a.Database_Server_OS__c;
                //stdAsset1.External_Asset_Name__c=a.External_Asset_Name__c;
                stdAsset1.Front_Back_Access__c=a.Front_Back_Access__c;
                stdAsset1.Managed_Hosting__c=a.Managed_Hosting__c;
                stdAsset1.Installed_Product_ID__c=a.Installed_Product_ID__c;
                stdAsset1.JDK_Version__c=a.JDK_Version__c;
                stdAsset1.Network__c=a.Network__c;
                stdAsset1.Platform__c=a.Platform__c;
                stdAsset1.Software_URL__c=a.Software_URL__c;
                stdAsset1.Version_Build__c=a.Version_Build__c;
                
 //   a.Product__c =  sa.Product2.Description;
    stdAsset1.Type__c = a.Type__c;
    stdAsset1.Psft_Product_Id__c = a.Psft_Product_Id__c;
    stdAsset1.License_Expiration_Date__c = a.License_Expiration_Date__c;
    stdAsset1.External_Description__c = a.External_Description__c;    
    stdAsset1.Core_License__c = a.Core_License__c;    
    stdAsset1.Version__c = a.Version__c;    
    stdAsset1.Version_Effective_Date__c = a.Version_Effective_Date__c;    
    stdAsset1.SerialNumber = a.Serial_Number__c;    
    stdAsset1.Comments__c= a.Comments__c;    
    stdAsset1.Status = a.Status__c;    
    stdAsset1.Quantity = a.Quantity__c ;    
    stdAsset1.InstallDate = a.Install_Date__c ;    
    stdAsset1.Date_Registered__c = a.Date_Registered__c;    
    stdAsset1.I_and_C_support__c = a.I_and_C_support__c ;    
    stdAsset1.Support_Level__c = a.Support_Level__c;    
    stdAsset1.Upgraded__c =a.Upgraded__c;    
    stdAsset1.Days_to_Expiration__c = a.Days_to_Expiration__c ;    
    stdAsset1.Upgrade_Flag__c =a.Upgrade_Flag__c ;
    stdAsset1.Last_Upgrade_Date__c = a.Last_Upgrade_Date__c;
                stdAsset.add(stdAsset1);
                custAsset.add(a);
                }
                insert stdAsset;
               // UpdationAsset.insertFlag=true;
          }
}
if(trigger.isUpdate)
{

if(UpdationAsset.updateFlag==false)
{
UpdationAsset.updateFlag=true;

        //UpdationAsset.updateFlag=true;
    system.debug('update');
    List<Asset__c> dumy=Trigger.new;
    //Id sid=dumy.Product_ID__c;
    integer i;
    List<ID> sid=new List<ID>();
    for(i=0;i<dumy.size();i++)
    {   if(dumy[i].Product_ID__c!=null)
        {
         sid.add(dumy[i].Product_ID__c);
         }

    }
    List<Asset> existingAsset=[select id,Name,accountId,Application_Server_OS__c,Database__c,
    Database_Server_OS__c,External_Asset_Name__c,Front_Back_Access__c,Managed_Hosting__c,Installed_Product_ID__c,
    JDK_Version__c,Network__c,Nickname__c,Platform__c,Software_URL__c,Version_Build__c from Asset where id in :sid];
               system.debug('update1');
               for(Asset__c ca:trigger.new)
               {
                for(Asset sa:existingAsset)
                {
                system.debug('update2');
                        string str=sa.id;
                        if(str==ca.Product_ID__c)
                        {
                        //sp.id=sa.id;
                        system.debug('update3');

                        sa.AccountId=ca.Account__c;
                       // sa.ContactId=ca.Contact__c;
                        sa.Name=ca.Asset_Name__c;
                        sa.Nickname__c=ca.Nickname__c;
                        sa.Application_Server_OS__c=ca.Application_Server_OS__c;
                        sa.Database__c=ca.Database__c;
                        sa.Database_Server_OS__c=ca.Database_Server_OS__c;
                        //stdAsset1.External_Asset_Name__c=a.External_Asset_Name__c;
                        sa.Front_Back_Access__c=ca.Front_Back_Access__c;
                        sa.Managed_Hosting__c=ca.Managed_Hosting__c;
                        sa.Installed_Product_ID__c=ca.Installed_Product_ID__c;
                        sa.JDK_Version__c=ca.JDK_Version__c;
                        sa.Network__c=ca.Network__c;
                        sa.Platform__c=ca.Platform__c;
                        sa.Software_URL__c=ca.Software_URL__c;
                        sa.Version_Build__c=ca.Version_Build__c;
                        
                        sa.Type__c = ca.Type__c;
    sa.Psft_Product_Id__c = ca.Psft_Product_Id__c;
    sa.License_Expiration_Date__c = ca.License_Expiration_Date__c;
    sa.External_Description__c = ca.External_Description__c;    
    sa.Core_License__c = ca.Core_License__c;    
    sa.Version__c = ca.Version__c;    
    sa.Version_Effective_Date__c = ca.Version_Effective_Date__c;    
    sa.SerialNumber = ca.Serial_Number__c;    
    sa.Comments__c= ca.Comments__c;    
    sa.Status = ca.Status__c;    
    sa.Quantity = ca.Quantity__c ;    
    sa.InstallDate = ca.Install_Date__c ;    
    sa.Date_Registered__c = ca.Date_Registered__c;    
    sa.I_and_C_support__c = ca.I_and_C_support__c ;    
    sa.Support_Level__c = ca.Support_Level__c;    
    sa.Upgraded__c = ca.Upgraded__c;    
    sa.Days_to_Expiration__c = ca.Days_to_Expiration__c ;    
    sa.Upgrade_Flag__c = ca.Upgrade_Flag__c ;
    sa.Last_Upgrade_Date__c = ca.Last_Upgrade_Date__c;
                        stdAsset.add(sa);
                       
                                               }
                    }
                }
        
        update stdAsset;
          //UpdationAsset.updateFlag=true; 
        
    }
}
}
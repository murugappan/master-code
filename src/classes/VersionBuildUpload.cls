public with sharing class VersionBuildUpload {

public List<Version_Build_Tree__c> VersionBuildUploadList {set;get;}
public boolean check {get;set;}

public VersionBuildUpload ()
{
 VersionBuildUploadList = new List<Version_Build_Tree__c>();
 Version_Build_Tree__c b = new Version_Build_Tree__c();
 VersionBuildUploadList.add(b);
 
 
}
public void addRow() // every click + 
{
 Version_Build_Tree__c b = new Version_Build_Tree__c();
 VersionBuildUploadList.add(b);
 
}

public void removeRow()
{
     Integer s = VersionBuildUploadList.size();
     if(VersionBuildUploadList.size()>0)
      {
          if(VersionBuildUploadList.size()==1)
          {
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Cannot Delete');
              ApexPages.addMessage(myMsg);
          }
          else
              VersionBuildUploadList.remove(VersionBuildUploadList.size()-1);
     }
 
}

public void saveRecords()
{
     try{
         insert VersionBuildUploadList;
         VersionBuildUploadList = new List<Version_Build_Tree__c>();
         ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.INFO, 'Records Inserted');
         ApexPages.addMessage(myMsg1);
     } 
     catch (Exception e){
          ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.Error, 'Records Not Inserted');
          ApexPages.addMessage(myMsg2);
     }
 
}

}
@isTest
    
  private class  CollaborateSurveyTest{
  
     static testMethod void myUnitTest() { 
  
        Collaborate_Survey__c collab = new Collaborate_Survey__c ();
  
        ApexPages.StandardController  std1 = New ApexPages.StandardController(Collab);
        
       CollaborateSurvey std = New CollaborateSurvey(std1);
       
        std.save();
  
  
    }
  
  }
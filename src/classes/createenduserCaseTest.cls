@isTest
private with sharing class createenduserCaseTest{

  static testmethod void unittest(){
  
 Account acc = TestMethodUtility.createAccount();
 insert acc; 
 ApexPages.StandardController cont = New ApexPages.StandardController(acc);
 createenduserCase  controller = New createenduserCase(cont);
 try{
 controller.populate();
 }
 Catch(exception e)
 {
 
 }
  
  }
  
  
}
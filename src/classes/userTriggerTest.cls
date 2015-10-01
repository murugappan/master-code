@istest
private class userTriggerTest {

    static testMethod void userDuplicateOperatorIdPreventerTest() {
   
   
   try
     {
     
     Profile p =[select Id,Name from Profile where Name='System Administrator'];
     

     Test.startTest();
   //First Record with Email address nikhil886846@gmail.com  
     User u2 =TestMethodUtility.CreateUser(p);
     u2.Email='nikhil886846@gmail.com';
     u2.PSFT_Operator_ID__c='123456';
    
     insert u2;
       
   //Below two users insert in list so that in Trigger,Map will have some value.     
     List<user> lu = new List<user>();   
     
     User u =TestMethodUtility.CreateUser(p);
     u.Email='nikhil886846@gmail.com';
     u.PSFT_Operator_ID__c='123456';
     lu.add(u);
     
     User u1 =TestMethodUtility.CreateUser(p);
     u1.Email='nikhil886846@gmail.com';
     u1.PSFT_Operator_ID__c='123456';
     lu.add(u1);
     
     insert lu;
    
     Test.StopTest();
     System.debug('+++Email++' + U.Email + u1.Email);
     }
     Catch(Exception e)
     {}
     
     }
  
   static testMethod void UserInsertUpdateTest() {     
   
   UserRole ur =[select id, Name from UserRole where Name='SRV – Restricted User License'];
   Profile pf3= [select id,Name from Profile where name = 'System Administrator'];
    
    
   User u4 = TestMethodUtility.createUser(pf3);
   insert u4; 
   
   u4.IsActive =False;
   u4.isBMEnabled__c =False;
   update u4; 
   u4.IsActive =False;
   update u4;
   User u3 = TestMethodUtility.createUser(pf3);
   u3.IsActive = false;
   insert u3;                        
   u3.IsActive= True;
       
  // u3.initial_password__c='i am trying to excute catch part of trigger which is written on user.here length of string is greater than whatever it can be ';   
  // update u3;
  // update u3;
  /* u3.isBMEnabled__c=True;
   u3.IsActive= False;
   u3.initial_password__c='i am trying to excute catch part of trigger which is written on user.here length of string is greater than whatever it can be ';   
   update u3; */
   }
   
   Static testmethod void UserDuplicatepreventorTest()
    {
    
     try
     {
     
     Profile p =[select Id,Name from Profile where Name='System Administrator'];
     

     Test.startTest();
   //First Record with Email address nikhil886846@gmail.com  
     User u2 =TestMethodUtility.CreateUser(p);
     u2.Email='nikhil886846@gmail.com';
    
     insert u2;
       
   //Below two users insert in list so that in Trigger,Map will have some value.     
     List<user> lu = new List<user>();   
     
     User u =TestMethodUtility.CreateUser(p);
     u.Email='nikhil886846@gmail.com';
     lu.add(u);
     
     User u1 =TestMethodUtility.CreateUser(p);
     u1.Email='nikhil886846@gmail.com';
     lu.add(u1);
     
     insert lu;
    
     Test.StopTest();
     System.debug('+++Email++' + U.Email + u1.Email);
     }
     Catch(Exception e)
     {}
     
     }
     
                      
  }
@isTest
private class  PreventupdateIDMTest {

  static testmethod void  PreventupdateIDMTest()
    {
    user uu =[Select id,username, Alias from User where Alias='idm'];
    System.Runas(uu)
     {
   try
   {  
    user u =[select id,Name,Alias,contactid  from user where contactid=null limit 1];
    u.FirstName='nik';
    update u;
    }
   Catch(Exception e)
   {

  system.debug('Error:'+e);

    }  
  }
 }
}
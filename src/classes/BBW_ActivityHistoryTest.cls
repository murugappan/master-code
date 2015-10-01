@isTest

private class BBW_ActivityHistoryTest
 {

    static testMethod void BBW_ActivityHistoryTest() 
    {
    BBW_ActivityHistory bch=new BBW_ActivityHistory();
    List<Attachment> attachList =new List<Attachment>(); 
    List<case> c=new List<case>();
    BBW_ActivityHistory BBWAch=new BBW_ActivityHistory ('Install problem',
     true,
    'Tiffany Day','jyoti.gaur1@wipro.com',system.today(),system.today(),'Email',
    'facing an issue', attachList );
       }
    }
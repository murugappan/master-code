public class AWSKeys {
  
  public class AWSKeysException extends Exception {}
  Amazon_Credentials__c keyObj = null;
  public string key { get { return keyObj.key__c; } private set; }
  public string secret { get { return keyObj.secret__c; } private set; }
 
  public AWSKeys(string name) {
    try {
 
      keyObj = [select key__c,secret__c,id from Amazon_Credentials__c where name = :name limit 1]; 
     
      if(keyObj.key__c == null || keyObj.key__c == ''){
         ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Error: No key is specified for the Amazon Credentials record with name of [' +name+']. Please enter the Key value and retry.');
         ApexPages.addMessage(errorMsg);
         throw new AWSKeysException('Error: No key is specified for the Amazon Credentials record with name of [' +name+']. Please enter the Key value and retry.');   
      }
      
      if(keyObj.secret__c == null || keyObj.secret__c == ''){
         ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Error: No secret is specified for the Amazon Credentials record with name of [' +name+']. Please enter the Secret value and retry.');
         ApexPages.addMessage(errorMsg);
         throw new AWSKeysException('Error: No secret is specified for the Amazon Credentials record with name of [' +name+']. Please enter the Secret value and retry.');   
      }
      
     }catch (QueryException queryEx) {
      system.debug('Error when querying the Amazon Credentials custom object. Did not find any record with name of ['+name+']. Please make sure the name is correct or create a record with the proper Amazon credentials and retry.');
      throw new AWSKeysException('Error when querying the Amazon Credentials custom object. Did not find any record with name of ['+name+']. Please make sure the name is correct or create a record with the proper Amazon credentials and retry.');
     } 
  }
  
  static testmethod void testInstance() {
    try{
      AWSKeys k = new AWSKeys('badname');
    }catch(AWSKeysException AWSExcept){
       system.debug('here: ' +AWSExcept.getTypeName());
       system.assert(AWSExcept.getTypeName().contains('AWSKeys.AWSKeysException'));
    }
    
    Amazon_Credentials__c t1 = new Amazon_Credentials__c( key__c='s1', secret__c='s1', name='test' );
    insert t1;
    AWSKeys k = new AWSKeys('test');
    system.assert(k.key == 's1');
    system.assert(k.secret == 's1');
    
    
    try{
      Amazon_Credentials__c t2 = new Amazon_Credentials__c( secret__c='s1', name='test2' );
      insert t2;
      k = new AWSKeys('test2');
    }catch(AWSKeysException AWSExcept){
         system.assert(AWSExcept.getTypeName().contains('AWSKeys.AWSKeysException'));
         
    }
    
    try{
      Amazon_Credentials__c t3 = new Amazon_Credentials__c( key__c='s1', name='test3' );
      insert t3;
      k = new AWSKeys('test3');
    }catch(AWSKeysException AWSExcept){
         system.assert(AWSExcept.getTypeName().contains('AWSKeys.AWSKeysException'));
         
    }
  }
}
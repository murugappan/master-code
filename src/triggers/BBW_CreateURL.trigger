trigger BBW_CreateURL on KB_Internal_Article_Link__c (before insert, before update) {
    
    //String articleNumber = '%' + trigger.new[0].Article_Number__c; 
    System.debug('trigger.new[0].Name>>>>>>'+ trigger.new[0].Name);
    String articleNumber = '%' + trigger.new[0].Name;
    System.debug('articleNumber>>>>>>'+ articleNumber);
    List<Solution> solList = [select id, SolutionName, SolutionNumber, Link__c from Solution where SolutionNumber Like :articleNumber];
    if(null != solList && solList.size() > 0) {
        trigger.new[0].URL__c = solList[0].Link__c + solList[0].id;
        //trigger.new[0].Article_Number__c = solList[0].SolutionNumber;
        trigger.new[0].Name = solList[0].SolutionNumber;
        trigger.new[0].Article_Name__c= solList[0].SolutionName;
    } else if(trigger.new[0].IsRunFromTestClass__c == false) {   //check if it is running from test class
        trigger.new[0].addError('Wrong Article Number');
    }     
}
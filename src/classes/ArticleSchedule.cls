global class ArticleSchedule implements Schedulable{

       global void execute(SchedulableContext SC) {
            ArticleSchedule M = new ArticleSchedule();
            M.selectArticles();
       }
    
        public void selectArticles(){
        
        List<Solution> updsol = new List<Solution>(); 
        Date d = System.today();        

        for(List<Solution> sol : [select Id,Calculate_12_months__c, Published_Date__c,Status from Solution where Status = 'Published' AND Calculate_12_months__c = 365]){
            for(Solution s : sol){
                Solution s1 = new Solution(ID = s.ID);
                s1.Change_Status_12_months__c = true;
                updsol.add(s1); 
            }
        }
        Update updsol;
    }
}
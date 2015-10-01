/* Used to add or remove survey takers from the database */
global class AddUsersController {
    public List<Contact> allUsers   {get; set;}
    public String theList           {get; set;}
    public String surveyRef         {get; set;}
 
   /** Fills the list of contacts who are taking the survey
       specified in the url parameter.
    */ 
    public AddUsersController() {
        surveyRef = Apexpages.currentPage().getParameters().get('sId');
    }

   /** Inserts a new Survey taker in the database
       param: userId    Contact ID as specified in the url parameter
       param: sId       Survey ID as specified in the url parameter
       return: boolean  returns 'true' if no error
    */  
    static Webservice String addUser(String userId, String sId, String caId) {
        String CaseId;
        case caserec;
        if(caId.toUpperCase() =='NONE'|| caId.length()<5)
          caseId = null;
        else  
        {
          caseId = caId;    
           caserec=[Select id,owner.id,owner.name,recordtype.name  from case where id =:caseId];
        }
        
        if(userId.toUpperCase() == 'NONE'|| userId.length()<5)
          userId = null;
          
      /*  List<SurveyTaker__c> check = [Select Contact__c, Survey__c, Case__c From SurveyTaker__c Where Contact__c=:userId and Survey__c=:sId and Case__c = :caseId];
        if(check != null && check.size()>0){
            return 'false';
            // Check to see if contact is not already in the database 
        }*/ //commented for TP4433
        /* Add the contact to the database otherwise */
        SurveyTaker__c st = new SurveyTaker__c();
        List <enduser__c> e = new list<enduser__c>();
        list<contact>c = new list<contact>();
        if(caserec != null && caserec.recordtype.name!= null && caserec.recordtype.name.contains('End User'))
        {
           e = [Select Id, name,email__c From enduser__c Where Id=:userId];
        }
        else
        {
         c = [Select Id, FirstName, LastName, email From Contact Where Id=:userId];
        }
         
        if((c == null || c.size()==0)&&(e==null || e.size()==0))
          return 'false';
        if(e.size()>0)
        {
         st.end_user__c = userId;
        }  
        else
        {
        st.Contact__c = userId;
        }
        
        st.Survey__c = sId;
        st.Taken__c = 'false';
        st.Case__c = caseId;
        st.Owner_Name__c=caserec.owner.name;
        st.Owner_id__c=caserec.ownerid;
        insert st;
        return 'true';
    }



   /** Removes a survey taker from the database
       param: userId    Contact ID as specified in the url parameter
       return: boolean  returns 'true' if no error
    */      
    public static Webservice String removeUser(String userId) {
        List<SurveyTaker__c> st = [Select Id, Contact__c From SurveyTaker__c Where Contact__c=:userId];
        for(SurveyTaker__c s:st) 
            delete s;
        return 'true';
    }    
  public void InsertNewSurveyTaker(String contactId, String surveyId, String taken, String caseId){
    SurveyTaker__c st = new SurveyTaker__c();
    st.Contact__c = contactId;
    st.Survey__c = surveyId;
    st.Taken__c = taken;
    st.Case__c = caseId;
    insert st;
  }
  //------------------------------------------------------------------------------//
}
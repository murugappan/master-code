public class CPQTriggerHelper {

    // Static Id Set to use in renewal creation batch trigger to avoid duplicate new renewal opportunity creation.
    // needed b/c duplicates are currently being created existing triggers/workflow on opportunity create/update are causing the trigger to run twice for the same opps.
    

    private static Set<Id> alreadyCreatedRenewals = new Set<Id>();

//check if list already contains the opp before going through trigger logic
    public static boolean renwalOppCreated(Id checkOpp) {
        return alreadyCreatedRenewals.contains(checkOpp);
    }

    //set the Id in the set
    public static void setAlreadyCreatedRenewals (Id renewalCreated) {
        alreadyCreatedRenewals.add(renewalCreated);
    }


}
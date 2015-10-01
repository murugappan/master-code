global class FutureMethodRecordProcessing
{

    @future
    public static void ReassignLead(Set<ID> lIdReassignSet) { 
    
        List<Lead> lUpdList = [SELECT Id FROM Lead WHERE Id IN: lIdReassignSet];
        for (Lead l:lUpdList) {
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule = true;                                         // use leadAssignment rules when updating
            l.setOptions(dmo);
        }
    
        try {update(lUpdList);}
        catch (DmlException e) {/* do something here like send email to sysad with error */}
    }
    
}
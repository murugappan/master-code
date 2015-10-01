global class EmailForStageValidationsScheduler implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        /* commenting out
        User[] users = [SELECT Id FROM User WHERE Profile.Name = 'Bb - Collab Senior Sales Management' and Email != 'donovan.lytle@blackboard.com'];
        for(User u :  users) {
            StageValidationsApprovalController.emailVerifier(u.Id);
        }
  
        commenting out */
    }
}
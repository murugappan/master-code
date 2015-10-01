global class ScheduleCloseCase_GRT_30days_Solunsuggst implements Schedulable{

    public static String sched = '0 0 12 1 1/1 ? *';  //Day 1 of every month 

    global static String scheduleMe() {
        ScheduleCloseCase_GRT_30days_Solunsuggst SC =new ScheduleCloseCase_GRT_30days_Solunsuggst(); 
        return System.schedule('Close the Case > 30days in Solution Suggested', sched, SC);
    }

    global void execute(SchedulableContext sc) {

        CloseCase_GRT_30days_Solunsuggst b1 = new CloseCase_GRT_30days_Solunsuggst();
        ID batchprocessid = Database.executeBatch(b1);           
    }
}
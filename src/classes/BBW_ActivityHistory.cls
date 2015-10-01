public with sharing class BBW_ActivityHistory {

     /* Properties of the class */
    public String subject 		{ get; set; }
    public boolean isTask   	{ get; set; }
    public String name   		{ get; set; }
    public String assignTo   	{ get; set; }
    public String activityType  { get; set; }
    public Datetime dueDate 	{ get; set; }
    public Datetime lastModDt 	{ get; set; }
    public String comments      { get; set; }
    public String to          	{ get; set; }
    public String cc          	{ get; set; }
    public String bcc          	{ get; set; }
    public String attachName 	{ get; set; }
    public String body          { get; set; }
    public String emailSub          { get; set; }
    
    
    public List<Attachment> attachmentList  { get; set; }
    
    /* Class constructor */
    public BBW_ActivityHistory(){}
    public BBW_ActivityHistory(String sub, boolean task, String contactName, String to,  Datetime dDate, Datetime lastDate, String aType, String comment, List<Attachment> attachList) {
        subject   = sub;
        dueDate = dDate;
        lastModDt = lastDate;
        isTask    = task;
        name   = contactName;
        activityType = aType;
        assignTo = to;
        attachmentList = attachList;
        comments = comment;
    }

}
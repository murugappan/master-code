/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          ServicesForecastPeriod
    @abstract       shows Services forecast for the next 8 months
    @since          2011.0715
    @discussion     Class to show Services Forecast
*/

public with sharing class ServicesForecastPeriod {
    // ------------------------------------------------
    // Class Variables
    // ------------------------------------------------
    private List<ServicesForecastMonth> servicesForecastMonths; 
    public Date startDate; 
    public User wimbaStaff; 
    
    // ------------------------------------------------
    // Constructor Method
    // ------------------------------------------------
    public ServicesForecastPeriod(Date value, User u) {
        this.wimbaStaff = u;
        this.startDate = value.toStartOfMonth();
        this.servicesForecastMonths = new List<ServicesForecastMonth>();
        for (Integer i = 0; i <= 8; i++) {
            ServicesForecastMonth stm = new ServicesForecastMonth(startDate.addMonths(i));   
            this.servicesForecastMonths.add( stm );
        }
    }
    
    // ------------------------------------------------
    // GET/SET Methods
    // ------------------------------------------------
    public Date getStartDate() { return startDate; } 
    public User getWimbaStaff() { return this.wimbaStaff; }
    public List<ServicesForecastMonth> getServicesForecastMonths() { return this.servicesForecastMonths; }
    
    public void setServices(List<Services_Project__c> servicesProjects) { 
        for(Services_Project__c service:servicesProjects) {
            if(service.Start_Date__c!= null && service.OwnerId == wimbaStaff.Id) { 
                for(ServicesForecastMonth servicesForecastMonth:servicesForecastMonths) {
                    Date monthDate = servicesForecastMonth.getStartingDate();
                    if (service.Start_Date__c.toStartOfMonth() <= monthDate && (service.End_Date__c == null || service.End_Date__c > monthDate)) 
                    { 
                        servicesForecastMonth.getServicesProjects().add(service);
                    }
                }
            }
            for(Services_Engagement__c servicesEngagement:service.Services_Engagements__r) {
                if(servicesEngagement.Start_Date__c!= null && servicesEngagement.Trainer__c == wimbaStaff.Id) {
                    for(ServicesForecastMonth servicesForecastMonth:servicesForecastMonths) {
                        Date monthDate = servicesForecastMonth.getStartingDate();
                        if (servicesEngagement.Start_Date__c.toStartOfMonth() <= monthDate && (servicesEngagement.End_Date__c == null || servicesEngagement.End_Date__c > monthDate))
                        { 
                            servicesForecastMonth.getServicesEngagements().add(servicesEngagement);
                        }
                    }
                }
            } 
        } 
    }
    
    public class ServicesForecastMonth {
        // ------------------------------------------------
        // Class Variables
        // ------------------------------------------------
        public List<Services_Project__c> servicesProjects;
        public List<Services_Engagement__c> servicesEngagements;
        public Date startingDate; 
        
        // ------------------------------------------------
        // Constructor Method
        // ------------------------------------------------
        
        public ServicesForecastMonth(Date value) { 
            startingDate = value;
            servicesProjects = new List<Services_Project__c>();
            servicesEngagements = new List<Services_Engagement__c>();
        }
        // ------------------------------------------------
        // GET/SET Methods
        // ------------------------------------------------
        public List<Services_Project__c> getServicesProjects() { return this.servicesProjects; }
        public List<Services_Engagement__c> getServicesEngagements() { return this.servicesEngagements; }
        public Date getStartingDate() { return this.startingDate; }
        public String getMonthName() { 
            return DateTime.newInstance(startingDate.year(),startingDate.month(),startingDate.day()).format('MMMM');
        } 
        
        public Integer getInProgressServicesProjects() { return servicesProjects.size();}
        
        public Integer getDollarValue() {
            Integer result = 0;
            for(Services_Engagement__c servicesEngagement:servicesEngagements)
            {
                if(servicesEngagement.Dollar_Value__c != null && servicesEngagement.Delivery_Date__c != null && servicesEngagement.Delivery_Date__c.month() == startingDate.month()) result += servicesEngagement.Dollar_Value__c.intValue();
            }
            return result;
        }
    }
}
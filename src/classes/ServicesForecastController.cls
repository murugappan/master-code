/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          ServicesForecastController
    @abstract       shows Services forecast for the next 8 months
    @since          2011.0715
    @discussion     Class to show Services Forecast
*/

public with sharing class ServicesForecastController {
    // ------------------------------------------------
    // Class Variables
    // ------------------------------------------------
    List<ServicesForecastPeriod> servicesForecastPeriods;
    List<Services_Project__c> servicesProjects = new List<Services_Project__c>();
    List<Services_Engagement__c> servicesEngagements = new List<Services_Engagement__c>();
    
    // ------------------------------------------------
    // Constructor Method
    // ------------------------------------------------
    public ServicesForecastController() {
        
        servicesForecastPeriods = new List<ServicesForecastPeriod>();
        servicesProjects = new List<Services_Project__c>();
        servicesEngagements = new List<Services_Engagement__c>();

        //Retrieve In Progress Services
        Date start = Date.today().toStartOfMonth();
        List<User> wimbaStaff = [SELECT Id, Name FROM User WHERE isActive = True AND UserRole.Name IN ('1 Operations','Collab Sr.Director,Professional Services','Collab Implementation&Consulting Manager','Collaborate Learning Services Manager','Collab Manager, Technical Services','Collaborate Technical Services Manager') ORDER BY Name];
        List<Services_Project__c> events = [SELECT Id, OwnerId, Owner.Name, Name, Total_Amount__c, Start_Date__c, End_Date__c, Status__c, Allocated_Amount__c, Delivered_Amount__c, CurrencyIsoCode, 
                                    (Select Id, Name, Delivery_Date__c, Start_Date__c, End_Date__c, Status__c, Trainer__c, Trainer__r.Name, Dollar_Value__c, CurrencyIsoCode from Services_Engagements__r where Delivery_Date__c >= :start and Status__c NOT IN ('Deferred'))
                                    FROM Services_Project__c
                                    WHERE Status__c = 'In-Progress'
                                    ORDER BY Start_Date__c DESC];
        
        for(User u : wimbaStaff)
        {
            ServicesForecastPeriod sfp = new ServicesForecastPeriod(Date.today(), u);
            sfp.setServices(events);
            servicesForecastPeriods.add(sfp);
        }
    }
    
    // ------------------------------------------------
    // GET/SET Methods
    // ------------------------------------------------
    public List<ServicesForecastPeriod> getServicesForecastPeriods() {return servicesForecastPeriods;}
    public List<Services_Project__c> getServicesProjects() {return servicesProjects;}
    public List<Services_Engagement__c> getServicesEngagements() {return servicesEngagements;}

    // ------------------------------------------------
    // Navigation Methods
    // ------------------------------------------------
    public PageReference displayServices() {
        //Clear the list of Services and Services Engagements before adding new ones 
        servicesProjects.clear();
        servicesEngagements.clear();

        Id userId = System.currentPageReference().getParameters().get('userid');
        String period = System.currentPageReference().getParameters().get('period');
        
        for(ServicesForecastPeriod servicesForecastPeriod:servicesForecastPeriods)
        {
            if(servicesForecastPeriod.getWimbaStaff().Id == userId)
            {
                for(ServicesForecastPeriod.ServicesForecastMonth servicesForecastMonth:servicesForecastPeriod.getServicesForecastMonths()){
                    if(servicesForecastMonth.getMonthName() == period)
                    {
                        servicesProjects = servicesForecastMonth.getServicesProjects().clone();
                    }
                }
            }
        }
        return null;
    }
    
    public PageReference displayServicesEngagements() {
        //Clear the list of Services and Services Engagements before adding new ones 
        servicesProjects.clear();
        servicesEngagements.clear();
        
        Id userId = System.currentPageReference().getParameters().get('userid');
        String period = System.currentPageReference().getParameters().get('period');
        
        for(ServicesForecastPeriod servicesForecastPeriod:servicesForecastPeriods)
        {
            if(servicesForecastPeriod.getWimbaStaff().Id == userId)
            {
                for(ServicesForecastPeriod.ServicesForecastMonth servicesForecastMonth:servicesForecastPeriod.getServicesForecastMonths()){
                    if(servicesForecastMonth.getMonthName() == period)
                    {           
                        servicesEngagements = servicesForecastMonth.getServicesEngagements().clone();
                    }
                }
            }
        }
        
        return null;
    }
  private static testmethod void ServicesForecastControllerTest(){
  
  Profile p= [select id, Name from profile where Name='System Administrator'];
  //Commented by Nikhil. Since these user roles has been deleted from Production.
 // UserRole ur =[select id,Name from UserRole where Name='Collab Sr.Director,Professional Services'];
    UserRole  ur=[Select id,Name from UserRole Where Name='SFDC Administrators' limit 1];
  user u =TestMethodUtility.createUser(p);
  u.UserRoleid=ur.id;
  insert u;
  System.Runas(u)
  {
  ServicesForecastController  controller = new ServicesForecastController();
  controller.getServicesForecastPeriods();
  controller.getServicesProjects();
  controller.getServicesEngagements();
  controller.displayServices();
  controller.displayServicesEngagements();
  }
  
  }    
}
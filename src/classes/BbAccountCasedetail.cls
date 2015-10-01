public with sharing class BbAccountCasedetail {
public String AcctID {get;set;}
public List<Case> caseList {get;set;}
public List<Case> caseList1 {get;set;}
public List<Case> caseList2 {get;set;}
public List<Case> caseList3 {get;set;}
public List<Case> caseList4 {get;set;}
public List<Case> caseList5 {get;set;}
public List<Case> caseList6 {get;set;}
public List<Case> caseList7 {get;set;}
public List<Case> caseList8 {get;set;}
public List<Case> caseList9 {get;set;}
public List<Case> caseList10 {get;set;}
public List<Case> caseList11 {get;set;}
public List<Case> caseList12 {get;set;}
public List<Case> caseList13 {get;set;}
public integer casecnt {get;set;}
public integer casecnt1 {get;set;}
public integer casecnt2 {get;set;}
public integer casecnt3 {get;set;}
public integer casecnt4 {get;set;}
public integer casecnt5 {get;set;}
public integer casecnt6 {get;set;}
public integer casecnt7 {get;set;}
public integer casecnt8 {get;set;}
public integer casecnt9 {get;set;}
public integer casecnt10 {get;set;}
public integer casecnt11 {get;set;}
public integer casecnt12 {get;set;}
public integer casecnt13 {get;set;}


public BbAccountCasedetail(ApexPages.StandardController controller) {

AcctID = ApexPages.currentPage().getParameters().get('id');
caseList = [Select Id, AccountId, Account.Name, Status, IsClosed from Case Where AccountId =:AcctID AND Core_License__r.Name = 'Learn' AND isClosed = false];
casecnt = caseList.size();

caseList1 = [Select Id, AccountId, Account.Name, Status from Case Where AccountId =:AcctID AND Core_License__r.Name = 'Learn' AND CreatedDate >= :system.today().addDays(-90)];
casecnt1 = caseList1.size();


caseList2 = [Select Id, AccountId, Account.Name, Status from Case Where AccountId =:AcctID AND Core_License__r.Name = 'ANGEL LMS' AND isClosed = false];
casecnt2 = caseList2.size();

caseList3 = [Select Id, AccountId, Account.Name, Status from Case Where AccountId =:AcctID AND Core_License__r.Name = 'ANGEL LMS' AND CreatedDate >= :system.today().addDays(-90)];
casecnt3 = caseList3.size();

caseList4 = [Select Id, AccountId, Account.Name, Status from Case Where AccountId =:AcctID AND Core_License__r.Name = 'Moodlerooms' AND isClosed = false];
casecnt4 = caseList4.size();

caseList5 = [Select Id, AccountId, Account.Name, Status from Case Where AccountId =:AcctID AND Core_License__r.Name = 'Moodlerooms' AND CreatedDate >= :system.today().addDays(-90)];
casecnt5 = caseList5.size();


caseList6 = [Select Id, AccountId, Account.Name, Status from Case Where AccountId =:AcctID AND Core_License__r.Name = 'Xythos' AND isClosed = false];
casecnt6 = caseList6.size();

caseList7 = [Select Id, AccountId, Account.Name, Status from Case Where AccountId =:AcctID AND Core_License__r.Name = 'Xythos' AND CreatedDate >= :system.today().addDays(-90)];
casecnt7 = caseList7.size();


caseList8 = [Select Id, AccountId, Account.Name, Status from Case Where AccountId =:AcctID AND Core_License__r.Name = 'CE/Vista' AND isClosed = false];
casecnt8 = caseList8.size();

caseList9 = [Select Id, AccountId, Account.Name, Status from Case Where AccountId =:AcctID AND Core_License__r.Name = 'CE/Vista' AND CreatedDate >= :system.today().addDays(-90)];
casecnt9 = caseList9.size();

caseList10 = [Select Id, AccountId, Account.Name, Status from Case Where AccountId =:AcctID AND Core_License__r.Name = 'Transaction System 3.x' AND isClosed = false];
casecnt10 = caseList10.size();

caseList11 = [Select Id, AccountId, Account.Name, Status from Case Where AccountId =:AcctID AND Core_License__r.Name = 'Transaction System 3.x' AND CreatedDate >= :system.today().addDays(-90)];
casecnt11 = caseList11.size();

caseList12 = [Select Id, AccountId, Account.Name, Status from Case Where AccountId =:AcctID AND Core_License__r.Name LIKE '%Collaborate%' AND isClosed = false];
casecnt12 = caseList12.size();

caseList13 = [Select Id, AccountId, Account.Name, Status from Case Where AccountId =:AcctID AND Core_License__r.Name LIKE '%Collaborate%' AND CreatedDate >= :system.today().addDays(-90)];
casecnt13 = caseList13.size();



}




}
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*   @name       :   AddMilestones
*   @object:    :   Case
*   @scope      :   Asset, Business Hours, Case, Entitlement, User
*   @dataload   :   Yes
*   @abstract   :   Master Trigger for Control of Case Milestones/SLAs
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
trigger AddMilestones on Case (before insert) {

    List < Case > caslist = new List < Case > ();
    caslist = Trigger.New;

    if (caslist.size() == 1) {
        for (Case c: Trigger.New) {
            System.debug(c.Invoke_Premium_Support__c);
            List < Asset > a = new List < Asset > ([select ID, Managed_Hosting__c, Support_Level__c from Asset where ID = :c.AssetID]);
            if (a != null && a.size() > 0) {
                if (a[0].Support_Level__c == 'ANGEL Premium Support' && c.Invoke_Premium_Support__c == true) {
                    BusinessHours b = [select ID, SUNDAYSTARTTIME, SUNDAYENDTIME, MONDAYSTARTTIME, MONDAYENDTIME, TUESDAYSTARTTIME, TUESDAYENDTIME, WEDNESDAYSTARTTIME, WEDNESDAYENDTIME, THURSDAYSTARTTIME, THURSDAYENDTIME, FRIDAYSTARTTIME, FRIDAYENDTIME, SATURDAYSTARTTIME, SATURDAYENDTIME from BusinessHours where Name = 'ANGEL Basic Support'];
                    String day = System.now().format('EEE');
                    Datetime t = System.now();
                    if (day == 'Mon') {
                        if (b.MONDAYSTARTTIME != null && b.MONDAYENDTIME != null && t.time() > b.MONDAYSTARTTIME && t.time() < b.MONDAYENDTIME) {
                            List < Entitlement > e = new List < Entitlement > ([select ID, BusinessHoursID, Case_Severity__c, Support_Level__c from Entitlement where Support_Level__c = 'ANGEL Premium Support'AND AssetID = :c.AssetID AND Outside_Business_Hours_ANGEL_Premium__c = false AND Case_Severity__c = :c.Case_Severity__c]);
                            if (e != null && e.size() > 0) {
                                c.EntitlementID = e[0].ID;
                                c.BusinessHoursID = e[0].BusinessHoursID;
                            }
                        } else {
                            List < Entitlement > e = new List < Entitlement > ([select ID, BusinessHoursID, Case_Severity__c, Support_Level__c from Entitlement where Support_Level__c = 'ANGEL Premium Support'AND AssetID = :c.AssetID AND Outside_Business_Hours_ANGEL_Premium__c = true AND Case_Severity__c = :c.Case_Severity__c]);
                            if (e != null && e.size() > 0) {
                                c.EntitlementID = e[0].ID;
                                c.BusinessHoursID = e[0].BusinessHoursID;
                            }
                        }
                    } else if (day == 'Tue') {
                        if (b.TUESDAYSTARTTIME != null && b.TUESDAYENDTIME != null && t.time() > b.TUESDAYSTARTTIME && t.time() < b.TUESDAYENDTIME) {
                            List < Entitlement > e = new List < Entitlement > ([select ID, BusinessHoursID, Case_Severity__c, Support_Level__c from Entitlement where Support_Level__c = 'ANGEL Premium Support'AND AssetID = :c.AssetID AND Outside_Business_Hours_ANGEL_Premium__c = false AND Case_Severity__c = :c.Case_Severity__c]);
                            if (e != null && e.size() > 0) {
                                c.EntitlementID = e[0].ID;
                                c.BusinessHoursID = e[0].BusinessHoursID;
                            }
                        } else {
                            List < Entitlement > e = new List < Entitlement > ([select ID, BusinessHoursID, Case_Severity__c, Support_Level__c from Entitlement where Support_Level__c = 'ANGEL Premium Support'AND AssetID = :c.AssetID AND Outside_Business_Hours_ANGEL_Premium__c = true AND Case_Severity__c = :c.Case_Severity__c]);
                            if (e != null && e.size() > 0) {
                                c.EntitlementID = e[0].ID;
                                c.BusinessHoursID = e[0].BusinessHoursID;
                            }
                        }
                    } else if (day == 'Wed') {
                        if (b.WEDNESDAYSTARTTIME != null && b.WEDNESDAYENDTIME != null && t.time() > b.WEDNESDAYSTARTTIME && t.time() < b.WEDNESDAYENDTIME) {
                            List < Entitlement > e = new List < Entitlement > ([select ID, BusinessHoursID, Case_Severity__c, Support_Level__c from Entitlement where Support_Level__c = 'ANGEL Premium Support'AND AssetID = :c.AssetID AND Outside_Business_Hours_ANGEL_Premium__c = false AND Case_Severity__c = :c.Case_Severity__c]);
                            if (e != null && e.size() > 0) {
                                c.EntitlementID = e[0].ID;
                                c.BusinessHoursID = e[0].BusinessHoursID;
                            }
                        } else {
                            List < Entitlement > e = new List < Entitlement > ([select ID, BusinessHoursID, Case_Severity__c, Support_Level__c from Entitlement where Support_Level__c = 'ANGEL Premium Support'AND AssetID = :c.AssetID AND Outside_Business_Hours_ANGEL_Premium__c = true AND Case_Severity__c = :c.Case_Severity__c]);
                            if (e != null && e.size() > 0) {
                                c.EntitlementID = e[0].ID;
                                c.BusinessHoursID = e[0].BusinessHoursID;
                            }
                        }
                    } else if (day == 'Thu') {
                        if (b.THURSDAYSTARTTIME != null && b.THURSDAYENDTIME != null && t.time() > b.THURSDAYSTARTTIME && t.time() < b.THURSDAYENDTIME) {
                            List < Entitlement > e = new List < Entitlement > ([select ID, BusinessHoursID, Case_Severity__c, Support_Level__c from Entitlement where Support_Level__c = 'ANGEL Premium Support'AND AssetID = :c.AssetID AND Outside_Business_Hours_ANGEL_Premium__c = false AND Case_Severity__c = :c.Case_Severity__c]);
                            if (e != null && e.size() > 0) {
                                c.EntitlementID = e[0].ID;
                                c.BusinessHoursID = e[0].BusinessHoursID;
                            }
                        } else {
                            List < Entitlement > e = new List < Entitlement > ([select ID, BusinessHoursID, Case_Severity__c, Support_Level__c from Entitlement where Support_Level__c = 'ANGEL Premium Support'AND AssetID = :c.AssetID AND Outside_Business_Hours_ANGEL_Premium__c = true AND Case_Severity__c = :c.Case_Severity__c]);
                            if (e != null && e.size() > 0) {
                                c.EntitlementID = e[0].ID;
                                c.BusinessHoursID = e[0].BusinessHoursID;
                            }
                        }
                    } else if (day == 'Fri') {
                        if (b.FRIDAYSTARTTIME != null && b.FRIDAYENDTIME != null && t.time() > b.FRIDAYSTARTTIME && t.time() < b.FRIDAYENDTIME) {
                            List < Entitlement > e = new List < Entitlement > ([select ID, BusinessHoursID, Case_Severity__c, Support_Level__c from Entitlement where Support_Level__c = 'ANGEL Premium Support'AND AssetID = :c.AssetID AND Outside_Business_Hours_ANGEL_Premium__c = false AND Case_Severity__c = :c.Case_Severity__c]);
                            if (e != null && e.size() > 0) {
                                c.EntitlementID = e[0].ID;
                                c.BusinessHoursID = e[0].BusinessHoursID;
                            }
                        } else {
                            List < Entitlement > e = new List < Entitlement > ([select ID, BusinessHoursID, Case_Severity__c, Support_Level__c from Entitlement where Support_Level__c = 'ANGEL Premium Support'AND AssetID = :c.AssetID AND Outside_Business_Hours_ANGEL_Premium__c = true AND Case_Severity__c = :c.Case_Severity__c]);
                            if (e != null && e.size() > 0) {
                                c.EntitlementID = e[0].ID;
                                c.BusinessHoursID = e[0].BusinessHoursID;
                            }
                        }
                    } else if (day == 'Sat') {
                        if (b.SATURDAYSTARTTIME != null && b.SATURDAYENDTIME != null && t.time() > b.SATURDAYSTARTTIME && t.time() < b.SATURDAYENDTIME) {
                            List < Entitlement > e = new List < Entitlement > ([select ID, BusinessHoursID, Case_Severity__c, Support_Level__c from Entitlement where Support_Level__c = 'ANGEL Premium Support'AND AssetID = :c.AssetID AND Outside_Business_Hours_ANGEL_Premium__c = false AND Case_Severity__c = :c.Case_Severity__c]);
                            if (e != null && e.size() > 0) {
                                c.EntitlementID = e[0].ID;
                                c.BusinessHoursID = e[0].BusinessHoursID;
                            }
                        } else {
                            List < Entitlement > e = new List < Entitlement > ([select ID, BusinessHoursID, Case_Severity__c, Support_Level__c from Entitlement where Support_Level__c = 'ANGEL Premium Support'AND AssetID = :c.AssetID AND Outside_Business_Hours_ANGEL_Premium__c = true AND Case_Severity__c = :c.Case_Severity__c]);
                            if (e != null && e.size() > 0) {
                                c.EntitlementID = e[0].ID;
                                c.BusinessHoursID = e[0].BusinessHoursID;
                            }
                        }
                    } else if (day == 'Sun') {
                        if (b.SUNDAYSTARTTIME != null && b.SUNDAYENDTIME != null && t.time() > b.SUNDAYSTARTTIME && t.time() < b.SUNDAYENDTIME) {
                            List < Entitlement > e = new List < Entitlement > ([select ID, BusinessHoursID, Case_Severity__c, Support_Level__c from Entitlement where Support_Level__c = 'ANGEL Premium Support'AND AssetID = :c.AssetID AND Outside_Business_Hours_ANGEL_Premium__c = false AND Case_Severity__c = :c.Case_Severity__c]);
                            if (e != null && e.size() > 0) {
                                c.EntitlementID = e[0].ID;
                                c.BusinessHoursID = e[0].BusinessHoursID;
                            }
                        } else {
                            List < Entitlement > e = new List < Entitlement > ([select ID, BusinessHoursID, Case_Severity__c, Support_Level__c from Entitlement where Support_Level__c = 'ANGEL Premium Support'AND AssetID = :c.AssetID AND Outside_Business_Hours_ANGEL_Premium__c = true AND Case_Severity__c = :c.Case_Severity__c]);
                            if (e != null && e.size() > 0) {
                                c.EntitlementID = e[0].ID;
                                c.BusinessHoursID = e[0].BusinessHoursID;
                            }
                        }
                    }
                } else if (a[0].Support_Level__c == 'Xythos Support') {
                    for (List < Entitlement > e: [select ID, Case_Severity__c, BusinessHoursID, Support_Level__c from Entitlement where Support_Level__c = 'Xythos Support'AND AssetID = :c.AssetID]) {
                        for (Entitlement e1: e) {
                            if (String.valueof(e1.Case_Severity__c).contains(c.Case_severity__c)) {
                                c.EntitlementID = e1.ID;
                                c.BusinessHoursID = e1.BusinessHoursID;
                            }
                        }
                    }
                } else if (a[0].Support_Level__c == 'ANGEL Basic Support' || (a[0].Support_Level__c == 'ANGEL Premium Support' && c.Invoke_Premium_Support__c == false)) {
                    if (c.Case_Severity__c == '1' && a[0].Managed_Hosting__c == 'ANGEL - Managed Hosting') {
                        List < Entitlement > e = new List < Entitlement > ([select ID, Name, BusinessHoursID, Case_Severity__c, ANGEL_Hosted__c, Support_Level__c from Entitlement where Support_Level__c = :a[0].Support_Level__c AND AssetID = :c.AssetID AND ANGEL_Hosted__c = true AND Case_Severity__c = '1']);
                        for (Entitlement e1: e) {
                            if (!e1.Name.contains('Premium')) {
                                c.EntitlementID = e1.ID;
                                c.BusinessHoursID = e1.BusinessHoursID;
                            }
                        }
                    } else {
                        for (List < Entitlement > e: [select ID, Name, BusinessHoursID, Case_Severity__c, Support_Level__c from Entitlement where Support_Level__c = :a[0].Support_Level__c AND AssetID = :c.AssetID]) {
                            for (Entitlement e1: e) {
                                if (String.valueof(e1.Case_Severity__c).contains(c.Case_severity__c) && !e1.Name.contains('Premium')) {
                                    c.EntitlementID = e1.ID;
                                    c.BusinessHoursID = e1.BusinessHoursID;
                                }
                            }
                        }
                    }
                } else {
                    if (a[0].Support_Level__c == 'Basic Support') {
                        String timezone = [select TimeZoneSidKey From User where ID = :Userinfo.getUserID()].TimeZoneSidKey;
                        for (List < Entitlement > e: [select ID, BusinessHoursID, Case_Severity__c, Support_Level__c, Business_Hour_Time_Zone__c from Entitlement where Support_Level__c = 'Basic Support'AND AssetID = :c.AssetID AND Business_Hour_Time_Zone__c = :timezone]) {
                            for (Entitlement e1: e) {
                                System.debug(e1.Case_Severity__c);
                                System.debug(e1.Support_Level__c);
                                System.debug(e1.Business_Hour_Time_Zone__c);
                                System.debug(timezone);
                                if (String.valueof(e1.Case_Severity__c).contains(c.Case_severity__c)) {
                                    c.EntitlementID = e1.ID;
                                    c.BusinessHoursID = e1.BusinessHoursID;
                                }
                            }
                        }
                    } else if (a[0].Support_Level__c == 'Enterprise Support') {
                        if (c.Case_Severity__c == '1' || c.Case_Severity__c == '2') {
                            List < Entitlement > e = new List < Entitlement > ([select ID, BusinessHoursID, Case_Severity__c, Support_Level__c, Business_Hour_Time_Zone__c from Entitlement where Support_Level__c = 'Enterprise Support'AND AssetID = :c.AssetID AND Case_Severity__c = :c.Case_Severity__c]);
                            if (e.size() > 0) {
                                c.EntitlementID = e[0].ID;
                                c.BusinessHoursID = e[0].BusinessHoursID;
                            }
                        } else if (c.Case_Severity__c == '3' || c.Case_Severity__c == '4') {
                            String timezone = [select TimeZoneSidKey From User where ID = :Userinfo.getUserID()].TimeZoneSidKey;
                            List < Entitlement > e = new List < Entitlement > ([select ID, BusinessHoursID, Case_Severity__c, Support_Level__c, Business_Hour_Time_Zone__c from Entitlement where Support_Level__c = 'Enterprise Support'AND AssetID = :c.AssetID AND Business_Hour_Time_Zone__c = :timezone]);
                           
                            for (Entitlement e1: e) {
                                if (e1.Case_Severity__c != null && e1.Case_Severity__c.contains('3') || e1.Case_Severity__c.contains('4')) {
                                    c.EntitlementID = e1.ID;
                                    c.BusinessHoursID = e1.BusinessHoursID;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}
/*
 *  Appiphony MB 5/24/2011
 *  Catalog Page for BlackBoard - CSS
 *  
 */
 
 /*General Styles*/
 .media{line-height:13px;}
 body{color:#000000; font-size:12px; font-family:Arial, Helvetica, sans-serif;}
 .containerHeader{font-weight:bold; font-size:14px; margin:0px 10px 0px 10px;}
 .headerImage{margin-right:10px; float:left;}
 .headerTitle{float:left; font-size:24px; margin-top:3px;}
 .paddedOut10{margin:10px;}
 .paddedOut5{margin:5px;}
 .paddedOut0{margin:0px;}
 .padded8{padding:8px;}
 .fullWidth{width:100%;}
 .paddedTop10{margin:10px 0px 0px 0px;}
 .spacer10{margin:9px 0px 0px 0px; height:1px;}
 .toTheRight{float:right;}
 .toTheLeft{float:left;}
 .removeLeftPad{margin-left:0px;}
 .removeRightPad{margin-right:0px;}
 .strong{font-weight:bold;}
 .width85{width:85%;}
 .width10{width:10% !IMPORTANT;}
 .width5{width:5%}
 .imageTopperLearners{margin-top:6px;}
 .hideMe{display:none;}
 .forceLeft{float:left !IMPORTANT;}
 .padding10{padding:10px;}
 
 /*Bread Crumb Styles*/
 .crumbs a{font-size:11px; font-family:Verdana; color:#015BA7; text-decoration:none;}
 
 
 /* List elements for category list */
 .categoryList {float:left; width:100%;}
 .categoryList ul{float:left; margin:10px 5%; width:90%;}
 .categoryList li{float:left; list-style-type: none; margin:0px; width:33%;}
 .categoryList a{color:#015BA7; padding:2px;}
 .categoryList a:hover{color:#FFFFFF; background-color:#1797C0;}
 .categoryList .active a{color:#FFFFFF; background-color:#1797C0;}
 .categoryList .active a:hover{color:#FFFFFF; background-color:#1797C0;}
 .categoryList .active {color:#FFFFFF; background-color:#1797C0;}
 
 /*Fix for EXTJS CSS border box on Salesforce Tabs*/
  .tabNavigation *{box-sizing: content-box !IMPORTANT; -moz-box-sizing: content-box !IMPORTANT; -ms-box-sizing: content-box !IMPORTANT; -webkit-box-sizing: content-box !IMPORTANT;}

 /*Course Styles */
 .courseWrapper{margin:5px 5%; width:90%;}
 .title{}
 .courseTitle{color:#336600; font-size:16px; margin:0px 5px;}
 .rule{height:1px; border-bottom:1px solid #E0E0E0; margin:10px 0px;}
 .courseNumber{width:50px; float:left;}
 .courseSubHeading{font-size:11px;}
 .courseData{color:#666666;}
 .courseMargin{margin:5px;}
 .courseDescription{color:#333333; font-size:12px; line-height:17px;}
 .courseBackground{background-color:#FCFEFE !IMPORTANT;}
 .tableBackground{background-color:#F8F8F8;}
 .courseDate{margin-top:15px; margin-bottom:15px;}
 .body a{font-size:11px; font-family:Verdana; color:#015BA7; text-decoration:none;}
 .defaultBody{margin-top:15px; line-height:17px;}
 
 .buttonPanel{margin:0px 5px; float:right; display:inline;}
 
 .btnPadded{padding:5px 10px !IMPORTANT;}
 .btnPaddedLarge{padding:8px 15px !IMPORTANT; font-size:11px !IMPORTANT;}
 .btnRight{margin-right:5px !IMPORTANT;} 
 .btnMarginTop3{margin-top:3px;}
 /*Button Panel*/ 
 .buttonContainer{width:200px;}
 .buttonContainerSmall{width:70px;}
  .buttonContainerSmallSelected{width:230px;}
 
 /*Drop Down */
 .drop{width:105px;}
 .drop ul {font-size:14px; list-style: none;} 
 .drop ul li {display: block; position: relative; float: left;}
 .drop li ul { display:none; }
 .drop ul li a{font-size:11px; display: block; text-decoration: none; color: #015BA7; width:105px; text-align:center; padding: 7px 2px 7px 2px; margin-left: 1px; margin-top:3px; white-space: nowrap; text-decoration:underline;}
 .drop ul li a:hover {font-size:11px; background: #1797C0; color:#FFFFFF; text-decoration:none;}
 .drop li:hover ul {display: block; position: absolute; border:1px solid #1797C0; width:299px; margin-left:-193px; background-color:#F2F8FB; z-index:1001;}
 .drop li:hover a{background:#1797C0; color:#FFFFFF; text-decoration:none;}
 
 .topLine{border-top:1px solid #E0E0E0;}
 .savedCourse{width:267px; float:left;}
 .savedCourseSide{float:left; line-height:normal; width:100%;}
 .deleteIcon{width:15px; float:left; margin-right:5px; height:100%;}
 .deleteIcon a{width:15px !IMPORTANT; padding:0px !IMPORTANT; background-color:transparent !IMPORTANT; text-decoration:none;}
 .deleteIcon a:hover{width:15px !IMPORTANT; padding:0px !IMPORTANT; background-color:transparent !IMPORTANT; text-decoration:none;}
 .savedCourseLine{float:left;}
 .savedCourseTitle{font-weight:bold; font-size:11px; margin-left:5px;}
 .savedCourseName{font-size:11px; color:#666666; margin-left:5px;}
 .deleteLearner{text-decoration:none;}
 .deleteLearner:hover{text-decoration:none;}
 
 /*EXJS Overwrites*/
 .courseTable .x-grid-header-ct, .courseTable .x-panel-default, .courseTable .x-panel .x-grid-body, .courseTable .x-scroller-vertical{border-color:#E3E3E3;}
 .courseTable .x-grid-row-selected .x-grid-cell, .courseTable .x-grid-row-selected .x-grid-rowwrap-div{background-color:#C4E7F2 !IMPORTANT; border-color:#E7E7E7 !IMPORTANT;}
 .courseTable a{color:#015BA7; text-decoration:underline;}
 .courseTable a:hover{color:#015BA7; text-decoration:underline;}
 .courseTable .x-column-header-text{font-weight:bold;}
 .courseTable .x-grid-row .x-grid-cell{font: normal 12px arial,verdana,sans-serif;}
 /*.courseTable .x-panel, .courseTable .x-grid, .courseTable .x-panel-default, .courseTable .x-vertical-scroller-present{ width:100% !IMPORTANT;}
 .courseTable .x-grid-table, .courseTable .x-grid-table-resizer, .courseTable .x-unselectable{width:100% !IMPORTANT;}
 .courseTable .x-grid-header-ct, .courseTable .x-grid-header-ct-default, .courseTable .x-docked, .courseTable .x-docked-top, .courseTable .x-grid-header-ct-docked-top, .courseTable .x-grid-header-ct-default-docked-top, .courseTable .x-box-layout-ct{width:100% !IMPORTANT;}
 .courseTable .x-unselectable, .courseTable .x-column-header,.courseTable .x-unselectable-default, .courseTable .x-column-header-align-left,.courseTable .x-box-item x-column-header-first{width:100% !IMPORTANT;}
 */
 .courseBackground .x-border-box .x-form-text{height:16px; font-size:11px;}
 .courseTable{width:100% !IMPORTANT;}
 
 /*EXTJS Class Containers*/
 .bb-sidebar, .bb-panel{width:100% !IMPORTANT; height:100% !IMPORTANT;}
 
 /*Selected Learners */
 .col{float:left; line-height:14px;}
 .toggle{width:2%; margin:15px 2%;} 
 .image{width:30%;} 
 .info{width:62%; color:#A3A3A3; font-style:italic;}
 .ptn{font-weight:bold; color:#0C63C5; font-size:12px; margin-left:20px; margin-top:2px !IMPORTANT;}
 .detail{font-size:11px; color:#4A4A55;}
 .lineRule{width:94%; margin:5px 3% 6px 3%; height:1px; border-bottom:1px solid #E0E0E0; }
 .last{margin-left:6% !IMPORTANT;} 
 .deleteSavedCourse{text-decoration:none;}
 .deleteSavedCourse:hover{text-decoration:none;}
 
 /*Message Boxes*/
 .infoMessage{border:1px solid #359AFF; background-color:#FFFFCC; -moz-border-radius: 4px; -webkit-border-radius: 4px; border-radius:4px; margin:10px 0px; width:100%;}
 .messageBoxBB .info{width:100%; color:#000000; font-size:12px; font-style:normal;}
 .messageBoxBB a{color: #015BA7;}
 .messageBoxBB .infoIconBB{float:left; margin-right:10px; width:24px; display:inline !IMPORTANT;}
 .messageTextMargin{margin-top:6px; width:600px;}
 
 .whiteSide {background-color: #FCFEFE !important; min-height: 357px;}
 .topeBg {background-color: #F8F8F8 !important;}
 
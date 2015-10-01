<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Enrollment Creation</fullName>
        <actions>
            <name>Enrollment_Creation</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Enrollment__c.Status__c</field>
            <operation>equals</operation>
            <value>Pending</value>
        </criteriaItems>
        <description>This workflow is used in the Blackboard Learn for Sales application to send an Outbound Message when an Enrollment record is created to Blackboard Learn.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>

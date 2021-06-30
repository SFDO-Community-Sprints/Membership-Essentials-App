/*
* Created by MHumpolec on 6/3/2021.
*/

public with sharing class MembershipContactRoleHandler extends TriggerHandler{
    
    private Map<Id, Membership_Contact_Role__c> touchedRoles;
    private Map<Id, Membership_Contact_Role__c> oldRolesMap;
    @TestVisible private ConfigurationService cs;
    
    public MembershipContactRoleHandler(){
        cs = new ConfigurationService();
        this.touchedRoles = (Map<Id, Membership_Contact_Role__c>) Trigger.newMap;
        if (Trigger.oldMap != null) {
            this.oldRolesMap = (Map<Id, Membership_Contact_Role__c>) Trigger.oldMap;
        } else {
            this.oldRolesMap = new Map<Id, Membership_Contact_Role__c>();
        }
    }
    
    public override void afterUpdate(){
         managePrimaryContactRole();
    }
    
    /**
    * If Contact Role has been marked as primary put the contact to the primary contact on membership - will roll down
    */
    
    private void managePrimaryContactRole (){
        List<Membership__c> membershipsToUpdate = new List<Membership__c>();

        for(Id touchedRole : this.touchedRoles.keySet()) {
            Boolean newPrim = touchedRoles.get(touchedRole).Is_Primary__c;
            Boolean oldPrim = oldRolesMap.containsKey(touchedRole) ? oldRolesMap.get(touchedRole).Is_Primary__c : false;
            if (oldPrim == false && newPrim == true) {
                Membership__c m = new Membership__c( Id = touchedRoles.get(touchedRole).Membership__c, Primary_Contact__c = touchedRoles.get(touchedRole).Contact__c);
                membershipsToUpdate.add( m);
            }
        }
        update membershipsToUpdate;
    }
}
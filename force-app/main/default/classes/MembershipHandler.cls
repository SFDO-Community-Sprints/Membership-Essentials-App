/**
 * Created by ChrisPifer on 2/10/2021.
 */

public with sharing class MembershipHandler extends TriggerHandler{
    public override void afterInsert(){
        Set<Id> contactSet = new Set<Id>();
        Set<Id> accountSet = new Set<Id>();
        ConfigurationService cs = new ConfigurationService();

        for(Membership__c m : (List<Membership__c>)Trigger.new){
            //Anything we can do to prevent this running every time?!
            // always check for changes: status, end date, primary, do not expire
            // statuses = current or renewal
            // if end date > Today or do not expire is changed
            // primary is changed

            // if new and active, call service 
            if(m.Primary__c == true 
            && cs.getActiveMembershipStatuses().contains(m.Status__c)
            && (m.End_Date__c >= System.today() || m.Does_Not_Expire__c == true)) {
                if(m.Primary_Contact__c != null) {
                    contactSet.add(m.Primary_Contact__c);
                }
                if(m.Account__c != null) {
                    accountSet.add(m.Account__c);
                }
            }

        }
        MembershipService ms = new MembershipService();
        if(contactSet.size() > 0) {
            ms.rollupPrimaryMembershipContact(contactSet);
        }
        if(accountSet.size() > 0) {
            ms.rollupPrimaryMembershipAccount(accountSet);
        }
        
    }
  /*
   * Created by ChrisPifer on 9/24/2020.
   */

    private Map<Id, Membership__c> newMembershipsMap;
    private Map<Id, Membership__c> oldMembershipsMap;
    private Map<Id, Membership_Contact_Role__c> touchedRolesIds;

    public MembershipHandler(){
        this.newMembershipsMap = (Map<Id, Membership__c>) Trigger.newMap;
        if (Trigger.oldMap != null) {
            this.oldMembershipsMap = (Map<Id, Membership__c>) Trigger.oldMap;
        } else {
            this.oldMembershipsMap = new Map<Id, Membership__c>();
        }
    }

    public override void afterInsert(){
        managePrimaryContactRole();
    }

    public override void afterUpdate(){
        managePrimaryContactRole();
    }
    /**
     * If when a membership is created or updated and primary contact is set or changed
     * Check for a primary contact membership role for that contact, create if missing.
     */

    private void managePrimaryContactRole (){
        List<Id> membershipContacts = new List<Id>();
        Set<String> newContactMembershipKey = new Set<String>();
        Set<String> oldContactMembershipKey = new Set<String>();
        Set<String> foundMembershipKeys = new Set<String>();
        Set<String> promotedMembershipKeys = new Set<String>();
        Map<Id, Id> keyPairsToPromote = new Map<Id, Id>();
        Map<Id, Id> keyPairsToDemote = new Map<Id, Id>();
        List<Membership_Contact_Role__c> contactRolesForCreate = new List<Membership_Contact_Role__c>();
        List<Membership_Contact_Role__c> contactRolesForUpdate = new List<Membership_Contact_Role__c>();
        List<Membership_Contact_Role__c> contactRolesToDemote = new List<Membership_Contact_Role__c>();
        List<Membership_Contact_Role__c> contactRolesToPromote = new List<Membership_Contact_Role__c>();
        Map<String, Membership_Contact_Role__c> rolesByContactMembId = new Map<String, Membership_Contact_Role__c>();
        //check if we have any new records or changed contact roles
        for(Id newMembershipId : this.newMembershipsMap.keySet()) {
            Id newPrimContactId = newMembershipsMap.get(newMembershipId).Primary_Contact__c;
            Id oldPrimContactId = oldMembershipsMap.containsKey(newMembershipId) ? oldMembershipsMap.get(newMembershipId).Primary_Contact__c : null;
            //Three scenarios to manage - newly created, edited to new record, edited to null
            newContactMembershipKey.add('' + newPrimContactId + newMembershipId);
            oldContactMembershipKey.add('' + oldPrimContactId + newMembershipId);
            //New Membership Record
            if (oldPrimContactId == null && newPrimContactId != null) {
                contactRolesForCreate.add(createRole(newPrimContactId, newMembershipId, true));
            }
            //Updated membership, values changed
            if (newPrimContactId != null && oldPrimContactId != null && newPrimContactId != oldPrimContactId) {
                keyPairsToPromote.put(newPrimContactId, newMembershipId);
                keyPairsToDemote.put(oldPrimContactId, newMembershipId);
                promotedMembershipKeys.add('' + newPrimContactId + newMembershipId);
            }
            //Updated membership changed to null
            if (newPrimContactId == null && oldPrimContactId != null) {
                keyPairsToDemote.put(oldPrimContactId, newMembershipId);
            }
        }
        contactRolesToDemote = [SELECT Id, Name, Contact__c, Membership__c FROM Membership_Contact_Role__c WHERE
        Contact__c IN: keyPairsToDemote.keySet() AND Membership__c IN: keyPairsToDemote.values() ];
        contactRolesToPromote = [SELECT Id, Name, Contact__c, Membership__c FROM Membership_Contact_Role__c WHERE
        Contact__c IN: keyPairsToPromote.keySet() AND Membership__c IN: keyPairsToPromote.values() ];
        for(Membership_Contact_Role__c mcr : contactRolesToPromote){
            foundMembershipKeys.add('' + mcr.Contact__c + mcr.Membership__c);
        }
        for(String idKey : promotedMembershipKeys){
            if(!foundMembershipKeys.contains(idKey)){
                contactRolesForCreate.add(createRole(idKey.left(18), idKey.right(18), true ));
            }
        }
        for(Membership_Contact_Role__c mcr : contactRolesToDemote){
            String thisKey = '' + mcr.Contact__c + mcr.Membership__c;
            if(oldContactMembershipKey.contains(thisKey)){
                contactRolesForUpdate.add(demoteRole(mcr));
            }
        }
        for(Membership_Contact_Role__c mcr : contactRolesToPromote){
            if(newContactMembershipKey.contains('' + mcr.Contact__c + mcr.Membership__c)) {
                contactRolesForUpdate.add(promoteRole(mcr));
            }
        }
        update contactRolesForUpdate;
        insert contactRolesForCreate;
    }

    private Membership_Contact_Role__c createRole(Id ContactId, Id MembershipId, Boolean primary){
        String defaultName = '';
        if(primary){
            defaultName = 'Primary Member';
        } else {
            defaultName = 'Member';
        }

        Membership_Contact_Role__c mcr = new Membership_Contact_Role__c(
                Name = defaultName,
                Contact__c = ContactId,
                Membership__c = MembershipId,
                Is_Primary__c = primary,
                Start_Date__c = Date.today()
        );
        return mcr;
    }

    private Membership_Contact_Role__c demoteRole(Membership_Contact_Role__c mcr){
        if(mcr.name == 'Primary Member'){
            mcr.name = 'Member';
        }
        mcr.Is_Primary__c = false;
        return mcr;
    }

    private Membership_Contact_Role__c promoteRole(Membership_Contact_Role__c mcr){
        mcr.Name = 'Primary Member';
        mcr.Is_Primary__c = true;
        mcr.Start_Date__c = Date.today();
        return mcr;
    }
}
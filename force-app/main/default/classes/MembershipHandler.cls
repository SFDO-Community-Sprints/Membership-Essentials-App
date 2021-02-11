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
                    AccountSet.add(m.Account__c);
                }
            }

        }
        MembershipService ms = new MembershipService();
        if(contactSet.size() > 0) {
            ms.rollupPrimaryMembershipContact(contactSet);
        }
        if(accountSet.size() > 0) {
            ms.rollupPrimaryMembershipAccount(AccountSet);
        }
        
    }

}
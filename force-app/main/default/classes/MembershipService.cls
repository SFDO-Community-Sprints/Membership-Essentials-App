/**
 * Created by ChrisPifer on 2/10/2021.
 */

public without sharing class MembershipService {
    @TestVisible private ConfigurationService cs;

    public MembershipService(){
        cs = new ConfigurationService();
    }

    public void rollupPrimaryMembershipContact(Set<Id> contactIds){

    }

    public void rollupPrimaryMembershipAccount(Set<Id> accountIds){
        // for each account in the set
            // look at all the memberships
            // identify the one that is the primary
            // set Primary_Membership__c on those accounts
        // update accounts
    }
}
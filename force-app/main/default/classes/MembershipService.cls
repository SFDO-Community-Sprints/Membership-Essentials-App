/**
 * Created by ChrisPifer on 2/10/2021.
 */

public without sharing class MembershipService {
    @TestVisible private ConfigurationService cs;

    public MembershipService(){
        cs = new ConfigurationService();
    }

    public void rollupPrimaryMembership(Set<Id> contactIds){

    }
}
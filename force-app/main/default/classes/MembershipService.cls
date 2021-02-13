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
        // collect accounts to update
        List<Account> to_update = new List<Account>();
        
        // grab all the memberships related that are primary and non-expired and put into a list
        List<Membership__c> mem_list = [
            SELECT Id, Primary__c, End_Date__c, Does_Not_Expire__c, Account__c
            FROM Membership__c
            WHERE Account__c IN :accountIds AND Primary__c = true // identify the ones that are the primary
            AND (Does_Not_Expire__c = true OR End_Date__c >= TODAY) // get rid of expired ones
            ORDER BY End_Date__c DESC NULLS FIRST // gets the not-expiring ones first
            ];
        
        for (Membership__c m : mem_list) {
            Account a = [SELECT Id, Primary_Membership__c FROM Account WHERE Id = :m.Account__c];
            a.Primary_Membership__c = m.Id;
            to_update.add(a);
        }
        
        //create a map that will hold the values of the list 
		Map<Id,Account> accmap = new Map<Id,Account>();

		//put all the values from the list to map. 
		accmap.putall(to_update);
		if(accmap.size()>0){
			update accmap.values();
        }
    	
	}
}
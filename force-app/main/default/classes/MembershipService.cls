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
        
        // grab all the memberships related that are primary and non-expired and put into a list
        List<Membership__c> mem_list = [
            SELECT Id, Primary__c, End_Date__c, Does_Not_Expire__c, Account__c
            FROM Membership__c
            WHERE Account__c IN :accountIds AND Primary__c = true // identify the ones that are the primary
            AND (Does_Not_Expire__c = true OR End_Date__c >= TODAY) // get rid of expired ones
            ORDER BY End_Date__c DESC NULLS FIRST // gets the not-expiring ones first
            ];
        	// if multiple memberships meet this criteria, need to handle. 
        
        // list of all accounts in set
        List<Account> acc_list = [SELECT Id, Primary_Membership__c FROM Account WHERE Id IN :accountIds];
        Map<Id,Account> acc_map= new Map<Id, Account>(acc_list);
        
        for (Membership__c m : mem_list) {
            Account a = acc_map.get(m.Account__c); 
            a.Primary_Membership__c = m.Id;
            acc_map.put(a.Id, a);
        }
        
     	// update accounts
		if(acc_map.size()>0){
			update acc_map.values();
        }
    	
	}
}
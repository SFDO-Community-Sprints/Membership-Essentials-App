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

    // Update lapsed and expired memberships, along with the MCRs and accounts.
    public void updateMembership(List<Membership__c> memberships) {
        // Get lapse period from custom metadata.  Default is 30 days.
        Integer lapsePeriod = 30;
        List<Membership_Setting__mdt> settings = getMemSetting();
        if (!settings.isEmpty() && settings[0].Lapse_Period__c != null && settings[0].Lapse_Period__c > 0) {
            lapsePeriod = (Integer)(settings[0].Lapse_Period__c);
        }

        Date todayDate = Date.today();
        Date finalDate = Date.today().addDays(lapsePeriod);
        Map<Id, Membership__c> memsToUpdate = new Map<Id, Membership__c>();
        List<Account> acctsToUpdate = new List<Account>();
        List<Contact> contactsToUpdate = new List<Contact>();

        for (Membership__c mem : memberships) {
            Membership__c tmpMem = new Membership__c(Id = mem.Id);
            // End Date has passed and Status is still Current.
            // Lapse Period has passed and Status is still Lapsed.
            if (mem.End_Date__c < todayDate && mem.Status__c == 'Current') {
                tmpMem.Status__c = 'Lapsed';
            } else if (mem.End_Date__c < finalDate && mem.Status__c == 'Lapsed') {
                tmpMem.Status__c = 'Former';
            }
            if (tmpMem.Status__c != null) {
                memsToUpdate.put(mem.Id, tmpMem);
                // Check if account needs update
                if (mem.Account__c != null) {
                    Account tmpAcct = new Account(
                        Id = mem.Account__c,
                        Membership_Status__c = tmpMem.Status__c
                    );
                    acctsToUpdate.add(tmpAcct);
                }
            }
        }

        // Create contact list for update.
        List<Membership_Contact_Role__c> roles = [SELECT Membership__c, Contact__c 
                FROM Membership_Contact_Role__c 
                WHERE Membership__c IN :memberships];
        for (Membership_Contact_Role__c role : roles) {
            Contact tmpContact = new Contact(
                Id = role.Contact__c,
                Membership_Status__c = memsToUpdate.get(role.Membership__c).Status__c
            );
            contactsToUpdate.add(tmpContact);
        }

        // Update memberships and related records as needed.
        update memberships;
        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
        if (!acctsToUpdate.isEmpty()) {
            update acctsToUpdate;
        }

    }

    public List<Membership_Setting__mdt> getMemSetting() {
        return [SELECT Lapse_Period__c FROM Membership_Setting__mdt LIMIT 1];
    }
}
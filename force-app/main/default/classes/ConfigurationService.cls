// This class is `without sharing` to ensure data integrity
// TODO(flow-migration): Centralizes hard-coded membership types, active statuses, and role names for Apex trigger handlers; replace with Membership_Essentials_Setting__mdt lookups in Flow.
public without sharing class ConfigurationService {
    // TODO(settings-mdt): 'Individual' — individual membership type
    public List<String> getIndividualMembershipTypes() {
        return new List<String>{'Individual'};
    }

    // TODO(settings-mdt): 'Household' — household membership type
    public List<String> getHouseholdMembershipTypes() {
        return new List<String>{'Household'};
    }

    // TODO(settings-mdt): 'Corporate' — corporate membership type
    public List<String> getCorporateMembershipTypes() {
        return new List<String>{'Corporate'};
    }

    // TODO(settings-mdt): 'Household', 'Corporate' — non-individual membership types that share memberships across account contacts
    public List<String> getNonIndividualMembershipTypes() {
        return new List<String>{'Household', 'Corporate'};
    }
    
    // TODO(settings-mdt): 'Current', 'Renewal' — membership statuses treated as active for primary membership rollups
     public List<String> getActiveMembershipStatuses() {
        return new List<String>{'Current','Renewal'};
    }

    // TODO(settings-mdt): 'Household Member' — role assigned to contacts added to an account with an active non-individual membership
    public String getHouseholdMemberRole() {
        return 'Household Member';
    }
      
    // TODO(settings-mdt): 'Primary Member' — role name for the primary contact on a membership
    public String getPrimaryMember() {
        return 'Primary Member';
    }
    
    // TODO(settings-mdt): 'Member' — default role name for a non-primary contact or demoted primary contact on a membership
    public String getMember() {
        return 'Member';
    }
    
}

public without sharing class ConfigurationService {
    public List<String> getIndividualMembershipTypes() {
        return new List<String>{'Individual'};
    }

    public List<String> getHouseholdMembershipTypes() {
        return new List<String>{'Household'};
    }

    public List<String> getCorporateMembershipTypes() {
        return new List<String>{'Corporate'};
    }

    public List<String> getNonIndividualMembershipTypes() {
        return new List<String>{'Household', 'Corporate'};
    }

    public List<String> getActiveMembershipStatuses() {
        return new List<String>{'Current','Renewal'};
    }
}

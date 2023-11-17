# Seeding Data for MembershipSchemaAndBenefits project

1. Create a membership cci org definition: `cci org scratch dev membership --days 30`
2. Create a scartch org then install OSC MembershipSchemaAndBenefits package: Run `cci flow run dev_org --org membership`
3. Load OSC MembershipSchemaAndBenefits Snowfakery Generated Data: Run `cci flow run osc_memberships_project --org membership`
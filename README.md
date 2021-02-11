# Membership Schema And Benefits

For updated project overview and accomplishments by sprint, please refer to the Wiki & orient on the "Start Here" page.

### Project Team (Virtual Sprint February 2021)
* Leaders: Chris Pifer & Duncan McGovern
* Scribe: Duncan McGovern
* List of all Contributors: Jillian Niler, Amanda Styles, Rachel Whaley, Brandon Mead, Emily Wilson, Michael Beaty, Rex Clark

### Project Team (Virtual Sprint September 2020)
* Team Leader(s):  Chris Pifer
* GitHub Scribe(s): David Reed
* List of all Contributors: Duncan McGovern, Evan Ponter, Lynda En, Ryan Baba

### Project Team (Virtual Sprint March 31, 2020)
Help us give you the thanks you deserve! Please ensure that all contributing members of the team are included!
* Team Leader(s): Kai Williams
* GitHub Scribe(s): Evan Ponter, Collin Zimmerman
* List of all Contributors: Evan Ponter, Reede Stockton, James Browne, Mel Brockley, Chris Pifer

### Project Team (Previous Sprint)
Help us give you the thanks you deserve! Please ensure that all contributing members of the team are included!
* Team Leader(s): 
* GitHub Scribe(s): [Thomas Taylor](/tet3) & [Duncan McGovern](/D-McGovern)
* List of all Contributors: [Andrea Hanson](/andreahanson), Dean Graham, John Adams, Deepa Bedi, Shari Carlson Reily, [Michael Kolodner](/mkolodner), Brittany Neale, Amy Bucciferro

### Project Vision (Your first task as a team)
A schema for memberships, sponsorship, renewals, payments, multiple members, families, benefits, etc, that actually works. Eventually automation etc.

* **What is the big problem that your project is trying to solve?**
    The existing NPSP membership data model is very lightweight and doesn't meet many orgs' needs. We seek to design a data model that is flexible and extensible for a wide range of membership and entitlement models including memberships and sponsonships. 

* **Who will be using your project?**
    Organizations that have any form of membership or sponsorship, paid or unpaid. 

* **A year from now, how do you see people describing your project?**
    A foundational data structure that can be extended and modified

* **Use these questions to form a clear vision statement of 3-5 sentences (rough guideline).** 
The team would like to provide nonprofits and consultants with a framework for benefits including memberships and sponsorships that is separate from opportunities for both technical and operational considerations. These include benefits that are not tied to a financial contribution as well as the ability expose benefits objects to all SF license types (community, platform, etc). It also decouples purchasing a benefit from the benefit recipient(s).

Having trouble? Salesforce.org staff and your fellow sprinters are here to help! Use one of your table's request signs and/or post in the Quip Chat to seek help, and we'll pop by.

### Requirements and Ongoing Concerns
[See Requirements Wiki Page](https://github.com/SFDO-Community-Sprints/MembershipSchemaAndBenefits/wiki/Requirements)


### Solutioning
[See Solutioning Wiki Page](https://github.com/SFDO-Community-Sprints/MembershipSchemaAndBenefits/wiki/Solutioning)

## Next Steps
* Have Beta Testers use the v4 architecture as a base to build out their membership implementation
* Collect feedback from those tests
* Use cases / user stories
* Define MVP and Roadmap
* List edge cases we will not support
* Finish building out custom fields
* List custom settings/automation to prioritize
* Create example email alerts and templates that orgs could use as a starting point

## Code
* Custom setting (or metadata) : based on product, assign related benefits to Opportunity
    * for future
  
### Project Resources

* [Current NPSP functionality docs](https://powerofus.force.com/s/article/NPSP-Working-with-Memberships)
* Possibly related Hub Ideas:
  *   [Automate Membership Origin and Start/End Dates on new Opportunities](https://powerofus.force.com/s/idea/a1W80000004DUjLEAW/automate-membership-origin-and-startend-dates-on-new-opportunities)
  *   [Customize payment automation by stage](https://powerofus.force.com/s/idea/a1W80000006bnfMEAQ/customize-payment-automation-by-stage)
* Code hasn't yet been created
* Also see prior sprint work done during Amsterdam Sprint in 2019 https://github.com/SFDO-Community-Sprints/Membership-Management

### Project Team Accomplishments
Sprint 2020 Virtual Sprint
* Created v4 schema
    * benefits catalogue/used objects could fit into schema but not mapped out as out of scope for this Sprint
* Implemented v4 schema in scratch org with custom fields and relationships
* Discussed and solidified decisions made in prior groups regarding membership, ensuring flexibilitiy for a range of use cases

Philly Sprint?
* Reduced data model to 3 objects
* Many, many discussions that all return to the same core data model
* Feeling confident in creating a junction object between contact and membership
    * slightly less confident in how to address benefits

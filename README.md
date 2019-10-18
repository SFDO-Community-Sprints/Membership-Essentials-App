### Membership Schema And Benefits

### Project Team
Help us give you the thanks you deserve! Please ensure that all contributing members of the team are included!
* Team Leader(s): 
* GitHub Scribe(s): [Thomas Taylor](/tet3) 
* List of all Contributors: [Andrea Hanson](/andreahanson), Dean Graham, John Adams, Deepa Bedi, Shari Carlson Reily, [Michael Kolodner](/mkolodner), Brittany Neale, Amy Bucciferro

### Project Vision (Your first task as a team)
A schema for memberships, renewals, payments, multiple members, families, benefits, etc, that actually works. Eventually automation etc.

* What is the big problem that your project is trying to solve?
    The existing NPSP membership data model is very lightweight and doesn't meet many orgs' needs. We seek to design a data model that is flexible and extensible for a wide range of membership models. 

* Who will be using your project?
    Organizations that have paid memberships of some kind. 

* A year from now, how do you see people describing your project?

Use these questions to form a clear vision statement of 3-5 sentences (rough guideline). 

Having trouble? Salesforce.org staff and your fellow sprinters are here to help! Use one of your table's request signs and/or post in the Quip Chat to seek help, and we'll pop by.

### Requirements

* Track retention, renewal and reacquire
* automate labeling of membership opps as new, renewal, reacquire
* Individual memberships
* Dual & Household memberships
* Multiple Contacts attached to a membership, not necessarily tied to a single Account
* benefits/or Membership can be assigned to specific or additional contacts - relevant for Organizational membership that grants benefits to a specific number of members
* Memberships without payment, eg, gift memberships & subscriptions
* Free memberships 
* Membership levels & products
* Overlapping membership levels, especially re: discounted levels like Senior or Student 
* Personal Benefit/non-tax deductible amount
* Multiple memberships per contact
* acknowledgements & receipting
* automate renewal creation
* automate renewal reminders
* tying benefits to specific events, eg, seats, ads
* marking memberships as lapsed
* grace period 
* multi-year memberships
* membership # associated with Contact(s)
* membership card
* suspending memberships
* organizational memberships
* periodic/recurring payments for memberships
* suspension of membership if recurring payment missed
* Communities compatibility/automation
* differentiate between membership benefit entitlements and actual receipt
* track if member declines benefits - relates to tax-deductibility as well
* benefits over longer period of time, including over multiple events

## Requirements to refine
* Benefit/purchase rollovers
  * status in benefit Assignment
* Different benefits -> new vs. renewing 
* Membership records required for:
  * Communities
  * Org/Corporate memberships
* BDI considerations 

![Image of MemberPosterPhoto.jpg](images/MemberPosterPhoto.jpg)

### Solutioning

* [Draw.io ERD](https://www.draw.io/?lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=1&title=MembershipSchema-PhillySprint.drawio#Uhttps%3A%2F%2Fdrive.google.com%2Fa%2Fcoolbrook.org%2Fuc%3Fid%3D1UGZOsbNlRQTadTfOZhl7pvLYH-NQnRqz%26export%3Ddownload)

![Image of InitialDataModel.jpg](images/InitialDataModel.jpg)

## Next Steps for Friday
* Use cases / user stories
* Prove out on model
* Re-validate requirements
* Firm answer on the membership and its junction
* Determine custom settings
* Define MVP and Roadmap
* List edge cases we will not support

## Code
* Custom setting (or metadata) : based on product, assign related benefits to Opportunity
  
### Project Resources

* [Current NPSP functionality docs](https://powerofus.force.com/s/article/NPSP-Working-with-Memberships)
* Possibly related Hub Ideas:
  *   [Automate Membership Origin and Start/End Dates on new Opportunities](https://powerofus.force.com/s/idea/a1W80000004DUjLEAW/automate-membership-origin-and-startend-dates-on-new-opportunities)
  *   [Customize payment automation by stage](https://powerofus.force.com/s/idea/a1W80000006bnfMEAQ/customize-payment-automation-by-stage)
* Where can we find additional information on your project? Ie. do you have supporting code in another Repo, do you have documentation in Google, your repo's Wiki, etc.? Be sure to include (or at least links to) all supporting material here. If it's not in your project Repo, it will get lost.

### Project Team Accomplishments
What did the Project Team accomplished during the Sprint?

### Future Contributions (AKA what were you unable to finish at the Sprint)
Often, it takes multiple Sprints to contribute an idea back into the Community. What happens at a Sprint does not stay at a Sprint! If someone were to contribute to this project at the next Sprint what would you want them to work on to move this project forward?<br><br>
* What is your project's Roadmap?

**Important**: If you have specific asks to help move this project forward we would recommend that you list them here, but also create separate Issues for each and add the label of "help wanted". This is a well-worn best practice for projects living in GitHub.

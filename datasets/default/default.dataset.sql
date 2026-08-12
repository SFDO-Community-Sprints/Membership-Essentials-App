BEGIN TRANSACTION;
CREATE TABLE "Account" (
	id VARCHAR(255) NOT NULL, 
	"AccountNumber" VARCHAR(255), 
	"AccountSource" VARCHAR(255), 
	"AnnualRevenue" VARCHAR(255), 
	"BillingCity" VARCHAR(255), 
	"BillingCountry" VARCHAR(255), 
	"BillingGeocodeAccuracy" VARCHAR(255), 
	"BillingLatitude" VARCHAR(255), 
	"BillingLongitude" VARCHAR(255), 
	"BillingPostalCode" VARCHAR(255), 
	"BillingState" VARCHAR(255), 
	"BillingStreet" VARCHAR(255), 
	"CleanStatus" VARCHAR(255), 
	"Description" VARCHAR(255), 
	"DunsNumber" VARCHAR(255), 
	"Fax" VARCHAR(255), 
	"First_Membership_Start_Date__c" VARCHAR(255), 
	"Industry" VARCHAR(255), 
	"Jigsaw" VARCHAR(255), 
	"Last_Membership_Start_Date__c" VARCHAR(255), 
	"Membership_End_Date__c" VARCHAR(255), 
	"Membership_Status__c" VARCHAR(255), 
	"Membership_Type__c" VARCHAR(255), 
	"NaicsCode" VARCHAR(255), 
	"NaicsDesc" VARCHAR(255), 
	"Name" VARCHAR(255), 
	"NumberOfEmployees" VARCHAR(255), 
	"Ownership" VARCHAR(255), 
	"Phone" VARCHAR(255), 
	"Rating" VARCHAR(255), 
	"ShippingCity" VARCHAR(255), 
	"ShippingCountry" VARCHAR(255), 
	"ShippingGeocodeAccuracy" VARCHAR(255), 
	"ShippingLatitude" VARCHAR(255), 
	"ShippingLongitude" VARCHAR(255), 
	"ShippingPostalCode" VARCHAR(255), 
	"ShippingState" VARCHAR(255), 
	"ShippingStreet" VARCHAR(255), 
	"Sic" VARCHAR(255), 
	"SicDesc" VARCHAR(255), 
	"Site" VARCHAR(255), 
	"TickerSymbol" VARCHAR(255), 
	"Tradestyle" VARCHAR(255), 
	"Type" VARCHAR(255), 
	"Website" VARCHAR(255), 
	"YearStarted" VARCHAR(255), 
	"DandbCompanyId" VARCHAR(255), 
	"OperatingHoursId" VARCHAR(255), 
	"ParentId" VARCHAR(255), 
	"Primary_Membership__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Account" VALUES('Account-1','','','','','','','','','','','','Pending','','','','','','','','','','','','','Existing Account','','','','','','','','','','','','','','','','','','','','','','','Account-2','');
INSERT INTO "Account" VALUES('Account-2','','','','','','','','','','','','Pending','','','','','','','','','','','','','Existing Parent Account','','','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES('Account-3','','','','','','','','','','','','Pending','','','','','','','','','','','','','Alvarez Household','','','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES('Account-4','','','','','','','','','','','','Pending','','','','','','','','','','','','','Bennett Household','','','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES('Account-5','','','','','','','','','','','','Pending','','','','','','','','','','','','','Chen Household','','','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES('Account-6','','','','','','','','','','','','Pending','','','','','','','','','','','','','Diallo Household','','','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES('Account-7','','','','','','','','','','','','Pending','','','','','','','','','','','','','Eriksson Household','','','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES('Account-8','','','','','','','','','','','','Pending','','','','','','','','','','','','','Fitzgerald Household','','','','','','','','','','','','','','','','','','','','','','','','');
CREATE TABLE "Contact" (
	id VARCHAR(255) NOT NULL, 
	"AssistantName" VARCHAR(255), 
	"AssistantPhone" VARCHAR(255), 
	"Birthdate" VARCHAR(255), 
	"CleanStatus" VARCHAR(255), 
	"Department" VARCHAR(255), 
	"Description" VARCHAR(255), 
	"DoNotCall" VARCHAR(255), 
	"Email" VARCHAR(255), 
	"EmailBouncedDate" VARCHAR(255), 
	"EmailBouncedReason" VARCHAR(255), 
	"Fax" VARCHAR(255), 
	"FirstName" VARCHAR(255), 
	"First_Membership_Start_Date__c" VARCHAR(255), 
	"GenderIdentity" VARCHAR(255), 
	"HasOptedOutOfEmail" VARCHAR(255), 
	"HasOptedOutOfFax" VARCHAR(255), 
	"HomePhone" VARCHAR(255), 
	"Jigsaw" VARCHAR(255), 
	"LastName" VARCHAR(255), 
	"Last_Membership_Start_Date__c" VARCHAR(255), 
	"LeadSource" VARCHAR(255), 
	"MailingCity" VARCHAR(255), 
	"MailingCountry" VARCHAR(255), 
	"MailingGeocodeAccuracy" VARCHAR(255), 
	"MailingLatitude" VARCHAR(255), 
	"MailingLongitude" VARCHAR(255), 
	"MailingPostalCode" VARCHAR(255), 
	"MailingState" VARCHAR(255), 
	"MailingStreet" VARCHAR(255), 
	"Membership_End_Date__c" VARCHAR(255), 
	"Membership_Status__c" VARCHAR(255), 
	"Membership_Type__c" VARCHAR(255), 
	"MobilePhone" VARCHAR(255), 
	"OtherCity" VARCHAR(255), 
	"OtherCountry" VARCHAR(255), 
	"OtherGeocodeAccuracy" VARCHAR(255), 
	"OtherLatitude" VARCHAR(255), 
	"OtherLongitude" VARCHAR(255), 
	"OtherPhone" VARCHAR(255), 
	"OtherPostalCode" VARCHAR(255), 
	"OtherState" VARCHAR(255), 
	"OtherStreet" VARCHAR(255), 
	"Phone" VARCHAR(255), 
	"Pronouns" VARCHAR(255), 
	"Salutation" VARCHAR(255), 
	"Title" VARCHAR(255), 
	"AccountId" VARCHAR(255), 
	"IndividualId" VARCHAR(255), 
	"ReportsToId" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Contact" VALUES('Contact-1','','','','Pending','','','False','email@email.com','','','','Member','','','False','False','','','Testerson','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO "Contact" VALUES('Contact-3','','','','Pending','','','False','alvarez@example.com','','','','Demo','','','False','False','','','Alvarez','','','','','','','','','','','','','','','','','','','','','','','','','','','','Account-3','','');
INSERT INTO "Contact" VALUES('Contact-4','','','','Pending','','','False','bennett@example.com','','','','Demo','','','False','False','','','Bennett','','','','','','','','','','','','','','','','','','','','','','','','','','','','Account-4','','');
INSERT INTO "Contact" VALUES('Contact-5','','','','Pending','','','False','chen@example.com','','','','Demo','','','False','False','','','Chen','','','','','','','','','','','','','','','','','','','','','','','','','','','','Account-5','','');
INSERT INTO "Contact" VALUES('Contact-6','','','','Pending','','','False','diallo@example.com','','','','Demo','','','False','False','','','Diallo','','','','','','','','','','','','','','','','','','','','','','','','','','','','Account-6','','');
INSERT INTO "Contact" VALUES('Contact-7','','','','Pending','','','False','eriksson@example.com','','','','Demo','','','False','False','','','Eriksson','','','','','','','','','','','','','','','','','','','','','','','','','','','','Account-7','','');
INSERT INTO "Contact" VALUES('Contact-8','','','','Pending','','','False','fitzgerald@example.com','','','','Demo','','','False','False','','','Fitzgerald','','','','','','','','','','','','','','','','','','','','','','','','','','','','Account-8','','');
CREATE TABLE "DandBCompany" (
	id VARCHAR(255) NOT NULL, 
	"DunsNumber" VARCHAR(255), 
	"Name" VARCHAR(255), 
	PRIMARY KEY (id)
);
CREATE TABLE "Individual" (
	id VARCHAR(255) NOT NULL, 
	"LastName" VARCHAR(255), 
	PRIMARY KEY (id)
);
CREATE TABLE "Membership__c" (
	id VARCHAR(255) NOT NULL, 
	"Name" VARCHAR(255), 
	"Type__c" VARCHAR(255), 
	"Status__c" VARCHAR(255), 
	"Start_Date__c" VARCHAR(255), 
	"End_Date__c" VARCHAR(255), 
	"Account__c" VARCHAR(255), 
	"Primary_Contact__c" VARCHAR(255), 
	"Product__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Membership__c" VALUES('Membership__c-1','Alvarez Membership','Household','Current','2023-03-01','2027-03-01','Account-3','Contact-3','Product2-5');
INSERT INTO "Membership__c" VALUES('Membership__c-2','Bennett Membership','Household','Current','2023-06-01','2027-06-01','Account-4','Contact-4','Product2-3');
INSERT INTO "Membership__c" VALUES('Membership__c-3','Chen Membership','Individual','Current','2022-09-01','2025-09-01','Account-5','Contact-5','Product2-1');
INSERT INTO "Membership__c" VALUES('Membership__c-4','Diallo Membership','Individual','Current','2024-02-01','2025-02-01','Account-6','Contact-6','Product2-1');
INSERT INTO "Membership__c" VALUES('Membership__c-5','Eriksson Membership','Household','Current','2026-07-01','2027-07-01','Account-7','Contact-7','Product2-2');
INSERT INTO "Membership__c" VALUES('Membership__c-6','Fitzgerald Membership','Household','Current','2021-04-01','2026-09-01','Account-8','Contact-8','Product2-3');
CREATE TABLE "OperatingHours" (
	id VARCHAR(255) NOT NULL, 
	"Name" VARCHAR(255), 
	"TimeZone" VARCHAR(255), 
	PRIMARY KEY (id)
);
CREATE TABLE "Product2" (
	id VARCHAR(255) NOT NULL, 
	"Description" VARCHAR(255), 
	"DisplayUrl" VARCHAR(255), 
	"ExternalId" VARCHAR(255), 
	"Family" VARCHAR(255), 
	"Grace_Period__c" VARCHAR(255), 
	"IsActive" VARCHAR(255), 
	"IsSerialized" VARCHAR(255), 
	"Membership_Tier__c" VARCHAR(255), 
	"Name" VARCHAR(255), 
	"ProductCode" VARCHAR(255), 
	"QuantityUnitOfMeasure" VARCHAR(255), 
	"Renewal_Option__c" VARCHAR(255), 
	"StockKeepingUnit" VARCHAR(255), 
	"Term_Unit__c" VARCHAR(255), 
	"Term__c" VARCHAR(255), 
	"Downgrade_Path__c" VARCHAR(255), 
	"Upgrade_Path__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Product2" VALUES('Product2-1','','','','Membership','30','True','False','3','Basic Membership','','','Renewable','BSC','Year','1.0','','Product2-2');
INSERT INTO "Product2" VALUES('Product2-2','','','','Membership','30','True','False','1','Standard Membership','','','Renewable','STD','Year','1.0','Product2-1','Product2-5');
INSERT INTO "Product2" VALUES('Product2-3','','','','Membership','30','True','False','2','Family Membership','','','Renewable','FAM','Year','1.0','','');
INSERT INTO "Product2" VALUES('Product2-4','','','','Membership','30','True','False','4','Youth Membership','','','Renewable','YTH','Year','1.0','','Product2-2');
INSERT INTO "Product2" VALUES('Product2-5','','','','Membership','30','True','False','0','Premier Membership','','','Renewable','PMR','Year','1.0','Product2-2','');
CREATE TABLE "Membership_Form_Submission__c" (
	id VARCHAR(255) NOT NULL, 
	"Status__c" VARCHAR(255), 
	"Membership_Finder_Ran__c" VARCHAR(255), 
	"Term_Start_Date__c" VARCHAR(255), 
	"SalePrice__c" VARCHAR(255), 
	"Duration__c" VARCHAR(255), 
	"MembershipType__c" VARCHAR(255), 
	"Source_Code__c" VARCHAR(255), 
	"Membership__c" VARCHAR(255), 
	"Account__c" VARCHAR(255), 
	"Product__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Membership_Form_Submission__c" VALUES('MFS-1','Imported','True','2023-03-01','150','1 Year','Household','WEB','Membership__c-1','Account-3','Product2-3');
INSERT INTO "Membership_Form_Submission__c" VALUES('MFS-2','Imported','True','2024-03-01','500','1 Year','Household','RENEWAL','Membership__c-1','Account-3','Product2-2');
INSERT INTO "Membership_Form_Submission__c" VALUES('MFS-3','Imported','True','2025-03-01','2500','1 Year','Household','GALA','Membership__c-1','Account-3','Product2-5');
INSERT INTO "Membership_Form_Submission__c" VALUES('MFS-4','Imported','True','2026-03-01','2500','1 Year','Household','RENEWAL','Membership__c-1','Account-3','Product2-5');
INSERT INTO "Membership_Form_Submission__c" VALUES('MFS-5','Imported','True','2023-06-01','150','1 Year','Household','WEB','Membership__c-2','Account-4','Product2-3');
INSERT INTO "Membership_Form_Submission__c" VALUES('MFS-6','Imported','True','2024-06-01','150','1 Year','Household','RENEWAL','Membership__c-2','Account-4','Product2-3');
INSERT INTO "Membership_Form_Submission__c" VALUES('MFS-7','Imported','True','2025-06-01','150','1 Year','Household','RENEWAL','Membership__c-2','Account-4','Product2-3');
INSERT INTO "Membership_Form_Submission__c" VALUES('MFS-8','Imported','True','2026-06-01','150','1 Year','Household','RENEWAL','Membership__c-2','Account-4','Product2-3');
INSERT INTO "Membership_Form_Submission__c" VALUES('MFS-9','Imported','True','2022-09-01','500','1 Year','Individual','MEMBER_DRIVE','Membership__c-3','Account-5','Product2-2');
INSERT INTO "Membership_Form_Submission__c" VALUES('MFS-10','Imported','True','2023-09-01','150','1 Year','Individual','RENEWAL','Membership__c-3','Account-5','Product2-3');
INSERT INTO "Membership_Form_Submission__c" VALUES('MFS-11','Imported','True','2024-09-01','75','1 Year','Individual','RENEWAL','Membership__c-3','Account-5','Product2-1');
INSERT INTO "Membership_Form_Submission__c" VALUES('MFS-12','Imported','True','2024-02-01','75','1 Year','Individual','SOCIAL','Membership__c-4','Account-6','Product2-1');
INSERT INTO "Membership_Form_Submission__c" VALUES('MFS-13','Imported','True','2026-07-01','500','1 Year','Household','WEB','Membership__c-5','Account-7','Product2-2');
INSERT INTO "Membership_Form_Submission__c" VALUES('MFS-14','Imported','True','2021-04-01','75','1 Year','Household','WEB','Membership__c-6','Account-8','Product2-1');
INSERT INTO "Membership_Form_Submission__c" VALUES('MFS-15','Imported','True','2022-04-01','75','1 Year','Household','RENEWAL','Membership__c-6','Account-8','Product2-1');
INSERT INTO "Membership_Form_Submission__c" VALUES('MFS-16','Imported','True','2024-09-01','150','1 Year','Household','WINBACK_MAIL','Membership__c-6','Account-8','Product2-3');
INSERT INTO "Membership_Form_Submission__c" VALUES('MFS-17','Imported','True','2025-09-01','150','1 Year','Household','RENEWAL','Membership__c-6','Account-8','Product2-3');
COMMIT;

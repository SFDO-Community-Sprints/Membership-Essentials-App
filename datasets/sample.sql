BEGIN TRANSACTION;
CREATE TABLE "Account" (
	id INTEGER NOT NULL, 
	"First_Membership_Start_Date__c" VARCHAR(255), 
	"Last_Membership_Start_Date__c" VARCHAR(255), 
	"Membership_End_Date__c" VARCHAR(255), 
	"Membership_Status__c" VARCHAR(255), 
	"Membership_Type__c" VARCHAR(255), 
	"Name" VARCHAR(255), 
	"ParentId" VARCHAR(255), 
	"Primary_Membership__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Account" VALUES(1,'2022-09-28','','2023-09-28','Current','Individual','Levi Frost Household','','34');
INSERT INTO "Account" VALUES(2,'2022-07-17','','2023-07-17','Lapsed','Individual','Perry Higgins Household','','');
INSERT INTO "Account" VALUES(3,'2022-12-10','','2023-12-10','Former','Household','Crystal Farrell Household','','36');
INSERT INTO "Account" VALUES(4,'2022-12-05','','2023-12-05','Former','Household','Ernest Shields Household','','');
INSERT INTO "Account" VALUES(5,'2022-06-28','','2023-06-28','Current','Corporate','Stanley-Best','','');
INSERT INTO "Account" VALUES(6,'2023-02-01','','2024-02-01','Lapsed','Corporate','Colon-Cooke','','33');
INSERT INTO "Account" VALUES(7,'2022-08-28','','2023-08-28','Renewal','Corporate','Palmer Ltd','','');
INSERT INTO "Account" VALUES(8,'2022-09-05','','2023-09-05','Lapsed','Corporate','Mccall, Short and Short','','');
INSERT INTO "Account" VALUES(9,'2022-09-27','','2023-09-27','Former','Household','Ashley Trevino Household','','40');
INSERT INTO "Account" VALUES(10,'2022-12-11','','2023-12-11','Former','Household','Isabella Middleton Household','','32');
INSERT INTO "Account" VALUES(11,'2022-05-07','','2023-05-07','Renewal','Individual','Shane Fowler Household','','71');
INSERT INTO "Account" VALUES(12,'2022-07-06','','2023-07-06','Lapsed','Household','Dan Huff Household','','72');
INSERT INTO "Account" VALUES(13,'2022-12-21','','2023-12-21','Lapsed','Corporate','Burnett Inc','','');
INSERT INTO "Account" VALUES(14,'2022-12-14','','2023-12-14','Former','Household','Henry Acevedo Household','','74');
INSERT INTO "Account" VALUES(15,'2022-08-27','','2023-08-27','Current','Individual','Michaela Buckley Household','','');
INSERT INTO "Account" VALUES(16,'2022-10-09','','2023-10-09','Former','Corporate','Figueroa Inc','','');
INSERT INTO "Account" VALUES(17,'2022-08-17','','2023-08-17','Renewal','Household','Howard Cantu Household','','77');
INSERT INTO "Account" VALUES(18,'2022-06-12','','2023-06-12','Current','Corporate','Cooley-Lynn','','78');
INSERT INTO "Account" VALUES(19,'2022-05-15','','2023-05-15','Lapsed','Corporate','Carlson, Robles and Stein','','79');
INSERT INTO "Account" VALUES(20,'2023-02-10','','2024-02-10','Former','Individual','Bill Booker Household','','');
INSERT INTO "Account" VALUES(21,'2022-08-07','','2023-08-07','Renewal','Individual','Kirsten Ritter Household','','91');
INSERT INTO "Account" VALUES(22,'2022-06-04','','2023-06-04','Current','Individual','Kristine Mcgrath Household','','92');
INSERT INTO "Account" VALUES(23,'2022-10-25','','2023-10-25','Lapsed','Corporate','Malone-Cardenas','','');
INSERT INTO "Account" VALUES(24,'2022-10-04','','2023-10-04','Renewal','Household','Bill Watkins Household','','94');
INSERT INTO "Account" VALUES(25,'2022-07-04','','2023-07-04','Current','Corporate','Fleming-Barajas','','95');
INSERT INTO "Account" VALUES(26,'2022-08-29','','2023-08-29','Renewal','Corporate','Mullins, Casey and Sheppard','','');
INSERT INTO "Account" VALUES(27,'2022-06-03','','2023-06-03','Renewal','Corporate','Mooney, Simon and Jordan','','97');
INSERT INTO "Account" VALUES(28,'2022-09-15','','2023-09-15','Lapsed','Corporate','Contreras Ltd','','98');
INSERT INTO "Account" VALUES(29,'2022-11-28','','2023-11-28','Renewal','Household','Sheryl Schwartz Household','','');
INSERT INTO "Account" VALUES(30,'2022-12-04','','2023-12-04','Lapsed','Household','Rebecca Adams Household','','100');
INSERT INTO "Account" VALUES(31,'2023-01-06','','2024-01-06','Current','Household','Calvin Forbes Household','','1');
INSERT INTO "Account" VALUES(32,'2022-09-29','','2023-09-29','Current','Corporate','Rivas LLC','','');
INSERT INTO "Account" VALUES(33,'2022-12-07','','2023-12-07','Current','Household','Shawna Buck Household','','');
INSERT INTO "Account" VALUES(34,'2022-12-14','','2023-12-14','Current','Corporate','Mays, Ball and Horn','','');
INSERT INTO "Account" VALUES(35,'2022-03-29','','2023-03-29','Former','Household','Karina Sellers Household','','');
INSERT INTO "Account" VALUES(36,'2023-01-17','','2024-01-17','Former','Corporate','Day, Gardner and Miranda','','6');
INSERT INTO "Account" VALUES(37,'2022-05-07','','2023-05-07','Lapsed','Individual','Cheyenne Robles Household','','7');
INSERT INTO "Account" VALUES(38,'2022-09-26','','2023-09-26','Current','Household','Vicki Keith Household','','');
INSERT INTO "Account" VALUES(39,'2022-06-15','','2023-06-15','Renewal','Corporate','Odom-Miles','','9');
INSERT INTO "Account" VALUES(40,'2023-01-19','','2024-01-19','Current','Individual','Norma Gomez Household','','');
INSERT INTO "Account" VALUES(41,'2022-07-23','','2023-07-23','Current','Household','Suzanne Gibson Household','','23');
INSERT INTO "Account" VALUES(42,'2022-05-01','','2023-05-01','Lapsed','Household','Monica Sosa Household','','24');
INSERT INTO "Account" VALUES(43,'2022-10-14','','2023-10-14','Former','Household','Wesley Camacho Household','','25');
INSERT INTO "Account" VALUES(44,'2022-10-06','','2023-10-06','Current','Household','Eric Moses Household','','');
INSERT INTO "Account" VALUES(45,'2022-06-26','','2023-06-26','Renewal','Individual','Joanne Mack Household','','27');
INSERT INTO "Account" VALUES(46,'2022-12-16','','2023-12-16','Former','Corporate','Hester and Sons','','');
INSERT INTO "Account" VALUES(47,'2022-07-27','','2023-07-27','Renewal','Individual','Jody Gregory Household','','');
INSERT INTO "Account" VALUES(48,'2022-11-25','','2023-11-25','Renewal','Individual','Oscar Crosby Household','','');
INSERT INTO "Account" VALUES(49,'2022-11-15','','2023-11-15','Former','Household','Terrance Vega Household','','11');
INSERT INTO "Account" VALUES(50,'2022-08-24','','2023-08-24','Renewal','Household','Rick Mccall Household','','');
INSERT INTO "Account" VALUES(51,'2022-04-01','','2023-04-01','Renewal','Individual','Kim Ferrell Household','','51');
INSERT INTO "Account" VALUES(52,'2022-06-20','','2023-06-20','Former','Household','Karina Mora Household','','52');
INSERT INTO "Account" VALUES(53,'2022-12-25','','2023-12-25','Current','Corporate','Gregory Inc','','');
INSERT INTO "Account" VALUES(54,'2022-05-12','','2023-05-12','Former','Corporate','Hammond, Wiggins and Odonnell','','');
INSERT INTO "Account" VALUES(55,'2022-09-24','','2023-09-24','Lapsed','Individual','Manuel Dodson Household','','');
INSERT INTO "Account" VALUES(56,'2022-05-25','','2023-05-25','Renewal','Individual','Christie Reeves Household','','56');
INSERT INTO "Account" VALUES(57,'2022-10-22','','2023-10-22','Renewal','Individual','Ann Fowler Household','','');
INSERT INTO "Account" VALUES(58,'2022-09-26','','2023-09-26','Renewal','Individual','Kristen Hale Household','','58');
INSERT INTO "Account" VALUES(59,'2022-10-21','','2023-10-21','Renewal','Household','Stanley Stein Household','','');
INSERT INTO "Account" VALUES(60,'2022-06-05','','2023-06-05','Current','Corporate','Nixon Inc','','');
INSERT INTO "Account" VALUES(61,'','','','','','Sample Account for Entitlements','','');
INSERT INTO "Account" VALUES(62,'2023-01-04','','2024-01-04','Current','Household','Leon Macias Household','','');
INSERT INTO "Account" VALUES(63,'2023-02-09','','2024-02-09','Current','Corporate','Stone and Sons','','');
INSERT INTO "Account" VALUES(64,'2022-05-22','','2023-05-22','Renewal','Individual','Kristopher Cantu Household','','83');
INSERT INTO "Account" VALUES(65,'2022-04-24','','2023-04-24','Former','Individual','Rachael Dalton Household','','');
INSERT INTO "Account" VALUES(66,'2022-09-26','','2023-09-26','Renewal','Individual','Jason Barr Household','','85');
INSERT INTO "Account" VALUES(67,'2022-11-17','','2023-11-17','Renewal','Individual','Selena Williams Household','','');
INSERT INTO "Account" VALUES(68,'2022-10-11','','2023-10-11','Lapsed','Corporate','Sutton, Valentine and Dickson','','');
INSERT INTO "Account" VALUES(69,'2022-08-26','','2023-08-26','Lapsed','Household','Cole Cervantes Household','','88');
INSERT INTO "Account" VALUES(70,'2022-07-07','','2023-07-07','Former','Corporate','Madden-Harrell','','');
INSERT INTO "Account" VALUES(71,'2022-12-01','','2023-12-01','Lapsed','Individual','Frederick Cherry Household','','');
INSERT INTO "Account" VALUES(72,'2022-09-24','','2023-09-24','Former','Household','Jerome Lloyd Household','','42');
INSERT INTO "Account" VALUES(73,'2022-05-01','','2023-05-01','Current','Individual','Samantha Mcintyre Household','','');
INSERT INTO "Account" VALUES(74,'2022-04-28','','2023-04-28','Renewal','Corporate','Stokes, Kirk and Figueroa','','');
INSERT INTO "Account" VALUES(75,'2022-06-19','','2023-06-19','Current','Individual','Kaitlyn Raymond Household','','');
INSERT INTO "Account" VALUES(76,'2022-09-15','','2023-09-15','Current','Individual','Raven Woodard Household','','');
INSERT INTO "Account" VALUES(77,'2022-06-18','','2023-06-18','Lapsed','Corporate','Hogan, Molina and Anthony','','47');
INSERT INTO "Account" VALUES(78,'2022-03-29','','2023-03-29','Lapsed','Household','Judy Kaiser Household','','48');
INSERT INTO "Account" VALUES(79,'2022-03-30','','2023-03-30','Renewal','Household','Crystal Jackson Household','','49');
INSERT INTO "Account" VALUES(80,'2022-08-30','','2023-08-30','Current','Individual','Ethan Wiggins Household','','');
INSERT INTO "Account" VALUES(81,'2023-03-25','','2024-03-25','Renewal','Individual','Sonia Mathis Household','','41');
INSERT INTO "Account" VALUES(82,'2022-08-29','','2023-08-29','Lapsed','Corporate','Wheeler LLC','','13');
INSERT INTO "Account" VALUES(83,'2022-06-12','','2023-06-12','Current','Household','Jane Marshall Household','','14');
INSERT INTO "Account" VALUES(84,'2023-01-17','','2024-01-17','Lapsed','Individual','Brandon Kramer Household','','15');
INSERT INTO "Account" VALUES(85,'2023-02-01','','2024-02-01','Lapsed','Corporate','Ferguson-Stephens','','16');
INSERT INTO "Account" VALUES(86,'2023-02-02','','2024-02-02','Renewal','Individual','Carol Bolton Household','','');
INSERT INTO "Account" VALUES(87,'2022-04-01','','2023-04-01','Former','Individual','Wanda Gray Household','','18');
INSERT INTO "Account" VALUES(88,'2022-04-10','','2023-04-10','Renewal','Individual','Bianca Navarro Household','','19');
INSERT INTO "Account" VALUES(89,'2022-04-30','','2023-04-30','Former','Individual','Allison Hogan Household','','');
INSERT INTO "Account" VALUES(90,'2023-02-01','','2024-02-01','Lapsed','Corporate','Lin, Robbins and Whitaker','','21');
INSERT INTO "Account" VALUES(91,'2023-03-12','','2024-03-12','Lapsed','Household','Bonnie Pham Household','','22');
INSERT INTO "Account" VALUES(92,'2023-01-19','','2024-01-19','Lapsed','Corporate','Montes Group','','');
INSERT INTO "Account" VALUES(93,'2022-04-22','','2023-04-22','Lapsed','Household','Stacey Cooke Household','','62');
INSERT INTO "Account" VALUES(94,'2023-02-19','','2024-02-19','Renewal','Corporate','Bass Group','','');
INSERT INTO "Account" VALUES(95,'2023-02-04','','2024-02-04','Lapsed','Individual','Justin Davenport Household','','');
INSERT INTO "Account" VALUES(96,'2022-11-26','','2023-11-26','Lapsed','Household','Mckenzie Woodward Household','','65');
INSERT INTO "Account" VALUES(97,'2022-07-09','','2023-07-09','Former','Individual','Carrie Williams Household','','66');
INSERT INTO "Account" VALUES(98,'2022-09-23','','2023-09-23','Lapsed','Corporate','Barajas Group','','67');
INSERT INTO "Account" VALUES(99,'2022-12-04','','2023-12-04','Lapsed','Household','Martin Baker Household','','');
INSERT INTO "Account" VALUES(100,'2022-12-31','','2023-12-31','Renewal','Individual','Carmen Hayden Household','','');
INSERT INTO "Account" VALUES(101,'2022-04-03','','2023-04-03','Lapsed','Corporate','Kent LLC','','');
CREATE TABLE "Contact" (
	id INTEGER NOT NULL, 
	"DoNotCall" VARCHAR(255), 
	"FirstName" VARCHAR(255), 
	"First_Membership_Start_Date__c" VARCHAR(255), 
	"HasOptedOutOfEmail" VARCHAR(255), 
	"HasOptedOutOfFax" VARCHAR(255), 
	"LastName" VARCHAR(255), 
	"Last_Membership_Start_Date__c" VARCHAR(255), 
	"Membership_End_Date__c" VARCHAR(255), 
	"Membership_Status__c" VARCHAR(255), 
	"Membership_Type__c" VARCHAR(255), 
	"AccountId" VARCHAR(255), 
	"ReportsToId" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Contact" VALUES(1,'False','Calvin','2023-01-06','False','False','Forbes','2023-01-06','2024-01-06','Current','Household','31','');
INSERT INTO "Contact" VALUES(2,'False','Kristie','2022-09-29','False','False','Chambers','2022-09-29','2023-09-29','Current','Corporate','32','');
INSERT INTO "Contact" VALUES(3,'False','Shawna','2022-12-07','False','False','Buck','2022-12-07','2023-12-07','Current','Household','33','');
INSERT INTO "Contact" VALUES(4,'False','Aaron','2022-12-14','False','False','Nicholson','2022-12-14','2023-12-14','Current','Corporate','34','');
INSERT INTO "Contact" VALUES(5,'False','Karina','2022-03-29','False','False','Sellers','2022-03-29','2023-03-29','Former','Household','35','');
INSERT INTO "Contact" VALUES(6,'False','Derrick','2023-01-17','False','False','Carter','2023-01-17','2024-01-17','Former','Corporate','36','');
INSERT INTO "Contact" VALUES(7,'False','Cheyenne','2022-05-07','False','False','Robles','2022-05-07','2023-05-07','Lapsed','Individual','37','');
INSERT INTO "Contact" VALUES(8,'False','Vicki','2022-09-26','False','False','Keith','2022-09-26','2023-09-26','Current','Household','38','');
INSERT INTO "Contact" VALUES(9,'False','Pam','2022-06-15','False','False','Ramos','2022-06-15','2023-06-15','Renewal','Corporate','39','');
INSERT INTO "Contact" VALUES(10,'False','Norma','2023-01-19','False','False','Gomez','2023-01-19','2024-01-19','Current','Individual','40','');
INSERT INTO "Contact" VALUES(11,'False','Stuart','2022-08-29','False','False','Kerr','2022-08-29','2023-08-29','Lapsed','Corporate','82','');
INSERT INTO "Contact" VALUES(12,'False','Jane','2022-06-12','False','False','Marshall','2022-06-12','2023-06-12','Current','Household','83','');
INSERT INTO "Contact" VALUES(13,'False','Brandon','2023-01-17','False','False','Kramer','2023-01-17','2024-01-17','Lapsed','Individual','84','');
INSERT INTO "Contact" VALUES(14,'False','Alec','2023-02-01','False','False','Buchanan','2023-02-01','2024-02-01','Lapsed','Corporate','85','');
INSERT INTO "Contact" VALUES(15,'False','Carol','2023-02-02','False','False','Bolton','2023-02-02','2024-02-02','Renewal','Individual','86','');
INSERT INTO "Contact" VALUES(16,'False','Wanda','2022-04-01','False','False','Gray','2022-04-01','2023-04-01','Former','Individual','87','');
INSERT INTO "Contact" VALUES(17,'False','Bianca','2022-04-10','False','False','Navarro','2022-04-10','2023-04-10','Renewal','Individual','88','');
INSERT INTO "Contact" VALUES(18,'False','Allison','2022-04-30','False','False','Hogan','2022-04-30','2023-04-30','Former','Individual','89','');
INSERT INTO "Contact" VALUES(19,'False','Fernando','2023-02-01','False','False','Collins','2023-02-01','2024-02-01','Lapsed','Corporate','90','');
INSERT INTO "Contact" VALUES(20,'False','Bonnie','2023-03-12','False','False','Pham','2023-03-12','2024-03-12','Lapsed','Household','91','');
INSERT INTO "Contact" VALUES(21,'False','Leon','2023-01-04','False','False','Macias','2023-01-04','2024-01-04','Current','Household','62','');
INSERT INTO "Contact" VALUES(22,'False','Jane','2023-02-09','False','False','Dyer','2023-02-09','2024-02-09','Current','Corporate','63','');
INSERT INTO "Contact" VALUES(23,'False','Kristopher','2022-05-22','False','False','Cantu','2022-05-22','2023-05-22','Renewal','Individual','64','');
INSERT INTO "Contact" VALUES(24,'False','Rachael','2022-04-24','False','False','Dalton','2022-04-24','2023-04-24','Former','Individual','65','');
INSERT INTO "Contact" VALUES(25,'False','Jason','2022-09-26','False','False','Barr','2022-09-26','2023-09-26','Renewal','Individual','66','');
INSERT INTO "Contact" VALUES(26,'False','Selena','2022-11-17','False','False','Williams','2022-11-17','2023-11-17','Renewal','Individual','67','');
INSERT INTO "Contact" VALUES(27,'False','Marie','2022-10-11','False','False','Andrade','2022-10-11','2023-10-11','Lapsed','Corporate','68','');
INSERT INTO "Contact" VALUES(28,'False','Cole','2022-08-26','False','False','Cervantes','2022-08-26','2023-08-26','Lapsed','Household','69','');
INSERT INTO "Contact" VALUES(29,'False','Ebony','2022-07-07','False','False','Villanueva','2022-07-07','2023-07-07','Former','Corporate','70','');
INSERT INTO "Contact" VALUES(30,'False','Frederick','2022-12-01','False','False','Cherry','2022-12-01','2023-12-01','Lapsed','Individual','71','');
INSERT INTO "Contact" VALUES(31,'False','Kim','2022-04-01','False','False','Ferrell','2022-04-01','2023-04-01','Renewal','Individual','51','');
INSERT INTO "Contact" VALUES(32,'False','Karina','2022-06-20','False','False','Mora','2022-06-20','2023-06-20','Former','Household','52','');
INSERT INTO "Contact" VALUES(33,'False','Sheri','2022-12-25','False','False','Poole','2022-12-25','2023-12-25','Current','Corporate','53','');
INSERT INTO "Contact" VALUES(34,'False','Alfred','2022-05-12','False','False','Hoover','2022-05-12','2023-05-12','Former','Corporate','54','');
INSERT INTO "Contact" VALUES(35,'False','Manuel','2022-09-24','False','False','Dodson','2022-09-24','2023-09-24','Lapsed','Individual','55','');
INSERT INTO "Contact" VALUES(36,'False','Christie','2022-05-25','False','False','Reeves','2022-05-25','2023-05-25','Renewal','Individual','56','');
INSERT INTO "Contact" VALUES(37,'False','Ann','2022-10-22','False','False','Fowler','2022-10-22','2023-10-22','Renewal','Individual','57','');
INSERT INTO "Contact" VALUES(38,'False','Kristen','2022-09-26','False','False','Hale','2022-09-26','2023-09-26','Renewal','Individual','58','');
INSERT INTO "Contact" VALUES(39,'False','Stanley','2022-10-21','False','False','Stein','2022-10-21','2023-10-21','Renewal','Household','59','');
INSERT INTO "Contact" VALUES(40,'False','Theodore','2022-06-05','False','False','Thomas','2022-06-05','2023-06-05','Current','Corporate','60','');
INSERT INTO "Contact" VALUES(41,'False','Brittany','2022-06-28','False','False','Weaver','2022-06-28','2023-06-28','Current','Corporate','5','');
INSERT INTO "Contact" VALUES(42,'False','Isabella','2022-12-11','False','False','Middleton','2022-12-11','2023-12-11','Former','Household','10','');
INSERT INTO "Contact" VALUES(43,'False','Brett','2023-02-01','False','False','Strong','2023-02-01','2024-02-01','Lapsed','Corporate','6','');
INSERT INTO "Contact" VALUES(44,'False','Levi','2022-09-28','False','False','Frost','2022-09-28','2023-09-28','Current','Individual','1','');
INSERT INTO "Contact" VALUES(45,'False','Perry','2022-07-17','False','False','Higgins','2022-07-17','2023-07-17','Lapsed','Individual','2','');
INSERT INTO "Contact" VALUES(46,'False','Crystal','2022-12-10','False','False','Farrell','2022-12-10','2023-12-10','Former','Household','3','');
INSERT INTO "Contact" VALUES(47,'False','Ernest','2022-12-05','False','False','Shields','2022-12-05','2023-12-05','Former','Household','4','');
INSERT INTO "Contact" VALUES(48,'False','Anthony','2022-08-28','False','False','Nielsen','2022-08-28','2023-08-28','Renewal','Corporate','7','');
INSERT INTO "Contact" VALUES(49,'False','William','2022-09-05','False','False','Frost','2022-09-05','2023-09-05','Lapsed','Corporate','8','');
INSERT INTO "Contact" VALUES(50,'False','Ashley','2022-09-27','False','False','Trevino','2022-09-27','2023-09-27','Former','Household','9','');
INSERT INTO "Contact" VALUES(51,'False','Shane','2022-05-07','False','False','Fowler','2022-05-07','2023-05-07','Renewal','Individual','11','');
INSERT INTO "Contact" VALUES(52,'False','Dan','2022-07-06','False','False','Huff','2022-07-06','2023-07-06','Lapsed','Household','12','');
INSERT INTO "Contact" VALUES(53,'False','Yvonne','2022-12-21','False','False','Bryant','2022-12-21','2023-12-21','Lapsed','Corporate','13','');
INSERT INTO "Contact" VALUES(54,'False','Henry','2022-12-14','False','False','Acevedo','2022-12-14','2023-12-14','Former','Household','14','');
INSERT INTO "Contact" VALUES(55,'False','Michaela','2022-08-27','False','False','Buckley','2022-08-27','2023-08-27','Current','Individual','15','');
INSERT INTO "Contact" VALUES(56,'False','Bryce','2022-10-09','False','False','Ayers','2022-10-09','2023-10-09','Former','Corporate','16','');
INSERT INTO "Contact" VALUES(57,'False','Howard','2022-08-17','False','False','Cantu','2022-08-17','2023-08-17','Renewal','Household','17','');
INSERT INTO "Contact" VALUES(58,'False','Ryan','2022-06-12','False','False','Miles','2022-06-12','2023-06-12','Current','Corporate','18','');
INSERT INTO "Contact" VALUES(59,'False','Clarence','2022-05-15','False','False','Schmitt','2022-05-15','2023-05-15','Lapsed','Corporate','19','');
INSERT INTO "Contact" VALUES(60,'False','Bill','2023-02-10','False','False','Booker','2023-02-10','2024-02-10','Former','Individual','20','');
INSERT INTO "Contact" VALUES(61,'False','Suzanne','2022-07-23','False','False','Gibson','2022-07-23','2023-07-23','Current','Household','41','');
INSERT INTO "Contact" VALUES(62,'False','Monica','2022-05-01','False','False','Sosa','2022-05-01','2023-05-01','Lapsed','Household','42','');
INSERT INTO "Contact" VALUES(63,'False','Wesley','2022-10-14','False','False','Camacho','2022-10-14','2023-10-14','Former','Household','43','');
INSERT INTO "Contact" VALUES(64,'False','Eric','2022-10-06','False','False','Moses','2022-10-06','2023-10-06','Current','Household','44','');
INSERT INTO "Contact" VALUES(65,'False','Joanne','2022-06-26','False','False','Mack','2022-06-26','2023-06-26','Renewal','Individual','45','');
INSERT INTO "Contact" VALUES(66,'False','Maurice','2022-12-16','False','False','Fitzpatrick','2022-12-16','2023-12-16','Former','Corporate','46','');
INSERT INTO "Contact" VALUES(67,'False','Jody','2022-07-27','False','False','Gregory','2022-07-27','2023-07-27','Renewal','Individual','47','');
INSERT INTO "Contact" VALUES(68,'False','Oscar','2022-11-25','False','False','Crosby','2022-11-25','2023-11-25','Renewal','Individual','48','');
INSERT INTO "Contact" VALUES(69,'False','Terrance','2022-11-15','False','False','Vega','2022-11-15','2023-11-15','Former','Household','49','');
INSERT INTO "Contact" VALUES(70,'False','Rick','2022-08-24','False','False','Mccall','2022-08-24','2023-08-24','Renewal','Household','50','');
INSERT INTO "Contact" VALUES(71,'False','Dakota','2023-01-19','False','False','Manning','2023-01-19','2024-01-19','Lapsed','Corporate','92','');
INSERT INTO "Contact" VALUES(72,'False','Stacey','2022-04-22','False','False','Cooke','2022-04-22','2023-04-22','Lapsed','Household','93','');
INSERT INTO "Contact" VALUES(73,'False','Mia','2023-02-19','False','False','Holland','2023-02-19','2024-02-19','Renewal','Corporate','94','');
INSERT INTO "Contact" VALUES(74,'False','Justin','2023-02-04','False','False','Davenport','2023-02-04','2024-02-04','Lapsed','Individual','95','');
INSERT INTO "Contact" VALUES(75,'False','Mckenzie','2022-11-26','False','False','Woodward','2022-11-26','2023-11-26','Lapsed','Household','96','');
INSERT INTO "Contact" VALUES(76,'False','Carrie','2022-07-09','False','False','Williams','2022-07-09','2023-07-09','Former','Individual','97','');
INSERT INTO "Contact" VALUES(77,'False','Larry','2022-09-23','False','False','Clayton','2022-09-23','2023-09-23','Lapsed','Corporate','98','');
INSERT INTO "Contact" VALUES(78,'False','Martin','2022-12-04','False','False','Baker','2022-12-04','2023-12-04','Lapsed','Household','99','');
INSERT INTO "Contact" VALUES(79,'False','Carmen','2022-12-31','False','False','Hayden','2022-12-31','2023-12-31','Renewal','Individual','100','');
INSERT INTO "Contact" VALUES(80,'False','Bryan','2022-04-03','False','False','Fields','2022-04-03','2023-04-03','Lapsed','Corporate','101','');
INSERT INTO "Contact" VALUES(81,'False','Kirsten','2022-08-07','False','False','Ritter','2022-08-07','2023-08-07','Renewal','Individual','21','');
INSERT INTO "Contact" VALUES(82,'False','Kristine','2022-06-04','False','False','Mcgrath','2022-06-04','2023-06-04','Current','Individual','22','');
INSERT INTO "Contact" VALUES(83,'False','Pedro','2022-10-25','False','False','Levine','2022-10-25','2023-10-25','Lapsed','Corporate','23','');
INSERT INTO "Contact" VALUES(84,'False','Bill','2022-10-04','False','False','Watkins','2022-10-04','2023-10-04','Renewal','Household','24','');
INSERT INTO "Contact" VALUES(85,'False','Ronnie','2022-07-04','False','False','Glover','2022-07-04','2023-07-04','Current','Corporate','25','');
INSERT INTO "Contact" VALUES(86,'False','Belinda','2022-08-29','False','False','Benjamin','2022-08-29','2023-08-29','Renewal','Corporate','26','');
INSERT INTO "Contact" VALUES(87,'False','Sandy','2022-06-03','False','False','Mayer','2022-06-03','2023-06-03','Renewal','Corporate','27','');
INSERT INTO "Contact" VALUES(88,'False','Molly','2022-09-15','False','False','Powell','2022-09-15','2023-09-15','Lapsed','Corporate','28','');
INSERT INTO "Contact" VALUES(89,'False','Sheryl','2022-11-28','False','False','Schwartz','2022-11-28','2023-11-28','Renewal','Household','29','');
INSERT INTO "Contact" VALUES(90,'False','Rebecca','2022-12-04','False','False','Adams','2022-12-04','2023-12-04','Lapsed','Household','30','');
INSERT INTO "Contact" VALUES(91,'False','Sonia','2023-03-25','False','False','Mathis','2023-03-25','2024-03-25','Renewal','Individual','81','');
INSERT INTO "Contact" VALUES(92,'False','Jerome','2022-09-24','False','False','Lloyd','2022-09-24','2023-09-24','Former','Household','72','');
INSERT INTO "Contact" VALUES(93,'False','Samantha','2022-05-01','False','False','Mcintyre','2022-05-01','2023-05-01','Current','Individual','73','');
INSERT INTO "Contact" VALUES(94,'False','Jesse','2022-04-28','False','False','Wall','2022-04-28','2023-04-28','Renewal','Corporate','74','');
INSERT INTO "Contact" VALUES(95,'False','Kaitlyn','2022-06-19','False','False','Raymond','2022-06-19','2023-06-19','Current','Individual','75','');
INSERT INTO "Contact" VALUES(96,'False','Raven','2022-09-15','False','False','Woodard','2022-09-15','2023-09-15','Current','Individual','76','');
INSERT INTO "Contact" VALUES(97,'False','Stacie','2022-06-18','False','False','Carney','2022-06-18','2023-06-18','Lapsed','Corporate','77','');
INSERT INTO "Contact" VALUES(98,'False','Judy','2022-03-29','False','False','Kaiser','2022-03-29','2023-03-29','Lapsed','Household','78','');
INSERT INTO "Contact" VALUES(99,'False','Crystal','2022-03-30','False','False','Jackson','2022-03-30','2023-03-30','Renewal','Household','79','');
INSERT INTO "Contact" VALUES(100,'False','Ethan','2022-08-30','False','False','Wiggins','2022-08-30','2023-08-30','Current','Individual','80','');
CREATE TABLE "Membership_Contact_Role__c" (
	id INTEGER NOT NULL, 
	"Does_Not_Expire__c" VARCHAR(255), 
	"End_Date__c" VARCHAR(255), 
	"Is_Primary__c" VARCHAR(255), 
	"Name" VARCHAR(255), 
	"Role__c" VARCHAR(255), 
	"Start_Date__c" VARCHAR(255), 
	"Status__c" VARCHAR(255), 
	"Type__c" VARCHAR(255), 
	"Contact__c" VARCHAR(255), 
	"Membership__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Membership_Contact_Role__c" VALUES(1,'False','','True','Primary Member','','2023-03-29','','','1','1');
INSERT INTO "Membership_Contact_Role__c" VALUES(2,'False','','True','Primary Member','','2023-03-29','','','2','2');
INSERT INTO "Membership_Contact_Role__c" VALUES(3,'False','','True','Primary Member','','2023-03-29','','','3','3');
INSERT INTO "Membership_Contact_Role__c" VALUES(4,'False','','True','Primary Member','','2023-03-29','','','4','4');
INSERT INTO "Membership_Contact_Role__c" VALUES(5,'False','','True','Primary Member','','2023-03-29','','','5','5');
INSERT INTO "Membership_Contact_Role__c" VALUES(6,'False','','True','Primary Member','','2023-03-29','','','6','6');
INSERT INTO "Membership_Contact_Role__c" VALUES(7,'False','','True','Primary Member','','2023-03-29','','','7','7');
INSERT INTO "Membership_Contact_Role__c" VALUES(8,'False','','True','Primary Member','','2023-03-29','','','8','8');
INSERT INTO "Membership_Contact_Role__c" VALUES(9,'False','','True','Primary Member','','2023-03-29','','','9','9');
INSERT INTO "Membership_Contact_Role__c" VALUES(10,'False','','True','Primary Member','','2023-03-29','','','10','10');
INSERT INTO "Membership_Contact_Role__c" VALUES(11,'False','','True','Primary Member','','2023-03-29','','','61','23');
INSERT INTO "Membership_Contact_Role__c" VALUES(12,'False','','True','Primary Member','','2023-03-29','','','62','24');
INSERT INTO "Membership_Contact_Role__c" VALUES(13,'False','','True','Primary Member','','2023-03-29','','','63','25');
INSERT INTO "Membership_Contact_Role__c" VALUES(14,'False','','True','Primary Member','','2023-03-29','','','64','26');
INSERT INTO "Membership_Contact_Role__c" VALUES(15,'False','','True','Primary Member','','2023-03-29','','','65','27');
INSERT INTO "Membership_Contact_Role__c" VALUES(16,'False','','True','Primary Member','','2023-03-29','','','66','28');
INSERT INTO "Membership_Contact_Role__c" VALUES(17,'False','','True','Primary Member','','2023-03-29','','','67','29');
INSERT INTO "Membership_Contact_Role__c" VALUES(18,'False','','True','Primary Member','','2023-03-29','','','68','30');
INSERT INTO "Membership_Contact_Role__c" VALUES(19,'False','','True','Primary Member','','2023-03-29','','','69','11');
INSERT INTO "Membership_Contact_Role__c" VALUES(20,'False','','True','Primary Member','','2023-03-29','','','70','12');
INSERT INTO "Membership_Contact_Role__c" VALUES(21,'False','','True','Primary Member','','2023-03-29','','','11','13');
INSERT INTO "Membership_Contact_Role__c" VALUES(22,'False','','True','Primary Member','','2023-03-29','','','12','14');
INSERT INTO "Membership_Contact_Role__c" VALUES(23,'False','','True','Primary Member','','2023-03-29','','','13','15');
INSERT INTO "Membership_Contact_Role__c" VALUES(24,'False','','True','Primary Member','','2023-03-29','','','14','16');
INSERT INTO "Membership_Contact_Role__c" VALUES(25,'False','','True','Primary Member','','2023-03-29','','','15','17');
INSERT INTO "Membership_Contact_Role__c" VALUES(26,'False','','True','Primary Member','','2023-03-29','','','16','18');
INSERT INTO "Membership_Contact_Role__c" VALUES(27,'False','','True','Primary Member','','2023-03-29','','','17','19');
INSERT INTO "Membership_Contact_Role__c" VALUES(28,'False','','True','Primary Member','','2023-03-29','','','18','20');
INSERT INTO "Membership_Contact_Role__c" VALUES(29,'False','','True','Primary Member','','2023-03-29','','','19','21');
INSERT INTO "Membership_Contact_Role__c" VALUES(30,'False','','True','Primary Member','','2023-03-29','','','20','22');
INSERT INTO "Membership_Contact_Role__c" VALUES(31,'False','','True','Primary Member','','2023-03-29','','','41','31');
INSERT INTO "Membership_Contact_Role__c" VALUES(32,'False','','True','Primary Member','','2023-03-29','','','42','32');
INSERT INTO "Membership_Contact_Role__c" VALUES(33,'False','','True','Primary Member','','2023-03-29','','','43','33');
INSERT INTO "Membership_Contact_Role__c" VALUES(34,'False','','True','Primary Member','','2023-03-29','','','44','34');
INSERT INTO "Membership_Contact_Role__c" VALUES(35,'False','','True','Primary Member','','2023-03-29','','','45','35');
INSERT INTO "Membership_Contact_Role__c" VALUES(36,'False','','True','Primary Member','','2023-03-29','','','46','36');
INSERT INTO "Membership_Contact_Role__c" VALUES(37,'False','','True','Primary Member','','2023-03-29','','','47','37');
INSERT INTO "Membership_Contact_Role__c" VALUES(38,'False','','True','Primary Member','','2023-03-29','','','48','38');
INSERT INTO "Membership_Contact_Role__c" VALUES(39,'False','','True','Primary Member','','2023-03-29','','','49','39');
INSERT INTO "Membership_Contact_Role__c" VALUES(40,'False','','True','Primary Member','','2023-03-29','','','50','40');
INSERT INTO "Membership_Contact_Role__c" VALUES(41,'False','','True','Primary Member','','2023-03-29','','','91','41');
INSERT INTO "Membership_Contact_Role__c" VALUES(42,'False','','True','Primary Member','','2023-03-29','','','92','42');
INSERT INTO "Membership_Contact_Role__c" VALUES(43,'False','','True','Primary Member','','2023-03-29','','','93','43');
INSERT INTO "Membership_Contact_Role__c" VALUES(44,'False','','True','Primary Member','','2023-03-29','','','94','44');
INSERT INTO "Membership_Contact_Role__c" VALUES(45,'False','','True','Primary Member','','2023-03-29','','','95','45');
INSERT INTO "Membership_Contact_Role__c" VALUES(46,'False','','True','Primary Member','','2023-03-29','','','96','46');
INSERT INTO "Membership_Contact_Role__c" VALUES(47,'False','','True','Primary Member','','2023-03-29','','','97','47');
INSERT INTO "Membership_Contact_Role__c" VALUES(48,'False','','True','Primary Member','','2023-03-29','','','98','48');
INSERT INTO "Membership_Contact_Role__c" VALUES(49,'False','','True','Primary Member','','2023-03-29','','','99','49');
INSERT INTO "Membership_Contact_Role__c" VALUES(50,'False','','True','Primary Member','','2023-03-29','','','100','50');
INSERT INTO "Membership_Contact_Role__c" VALUES(51,'False','','True','Primary Member','','2023-03-29','','','31','51');
INSERT INTO "Membership_Contact_Role__c" VALUES(52,'False','','True','Primary Member','','2023-03-29','','','32','52');
INSERT INTO "Membership_Contact_Role__c" VALUES(53,'False','','True','Primary Member','','2023-03-29','','','33','53');
INSERT INTO "Membership_Contact_Role__c" VALUES(54,'False','','True','Primary Member','','2023-03-29','','','34','54');
INSERT INTO "Membership_Contact_Role__c" VALUES(55,'False','','True','Primary Member','','2023-03-29','','','35','55');
INSERT INTO "Membership_Contact_Role__c" VALUES(56,'False','','True','Primary Member','','2023-03-29','','','36','56');
INSERT INTO "Membership_Contact_Role__c" VALUES(57,'False','','True','Primary Member','','2023-03-29','','','37','57');
INSERT INTO "Membership_Contact_Role__c" VALUES(58,'False','','True','Primary Member','','2023-03-29','','','38','58');
INSERT INTO "Membership_Contact_Role__c" VALUES(59,'False','','True','Primary Member','','2023-03-29','','','39','59');
INSERT INTO "Membership_Contact_Role__c" VALUES(60,'False','','True','Primary Member','','2023-03-29','','','40','60');
INSERT INTO "Membership_Contact_Role__c" VALUES(61,'False','','True','Primary Member','','2023-03-29','','','71','61');
INSERT INTO "Membership_Contact_Role__c" VALUES(62,'False','','True','Primary Member','','2023-03-29','','','72','62');
INSERT INTO "Membership_Contact_Role__c" VALUES(63,'False','','True','Primary Member','','2023-03-29','','','73','63');
INSERT INTO "Membership_Contact_Role__c" VALUES(64,'False','','True','Primary Member','','2023-03-29','','','74','64');
INSERT INTO "Membership_Contact_Role__c" VALUES(65,'False','','True','Primary Member','','2023-03-29','','','75','65');
INSERT INTO "Membership_Contact_Role__c" VALUES(66,'False','','True','Primary Member','','2023-03-29','','','76','66');
INSERT INTO "Membership_Contact_Role__c" VALUES(67,'False','','True','Primary Member','','2023-03-29','','','77','67');
INSERT INTO "Membership_Contact_Role__c" VALUES(68,'False','','True','Primary Member','','2023-03-29','','','78','68');
INSERT INTO "Membership_Contact_Role__c" VALUES(69,'False','','True','Primary Member','','2023-03-29','','','79','69');
INSERT INTO "Membership_Contact_Role__c" VALUES(70,'False','','True','Primary Member','','2023-03-29','','','80','70');
INSERT INTO "Membership_Contact_Role__c" VALUES(71,'False','','True','Primary Member','','2023-03-29','','','51','71');
INSERT INTO "Membership_Contact_Role__c" VALUES(72,'False','','True','Primary Member','','2023-03-29','','','52','72');
INSERT INTO "Membership_Contact_Role__c" VALUES(73,'False','','True','Primary Member','','2023-03-29','','','53','73');
INSERT INTO "Membership_Contact_Role__c" VALUES(74,'False','','True','Primary Member','','2023-03-29','','','54','74');
INSERT INTO "Membership_Contact_Role__c" VALUES(75,'False','','True','Primary Member','','2023-03-29','','','55','75');
INSERT INTO "Membership_Contact_Role__c" VALUES(76,'False','','True','Primary Member','','2023-03-29','','','56','76');
INSERT INTO "Membership_Contact_Role__c" VALUES(77,'False','','True','Primary Member','','2023-03-29','','','57','77');
INSERT INTO "Membership_Contact_Role__c" VALUES(78,'False','','True','Primary Member','','2023-03-29','','','58','78');
INSERT INTO "Membership_Contact_Role__c" VALUES(79,'False','','True','Primary Member','','2023-03-29','','','59','79');
INSERT INTO "Membership_Contact_Role__c" VALUES(80,'False','','True','Primary Member','','2023-03-29','','','60','80');
INSERT INTO "Membership_Contact_Role__c" VALUES(81,'False','','True','Primary Member','','2023-03-29','','','21','81');
INSERT INTO "Membership_Contact_Role__c" VALUES(82,'False','','True','Primary Member','','2023-03-29','','','22','82');
INSERT INTO "Membership_Contact_Role__c" VALUES(83,'False','','True','Primary Member','','2023-03-29','','','23','83');
INSERT INTO "Membership_Contact_Role__c" VALUES(84,'False','','True','Primary Member','','2023-03-29','','','24','84');
INSERT INTO "Membership_Contact_Role__c" VALUES(85,'False','','True','Primary Member','','2023-03-29','','','25','85');
INSERT INTO "Membership_Contact_Role__c" VALUES(86,'False','','True','Primary Member','','2023-03-29','','','26','86');
INSERT INTO "Membership_Contact_Role__c" VALUES(87,'False','','True','Primary Member','','2023-03-29','','','27','87');
INSERT INTO "Membership_Contact_Role__c" VALUES(88,'False','','True','Primary Member','','2023-03-29','','','28','88');
INSERT INTO "Membership_Contact_Role__c" VALUES(89,'False','','True','Primary Member','','2023-03-29','','','29','89');
INSERT INTO "Membership_Contact_Role__c" VALUES(90,'False','','True','Primary Member','','2023-03-29','','','30','90');
INSERT INTO "Membership_Contact_Role__c" VALUES(91,'False','','True','Primary Member','','2023-03-29','','','81','91');
INSERT INTO "Membership_Contact_Role__c" VALUES(92,'False','','True','Primary Member','','2023-03-29','','','82','92');
INSERT INTO "Membership_Contact_Role__c" VALUES(93,'False','','True','Primary Member','','2023-03-29','','','83','93');
INSERT INTO "Membership_Contact_Role__c" VALUES(94,'False','','True','Primary Member','','2023-03-29','','','84','94');
INSERT INTO "Membership_Contact_Role__c" VALUES(95,'False','','True','Primary Member','','2023-03-29','','','85','95');
INSERT INTO "Membership_Contact_Role__c" VALUES(96,'False','','True','Primary Member','','2023-03-29','','','86','96');
INSERT INTO "Membership_Contact_Role__c" VALUES(97,'False','','True','Primary Member','','2023-03-29','','','87','97');
INSERT INTO "Membership_Contact_Role__c" VALUES(98,'False','','True','Primary Member','','2023-03-29','','','88','98');
INSERT INTO "Membership_Contact_Role__c" VALUES(99,'False','','True','Primary Member','','2023-03-29','','','89','99');
INSERT INTO "Membership_Contact_Role__c" VALUES(100,'False','','True','Primary Member','','2023-03-29','','','90','100');
CREATE TABLE "Membership__c" (
	id INTEGER NOT NULL, 
	"Does_Not_Expire__c" VARCHAR(255), 
	"End_Date__c" VARCHAR(255), 
	"Name" VARCHAR(255), 
	"Origin__c" VARCHAR(255), 
	"Primary__c" VARCHAR(255), 
	"Start_Date__c" VARCHAR(255), 
	"Status__c" VARCHAR(255), 
	"Type__c" VARCHAR(255), 
	"Account__c" VARCHAR(255), 
	"Opportunity__c" VARCHAR(255), 
	"Primary_Contact__c" VARCHAR(255), 
	"Product__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Membership__c" VALUES(1,'False','2024-01-06','Calvin Forbes Household-Household Membership','Renewed','True','2023-01-06','Renewal','Household','31','51','1','2');
INSERT INTO "Membership__c" VALUES(2,'False','2023-09-29','Rivas LLC-Corporate Membership','New','True','2022-09-29','Lapsed','Corporate','32','52','2','3');
INSERT INTO "Membership__c" VALUES(3,'False','2023-12-07','Shawna Buck Household-Household Membership','Renewed','True','2022-12-07','Lapsed','Household','33','53','3','2');
INSERT INTO "Membership__c" VALUES(4,'False','2023-12-14','Mays, Ball and Horn-Corporate Membership','Reacquired','True','2022-12-14','Former','Corporate','34','54','4','3');
INSERT INTO "Membership__c" VALUES(5,'False','2023-03-29','Karina Sellers Household-Household Membership','Reacquired','True','2022-03-29','Former','Household','35','55','5','2');
INSERT INTO "Membership__c" VALUES(6,'False','2024-01-17','Day, Gardner and Miranda-Corporate Membership','Renewed','True','2023-01-17','Renewal','Corporate','36','56','6','3');
INSERT INTO "Membership__c" VALUES(7,'False','2023-05-07','Cheyenne Robles Household-Individual Membership','Reacquired','True','2022-05-07','Current','Individual','37','57','7','1');
INSERT INTO "Membership__c" VALUES(8,'False','2023-09-26','Vicki Keith Household-Household Membership','Reacquired','True','2022-09-26','Former','Household','38','58','8','2');
INSERT INTO "Membership__c" VALUES(9,'False','2023-06-15','Odom-Miles-Corporate Membership','New','True','2022-06-15','Renewal','Corporate','39','59','9','3');
INSERT INTO "Membership__c" VALUES(10,'False','2024-01-19','Norma Gomez Household-Individual Membership','Reacquired','True','2023-01-19','Lapsed','Individual','40','60','10','1');
INSERT INTO "Membership__c" VALUES(11,'False','2023-11-15','Terrance Vega Household-Household Membership','Reacquired','True','2022-11-15','Current','Household','49','9','69','2');
INSERT INTO "Membership__c" VALUES(12,'False','2023-08-24','Rick Mccall Household-Household Membership','Reacquired','True','2022-08-24','Lapsed','Household','50','10','70','2');
INSERT INTO "Membership__c" VALUES(13,'False','2023-08-29','Wheeler LLC-Corporate Membership','New','True','2022-08-29','Renewal','Corporate','82','91','11','3');
INSERT INTO "Membership__c" VALUES(14,'False','2023-06-12','Jane Marshall Household-Household Membership','Renewed','True','2022-06-12','Renewal','Household','83','92','12','2');
INSERT INTO "Membership__c" VALUES(15,'False','2024-01-17','Brandon Kramer Household-Individual Membership','New','True','2023-01-17','Current','Individual','84','93','13','1');
INSERT INTO "Membership__c" VALUES(16,'False','2024-02-01','Ferguson-Stephens-Corporate Membership','Renewed','True','2023-02-01','Renewal','Corporate','85','94','14','3');
INSERT INTO "Membership__c" VALUES(17,'False','2024-02-02','Carol Bolton Household-Individual Membership','Renewed','True','2023-02-02','Lapsed','Individual','86','95','15','1');
INSERT INTO "Membership__c" VALUES(18,'False','2023-04-01','Wanda Gray Household-Individual Membership','Renewed','True','2022-04-01','Renewal','Individual','87','96','16','1');
INSERT INTO "Membership__c" VALUES(19,'False','2023-04-10','Bianca Navarro Household-Individual Membership','Reacquired','True','2022-04-10','Renewal','Individual','88','97','17','1');
INSERT INTO "Membership__c" VALUES(20,'False','2023-04-30','Allison Hogan Household-Individual Membership','Renewed','True','2022-04-30','Lapsed','Individual','89','98','18','1');
INSERT INTO "Membership__c" VALUES(21,'False','2024-02-01','Lin, Robbins and Whitaker-Corporate Membership','Reacquired','True','2023-02-01','Renewal','Corporate','90','99','19','3');
INSERT INTO "Membership__c" VALUES(22,'False','2024-03-12','Bonnie Pham Household-Household Membership','Renewed','True','2023-03-12','Renewal','Household','91','100','20','2');
INSERT INTO "Membership__c" VALUES(23,'False','2023-07-23','Suzanne Gibson Household-Household Membership','Reacquired','True','2022-07-23','Current','Household','41','1','61','2');
INSERT INTO "Membership__c" VALUES(24,'False','2023-05-01','Monica Sosa Household-Household Membership','Renewed','True','2022-05-01','Current','Household','42','2','62','2');
INSERT INTO "Membership__c" VALUES(25,'False','2023-10-14','Wesley Camacho Household-Household Membership','Renewed','True','2022-10-14','Renewal','Household','43','3','63','2');
INSERT INTO "Membership__c" VALUES(26,'False','2023-10-06','Eric Moses Household-Household Membership','Renewed','True','2022-10-06','Former','Household','44','4','64','2');
INSERT INTO "Membership__c" VALUES(27,'False','2023-06-26','Joanne Mack Household-Individual Membership','New','True','2022-06-26','Renewal','Individual','45','5','65','1');
INSERT INTO "Membership__c" VALUES(28,'False','2023-12-16','Hester and Sons-Corporate Membership','Reacquired','True','2022-12-16','Former','Corporate','46','6','66','3');
INSERT INTO "Membership__c" VALUES(29,'False','2023-07-27','Jody Gregory Household-Individual Membership','Renewed','True','2022-07-27','Former','Individual','47','7','67','1');
INSERT INTO "Membership__c" VALUES(30,'False','2023-11-25','Oscar Crosby Household-Individual Membership','New','True','2022-11-25','Former','Individual','48','8','68','1');
INSERT INTO "Membership__c" VALUES(31,'False','2023-06-28','Stanley-Best-Corporate Membership','New','True','2022-06-28','Former','Corporate','5','81','41','3');
INSERT INTO "Membership__c" VALUES(32,'False','2023-12-11','Isabella Middleton Household-Household Membership','Reacquired','True','2022-12-11','Current','Household','10','82','42','2');
INSERT INTO "Membership__c" VALUES(33,'False','2024-02-01','Colon-Cooke-Corporate Membership','New','True','2023-02-01','Renewal','Corporate','6','83','43','3');
INSERT INTO "Membership__c" VALUES(34,'False','2023-09-28','Levi Frost Household-Individual Membership','Reacquired','True','2022-09-28','Current','Individual','1','84','44','1');
INSERT INTO "Membership__c" VALUES(35,'False','2023-07-17','Perry Higgins Household-Individual Membership','Reacquired','True','2022-07-17','Lapsed','Individual','2','85','45','1');
INSERT INTO "Membership__c" VALUES(36,'False','2023-12-10','Crystal Farrell Household-Household Membership','New','True','2022-12-10','Current','Household','3','86','46','2');
INSERT INTO "Membership__c" VALUES(37,'False','2023-12-05','Ernest Shields Household-Household Membership','Reacquired','True','2022-12-05','Lapsed','Household','4','87','47','2');
INSERT INTO "Membership__c" VALUES(38,'False','2023-08-28','Palmer Ltd-Corporate Membership','Renewed','True','2022-08-28','Lapsed','Corporate','7','88','48','3');
INSERT INTO "Membership__c" VALUES(39,'False','2023-09-05','Mccall, Short and Short-Corporate Membership','New','True','2022-09-05','Former','Corporate','8','89','49','3');
INSERT INTO "Membership__c" VALUES(40,'False','2023-09-27','Ashley Trevino Household-Household Membership','Renewed','True','2022-09-27','Current','Household','9','90','50','2');
INSERT INTO "Membership__c" VALUES(41,'False','2024-03-25','Sonia Mathis Household-Individual Membership','New','True','2023-03-25','Renewal','Individual','81','21','91','1');
INSERT INTO "Membership__c" VALUES(42,'False','2023-09-24','Jerome Lloyd Household-Household Membership','Renewed','True','2022-09-24','Renewal','Household','72','22','92','2');
INSERT INTO "Membership__c" VALUES(43,'False','2023-05-01','Samantha Mcintyre Household-Individual Membership','Renewed','True','2022-05-01','Former','Individual','73','23','93','1');
INSERT INTO "Membership__c" VALUES(44,'False','2023-04-28','Stokes, Kirk and Figueroa-Corporate Membership','Renewed','True','2022-04-28','Former','Corporate','74','24','94','3');
INSERT INTO "Membership__c" VALUES(45,'False','2023-06-19','Kaitlyn Raymond Household-Individual Membership','Reacquired','True','2022-06-19','Lapsed','Individual','75','25','95','1');
INSERT INTO "Membership__c" VALUES(46,'False','2023-09-15','Raven Woodard Household-Individual Membership','New','True','2022-09-15','Lapsed','Individual','76','26','96','1');
INSERT INTO "Membership__c" VALUES(47,'False','2023-06-18','Hogan, Molina and Anthony-Corporate Membership','New','True','2022-06-18','Current','Corporate','77','27','97','3');
INSERT INTO "Membership__c" VALUES(48,'False','2023-03-29','Judy Kaiser Household-Household Membership','Renewed','True','2022-03-29','Renewal','Household','78','28','98','2');
INSERT INTO "Membership__c" VALUES(49,'False','2023-03-30','Crystal Jackson Household-Household Membership','Reacquired','True','2022-03-30','Renewal','Household','79','29','99','2');
INSERT INTO "Membership__c" VALUES(50,'False','2023-08-30','Ethan Wiggins Household-Individual Membership','Reacquired','True','2022-08-30','Lapsed','Individual','80','30','100','1');
INSERT INTO "Membership__c" VALUES(51,'False','2023-04-01','Kim Ferrell Household-Individual Membership','New','True','2022-04-01','Renewal','Individual','51','41','31','1');
INSERT INTO "Membership__c" VALUES(52,'False','2023-06-20','Karina Mora Household-Household Membership','Renewed','True','2022-06-20','Renewal','Household','52','42','32','2');
INSERT INTO "Membership__c" VALUES(53,'False','2023-12-25','Gregory Inc-Corporate Membership','Reacquired','True','2022-12-25','Lapsed','Corporate','53','43','33','3');
INSERT INTO "Membership__c" VALUES(54,'False','2023-05-12','Hammond, Wiggins and Odonnell-Corporate Membership','Renewed','True','2022-05-12','Former','Corporate','54','44','34','3');
INSERT INTO "Membership__c" VALUES(55,'False','2023-09-24','Manuel Dodson Household-Individual Membership','Reacquired','True','2022-09-24','Lapsed','Individual','55','45','35','1');
INSERT INTO "Membership__c" VALUES(56,'False','2023-05-25','Christie Reeves Household-Individual Membership','Reacquired','True','2022-05-25','Renewal','Individual','56','46','36','1');
INSERT INTO "Membership__c" VALUES(57,'False','2023-10-22','Ann Fowler Household-Individual Membership','Reacquired','True','2022-10-22','Lapsed','Individual','57','47','37','1');
INSERT INTO "Membership__c" VALUES(58,'False','2023-09-26','Kristen Hale Household-Individual Membership','New','True','2022-09-26','Renewal','Individual','58','48','38','1');
INSERT INTO "Membership__c" VALUES(59,'False','2023-10-21','Stanley Stein Household-Household Membership','Reacquired','True','2022-10-21','Lapsed','Household','59','49','39','2');
INSERT INTO "Membership__c" VALUES(60,'False','2023-06-05','Nixon Inc-Corporate Membership','New','True','2022-06-05','Lapsed','Corporate','60','50','40','3');
INSERT INTO "Membership__c" VALUES(61,'False','2024-01-19','Montes Group-Corporate Membership','Renewed','True','2023-01-19','Former','Corporate','92','31','71','3');
INSERT INTO "Membership__c" VALUES(62,'False','2023-04-22','Stacey Cooke Household-Household Membership','Renewed','True','2022-04-22','Current','Household','93','32','72','2');
INSERT INTO "Membership__c" VALUES(63,'False','2024-02-19','Bass Group-Corporate Membership','Renewed','True','2023-02-19','Lapsed','Corporate','94','33','73','3');
INSERT INTO "Membership__c" VALUES(64,'False','2024-02-04','Justin Davenport Household-Individual Membership','Reacquired','True','2023-02-04','Former','Individual','95','34','74','1');
INSERT INTO "Membership__c" VALUES(65,'False','2023-11-26','Mckenzie Woodward Household-Household Membership','Renewed','True','2022-11-26','Current','Household','96','35','75','2');
INSERT INTO "Membership__c" VALUES(66,'False','2023-07-09','Carrie Williams Household-Individual Membership','Renewed','True','2022-07-09','Current','Individual','97','36','76','1');
INSERT INTO "Membership__c" VALUES(67,'False','2023-09-23','Barajas Group-Corporate Membership','New','True','2022-09-23','Current','Corporate','98','37','77','3');
INSERT INTO "Membership__c" VALUES(68,'False','2023-12-04','Martin Baker Household-Household Membership','New','True','2022-12-04','Former','Household','99','38','78','2');
INSERT INTO "Membership__c" VALUES(69,'False','2023-12-31','Carmen Hayden Household-Individual Membership','Renewed','True','2022-12-31','Former','Individual','100','39','79','1');
INSERT INTO "Membership__c" VALUES(70,'False','2023-04-03','Kent LLC-Corporate Membership','New','True','2022-04-03','Former','Corporate','101','40','80','3');
INSERT INTO "Membership__c" VALUES(71,'False','2023-05-07','Shane Fowler Household-Individual Membership','Reacquired','True','2022-05-07','Current','Individual','11','71','51','1');
INSERT INTO "Membership__c" VALUES(72,'False','2023-07-06','Dan Huff Household-Household Membership','Renewed','True','2022-07-06','Renewal','Household','12','72','52','2');
INSERT INTO "Membership__c" VALUES(73,'False','2023-12-21','Burnett Inc-Corporate Membership','Renewed','True','2022-12-21','Lapsed','Corporate','13','73','53','3');
INSERT INTO "Membership__c" VALUES(74,'False','2023-12-14','Henry Acevedo Household-Household Membership','Renewed','True','2022-12-14','Renewal','Household','14','74','54','2');
INSERT INTO "Membership__c" VALUES(75,'False','2023-08-27','Michaela Buckley Household-Individual Membership','New','True','2022-08-27','Lapsed','Individual','15','75','55','1');
INSERT INTO "Membership__c" VALUES(76,'False','2023-10-09','Figueroa Inc-Corporate Membership','Reacquired','True','2022-10-09','Lapsed','Corporate','16','76','56','3');
INSERT INTO "Membership__c" VALUES(77,'False','2023-08-17','Howard Cantu Household-Household Membership','Renewed','True','2022-08-17','Renewal','Household','17','77','57','2');
INSERT INTO "Membership__c" VALUES(78,'False','2023-06-12','Cooley-Lynn-Corporate Membership','New','True','2022-06-12','Current','Corporate','18','78','58','3');
INSERT INTO "Membership__c" VALUES(79,'False','2023-05-15','Carlson, Robles and Stein-Corporate Membership','Reacquired','True','2022-05-15','Renewal','Corporate','19','79','59','3');
INSERT INTO "Membership__c" VALUES(80,'False','2024-02-10','Bill Booker Household-Individual Membership','Renewed','True','2023-02-10','Former','Individual','20','80','60','1');
INSERT INTO "Membership__c" VALUES(81,'False','2024-01-04','Leon Macias Household-Household Membership','Renewed','True','2023-01-04','Lapsed','Household','62','20','21','2');
INSERT INTO "Membership__c" VALUES(82,'False','2024-02-09','Stone and Sons-Corporate Membership','New','True','2023-02-09','Former','Corporate','63','11','22','3');
INSERT INTO "Membership__c" VALUES(83,'False','2023-05-22','Kristopher Cantu Household-Individual Membership','New','True','2022-05-22','Renewal','Individual','64','12','23','1');
INSERT INTO "Membership__c" VALUES(84,'False','2023-04-24','Rachael Dalton Household-Individual Membership','Renewed','True','2022-04-24','Lapsed','Individual','65','13','24','1');
INSERT INTO "Membership__c" VALUES(85,'False','2023-09-26','Jason Barr Household-Individual Membership','Reacquired','True','2022-09-26','Current','Individual','66','14','25','1');
INSERT INTO "Membership__c" VALUES(86,'False','2023-11-17','Selena Williams Household-Individual Membership','Renewed','True','2022-11-17','Lapsed','Individual','67','15','26','1');
INSERT INTO "Membership__c" VALUES(87,'False','2023-10-11','Sutton, Valentine and Dickson-Corporate Membership','Renewed','True','2022-10-11','Former','Corporate','68','16','27','3');
INSERT INTO "Membership__c" VALUES(88,'False','2023-08-26','Cole Cervantes Household-Household Membership','Reacquired','True','2022-08-26','Renewal','Household','69','17','28','2');
INSERT INTO "Membership__c" VALUES(89,'False','2023-07-07','Madden-Harrell-Corporate Membership','Reacquired','True','2022-07-07','Lapsed','Corporate','70','18','29','3');
INSERT INTO "Membership__c" VALUES(90,'False','2023-12-01','Frederick Cherry Household-Individual Membership','Renewed','True','2022-12-01','Lapsed','Individual','71','19','30','1');
INSERT INTO "Membership__c" VALUES(91,'False','2023-08-07','Kirsten Ritter Household-Individual Membership','Renewed','True','2022-08-07','Renewal','Individual','21','61','81','1');
INSERT INTO "Membership__c" VALUES(92,'False','2023-06-04','Kristine Mcgrath Household-Individual Membership','Renewed','True','2022-06-04','Current','Individual','22','62','82','1');
INSERT INTO "Membership__c" VALUES(93,'False','2023-10-25','Malone-Cardenas-Corporate Membership','Renewed','True','2022-10-25','Lapsed','Corporate','23','63','83','3');
INSERT INTO "Membership__c" VALUES(94,'False','2023-10-04','Bill Watkins Household-Household Membership','New','True','2022-10-04','Renewal','Household','24','64','84','2');
INSERT INTO "Membership__c" VALUES(95,'False','2023-07-04','Fleming-Barajas-Corporate Membership','Reacquired','True','2022-07-04','Current','Corporate','25','65','85','3');
INSERT INTO "Membership__c" VALUES(96,'False','2023-08-29','Mullins, Casey and Sheppard-Corporate Membership','New','True','2022-08-29','Lapsed','Corporate','26','66','86','3');
INSERT INTO "Membership__c" VALUES(97,'False','2023-06-03','Mooney, Simon and Jordan-Corporate Membership','Renewed','True','2022-06-03','Current','Corporate','27','67','87','3');
INSERT INTO "Membership__c" VALUES(98,'False','2023-09-15','Contreras Ltd-Corporate Membership','Reacquired','True','2022-09-15','Renewal','Corporate','28','68','88','3');
INSERT INTO "Membership__c" VALUES(99,'False','2023-11-28','Sheryl Schwartz Household-Household Membership','Renewed','True','2022-11-28','Former','Household','29','69','89','2');
INSERT INTO "Membership__c" VALUES(100,'False','2023-12-04','Rebecca Adams Household-Household Membership','New','True','2022-12-04','Renewal','Household','30','70','90','2');
CREATE TABLE "Opportunity" (
	id INTEGER NOT NULL, 
	"CloseDate" VARCHAR(255), 
	"IsPrivate" VARCHAR(255), 
	"Name" VARCHAR(255), 
	"StageName" VARCHAR(255), 
	"AccountId" VARCHAR(255), 
	"ContactId" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Opportunity" VALUES(1,'2022-07-23','False','Suzanne Gibson Household-Household-2022-07-23','Closed Won','41','');
INSERT INTO "Opportunity" VALUES(2,'2022-05-01','False','Monica Sosa Household-Household-2022-05-01','Closed Won','42','');
INSERT INTO "Opportunity" VALUES(3,'2022-10-14','False','Wesley Camacho Household-Household-2022-10-14','Closed Won','43','');
INSERT INTO "Opportunity" VALUES(4,'2022-10-06','False','Eric Moses Household-Household-2022-10-06','Closed Won','44','');
INSERT INTO "Opportunity" VALUES(5,'2022-06-26','False','Joanne Mack Household-Individual-2022-06-26','Closed Won','45','');
INSERT INTO "Opportunity" VALUES(6,'2022-12-16','False','Hester and Sons-Corporate-2022-12-16','Closed Won','46','');
INSERT INTO "Opportunity" VALUES(7,'2022-07-27','False','Jody Gregory Household-Individual-2022-07-27','Closed Won','47','');
INSERT INTO "Opportunity" VALUES(8,'2022-11-25','False','Oscar Crosby Household-Individual-2022-11-25','Closed Won','48','');
INSERT INTO "Opportunity" VALUES(9,'2022-11-15','False','Terrance Vega Household-Household-2022-11-15','Closed Won','49','');
INSERT INTO "Opportunity" VALUES(10,'2022-08-24','False','Rick Mccall Household-Household-2022-08-24','Closed Won','50','');
INSERT INTO "Opportunity" VALUES(11,'2023-02-09','False','Stone and Sons-Corporate-2023-02-09','Closed Won','63','');
INSERT INTO "Opportunity" VALUES(12,'2022-05-22','False','Kristopher Cantu Household-Individual-2022-05-22','Closed Won','64','');
INSERT INTO "Opportunity" VALUES(13,'2022-04-24','False','Rachael Dalton Household-Individual-2022-04-24','Closed Won','65','');
INSERT INTO "Opportunity" VALUES(14,'2022-09-26','False','Jason Barr Household-Individual-2022-09-26','Closed Won','66','');
INSERT INTO "Opportunity" VALUES(15,'2022-11-17','False','Selena Williams Household-Individual-2022-11-17','Closed Won','67','');
INSERT INTO "Opportunity" VALUES(16,'2022-10-11','False','Sutton, Valentine and Dickson-Corporate-2022-10-11','Closed Won','68','');
INSERT INTO "Opportunity" VALUES(17,'2022-08-26','False','Cole Cervantes Household-Household-2022-08-26','Closed Won','69','');
INSERT INTO "Opportunity" VALUES(18,'2022-07-07','False','Madden-Harrell-Corporate-2022-07-07','Closed Won','70','');
INSERT INTO "Opportunity" VALUES(19,'2022-12-01','False','Frederick Cherry Household-Individual-2022-12-01','Closed Won','71','');
INSERT INTO "Opportunity" VALUES(20,'2023-01-04','False','Leon Macias Household-Household-2023-01-04','Closed Won','62','');
INSERT INTO "Opportunity" VALUES(21,'2023-03-25','False','Sonia Mathis Household-Individual-2023-03-25','Closed Won','81','');
INSERT INTO "Opportunity" VALUES(22,'2022-09-24','False','Jerome Lloyd Household-Household-2022-09-24','Closed Won','72','');
INSERT INTO "Opportunity" VALUES(23,'2022-05-01','False','Samantha Mcintyre Household-Individual-2022-05-01','Closed Won','73','');
INSERT INTO "Opportunity" VALUES(24,'2022-04-28','False','Stokes, Kirk and Figueroa-Corporate-2022-04-28','Closed Won','74','');
INSERT INTO "Opportunity" VALUES(25,'2022-06-19','False','Kaitlyn Raymond Household-Individual-2022-06-19','Closed Won','75','');
INSERT INTO "Opportunity" VALUES(26,'2022-09-15','False','Raven Woodard Household-Individual-2022-09-15','Closed Won','76','');
INSERT INTO "Opportunity" VALUES(27,'2022-06-18','False','Hogan, Molina and Anthony-Corporate-2022-06-18','Closed Won','77','');
INSERT INTO "Opportunity" VALUES(28,'2022-03-29','False','Judy Kaiser Household-Household-2022-03-29','Closed Won','78','');
INSERT INTO "Opportunity" VALUES(29,'2022-03-30','False','Crystal Jackson Household-Household-2022-03-30','Closed Won','79','');
INSERT INTO "Opportunity" VALUES(30,'2022-08-30','False','Ethan Wiggins Household-Individual-2022-08-30','Closed Won','80','');
INSERT INTO "Opportunity" VALUES(31,'2023-01-19','False','Montes Group-Corporate-2023-01-19','Closed Won','92','');
INSERT INTO "Opportunity" VALUES(32,'2022-04-22','False','Stacey Cooke Household-Household-2022-04-22','Closed Won','93','');
INSERT INTO "Opportunity" VALUES(33,'2023-02-19','False','Bass Group-Corporate-2023-02-19','Closed Won','94','');
INSERT INTO "Opportunity" VALUES(34,'2023-02-04','False','Justin Davenport Household-Individual-2023-02-04','Closed Won','95','');
INSERT INTO "Opportunity" VALUES(35,'2022-11-26','False','Mckenzie Woodward Household-Household-2022-11-26','Closed Won','96','');
INSERT INTO "Opportunity" VALUES(36,'2022-07-09','False','Carrie Williams Household-Individual-2022-07-09','Closed Won','97','');
INSERT INTO "Opportunity" VALUES(37,'2022-09-23','False','Barajas Group-Corporate-2022-09-23','Closed Won','98','');
INSERT INTO "Opportunity" VALUES(38,'2022-12-04','False','Martin Baker Household-Household-2022-12-04','Closed Won','99','');
INSERT INTO "Opportunity" VALUES(39,'2022-12-31','False','Carmen Hayden Household-Individual-2022-12-31','Closed Won','100','');
INSERT INTO "Opportunity" VALUES(40,'2022-04-03','False','Kent LLC-Corporate-2022-04-03','Closed Won','101','');
INSERT INTO "Opportunity" VALUES(41,'2022-04-01','False','Kim Ferrell Household-Individual-2022-04-01','Closed Won','51','');
INSERT INTO "Opportunity" VALUES(42,'2022-06-20','False','Karina Mora Household-Household-2022-06-20','Closed Won','52','');
INSERT INTO "Opportunity" VALUES(43,'2022-12-25','False','Gregory Inc-Corporate-2022-12-25','Closed Won','53','');
INSERT INTO "Opportunity" VALUES(44,'2022-05-12','False','Hammond, Wiggins and Odonnell-Corporate-2022-05-12','Closed Won','54','');
INSERT INTO "Opportunity" VALUES(45,'2022-09-24','False','Manuel Dodson Household-Individual-2022-09-24','Closed Won','55','');
INSERT INTO "Opportunity" VALUES(46,'2022-05-25','False','Christie Reeves Household-Individual-2022-05-25','Closed Won','56','');
INSERT INTO "Opportunity" VALUES(47,'2022-10-22','False','Ann Fowler Household-Individual-2022-10-22','Closed Won','57','');
INSERT INTO "Opportunity" VALUES(48,'2022-09-26','False','Kristen Hale Household-Individual-2022-09-26','Closed Won','58','');
INSERT INTO "Opportunity" VALUES(49,'2022-10-21','False','Stanley Stein Household-Household-2022-10-21','Closed Won','59','');
INSERT INTO "Opportunity" VALUES(50,'2022-06-05','False','Nixon Inc-Corporate-2022-06-05','Closed Won','60','');
INSERT INTO "Opportunity" VALUES(51,'2023-01-06','False','Calvin Forbes Household-Household-2023-01-06','Closed Won','31','');
INSERT INTO "Opportunity" VALUES(52,'2022-09-29','False','Rivas LLC-Corporate-2022-09-29','Closed Won','32','');
INSERT INTO "Opportunity" VALUES(53,'2022-12-07','False','Shawna Buck Household-Household-2022-12-07','Closed Won','33','');
INSERT INTO "Opportunity" VALUES(54,'2022-12-14','False','Mays, Ball and Horn-Corporate-2022-12-14','Closed Won','34','');
INSERT INTO "Opportunity" VALUES(55,'2022-03-29','False','Karina Sellers Household-Household-2022-03-29','Closed Won','35','');
INSERT INTO "Opportunity" VALUES(56,'2023-01-17','False','Day, Gardner and Miranda-Corporate-2023-01-17','Closed Won','36','');
INSERT INTO "Opportunity" VALUES(57,'2022-05-07','False','Cheyenne Robles Household-Individual-2022-05-07','Closed Won','37','');
INSERT INTO "Opportunity" VALUES(58,'2022-09-26','False','Vicki Keith Household-Household-2022-09-26','Closed Won','38','');
INSERT INTO "Opportunity" VALUES(59,'2022-06-15','False','Odom-Miles-Corporate-2022-06-15','Closed Won','39','');
INSERT INTO "Opportunity" VALUES(60,'2023-01-19','False','Norma Gomez Household-Individual-2023-01-19','Closed Won','40','');
INSERT INTO "Opportunity" VALUES(61,'2022-08-07','False','Kirsten Ritter Household-Individual-2022-08-07','Closed Won','21','');
INSERT INTO "Opportunity" VALUES(62,'2022-06-04','False','Kristine Mcgrath Household-Individual-2022-06-04','Closed Won','22','');
INSERT INTO "Opportunity" VALUES(63,'2022-10-25','False','Malone-Cardenas-Corporate-2022-10-25','Closed Won','23','');
INSERT INTO "Opportunity" VALUES(64,'2022-10-04','False','Bill Watkins Household-Household-2022-10-04','Closed Won','24','');
INSERT INTO "Opportunity" VALUES(65,'2022-07-04','False','Fleming-Barajas-Corporate-2022-07-04','Closed Won','25','');
INSERT INTO "Opportunity" VALUES(66,'2022-08-29','False','Mullins, Casey and Sheppard-Corporate-2022-08-29','Closed Won','26','');
INSERT INTO "Opportunity" VALUES(67,'2022-06-03','False','Mooney, Simon and Jordan-Corporate-2022-06-03','Closed Won','27','');
INSERT INTO "Opportunity" VALUES(68,'2022-09-15','False','Contreras Ltd-Corporate-2022-09-15','Closed Won','28','');
INSERT INTO "Opportunity" VALUES(69,'2022-11-28','False','Sheryl Schwartz Household-Household-2022-11-28','Closed Won','29','');
INSERT INTO "Opportunity" VALUES(70,'2022-12-04','False','Rebecca Adams Household-Household-2022-12-04','Closed Won','30','');
INSERT INTO "Opportunity" VALUES(71,'2022-05-07','False','Shane Fowler Household-Individual-2022-05-07','Closed Won','11','');
INSERT INTO "Opportunity" VALUES(72,'2022-07-06','False','Dan Huff Household-Household-2022-07-06','Closed Won','12','');
INSERT INTO "Opportunity" VALUES(73,'2022-12-21','False','Burnett Inc-Corporate-2022-12-21','Closed Won','13','');
INSERT INTO "Opportunity" VALUES(74,'2022-12-14','False','Henry Acevedo Household-Household-2022-12-14','Closed Won','14','');
INSERT INTO "Opportunity" VALUES(75,'2022-08-27','False','Michaela Buckley Household-Individual-2022-08-27','Closed Won','15','');
INSERT INTO "Opportunity" VALUES(76,'2022-10-09','False','Figueroa Inc-Corporate-2022-10-09','Closed Won','16','');
INSERT INTO "Opportunity" VALUES(77,'2022-08-17','False','Howard Cantu Household-Household-2022-08-17','Closed Won','17','');
INSERT INTO "Opportunity" VALUES(78,'2022-06-12','False','Cooley-Lynn-Corporate-2022-06-12','Closed Won','18','');
INSERT INTO "Opportunity" VALUES(79,'2022-05-15','False','Carlson, Robles and Stein-Corporate-2022-05-15','Closed Won','19','');
INSERT INTO "Opportunity" VALUES(80,'2023-02-10','False','Bill Booker Household-Individual-2023-02-10','Closed Won','20','');
INSERT INTO "Opportunity" VALUES(81,'2022-06-28','False','Stanley-Best-Corporate-2022-06-28','Closed Won','5','');
INSERT INTO "Opportunity" VALUES(82,'2022-12-11','False','Isabella Middleton Household-Household-2022-12-11','Closed Won','10','');
INSERT INTO "Opportunity" VALUES(83,'2023-02-01','False','Colon-Cooke-Corporate-2023-02-01','Closed Won','6','');
INSERT INTO "Opportunity" VALUES(84,'2022-09-28','False','Levi Frost Household-Individual-2022-09-28','Closed Won','1','');
INSERT INTO "Opportunity" VALUES(85,'2022-07-17','False','Perry Higgins Household-Individual-2022-07-17','Closed Won','2','');
INSERT INTO "Opportunity" VALUES(86,'2022-12-10','False','Crystal Farrell Household-Household-2022-12-10','Closed Won','3','');
INSERT INTO "Opportunity" VALUES(87,'2022-12-05','False','Ernest Shields Household-Household-2022-12-05','Closed Won','4','');
INSERT INTO "Opportunity" VALUES(88,'2022-08-28','False','Palmer Ltd-Corporate-2022-08-28','Closed Won','7','');
INSERT INTO "Opportunity" VALUES(89,'2022-09-05','False','Mccall, Short and Short-Corporate-2022-09-05','Closed Won','8','');
INSERT INTO "Opportunity" VALUES(90,'2022-09-27','False','Ashley Trevino Household-Household-2022-09-27','Closed Won','9','');
INSERT INTO "Opportunity" VALUES(91,'2022-08-29','False','Wheeler LLC-Corporate-2022-08-29','Closed Won','82','');
INSERT INTO "Opportunity" VALUES(92,'2022-06-12','False','Jane Marshall Household-Household-2022-06-12','Closed Won','83','');
INSERT INTO "Opportunity" VALUES(93,'2023-01-17','False','Brandon Kramer Household-Individual-2023-01-17','Closed Won','84','');
INSERT INTO "Opportunity" VALUES(94,'2023-02-01','False','Ferguson-Stephens-Corporate-2023-02-01','Closed Won','85','');
INSERT INTO "Opportunity" VALUES(95,'2023-02-02','False','Carol Bolton Household-Individual-2023-02-02','Closed Won','86','');
INSERT INTO "Opportunity" VALUES(96,'2022-04-01','False','Wanda Gray Household-Individual-2022-04-01','Closed Won','87','');
INSERT INTO "Opportunity" VALUES(97,'2022-04-10','False','Bianca Navarro Household-Individual-2022-04-10','Closed Won','88','');
INSERT INTO "Opportunity" VALUES(98,'2022-04-30','False','Allison Hogan Household-Individual-2022-04-30','Closed Won','89','');
INSERT INTO "Opportunity" VALUES(99,'2023-02-01','False','Lin, Robbins and Whitaker-Corporate-2023-02-01','Closed Won','90','');
INSERT INTO "Opportunity" VALUES(100,'2023-03-12','False','Bonnie Pham Household-Household-2023-03-12','Closed Won','91','');
CREATE TABLE "OpportunityLineItem" (
	id INTEGER NOT NULL, 
	"Quantity" VARCHAR(255), 
	"Membership__c" VARCHAR(255), 
	"OpportunityId" VARCHAR(255), 
	"Product2Id" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "OpportunityLineItem" VALUES(1,'1.0','1','51','2');
INSERT INTO "OpportunityLineItem" VALUES(2,'1.0','2','52','3');
INSERT INTO "OpportunityLineItem" VALUES(3,'1.0','3','53','2');
INSERT INTO "OpportunityLineItem" VALUES(4,'1.0','4','54','3');
INSERT INTO "OpportunityLineItem" VALUES(5,'1.0','5','55','2');
INSERT INTO "OpportunityLineItem" VALUES(6,'1.0','6','56','3');
INSERT INTO "OpportunityLineItem" VALUES(7,'1.0','7','57','1');
INSERT INTO "OpportunityLineItem" VALUES(8,'1.0','8','58','2');
INSERT INTO "OpportunityLineItem" VALUES(9,'1.0','9','59','3');
INSERT INTO "OpportunityLineItem" VALUES(10,'1.0','10','60','1');
INSERT INTO "OpportunityLineItem" VALUES(11,'1.0','23','1','2');
INSERT INTO "OpportunityLineItem" VALUES(12,'1.0','24','2','2');
INSERT INTO "OpportunityLineItem" VALUES(13,'1.0','25','3','2');
INSERT INTO "OpportunityLineItem" VALUES(14,'1.0','26','4','2');
INSERT INTO "OpportunityLineItem" VALUES(15,'1.0','27','5','1');
INSERT INTO "OpportunityLineItem" VALUES(16,'1.0','28','6','3');
INSERT INTO "OpportunityLineItem" VALUES(17,'1.0','29','7','1');
INSERT INTO "OpportunityLineItem" VALUES(18,'1.0','30','8','1');
INSERT INTO "OpportunityLineItem" VALUES(19,'1.0','11','9','2');
INSERT INTO "OpportunityLineItem" VALUES(20,'1.0','12','10','2');
INSERT INTO "OpportunityLineItem" VALUES(21,'1.0','61','31','3');
INSERT INTO "OpportunityLineItem" VALUES(22,'1.0','62','32','2');
INSERT INTO "OpportunityLineItem" VALUES(23,'1.0','63','33','3');
INSERT INTO "OpportunityLineItem" VALUES(24,'1.0','64','34','1');
INSERT INTO "OpportunityLineItem" VALUES(25,'1.0','65','35','2');
INSERT INTO "OpportunityLineItem" VALUES(26,'1.0','66','36','1');
INSERT INTO "OpportunityLineItem" VALUES(27,'1.0','67','37','3');
INSERT INTO "OpportunityLineItem" VALUES(28,'1.0','68','38','2');
INSERT INTO "OpportunityLineItem" VALUES(29,'1.0','69','39','1');
INSERT INTO "OpportunityLineItem" VALUES(30,'1.0','70','40','3');
INSERT INTO "OpportunityLineItem" VALUES(31,'1.0','51','41','1');
INSERT INTO "OpportunityLineItem" VALUES(32,'1.0','52','42','2');
INSERT INTO "OpportunityLineItem" VALUES(33,'1.0','53','43','3');
INSERT INTO "OpportunityLineItem" VALUES(34,'1.0','54','44','3');
INSERT INTO "OpportunityLineItem" VALUES(35,'1.0','55','45','1');
INSERT INTO "OpportunityLineItem" VALUES(36,'1.0','56','46','1');
INSERT INTO "OpportunityLineItem" VALUES(37,'1.0','57','47','1');
INSERT INTO "OpportunityLineItem" VALUES(38,'1.0','58','48','1');
INSERT INTO "OpportunityLineItem" VALUES(39,'1.0','59','49','2');
INSERT INTO "OpportunityLineItem" VALUES(40,'1.0','60','50','3');
INSERT INTO "OpportunityLineItem" VALUES(41,'1.0','41','21','1');
INSERT INTO "OpportunityLineItem" VALUES(42,'1.0','42','22','2');
INSERT INTO "OpportunityLineItem" VALUES(43,'1.0','43','23','1');
INSERT INTO "OpportunityLineItem" VALUES(44,'1.0','44','24','3');
INSERT INTO "OpportunityLineItem" VALUES(45,'1.0','45','25','1');
INSERT INTO "OpportunityLineItem" VALUES(46,'1.0','46','26','1');
INSERT INTO "OpportunityLineItem" VALUES(47,'1.0','47','27','3');
INSERT INTO "OpportunityLineItem" VALUES(48,'1.0','48','28','2');
INSERT INTO "OpportunityLineItem" VALUES(49,'1.0','49','29','2');
INSERT INTO "OpportunityLineItem" VALUES(50,'1.0','50','30','1');
INSERT INTO "OpportunityLineItem" VALUES(51,'1.0','71','71','1');
INSERT INTO "OpportunityLineItem" VALUES(52,'1.0','72','72','2');
INSERT INTO "OpportunityLineItem" VALUES(53,'1.0','73','73','3');
INSERT INTO "OpportunityLineItem" VALUES(54,'1.0','74','74','2');
INSERT INTO "OpportunityLineItem" VALUES(55,'1.0','75','75','1');
INSERT INTO "OpportunityLineItem" VALUES(56,'1.0','76','76','3');
INSERT INTO "OpportunityLineItem" VALUES(57,'1.0','77','77','2');
INSERT INTO "OpportunityLineItem" VALUES(58,'1.0','78','78','3');
INSERT INTO "OpportunityLineItem" VALUES(59,'1.0','79','79','3');
INSERT INTO "OpportunityLineItem" VALUES(60,'1.0','80','80','1');
INSERT INTO "OpportunityLineItem" VALUES(61,'1.0','31','81','3');
INSERT INTO "OpportunityLineItem" VALUES(62,'1.0','32','82','2');
INSERT INTO "OpportunityLineItem" VALUES(63,'1.0','33','83','3');
INSERT INTO "OpportunityLineItem" VALUES(64,'1.0','34','84','1');
INSERT INTO "OpportunityLineItem" VALUES(65,'1.0','35','85','1');
INSERT INTO "OpportunityLineItem" VALUES(66,'1.0','36','86','2');
INSERT INTO "OpportunityLineItem" VALUES(67,'1.0','37','87','2');
INSERT INTO "OpportunityLineItem" VALUES(68,'1.0','38','88','3');
INSERT INTO "OpportunityLineItem" VALUES(69,'1.0','39','89','3');
INSERT INTO "OpportunityLineItem" VALUES(70,'1.0','40','90','2');
INSERT INTO "OpportunityLineItem" VALUES(71,'1.0','91','61','1');
INSERT INTO "OpportunityLineItem" VALUES(72,'1.0','92','62','1');
INSERT INTO "OpportunityLineItem" VALUES(73,'1.0','93','63','3');
INSERT INTO "OpportunityLineItem" VALUES(74,'1.0','94','64','2');
INSERT INTO "OpportunityLineItem" VALUES(75,'1.0','95','65','3');
INSERT INTO "OpportunityLineItem" VALUES(76,'1.0','96','66','3');
INSERT INTO "OpportunityLineItem" VALUES(77,'1.0','97','67','3');
INSERT INTO "OpportunityLineItem" VALUES(78,'1.0','98','68','3');
INSERT INTO "OpportunityLineItem" VALUES(79,'1.0','99','69','2');
INSERT INTO "OpportunityLineItem" VALUES(80,'1.0','100','70','2');
INSERT INTO "OpportunityLineItem" VALUES(81,'1.0','13','91','3');
INSERT INTO "OpportunityLineItem" VALUES(82,'1.0','14','92','2');
INSERT INTO "OpportunityLineItem" VALUES(83,'1.0','15','93','1');
INSERT INTO "OpportunityLineItem" VALUES(84,'1.0','16','94','3');
INSERT INTO "OpportunityLineItem" VALUES(85,'1.0','17','95','1');
INSERT INTO "OpportunityLineItem" VALUES(86,'1.0','18','96','1');
INSERT INTO "OpportunityLineItem" VALUES(87,'1.0','19','97','1');
INSERT INTO "OpportunityLineItem" VALUES(88,'1.0','20','98','1');
INSERT INTO "OpportunityLineItem" VALUES(89,'1.0','21','99','3');
INSERT INTO "OpportunityLineItem" VALUES(90,'1.0','22','100','2');
INSERT INTO "OpportunityLineItem" VALUES(91,'1.0','81','20','2');
INSERT INTO "OpportunityLineItem" VALUES(92,'1.0','82','11','3');
INSERT INTO "OpportunityLineItem" VALUES(93,'1.0','83','12','1');
INSERT INTO "OpportunityLineItem" VALUES(94,'1.0','84','13','1');
INSERT INTO "OpportunityLineItem" VALUES(95,'1.0','85','14','1');
INSERT INTO "OpportunityLineItem" VALUES(96,'1.0','86','15','1');
INSERT INTO "OpportunityLineItem" VALUES(97,'1.0','87','16','3');
INSERT INTO "OpportunityLineItem" VALUES(98,'1.0','88','17','2');
INSERT INTO "OpportunityLineItem" VALUES(99,'1.0','89','18','3');
INSERT INTO "OpportunityLineItem" VALUES(100,'1.0','90','19','1');
CREATE TABLE "Product2" (
	id INTEGER NOT NULL, 
	"IsActive" VARCHAR(255), 
	"IsSerialized" VARCHAR(255), 
	"Name" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Product2" VALUES(1,'False','False','Individual Membership');
INSERT INTO "Product2" VALUES(2,'False','False','Household Membership');
INSERT INTO "Product2" VALUES(3,'False','False','Corporate Membership');
COMMIT;

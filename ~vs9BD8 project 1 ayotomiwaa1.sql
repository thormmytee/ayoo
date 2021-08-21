-- am creating a database unionbank

CREATE DATABASE unionbank;
-- am using the unionbank database

USE unionbank;

---ill be creating  a schema for the table borrower and loan
CREATE SCHEMA borrower;
   GO
CREATE SCHEMA loan;
   GO
CREATE TABLE borrower.borrower
(borrowerid                INT IDENTITY NOT NULL, 
 borrowerfirstname         VARCHAR(225) NULL, 
 borrowermiddleinitialname CHAR(1) NOT NULL, 
 borrowerlastname          VARCHAR(225) NOT NULL, 
 dob                       DATE NOT NULL, 
 gender                    CHAR(1) NULL, 
 TaxPayerID_SSN            VARCHAR(9) NOT NULL, 
 PhoneNumber               VARCHAR(10) NOT NULL, 
 Email                     VARCHAR(255) NOT NULL, 
 Citizenship               VARCHAR(255) NULL, 
 BeneficiaryName           VARCHAR(255) NULL, 
 IsUScitizen               BIT NOT NULL, 
 CreateDate                DATETIME NOT NULL
);
CREATE TABLE BORROWER.BORROWERADDRESS
(ADDRESSID     INT NOT NULL, 
 BORROWERID    INT NOT NULL, 
 STREETADDRESS VARCHAR(255) NOT NULL, 
 ZIP           VARCHAR(5) NOT NULL, 
 CREATEDATE    DATETIME NOT NULL,
);
USE unionbank;
CREATE TABLE dbo.calendar(CalendarDate DATETIME NULL, );
CREATE TABLE DBO.State(StateID CHAR(2) NOT NULL, );
DROP TABLE DBO.State;
CREATE TABLE DBO.State
(StateID    CHAR(2) NOT NULL, 
 stateName  VARCHAR(255) NOT NULL, 
 CREATEDATE DATETIME NOT NULL,
);
CREATE TABLE DBO.US_ZIPCODES
(IsSurrogateKey   INT NOT NULL, 
 ZIP              VARCHAR(5) NOT NULL, 
 Latitude         FLOAT NULL, 
 Longitude        FLOAT NULL, 
 CITY             VARCHAR(255) NULL, 
 STATE_ID         CHAR(2) NULL, 
 population       INT NULL, 
 density          DECIMAL(18, 0) NULL, 
 county_fips      VARCHAR(10) NULL, 
 county_name      VARCHAR(255) NULL, 
 county_names_all VARCHAR(255) NULL, 
 county_fips_all  VARCHAR(50) NULL, 
 timezone         VARCHAR(255) NULL, 
 CreateDate       DATETIME NOT NULL,
);
CREATE TABLE LOAN.LOANSETUPINFORMATION
(IsSurrogateKey           INT NOT NULL, 
 LoanNumber               VARCHAR(10) NOT NULL, 
 PurchaseAmount           NUMERIC(18, 2) NOT NULL, 
 loanterm                 INT NOT NULL, 
 borrowerid               INT NOT NULL, 
 underwriterid            INT NOT NULL, 
 productid                CHAR(2) NOT NULL, 
 interestrate             DECIMAL(3, 2) NOT NULL, 
 paymentfrequency         INT NOT NULL, 
 appraisalvalue           NUMERIC(18, 2) NOT NULL, 
 createdate               DATETIME NOT NULL, 
 ltv                      DECIMAL(4, 2) NOT NULL, 
 firstinterestpaymentdate DATETIME NULL, 
 maturitydate             DATETIME NOT NULL
);
CREATE TABLE loan.loanperiodic
(Issurrogatekey           INT NOT NULL, 
 Loannumber               VARCHAR NOT NULL, 
 Cycledate                DATETIME NOT NULL, 
 Extramonthlypayment      NUMERIC(18, 2) NOT NULL, 
 Unpaidprincipalbalance   NUMERIC(18, 2) NOT NULL, 
 Beginningschedulebalance NUMERIC(18, 2) NOT NULL, 
 Paidinstallment          NUMERIC(18, 2) NOT NULL, 
 Interestportion          NUMERIC(18, 2) NOT NULL, 
 Principalportion         NUMERIC(18, 2) NOT NULL, 
 Endschedulebalance       NUMERIC(18, 2) NOT NULL, 
 Actualendschedulebalance NUMERIC(18, 2) NOT NULL, 
 Totalinterestaccrued     NUMERIC(18, 2) NOT NULL, 
 Totalprincipalaccrued    NUMERIC(18, 2) NOT NULL, 
 DEFAULTPENALTY           NUMERIC(18, 2) NOT NULL, 
 Delinquencycode          INT NOT NULL, 
 Createdate               DATETIME NOT NULL,
);
CREATE TABLE loan.LU_Delinquency
(DelinquencyCode INT NOT NULL, 
 Delinquency     VARCHAR(255) NOT NULL,
);
CREATE TABLE loan.LU_PaymentFrequency
(PaymentFrequency             INT NOT NULL, 
 PaymentIsMadeEvery           INT NOT NULL, 
 PaymentFrequency_Description VARCHAR(255) NOT NULL,
);
CREATE TABLE loan.Underwriter
(UnderwriterID            INT NOT NULL, 
 UnderwriterFirstName     VARCHAR(255) NULL, 
 UnderwriterMiddleInitial CHAR(1) NULL, 
 UnderwriterLastName      VARCHAR(255) NOT NULL, 
 PhoneNumber              VARCHAR(14) NULL, 
 Email                    VARCHAR(255) NOT NULL, 
 CreateDate               DATETIME NOT NULL,
);

----the company wants the age should be at least 18 year
--- so i will set a constraint to check for the age 

ALTER TABLE borrower.borrower
ADD CONSTRAINT CHK_borrower_DOB CHECK(DOB <= DATEADD(YEAR, -18, GETDATE()));
GO

-----the company want to make sure the phone digit is 10
------ so we add a check constraint for the borrower phone

ALTER TABLE BORROWER.BORROWER
ADD CONSTRAINT CHK_BORROWER_PhoneNumber CHECK(LEN(PHONENUMBER) = 10);

---- THE COMPANY WANTS THE TaxPayerID_SSN TO BE 9 DIGIT

ALTER TABLE BORROWER.BORROWER
ADD CONSTRAINT CHK_BORROWER_TaxPayerID_SSN CHECK(LEN(TaxPayerID_SSN) = 9);

--- IF NO DATE IS INSERTED GETDATE SHOULF BE INTRODUCED
ALTER TABLE BORROWER.BORROWER
ADD CONSTRAINT CHEK_BORROWER_CreateDate DEFAULT(GETDATE()) FOR CreateDate;

----Should be the UNIQUE IDENTIFIER OF A RECORD on this table.
-----A borrower Can only have one BorrowerID and a BorrowerID can only be assigned to ONE borrower
ALTER TABLE BORROWER.BORROWER
ADD CONSTRAINT PK_BORROWER_borrowerid PRIMARY KEY(BORROWERID);
ALTER TABLE BORROWER.BORROWERADDRESS
ADD CONSTRAINT PK_BORROWERADDRESS_BORROWERID PRIMARY KEY(BORROWERID);

---If no value is inserted, 
---then the Create date should default to the current time when the insertion is done 

ALTER TABLE BORROWER.BORROWERADDRESS
ADD CONSTRAINT CHEK_BORROWERADDRESS_CreateDate DEFAULT(GETDATE()) FOR CreateDate;

----This column should contain the same values as those in the BorrowerID of the Borrower table. 
----In essence, the BorrowerID in both tables should create a relationship in both tables.  

ALTER TABLE BORROWER.BORROWERADDRESS
ADD CONSTRAINT [FK_BORROWERADDRESS_BORROWER_BORROWERID] FOREIGN KEY(BORROWERID) REFERENCES BORROWER.BORROWER(BORROWERID);

----This column should contain the same values as those in the ZIP of the US_Zip_Codes table.
---In essence, the ZIP in both tables should create a relationship in both tables.

ALTER TABLE DBO.US_ZIPCODES
ADD CONSTRAINT PK_BORROWER_ZIP PRIMARY KEY(ZIP);
ALTER TABLE BORROWER.BORROWERADDRESS
ADD CONSTRAINT [FK_BORROWER.BORROWERADDRESS_ZIP] FOREIGN KEY(ZIP) REFERENCES DBO.US_ZIPCODES(ZIP);

-----This combination Should be the UNIQUE IDENTIFIER OF A RECORD on this table.  
--- I MADE BOTH AddressID and BorrowerID  A UNIQUE IDENTIFIER ON THE RECORD 

ALTER TABLE BORROWER.BORROWERADDRESS
ADD CONSTRAINT UC_BORROWERADDRESS_ADDRESSID UNIQUE(ADDRESSID);
ALTER TABLE BORROWER.BORROWERADDRESS
ADD CONSTRAINT UC_BORROWERADDRESS_BorrowerID UNIQUE(BorrowerID);

------(Interestportion+Principalportion) = Paidinstallment 

ALTER TABLE loan.loanperiodic
ADD CONSTRAINT CHK_LOANPERIODIC_Paidinstallment CHECK((Interestportion + Principalportion) = Paidinstallment);

------If no value is inserted, then the Create date should default to the current time when the insertion is done 

ALTER TABLE loan.loanperiodic
ADD CONSTRAINT CHEK_loanperiodic_CreateDate DEFAULT(GETDATE()) FOR CreateDate;

-----If no value is inserted, then the default value should be zero 

ALTER TABLE loan.loanperiodic
ADD CONSTRAINT CHEK_loanperiodic_Extramonthlypayment DEFAULT 0 FOR Extramonthlypayment;

----Is a foreign key referencing the the column LoanNumber in the  LoanSetupInformation Table 

ALTER TABLE loan.loanperiodic
ADD CONSTRAINT PK_loanperiodic_LoanNumber PRIMARY KEY(LOANNUMBER);
ALTER TABLE LOAN.LOANSETUPINFORMATION
ADD CONSTRAINT PK_LOANSETUPINFORMATION_LoanNumber PRIMARY KEY(LOANNUMBER);
ALTER TABLE loan.loanperiodic
ADD CONSTRAINT [FK_loan.loanperiodic_LOANNUMBER] FOREIGN KEY(LOANNUMBER) REFERENCES LOAN.LOANSETUPINFORMATION(LOANNUMBER);

------Is a foreign key referencing the the column DelinquencyCode in the  LU_delinquency Table  

ALTER TABLE loan.LU_Delinquency
ADD CONSTRAINT PK_LU_Delinquency_DelinquencyCode PRIMARY KEY(DelinquencyCode);
ALTER TABLE loan.loanperiodic
ADD CONSTRAINT [FK_LOANPEROIDIC_LU_delinquency Table_DelinquencyCode] FOREIGN KEY(DelinquencyCode) REFERENCES loan.LU_Delinquency(DelinquencyCode);

--------This combination Should be the UNIQUE IDENTIFIER OF A RECORD on this table.  
---- i made both loannumber and cycledate a unique constraint
ALTER TABLE loan.loanperiodic
ADD CONSTRAINT PKLOANPERIODIC_loannumber_cycledate PRIMARY KEY(loannumber, cycledate);
;------This column should only take the values 35, 30, 15 and 10 
ALTER TABLE LOAN.LOANSETUpINFORMATION
ADD CONSTRAINT chk_LOANSETUpINFORMATION_loannumber check    ( loannumber in (  35, 30, 15, 10));

-----The values on this column should be ONLY between 0.01 and 0.30 
alter table loan.loansetupinformation
add constraint chk_loansetupinformation_interestrate  check(interestrate between 0.01 and 0.30);

------If no value is inserted, then the Create date should default to the current time when the insertion is done 
ALTER TABLE LOAN.LOANSETUPINFORMATION
ADD CONSTRAINT CHEK_LOANSETUPINFORMATION_CreateDate DEFAULT(GETDATE()) FOR CreateDate;

-------This column should contain the same values as those in the BorrowerID of the Borrower table.
-------In essence, the BorrowerID in both tables should create a relationship in both tables. 
-- Since i already made borrowerid a primary key on the table b.b i will just refer it as a forign key on the loansetupinfo table 

ALTER TABLE LOAN.LOANSETUPINFORMATION
ADD CONSTRAINT [FK_LOANSETUPINFORMATION_BORROWER TABLE_BORROWERID] FOREIGN KEY(BORROWERID) REFERENCES BORROWER.BORROWER(BORROWERID);

-------Is a foreign key referencing the column PaymentFrequency in the  LU_PaymentFrequency Table  
ALTER TABLE LOAN.LU_PaymentFrequency
ADD CONSTRAINT PK_LU_PaymentFrequency_PAYMENTFREQUENCY PRIMARY KEY(PAYMENTFREQUENCY);
ALTER TABLE LOAN.LOANSETUPINFORMATION
ADD CONSTRAINT [FK_LOANSETUPINFORMATION_LU_PaymentFrequency TABLE_PAYMENTFREQUENCY] FOREIGN KEY(PAYMENTFREQUENCY) REFERENCES LOAN.LU_PaymentFrequency(PAYMENTFREQUENCY);

-----Is a foreign key referencing the column UnderwriterID in the  UnderwriterID Table
ALTER TABLE loan.Underwriter
ADD CONSTRAINT PK_UNDERWRITER_UNDERWRITERID PRIMARY KEY(UNDERWRITERID);
ALTER TABLE LOAN.LOANSETUPINFORMATION
ADD CONSTRAINT [FK_LOANSETUPINFORMATION_UNDERWRITER TABLE_UNDERWRITERID] FOREIGN KEY(UNDERWRITERID) REFERENCES LOAN.UNDERWRITER(UNDERWRITERID);

----Should be the UNIQUE IDENTIFIER OF A RECORD on this table.  
----I ALREADY MADE LOANNUMBER, DELIQUENCYCODE AND PAYMENTFREQUENCY A PK 
----If no value is inserted, then the Create date should default to the current time when the insertion is done 
----AM GETTING ACUTAL DATEIF NO DATE WAS INSERTED AS FIRST 
ALTER TABLE DBO.STATE
ADD CONSTRAINT CHEK_STATE_CREATEDATE DEFAULT(GETDATE()) FOR CREATEDATE;

-----Should be the UNIQUE IDENTIFIER OF A RECORD on this table.  
ALTER TABLE DBO.[STATE]
ADD CONSTRAINT PK_STATE_STATEID PRIMARY KEY(STATEID);

------This column can only take unique values, no duplicates.  
ALTER TABLE DBO.STATE
ADD CONSTRAINT UC_STATE_STATENAME UNIQUE(STATENAME);

-------The email should containt the '@' symbol in the inserted value 
ALTER TABLE borrower.borrower
ADD CONSTRAINT CHK_EMAIL CHECK(EMAIL LIKE '%_@__%.__%');

------f no value is inserted, then the Create date should default to the current time when the insertion is done 
ALTER TABLE LOAN.UNDERWRITER
ADD CONSTRAINT CHEK_UNDERWRITER_CREATEDATE DEFAULT(GETDATE()) FOR CREATEDATE;

----If no value is inserted, then the Create date should default to the current time when the insertion is done 
ALTER TABLE DBO.US_ZipCodes
ADD CONSTRAINT CHEK_US_ZipCodes_CREATEDATE DEFAULT(GETDATE()) FOR CREATEDATE;




create database ONLINE_TEST
go
use ONLINE_TEST
go
CREATE TABLE USER_TYPES( --LOAI NG DUNG
USET_ID BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),
USETNAME NVARCHAR(100) NOT NULL, --TEN
USETISADMIN BIT NOT NULL, --KIEM TRA ADMIN
USETNOTE NVARCHAR(400) NULL) --GHI CHU
GO
CREATE TABLE USERS( -- NG DUNG
USE_ID BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),
USET_ID BIGINT NOT NULL FOREIGN KEY(USET_ID) REFERENCES USER_TYPES(USET_ID) ON DELETE NO ACTION ON UPDATE NO ACTION, --MA LOAI NG DUNG
USEACCOUNT VARCHAR(50) NOT NULL UNIQUE, --USERNAME AK
USEENC_PASSWORD VARCHAR(50) NOT NULL, --PASSWORD MA HOA
USEFIRSTNAME NVARCHAR(50) NOT NULL, --HO
USELASTNAME NVARCHAR(100) NOT NULL, --TEN
USEDOB DATE NOT NULL, --NG SINH
USEGENDER BIT NOT NULL, --GIOI TINH
USEEMAIL VARCHAR(50) NULL, --EMAIL
USEPHONE VARCHAR(50) NOT NULL, --SDT
USEISACTIVE BIT NOT NULL, --TRANG THAI ACTIVE HOAC BLOCK
USEDATE DATE NOT NULL) --NGAY TAO HOAC NGAY HET HAN
GO
CREATE TABLE PRIVILEGES( --QUYEN
PRI_ID BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),
PRINAME NVARCHAR(200) NOT NULL, --TEN QUYEN
PRIURL VARCHAR(100) NOT NULL, --
PRIPARENT SMALLINT NOT NULL,
PRIORDER SMALLINT NULL, --INDEX PRIVILEGES
PRINOTE NVARCHAR(400) NULL) --GHI CHU
GO
CREATE TABLE [PERMISSIONS]( --MOI USER CO 1-N QUYEN, MOI QUYEN THUOC 1-N USER
PER_ID BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),
USET_ID BIGINT NOT NULL FOREIGN KEY(USET_ID) REFERENCES USER_TYPES(USET_ID) ON DELETE NO ACTION ON UPDATE NO ACTION, --MA LOAI NG DUNG
PRI_ID BIGINT NOT NULL FOREIGN KEY(PRI_ID) REFERENCES PRIVILEGES(PRI_ID) ON DELETE NO ACTION ON UPDATE NO ACTION, --MA QUYEN
PERISREAD_ONLY BIT NOT NULL)
GO
create table RELATIVE_PRIVILEGES( --
REL_ID BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),
PRI_ID BIGINT NOT NULL FOREIGN KEY(PRI_ID) REFERENCES PRIVILEGES(PRI_ID) ON DELETE NO ACTION ON UPDATE NO ACTION, --MA QUYEN CHA
RELNAME VARCHAR(100) NOT NULL, --
RELURL VARCHAR(50) NOT NULL, --
RELNOTE VARCHAR(400) NULL) --
GO
CREATE TABLE [SUBJECTS]( --MON HOC
SUB_ID BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),
PARENT_ID BIGINT NULL FOREIGN KEY(PARENT_ID) REFERENCES SUBJECTS(SUB_ID) ON DELETE NO ACTION ON UPDATE NO ACTION, --MA MON HOC CHA
--MON HOC CHA (== NULL => RECORD LA MON HOC CHA | != NULL => RECORD LA MON HOC CON)
SUBID VARCHAR(20) NOT NULL UNIQUE, --MA MON HOC DANG(SUB001) | AK
SUBNAME NVARCHAR(100) NOT NULL) --TEN MON HOC
GO
CREATE TABLE ASSIGNMENTS( --DANG KY MON HOC
ASS_ID BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),
USE_ID BIGINT NOT NULL FOREIGN KEY(USE_ID) REFERENCES [USERS](USE_ID) ON DELETE NO ACTION ON UPDATE NO ACTION, --MA NG DUNG
SUB_ID BIGINT NOT NULL FOREIGN KEY(SUB_ID) REFERENCES [SUBJECTS](SUB_ID) ON DELETE NO ACTION ON UPDATE NO ACTION, --MA MON HOC
ASSLEVEL TINYINT NOT NULL) --CAP DO
GO
CREATE TABLE SEMESTERS( --HOC KY
SEM_ID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
SEMSEMESTER TINYINT NOT NULL, --HOC KY
SEMYEAR INT NOT NULL, --NAM HOC
SEMISCURRENT BIT NOT NULL) --LA HOC KY HIEN TAI
GO
CREATE TABLE LABS( --PHONG
LAB_ID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
LABNAME NVARCHAR(200) NOT NULL, --TEN PHONG 
LABADDRESS NVARCHAR(400) NOT NULL) --DIA CHI
GO
CREATE TABLE [GROUPS]( --NHOM HOAC LOP
GRP_ID BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),
LAB_ID INT NULL FOREIGN KEY(LAB_ID) REFERENCES LABS(LAB_ID) ON DELETE NO ACTION ON UPDATE NO ACTION, --MA PHONG
SEM_ID INT NOT NULL FOREIGN KEY(SEM_ID) REFERENCES SEMESTERS(SEM_ID) ON DELETE NO ACTION ON UPDATE NO ACTION, --MA HOC KY
SUB_ID BIGINT NOT NULL FOREIGN KEY(SUB_ID) REFERENCES [SUBJECTS](SUB_ID) ON DELETE NO ACTION ON UPDATE NO ACTION, --MA MON HOC
GRPID VARCHAR(20) NOT NULL, --MA NHOM DANG (A001)
GRPNAME NVARCHAR(100) NOT NULL, --TEN NHOM
GRPPASSWORD VARCHAR(50) NOT NULL, --MAT KHAU NHOM
GRPENC_PASSWORD VARCHAR(100) NOT NULL, --MAT KHAU MA HOA
GRPREV_PASSWORD VARCHAR(50) NOT NULL, --MAT KHAU REVIEW NHOM
GRP_ENC_PASSWORD VARCHAR(100) NOT NULL, --MAT KHAU REVIEW NHOM MA HOA
GRPISACTIVE BIT NOT NULL) --TRANG THAI NHOM ACTIVE | BLOCK
GO
CREATE TABLE TEST_TYPES( --LOAI BAI KIEM TRA
TEST_ID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
TESTNAME CHAR(100) NOT NULL, --TEN LOAI
TESTISCURRENT BIT NOT NULL, --
TESTORDER TINYINT NULL) --INDEX TEST TYPE
GO
CREATE TABLE TESTS( --BAI KIEM TRA
TES_ID BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),
SUB_ID BIGINT NOT NULL FOREIGN KEY(SUB_ID) REFERENCES SUBJECTS(SUB_ID) ON DELETE NO ACTION ON UPDATE NO ACTION, --MA MON HOC
USE_ID BIGINT NOT NULL FOREIGN KEY(USE_ID) REFERENCES USERS(USE_ID) ON DELETE NO ACTION ON UPDATE NO ACTION, --MA NG DUNG
SEM_ID INT NOT NULL FOREIGN KEY(SEM_ID) REFERENCES SEMESTERS(SEM_ID) ON DELETE NO ACTION ON UPDATE NO ACTION, --MA HOC KY
TEST_ID INT NOT NULL FOREIGN KEY(TEST_ID) REFERENCES TEST_TYPES(TEST_ID) ON DELETE NO ACTION ON UPDATE NO ACTION, --MA LOAI BAI KIEM TRA
TESTITLE NVARCHAR(20) NOT NULL, --TIEU DE
TESVERSION VARCHAR(50) NOT NULL, --PHIEN BAN
TESDATE DATE NOT NULL, --NGAY KIEM TRA
TESTIME BIGINT NOT NULL, --THOI GIAN LAM BAI
TESLANGUAGE CHAR(2) NOT NULL, --NGON NGU (VI,EN,JP)
TESISSHUFFLE BIT NOT NULL, --CO TRON HAY K?
TESISHEADPHONE BIT NOT NULL, --CO DUNG HEADPHONE HAY K?
TESISFRAME BIT NOT NULL, --
TESISACTIVE BIT NOT NULL, --TRANG THAI ACTIVE (BAT DAU LAM BAI)
TESISLOCKED BIT NOT NULL, --TRANG THAI KHOA (KET THUC LAM BAI)
TESPASSWORD VARCHAR(50) NOT NULL, --MAT KHAU BAI TEST, DUNG DE MO LAI KHI CAN THIET
TESENC_PASSWORD VARCHAR(100) NOT NULL, --MAT KHAU BAI TEST MA HOA
TESMAX_SCORE FLOAT NOT NULL DEFAULT(100), --DIEM TOI DA
TESNOTE NVARCHAR(400) NULL) --GHI CHU
GO
CREATE TABLE GROUP_TESTS( --XEP BAI THI CHO NHOM
GRPT_ID BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),
GRP_ID BIGINT NOT NULL FOREIGN KEY(GRP_ID) REFERENCES GROUPS(GRP_ID) ON DELETE NO ACTION ON UPDATE NO ACTION, --MA NHOM
TES_ID BIGINT NOT NULL FOREIGN KEY(TES_ID) REFERENCES TESTS(TES_ID) ON DELETE NO ACTION ON UPDATE NO ACTION, --MA BAI THI
GRPTSTATUS TINYINT NOT NULL, --TRANG THAI
GRPTDATE DATETIME NOT NULL) --NGAY GIO THI
GO
CREATE TABLE TESTING_FORMATS(
TESF_ID BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),
TES_ID BIGINT NOT NULL FOREIGN KEY(TES_ID) REFERENCES TESTS(TES_ID) ON DELETE NO ACTION ON UPDATE NO ACTION, --
TESISFREE BIT NOT NULL,
TESISSHOW_PART BIT NOT NULL,
TESISSHOW_SCORE BIT NOT NULL,
TESISSHOW_PROCTOR BIT NOT NULL,
TESISSHOW_FEEDBACK BIT NOT NULL,
TESISSHOW_SIGNNATURE BIT NOT NULL)
GO
CREATE TABLE TEST_DETAILS(
TESD_ID BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),
TESD_ID2 BIGINT NULL FOREIGN KEY(TESD_ID2) REFERENCES TEST_DETAILS(TESD_ID) ON DELETE NO ACTION ON UPDATE NO ACTION, -- SEFT JOIN 
TES_ID BIGINT NOT NULL FOREIGN KEY(TES_ID) REFERENCES TESTS(TES_ID) ON DELETE NO ACTION ON UPDATE NO ACTION, --MA BAI TEST
TESDID BIGINT NOT NULL,
TESDTABLE TINYINT NOT NULL,
TESDNO_QUESTION INT NOT NULL,
TESDORDER INT NULL)
GO
CREATE TABLE ANSWER_TYPES( --LOAI CAU TRA LOI
ANST_ID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
ANSTID CHAR(10) NOT NULL UNIQUE, --MA LOAI | AK
ANSTNAME NVARCHAR(50) NOT NULL, --TEN LOAI
ANSTORDER INT NULL, --INDEX ANSWER TYPE
ANSTSAMPLE NTEXT NULL) --VI DU MAU
GO
CREATE TABLE PARTS( --CAC HOC PHAN CUA 1 MON HOC
PAR_ID BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),
SUB_ID BIGINT NOT NULL FOREIGN KEY(SUB_ID) REFERENCES SUBJECTS(SUB_ID) ON DELETE NO ACTION ON UPDATE NO ACTION, --MA MON HOC
PARID CHAR(10) NOT NULL, --MA HOC PHAN DANG (HP001)
PARNAME NVARCHAR(200) NOT NULL, --TEN HOC PHAN
PARDIRECTION TEXT NULL,
PARDEFAULT_SCORE FLOAT NOT NULL, --DIEM MAC DINH CUA HOC PHAN
PARDEFAULT_COLUMN TINYINT NOT NULL,
PARDEFAULT_LEVEL TINYINT NOT NULL, --DO KHO HOC PHAN
PARORDER INT NULL, -- INDEX PART
PARNOTE NVARCHAR(400) NOT NULL) --GHI CHU
GO
CREATE TABLE QUESTION_FORMATS( --DINH DANG CAU HOI
QUEF_ID BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),
ANST_ID INT NOT NULL FOREIGN KEY(ANST_ID) REFERENCES ANSWER_TYPES(ANST_ID) ON DELETE NO ACTION ON UPDATE NO ACTION, --MA LAOI CAU TRA LOI
PAR_ID BIGINT NOT NULL FOREIGN KEY(PAR_ID) REFERENCES PARTS(PAR_ID) ON DELETE CASCADE ON UPDATE CASCADE, --MA HOC PHAN
QUEFORDER TINYINT NULL) --INDEX QUESTION FORMAT
GO
CREATE TABLE PASSAGES( --DOAN VAN
PAS_ID BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),
PAR_ID BIGINT NOT NULL FOREIGN KEY(PAR_ID) REFERENCES PARTS(PAR_ID) ON DELETE NO ACTION ON UPDATE NO ACTION, --MA HOC PHAN
ANST_ID INT NOT NULL FOREIGN KEY(ANST_ID) REFERENCES ANSWER_TYPES(ANST_ID) ON DELETE NO ACTION ON UPDATE NO ACTION, --MA LOAI CAU HOI
PASCONTENT NTEXT NOT NULL, --NOI DUNG DOAN VAN
PASISSHUFFLE BIT NOT NULL, --CO TRON HAY K?
PASISSHOW_ALL BIT NOT NULL,
PASMEDIA VARCHAR(50) NULL) --VIEO NEU CO (URL)
GO
CREATE TABLE IMAGE_BANKS( --ANH DUNG CHO CAC HOC PHAN
IMG_ID BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),
PAR_ID BIGINT NOT NULL FOREIGN KEY(PAR_ID) REFERENCES PARTS(PAR_ID) ON DELETE NO ACTION ON UPDATE NO ACTION, --MA HOC PHAN
IMGURL VARCHAR(50) NOT NULL) -- URL ANH
GO
CREATE TABLE QUESTIONS( --CAU HOI
QUE_ID BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),
ANST_ID INT NOT NULL FOREIGN KEY(ANST_ID) REFERENCES ANSWER_TYPES(ANST_ID) ON DELETE NO ACTION ON UPDATE NO ACTION, --MA LOAI CAU HOI
PAR_ID BIGINT NULL FOREIGN KEY(PAR_ID) REFERENCES PARTS(PAR_ID) ON DELETE NO ACTION ON UPDATE NO ACTION, --MA HOC PHAN (ALLOW NULL)
PAS_ID BIGINT NULL FOREIGN KEY(PAS_ID) REFERENCES PASSAGES(PAS_ID) ON DELETE NO ACTION ON UPDATE NO ACTION, --MA DOAN VAN (ALLOW NULL)
QUECONTENT NTEXT NOT NULL, --NOI DUNG CAU HOI
QUEISSHUFFLE BIT NOT NULL, --CO TRON HAY K?
QUESCORE FLOAT NOT NULL, --DIEM CAU HOI,
QUEOPT_COLUMN TINYINT NOT NULL, --CHIA COT CHO CAC DAP AN TRAC NGHIEM
QUEISBANK BIT NOT NULL, --CO PHAI LAY TRONG NGAN HANG CAU HOI HAY K?
QUELEVEL TINYINT NOT NULL, --CAP DO CAU HOI
QUEMEDIA CHAR(50) NULL, --URL VIDEO
QUEREFERENCE VARCHAR(100) NULL,
QUEORDER INT NULL) --INDEX QUESTION
GO
CREATE TABLE TAKERS( --NGUOI THI
TAK_ID BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),
TAKID VARCHAR(20) NOT NULL UNIQUE, --MA NGUOI THI DANG(SV001)
TAKFIRSTNAME NVARCHAR(50) NOT NULL, --HO
TAKLASTNAME NVARCHAR(100) NOT NULL, --TEN
TAKGENDER BIT NOT NULL, --GIOI TINH
TAKDOB DATE NOT NULL, --NGAY SINH
TAKADDRESS NVARCHAR(200) NULL, --DIA CHI
TAKEMAIL VARCHAR(50) NULL, --EMAIL
TAKPHONE VARCHAR(20) NOT NULL) --SDT
GO
CREATE TABLE EXAM_TAKINGS( --XEP NGUOI THI VAO NHOM & BAI THI
EXA_ID BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),
GRPT_ID BIGINT NOT NULL FOREIGN KEY(GRPT_ID) REFERENCES GROUP_TESTS(GRPT_ID) ON DELETE NO ACTION ON UPDATE NO ACTION, --MA NHOM THI VA BAI THI
TAK_ID BIGINT NOT NULL FOREIGN KEY(TAK_ID) REFERENCES TAKERS(TAK_ID) ON DELETE NO ACTION ON UPDATE NO ACTION, --MA NGUOI THI
EXAACCOUNT VARCHAR(50) NOT NULL,
EXAREMAINING_TIME BIGINT NOT NULL, --THOI GIAN THI CON LAI
EXADATE DATETIME NOT NULL, --NGAY THI
EXASTATUS TINYINT NOT NULL, --TRANG THAI
EXAIP VARCHAR(20) NULL) -- DIA CHI IP CUA MAY THI
GO
CREATE TABLE ANSWERS( --CAU TRA LOI KEIU NOI DUNG CUA NG THI
ANS_ID BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),
QUE_ID BIGINT NOT NULL FOREIGN KEY(QUE_ID) REFERENCES QUESTIONS(QUE_ID) ON DELETE NO ACTION ON UPDATE NO ACTION, --MA CAU HOI
EXA_ID BIGINT NOT NULL FOREIGN KEY(EXA_ID) REFERENCES EXAM_TAKINGS(EXA_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
--MA NG THI & NHOM & BAI THI
ANSPAR_ID BIGINT NOT NULL,
ANSCONTENT NVARCHAR(100) NOT NULL, --CAU TRA LOI DANG NOI DUNG
ANSSCORE FLOAT NOT NULL, -- DIEM CAU TRA LOI
ANSORDER INT NOT NULL, --INDEX ANSWER CONTENT
ANSOPTIDS VARCHAR(100) NULL)
GO
CREATE TABLE OPTIONS( --CAU TRA LOI DANG CHON
OPT_ID BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),
QUE_ID BIGINT NOT NULL FOREIGN KEY(QUE_ID) REFERENCES QUESTIONS(QUE_ID) ON DELETE NO ACTION ON UPDATE NO ACTION, --MA CAU HOI
OPTCONTENT NTEXT NOT NULL, --NOI DUNG CAU TRA LOI
OPTISCORRECT BIT NOT NULL, --CAU TRA LOI DUNG HAY K?
OPTORDER TINYINT NULL) --INDEX OPTION

















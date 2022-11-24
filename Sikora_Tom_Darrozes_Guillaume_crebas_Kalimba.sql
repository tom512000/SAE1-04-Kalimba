/*==============================================================*/
/* Nom de SGBD :  ORACLE Version 11g                            */
/* Date de création :  24/11/2022 14:08:50                      */
/*==============================================================*/


alter table Cours
   drop constraint FK_COURS_ANIMER_PROFESSE;

alter table Cours
   drop constraint FK_COURS_APPARTENI_TYPE_COU;

alter table Cours
   drop constraint FK_COURS_DEDIER_A_TYPE_INS;

alter table Instrument
   drop constraint FK_INSTRUME_CORRESPON_TYPE_INS;

alter table Pratiquer
   drop constraint FK_PRATIQUE_PRATIQUER_TYPE_INS;

alter table Pratiquer
   drop constraint FK_PRATIQUE_PRATIQUER_PROFESSE;

alter table Professeur
   drop constraint FK_PROFESSE_SPECIALIS_TYPE_INS;

alter table Tarifer
   drop constraint FK_TARIFER_TARIFER_TRANCHE;

alter table Tarifer
   drop constraint FK_TARIFER_TARIFER2_TYPE_COU;

alter table Type_Instrument
   drop constraint FK_TYPE_INS_REGROUPER_CATEGORI;

drop table Categorie cascade constraints;

drop index DEDIER_FK;

drop index DONNER_FK;

drop index AVOIR_FK;

drop table Cours cascade constraints;

drop index OCCUPER_FK;

drop table Instrument cascade constraints;

drop index PRATIQUER_FK;

drop table Pratiquer cascade constraints;

drop index SPECIALISATION_FK;

drop table Professeur cascade constraints;

drop index COUTER_FK;

drop table Tarifer cascade constraints;

drop table Tranche cascade constraints;

drop table Type_Cours cascade constraints;

drop index APPARTENIR_FK;

drop table Type_Instrument cascade constraints;

/*==============================================================*/
/* Table : Categorie                                            */
/*==============================================================*/
create table Categorie 
(
   idCat                INTEGER              not null,
   libCat               VARCHAR2(30),
   constraint PK_CATEGORIE primary key (idCat)
);

/*==============================================================*/
/* Table : Cours                                                */
/*==============================================================*/
create table Cours 
(
   idCours              INTEGER              not null,
   idProf               NUMBER               not null,
   idTpCours            INTEGER              not null,
   idTpInst             INTEGER,
   libCours             VARCHAR2(35),
   ageMini              INTEGER,
   ageMaxi              INTEGER,
   nbPlaces             INTEGER,
   constraint PK_COURS primary key (idCours)
);

/*==============================================================*/
/* Index : AVOIR_FK                                             */
/*==============================================================*/
create index AVOIR_FK on Cours (
   idTpCours ASC
);

/*==============================================================*/
/* Index : DONNER_FK                                            */
/*==============================================================*/
create index DONNER_FK on Cours (
   idProf ASC
);

/*==============================================================*/
/* Index : DEDIER_FK                                            */
/*==============================================================*/
create index DEDIER_FK on Cours (
   idTpInst ASC
);

/*==============================================================*/
/* Table : Instrument                                           */
/*==============================================================*/
create table Instrument 
(
   idInst               INTEGER              not null,
   idTpInst             INTEGER              not null,
   dateAchat            DATE,
   prixAchat            FLOAT,
   couleur              VARCHAR2(30),
   marque               VARCHAR2(30),
   modele               VARCHAR2(30),
   constraint PK_INSTRUMENT primary key (idInst)
);

/*==============================================================*/
/* Index : OCCUPER_FK                                           */
/*==============================================================*/
create index OCCUPER_FK on Instrument (
   idTpInst ASC
);

/*==============================================================*/
/* Table : Pratiquer                                            */
/*==============================================================*/
create table Pratiquer 
(
   idTpInst             INTEGER              not null,
   idProf               NUMBER               not null,
   constraint PK_PRATIQUER primary key (idTpInst, idProf)
);

/*==============================================================*/
/* Index : PRATIQUER_FK                                         */
/*==============================================================*/
create index PRATIQUER_FK on Pratiquer (
   idTpInst ASC
);

/*==============================================================*/
/* Table : Professeur                                           */
/*==============================================================*/
create table Professeur 
(
   idProf               NUMBER               not null,
   idTpInst             INTEGER,
   nomProf              VARCHAR2(30)         not null,
   pnomProf             VARCHAR2(30)         not null,
   dateNais             DATE                 not null,
   dateEmb              DATE,
   dateDpt              DATE,
   statut               INTEGER             
      constraint CKC_STATUT_PROFESSE check (statut is null or (statut in (1,2,3))),
   emailProf            VARCHAR2(30),
   telProf              CHAR(10),
   constraint PK_PROFESSEUR primary key (idProf)
);

/*==============================================================*/
/* Index : SPECIALISATION_FK                                    */
/*==============================================================*/
create index SPECIALISATION_FK on Professeur (
   idTpInst ASC
);

/*==============================================================*/
/* Table : Tarifer                                              */
/*==============================================================*/
create table Tarifer 
(
   idTranche            CHAR(1)              not null,
   idTpCours            INTEGER              not null,
   montant              FLOAT,
   constraint PK_TARIFER primary key (idTranche, idTpCours)
);

/*==============================================================*/
/* Index : COUTER_FK                                            */
/*==============================================================*/
create index COUTER_FK on Tarifer (
   idTranche ASC
);

/*==============================================================*/
/* Table : Tranche                                              */
/*==============================================================*/
create table Tranche 
(
   idTranche            CHAR(1)              not null,
   quotientMin          INTEGER,
   constraint PK_TRANCHE primary key (idTranche)
);

/*==============================================================*/
/* Table : Type_Cours                                           */
/*==============================================================*/
create table Type_Cours 
(
   idTpCours            INTEGER              not null,
   libTpCours           VARCHAR2(30),
   constraint PK_TYPE_COURS primary key (idTpCours)
);

/*==============================================================*/
/* Table : Type_Instrument                                      */
/*==============================================================*/
create table Type_Instrument 
(
   idTpInst             INTEGER              not null,
   idCat                INTEGER              not null,
   libTpInst            VARCHAR2(30),
   constraint PK_TYPE_INSTRUMENT primary key (idTpInst)
);

/*==============================================================*/
/* Index : APPARTENIR_FK                                        */
/*==============================================================*/
create index APPARTENIR_FK on Type_Instrument (
   idCat ASC
);

alter table Cours
   add constraint FK_COURS_ANIMER_PROFESSE foreign key (idProf)
      references Professeur (idProf);

alter table Cours
   add constraint FK_COURS_APPARTENI_TYPE_COU foreign key (idTpCours)
      references Type_Cours (idTpCours);

alter table Cours
   add constraint FK_COURS_DEDIER_A_TYPE_INS foreign key (idTpInst)
      references Type_Instrument (idTpInst);

alter table Instrument
   add constraint FK_INSTRUME_CORRESPON_TYPE_INS foreign key (idTpInst)
      references Type_Instrument (idTpInst);

alter table Pratiquer
   add constraint FK_PRATIQUE_PRATIQUER_TYPE_INS foreign key (idTpInst)
      references Type_Instrument (idTpInst);

alter table Pratiquer
   add constraint FK_PRATIQUE_PRATIQUER_PROFESSE foreign key (idProf)
      references Professeur (idProf);

alter table Professeur
   add constraint FK_PROFESSE_SPECIALIS_TYPE_INS foreign key (idTpInst)
      references Type_Instrument (idTpInst);

alter table Tarifer
   add constraint FK_TARIFER_TARIFER_TRANCHE foreign key (idTranche)
      references Tranche (idTranche);

alter table Tarifer
   add constraint FK_TARIFER_TARIFER2_TYPE_COU foreign key (idTpCours)
      references Type_Cours (idTpCours);

alter table Type_Instrument
   add constraint FK_TYPE_INS_REGROUPER_CATEGORI foreign key (idCat)
      references Categorie (idCat);


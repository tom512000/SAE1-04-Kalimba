ALTER TABLE PROFESSEUR 
ADD IDSPV INTEGER CONSTRAINT FK_IDSPV REFERENCES PROFESSEUR(IDPROF);

UPDATE PROFESSEUR
SET IDSPV = 1
WHERE IDPROF IN (7,9);

UPDATE PROFESSEUR
SET IDSPV = 3
WHERE IDPROF IN (4,6,5,1);

UPDATE PROFESSEUR
SET IDSPV = 4
WHERE IDPROF = 2;

UPDATE PROFESSEUR
SET IDSPV = 5
WHERE IDPROF IN (8,11,10);

UPDATE PROFESSEUR
SET IDSPV = 6
WHERE IDPROF IN (15,16);

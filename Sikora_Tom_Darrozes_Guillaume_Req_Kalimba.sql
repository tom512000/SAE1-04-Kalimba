-- http://sandron/S1/SAE-partieII-B.pdf
-- http://sandron/S1/Kalimba_MCD.pdf

-- R01 : Liste des professeurs dont le nom contient la lettre « E » en 2ème lettre et qui, soit ont été embauché entre 2000 et 2010, soit n’ont pas de date d’embauche. Tri dans l’ordre alphabétique sur les noms puis sur les prénoms.
SELECT NOMPROF||' '||PNOMPROF "Professeur", 
    DECODE(STATUT,1,'Titulaire',2,'Vacataire',3,'Stagiaire') "Statut", 
    EXTRACT(YEAR FROM DATEEMB) "Annee d'embauche"
FROM PROFESSEUR
WHERE UPPER(NOMPROF) LIKE '_E%'
AND (EXTRACT(YEAR FROM DATEEMB) BETWEEN 2000 AND 2010
OR DATEEMB IS NULL)
ORDER BY 1;

-- R02 : Liste des cours dont : - soit le libellé contient l’un des mots «musical» ou «chorale» et le nb de places est supérieur ou égal à 15. - Soit le libellé contient le mot « orchestre » et l’âge maximal est défini.
SELECT LIBCOURS "Cours", AGEMINI "Age Mini", NVL(AGEMAXI,99) "Age Maxi", NBPLACES "Nb Places"
FROM COURS
WHERE ((UPPER(LIBCOURS) LIKE '%MUSICAL%'
OR UPPER(LIBCOURS) LIKE '%CHORALE%')
AND NBPLACES >= 15)
OR (UPPER(LIBCOURS) LIKE '%ORCHESTRE%'
AND AGEMAXI IS NOT NULL);

-- R03 : Liste des professeurs qui sont vacataires (statut 2) avec le type d’instruments pour lequel ils sont spécialisés. Tri par nom.
SELECT NOMPROF||' '||PNOMPROF "Professeur", LIBTPINST "Type Instrument Principal"
FROM PROFESSEUR p INNER JOIN TYPE_INSTRUMENT ti ON p.IDTPINST = ti.IDTPINST
WHERE STATUT = 2
ORDER BY 1;

-- R04 : Liste des types instruments pour lesquels l’école de musique possède au moins un instrument.
SELECT LIBCAT "Categorie", LIBTPINST "Type Instrument"
FROM TYPE_INSTRUMENT ti INNER JOIN CATEGORIE c ON ti.IDCAT = c.IDCAT;

-- R05 : Liste des cours de type individuel dédié à un type d’instruments de la catégorie « Cordes ».
SELECT LIBCOURS "Cours", NOMPROF||' '||PNOMPROF "Professeur", NBPLACES "Nb Places"
FROM CATEGORIE ca INNER JOIN (((COURS co
    INNER JOIN PROFESSEUR pr ON co.IDPROF = pr.IDPROF)
    INNER JOIN TYPE_COURS tc ON co.IDTPCOURS = tc.IDTPCOURS)
    INNER JOIN TYPE_INSTRUMENT ti ON co.IDTPINST = ti.IDTPINST) ON ca.IDCAT = ti.IDCAT
WHERE UPPER(LIBTPCOURS) = 'COURS INDIVIDUEL'
AND UPPER(LIBCAT) = 'CORDES';

-- R06 : Liste des cours animés par le même professeur que le cours de flute (dont le libellé contient le mot « FLUTE »).
SELECT co1.LIBCOURS "Cours", NOMPROF||' '||PNOMPROF "Professeur", LIBTPINST "Type instrument"
FROM COURS co1
    INNER JOIN COURS co2 ON (co1.IDPROF = co2.IDPROF)
    INNER JOIN PROFESSEUR p ON (co1.IDPROF = p.IDPROF)
    INNER JOIN TYPE_INSTRUMENT ti ON (p.IDTPINST = ti.IDTPINST)
WHERE UPPER(co2.LIBCOURS) LIKE '%FLUTE%';


-- R07 : Liste des cours dédié à chaque type d’instrument qui fait partie d’une catégorie commençant par la lettre C. Afficher aussi les types d’instruments sans cours associé. Tri par catégorie.
SELECT LIBTPINST "Type Instrument", LIBCAT "Categorie", LIBCOURS "Cours"
FROM CATEGORIE ca
    INNER JOIN TYPE_INSTRUMENT ti ON (ca.IDCAT = ti.IDCAT)
    INNER JOIN COURS co ON (ti.IDTPINST = co.IDTPINST)
WHERE UPPER(LIBCAT) LIKE 'C%'
ORDER BY 2;

-- R08 : Liste des enseignants qui ne sont pas stagiaires (statut 3), embauchés après le 01 janvier 2011 avec leur référents (s’il en ont un).
SELECT DISTINCT p1.NOMPROF||' '||p1.PNOMPROF "Professeur", 
    EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM p1.DATENAIS)||' ans' "Age",
    TO_CHAR(p1.DATEEMB,'MONTH YYYY') "Embauche",
    p2.NOMPROF||' '||p2.PNOMPROF "Referent"
FROM PROFESSEUR p1, PROFESSEUR p2
WHERE p2.IDSPV(+) = p1.IDPROF
AND p1.STATUT != 3
AND p1.DATEEMB > TO_DATE('01/01/2011','DD/MM/YYYY');
SPOOL bruno_q2bonus.txt
SELECT TO_CHAR (sysdate, 'Day DD Month Year HH:MI:SS Am') FROM dual;

-- Question 2: (use script 7northwoods) Create a view containing course name, credit, student name, c_sec_id, SEC NUM, grade of all course section taken by a student.
-- Can we UPDATE, INSERT directly TO the view?
-- If NOT, can you provide a solution?
CREATE OR REPLACE VIEW COURSES_VIEW AS
SELECT C.COURSE_NAME, C.CREDITS, S.S_LAST, S.S_FIRST, CS.C_SEC_ID, CS.SEC_NUM, E.GRADE
FROM COURSE C, STUDENT S, COURSE_SECTION CS, ENROLLMENT E
WHERE E.C_SEC_ID = CS.C_SEC_ID
AND C.COURSE_ID = CS.COURSE_ID
AND E.S_ID = S.S_ID;

SELECT * FROM COURSES_VIEW;

UPDATE COURSES_VIEW
SET GRADE = 'B'
WHERE C_SEC_ID = 2 AND S_FIRST = 'Sarah';

UPDATE COURSES_VIEW
SET GRADE = 'C'
WHERE C_SEC_ID = 12 AND S_FIRST = 'Michael';
-- UPDATE OK
-- INSERT NOT OK

-- INSTEAD OF TRIGGER
DROP SEQUENCE STUD_SEQ;
CREATE SEQUENCE STUD_SEQ INCREMENT BY 1 START WITH 10;
DROP SEQUENCE COURSE_SEQ;
CREATE SEQUENCE COURSE_SEQ INCREMENT BY 1 START WITH 5;
DROP SEQUENCE C_SEC_ID_SEQ;
CREATE SEQUENCE C_SEC_ID_SEQ INCREMENT BY 1 START WITH 13;

CREATE OR REPLACE TRIGGER COURSES_VIEW_TRIGGER
    INSTEAD OF INSERT ON COURSES_VIEW
    FOR EACH ROW
        BEGIN
            INSERT INTO COURSE (COURSE_ID, COURSE_NAME, CREDITS)
            VALUES (COURSE_SEQ.NEXTVAL, :NEW.COURSE_NAME, :NEW.CREDITS);
    
            INSERT INTO STUDENT (S_ID, S_LAST, S_FIRST)
            VALUES (STUD_SEQ.NEXTVAL, :NEW.S_LAST, :NEW.S_FIRST);
    
            INSERT INTO COURSE_SECTION (C_SEC_ID, COURSE_ID, SEC_NUM)
            VALUES (C_SEC_ID_SEQ.NEXTVAL, COURSE_SEQ.CURRVAL, :NEW.SEC_NUM);
    
            INSERT INTO ENROLLMENT (S_ID, C_SEC_ID, GRADE)
            VALUES (STUD_SEQ.CURRVAL, C_SEC_ID_SEQ.CURRVAL, :NEW.GRADE);    
        END;
        /

INSERT INTO COURSES_VIEW VALUES ('DBII', 3, 'Landeiro', 'Bruno', 5, 5, 'A'); 

SELECT * FROM COURSES_VIEW;

SPOOL OFF
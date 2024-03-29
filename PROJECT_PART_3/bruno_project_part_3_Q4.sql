SPOOL C:\DB2\PROJECT_PART_3\bruno_project_part_3_Q4.txt
SELECT TO_CHAR(SYSDATE, 'DD Month Year Day HH:MI:SS Am') from dual;
SET SERVEROUTPUT ON;

-- Question 4: (use schemas des04, and script 7software)
-- We need to INSERT or UPDATE data of table consultant_skill , 
-- create needed functions, procedures � 
-- that accepts consultant id, skill id, and certification status for the task. 
-- The procedure should be user friendly enough to handle all possible errors such as 
-- consultant id, skill id do not exist OR certification status is different than �Y�, �N�. 
-- Make sure to display: Consultant last, first name, skill description 
-- and the confirmation of the DML performed 
-- (hint: Do not forget to add COMMIT inside the procedure)
CREATE OR REPLACE FUNCTION CONSULTANT_EXIST(P_ID IN NUMBER) RETURN BOOLEAN AS
V_ID NUMBER;
BEGIN
    SELECT C_ID INTO V_ID FROM CONSULTANT WHERE C_ID = P_ID;
    RETURN TRUE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
END;
/

CREATE OR REPLACE FUNCTION SKILL_EXIST(P_ID IN NUMBER) RETURN BOOLEAN AS
V_ID NUMBER;
BEGIN
    SELECT SKILL_ID INTO V_ID FROM SKILL WHERE SKILL_ID = P_ID;
    RETURN TRUE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
END;
/

CREATE OR REPLACE FUNCTION STATUS_IS_VALID(P_STATUS IN VARCHAR) RETURN BOOLEAN AS
BEGIN
    RETURN P_STATUS = 'Y' OR P_STATUS = 'N';
END;
/

CREATE OR REPLACE FUNCTION CERTIFICATION_IS_REGISTRED(P_C_ID IN NUMBER, P_SKILL_ID IN NUMBER) RETURN BOOLEAN AS
V_CURRENT_STATUS VARCHAR2(1);
BEGIN
    SELECT CERTIFICATION INTO V_CURRENT_STATUS FROM CONSULTANT_SKILL 
    WHERE C_ID = P_C_ID AND SKILL_ID = P_SKILL_ID;
    RETURN TRUE;
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
END;
/

CREATE OR REPLACE PROCEDURE P3Q4(P_C_ID IN NUMBER, P_SKILL_ID IN NUMBER, P_STATUS IN VARCHAR2) AS
V_IS_INPUT_VALID BOOLEAN := TRUE;
V_C_LAST VARCHAR(100);
V_C_FIRST VARCHAR(100);
V_SKILL_DESCRIPTION VARCHAR(100);
BEGIN
    IF NOT(CONSULTANT_EXIST(P_C_ID)) THEN
        V_IS_INPUT_VALID := FALSE;
        DBMS_OUTPUT.PUT_LINE('Consultant id do not exist');
    END IF;
    
    IF NOT(SKILL_EXIST(P_SKILL_ID)) THEN
        V_IS_INPUT_VALID := FALSE;
        DBMS_OUTPUT.PUT_LINE('Skill id do not exist');
    END IF;
    
    IF NOT(STATUS_IS_VALID(P_STATUS)) THEN
        V_IS_INPUT_VALID := FALSE;
        DBMS_OUTPUT.PUT_LINE('Certification status is different than �Y� OR �N�');
    END IF;
    
    IF V_IS_INPUT_VALID THEN
        
        SELECT SKILL_DESCRIPTION INTO V_SKILL_DESCRIPTION FROM SKILL WHERE SKILL_ID = P_SKILL_ID;
        SELECT C_LAST, C_FIRST INTO V_C_LAST, V_C_FIRST FROM CONSULTANT WHERE C_ID = P_C_ID;
        
        IF CERTIFICATION_IS_REGISTRED(P_C_ID, P_SKILL_ID) THEN
            UPDATE CONSULTANT_SKILL SET CERTIFICATION = P_STATUS 
                WHERE C_ID = P_C_ID AND SKILL_ID = P_SKILL_ID;
            DBMS_OUTPUT.PUT_LINE('SKILL CERTIFICATION UPDATED');    
        ELSE
            INSERT INTO CONSULTANT_SKILL (C_ID, SKILL_ID, CERTIFICATION)
                VALUES(P_C_ID, P_SKILL_ID, P_STATUS);
            DBMS_OUTPUT.PUT_LINE('SKILL CERTIFICATION INSERTED');
        END IF;

        DBMS_OUTPUT.PUT_LINE(V_C_LAST || ', ' || V_C_FIRST || ' - ' || V_SKILL_DESCRIPTION);
        COMMIT;
    END IF;
END;
/
EXEC P3Q4(100,1,'Y');
EXEC P3Q4(100,2,'Y');
EXEC P3Q4(105,2,'N');
EXEC P3Q4(106,2,'N');
EXEC P3Q4(105,105,'Y');
SPOOL OF
SPOOL BRUNO_PROJECT_PART_7_Q2_SPOOL.txt
SELECT TO_CHAR(SYSDATE, 'DD Month Year Day HH:MI:SS Am') from dual;
SET SERVEROUTPUT ON;
-- Question 2:
-- Run script 7software in schemas des04
-- Using %ROWTYPE in a procedure, display all the consultants. 
-- Under each consultant display all his/her skill (skill description) and the 
-- status of the skill (certified or not)
CREATE OR REPLACE PROCEDURE P7_Q2 AS
CURSOR CONSULTANT_CURR IS SELECT C_ID, C_LAST, C_FIRST FROM CONSULTANT;

CURSOR CONSULTANT_SKILL_CURR(P_C_ID CONSULTANT.C_ID%TYPE) IS 
  SELECT s.SKILL_DESCRIPTION, 
    DECODE(upper(CS.CERTIFICATION), 'Y', 'CERTIFIED', 'N', 'NOT CERTIFIED') AS CERT
    FROM SKILL S 
    JOIN CONSULTANT_SKILL CS ON S.skill_id = CS.skill_id 
    WHERE CS.C_ID = P_C_ID;

V_CONSULTANT CONSULTANT_CURR%ROWTYPE;
BEGIN
  OPEN CONSULTANT_CURR;
  FETCH CONSULTANT_CURR INTO V_CONSULTANT;
  WHILE CONSULTANT_CURR%FOUND LOOP
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('-----CONSULTANT-----');
    DBMS_OUTPUT.PUT_LINE(V_CONSULTANT.C_ID ||', '|| V_CONSULTANT.C_LAST ||', '|| V_CONSULTANT.C_FIRST);
    DBMS_OUTPUT.PUT_LINE('-----SKILLS-----');
    FOR S_INDEX IN CONSULTANT_SKILL_CURR(V_CONSULTANT.C_ID) LOOP
        DBMS_OUTPUT.PUT_LINE(S_INDEX.SKILL_DESCRIPTION ||', '|| S_INDEX.CERT);
    END LOOP;
    FETCH CONSULTANT_CURR INTO V_CONSULTANT;
  END LOOP;
  CLOSE CONSULTANT_CURR;
END;
/
EXEC P7_Q2;

SPOOL OFF;
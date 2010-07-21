drop procedure move1to2;

DELIMITER $
create procedure move1to2(goal int)
BEGIN
TRUNCATE TABLE Queue2;
set @num := 0, @name := -1, @s := -1, @e := -1;
insert into queue2
SELECT id, s, e, name, lchild, rchild, weight, popped, terminal from (
	SELECT id, s, e, name, lchild, rchild, weight, popped, terminal,
                @num := if (@name = name and @s = s and @e = e, @num+1, 1) as row_num,
                @name := name as dummy1, @s := s as dummy2, @e := e as dummy3
                FROM Queue1
                ORDER BY name, s, e, weight) as X
WHERE X.row_num <= goal;
END $
DELIMITER ;

drop procedure move2to1;
DELIMITER $
create procedure move2to1(goal int)
BEGIN
TRUNCATE TABLE Queue1;
set @num := 0, @name := -1, @s := -1, @e := -1;
insert into queue1
SELECT id, s, e, name, lchild, rchild, weight, popped, terminal from (
	SELECT id, s, e, name, lchild, rchild, weight, popped, terminal,
                @num := if (@name = name and @s = s and @e = e, @num+1, 1) as row_num,
                @name := name as dummy1, @s := s as dummy2, @e := e as dummy3
                FROM Queue2
                ORDER BY name, s, e, weight) as X
WHERE X.row_num <= goal;
END $
DELIMITER ;

drop procedure updateRules1;
DELIMITER $
create procedure updateRules1(round int)
BEGIN
INSERT INTO Queue1(s,e,name,weight,lchild)
SELECT s, e, head, UG.weight + Q.weight, Q.id
FROM UnaryGrammar UG, Queue1 Q
WHERE UG.body = Q.name and popped = round;

INSERT INTO Queue1(s,e,name,weight,lchild,rchild)
SELECT Q1.s, Q2.e, head, UG.weight + Q1.weight + Q2.weight, Q1.id, Q2.id
FROM BinaryGrammar UG, Queue1 Q1, Queue1 Q2
WHERE Q1.popped = round and Q1.e = Q2.s and
    UG.body1 = Q1.name and UG.body2 = Q2.name;

INSERT INTO Queue1(s,e,name,weight,lchild,rchild)
SELECT Q1.s, Q2.e, head, UG.weight + Q1.weight + Q2.weight, Q1.id, Q2.id
FROM BinaryGrammar UG, Queue1 Q1, Queue1 Q2
WHERE Q2.popped = round and Q1.e = Q2.s and
    UG.body1 = Q1.name and UG.body2 = Q2.name;
END $
DELIMITER ;

drop procedure updateRules2;
DELIMITER $
create procedure updateRules2(round int)
BEGIN
INSERT INTO Queue2(s,e,name,weight,lchild)
SELECT s, e, head, UG.weight + Q.weight, Q.id
FROM UnaryGrammar UG, Queue2 Q
WHERE UG.body = Q.name and popped = round;

INSERT INTO Queue2(s,e,name,weight,lchild,rchild)
SELECT Q1.s, Q2.e, head, UG.weight + Q1.weight + Q2.weight, Q1.id, Q2.id
FROM BinaryGrammar UG, Queue2 Q1, Queue2 Q2
WHERE Q1.popped = round and Q1.e = Q2.s and
    UG.body1 = Q1.name and UG.body2 = Q2.name;

INSERT INTO Queue2(s,e,name,weight,lchild,rchild)
SELECT Q1.s, Q2.e, head, UG.weight + Q1.weight + Q2.weight, Q1.id, Q2.id
FROM BinaryGrammar UG, Queue2 Q1, Queue2 Q2
WHERE Q2.popped = round and Q1.e = Q2.s and
    UG.body1 = Q1.name and UG.body2 = Q2.name;
END $
DELIMITER ;

drop procedure updatePopped1;
DELIMITER $
create procedure updatePopped1(round int)
BEGIN
UPDATE Queue1 SET popped = round
WHERE popped = 0
ORDER BY weight
LIMIT 5;
END $
DELIMITER ;

drop procedure updatePopped2;
DELIMITER $
create procedure updatePopped2(round int)
BEGIN
UPDATE Queue2 SET popped = round
WHERE popped = 0
ORDER BY weight
LIMIT 5;
END $
DELIMITER ;

drop procedure run;
DELIMITER $
create procedure run(len int, wanted int, root int)
BEGIN
DECLARE toDo int DEFAULT 1;
DECLARE soFar int DEFAULT 0;
DECLARE round int DEFAULT 1;
WHILE (toDo > 0 and soFar<wanted) DO
    IF (MOD(round,2) = 1) THEN
        -- select round;
        BEGIN
        CALL updatePopped1(round);
        -- select "after updatepopped";
        CALL updateRules1(round);
        -- select "after updateRules";
        CALL move1to2(wanted);
        -- select "after move";
        select COUNT(*) into toDo
            FROM Queue1
            WHERE popped = 0
            LIMIT 1;
         select COUNT(*) into soFar
            FROM Queue1
            WHERE s = 1 and e = len and name = root and popped > 0;
            -- LIMIT wanted;
        END;
        -- select "after counts";
    ELSE
        BEGIN
        CALL updatePopped2(round);
        CALL updateRules2(round);
        CALL move2to1(wanted);
        select COUNT(*) into toDo
        	-- Maybe Queue1 ?
            FROM Queue2
            WHERE popped = 0
            LIMIT 1;
        select COUNT(*) into soFar
            FROM Queue2
            WHERE s = 1 and e = len and name = root and popped > 0;
           -- LIMIT wanted
        END;
    END IF;
    SET ROUND = ROUND + 1;
END WHILE;
SELECT round;
select *
FROM Queue1
WHERE s = 1 and e = len and name = root and popped > 0;
-- LIMIT wanted;
END $
DELIMITER ;



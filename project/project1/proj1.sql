# Task1 i
CREATE VIEW q1i(namefirst, namelast, birthyear) AS
 SELECT namefirst, namelast, birthyear
 FROM people
 WHERE weight > 300;
;

# ii
CREATE VIEW q1ii(namefirst, namelast, birthyear) AS
 SELECT namefirst, namelast, birthyear
 FROM people
 WHERE namefirst LIKE "% %"
 ORDER BY namefirst, namelast;
;

# iii
CREATE VIEW q1iii(birthyear, avgheight, count) AS
 SELECT birthyear, avg(height), count(*)
 FROM people
 GROUP BY birthyear
 ORDER BY birthyear;
;

# iv
CREATE VIEW q1iv(birthyear, avgheight, count) AS
 SELECT birthyear, avg(height), count(*)
 FROM people
 GROUP BY birthyear
 HAVING avg(height) > 70
 ORDER BY birthyear;
;

# Task2
CREATE VIEW q2i(namefirst, namelast, playerID, yearid) AS
 SELECT p.namefirst, p.namelast, p.playerID, h.yearid
 FROM people AS p, halloffame AS h
 WHERE p.playerID = h.playerID
 ORDER BY h.yearid DESC , h.playerID;
;

CREATE VIEW q2ii(namefirst, namelast, playerID, schoolid, yearid) AS
 SELECT p.namefirst, p.namelast, p.playerID, s.schoolid, h.yearid
 FROM people AS p, halloffame AS h, collegeplaying AS c, schools AS s
 WHERE p.playerID = h.playerID AND c.playerid = p.playerid AND s.schoolID = c.schoolID AND s.schoolState = "CA"
 ORDER BY h.yearid DESC, s.schoolid, h.playerID;
;

CREATE VIEW q2iii(namefirst, namelast, playerID, schoolid, yearid) AS
 SELECT p.namefirst, p.namelast, p.playerID, s.schoolid, h.yearid
 FROM people AS p, halloffame AS h, collegeplaying AS c, schools AS s
 WHERE p.playerID = h.playerID AND c.playerid = p.playerid AND s.schoolID = c.schoolID AND s.schoolState = "CA"
 ORDER BY h.yearid DESC, s.schoolid, h.playerID;
;

CREATE VIEW q2iv(namefirst, namelast, playerID, schoolid) AS
 SELECT p.namefirst, p.namelast, p.playerID, c.schoolid
 FROM people AS p, halloffame AS h, collegeplaying AS c
 WHERE p.playerID = h.playerID AND c.playerid = p.playerid
 ORDER BY p.playerid DESC, c.schoolid;
;

# Task3
CREATE VIEW q3i(playerid, namefirst, namelast, slg) AS
 SELECT p.playerid, p.namefirst, p.namelast, s.slg
 FROM people AS p
 INNER JOIN
 (SELECT playerid, yearid, AB, (H + H2B + 2*H3B + 3*HR + 0.0)/(AB + 0.0) AS slg FROM batting) AS s
 ON s.playerid = p.playerid
 WHERE s.AB > 50
 ORDER BY s.slg DESC, s.yearid, s.playerid
 LIMIT 10;
;

CREATE VIEW q3ii(playerid, namefirst, namelast, lslg) AS
 SELECT p.playerid, p.namefirst, p.namelast, l.lslg
 FROM people AS p
 JOIN (SELECT playerid, (SUM(H) + SUM(H2B) + 2 * SUM(H3B) + 3 * SUM(HR) + 0.0)/(SUM(AB) + 0.0) AS lslg
       FROM batting GROUP BY playerid HAVING SUM(AB) > 50) AS l
 ON p.playerid = l.playerid
 ORDER BY l.lslg DESC, p.playerid
 LIMIT 10;
;

CREATE VIEW q3iii(namefirst, namelast, lslg) AS
 SELECT p.namefirst, p.namelast, l.lslg
 FROM people AS p
 JOIN (SELECT playerid, (SUM(H) + SUM(H2B) + 2 * SUM(H3B) + 3 * SUM(HR) + 0.0)/(SUM(AB) + 0.0) AS lslg
       FROM batting GROUP BY playerid HAVING SUM(AB) > 50) AS l
 ON p.playerid = l.playerid
 WHERE l.lslg > (SELECT (SUM(H) + SUM(H2B) + 2 * SUM(H3B) + 3 * SUM(HR) + 0.0)/(SUM(AB) + 0.0) AS lslg
        FROM batting WHERE playerid = "mayswi01")
 ORDER BY l.lslg DESC, p.playerid
 LIMIT 10;
;

#Task4
CREATE VIEW q4i(yearid, min, max, avg) AS
 SELECT yearid, max(salary), min(salary), avg(salary)
 FROM Salaries
 GROUP BY yearid
 ORDER BY yearid;
;

#Task4 ii
DROP TABLE IF EXISTS binids;
CREATE TABLE binids(binid);
INSERT INTO binids VALUES (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);

CREATE VIEW q4ii(binid, low, high, count) AS
 SELECT binid, 507500.0+binid*3249250,3756750.0+binid*3249250, count(*)
 from (SELECT CAST ((salary/width) AS INT), binstart, width
         FROM salaries, (SELECT MIN(salary), MAX(salary), CAST (((MAX(salary) - MIN(salary))/10) AS INT)
                           FROM salaries) AS bins_statistics
         WHERE yearid = 2016) AS binids ,salaries
 where (salary between 507500.0+binid*3249250 and 3756750.0+binid*3249250 )and yearID='2016'
 group by binid;
;

CREATE VIEW q4iii(yearid, mindiff, maxdiff, avgdiff) AS
 SELECT s1.yearid, min(s2.salary - s1.salary) AS mindiff, max(s2.salary - s1.salary) AS maxdiff, avg(s2.salary - s1.salary) AS avgdiff
 FROM Salaries s1 JOIN Salaries s2 ON s1.yearid = s2.yearid-1
 ORDER BY s1.yearid;
;

CREATE VIEW q4iv(playerid, salary, yearid) AS
 SELECT p.playerid, p.namefirst, p.namelast, s.salary, s.yearid
 FROM Salaries AS s
 JOIN people AS p
 ON s.playerid = p.playerid
 WHERE (s.yearid == 2000 OR s.yearid == 2001)
 GROUP BY s.yearid
 HAVING s.salary = max(s.salary);
;

CREATE VIEW q4v(playerid, namefirst, namelast, salary, yearid) AS
 SELECT a.teamid, max(s.salary) - min(s.salary)
 FROM allstarfull AS a
 JOIN Salaries AS s
 ON a.playerid = s.playerid AND a.yearid = s.yearid
 WHERE s.yearid = 2016
 GROUP BY a.teamid;
;

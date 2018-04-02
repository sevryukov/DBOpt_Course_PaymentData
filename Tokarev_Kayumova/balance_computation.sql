-- SELECT SUM(p.Amount), c.FirstName, c.SecondName FROM Payment p, Client c WHERE c.oid = p.Payer GROUP BY c.FirstName, c.SecondName;
SELECT t1.Plus - t2.Minus AS Balance, c.FirstName, c.SecondName FROM
(SELECT SUM(p.Amount) AS Plus, p.Payee FROM Payment p GROUP BY p.Payee) t1,
(SELECT SUM(p.Amount) AS Minus, p.Payer FROM Payment p GROUP BY p.Payer) t2,
  Client c
  WHERE t1.Payee = t2.Payer AND t1.Payee = c.Oid
  ORDER BY c.SecondName;
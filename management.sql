CREATE VIEW vw_management
AS
SELECT
    b.branch_id,
    b.branch_code,
    b.address AS branch_address,
   COUNT(o.order_id) AS delivered_orders_cnt,
    SUM(o.order_amount) AS delivered_amount_sum,
    o.currency AS currency
FROM dbo.cash_orders o
JOIN dbo.branches b
    ON b.branch_id = o.branch_id
JOIN dbo.order_statuses s
    ON s.status_id = o.status_id
WHERE
    s.status_name = N'Âûäàí'
    AND o.finished_at >= DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)
    AND o.finished_at <  DATEADD(MONTH, 1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1))
GROUP BY
    b.branch_id, b.branch_code, b.address, o.currency


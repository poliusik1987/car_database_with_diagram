-- левое внешнее соединение
SELECT cst.first_name, cst.last_name, cst.gender, cst.birthdate,
cst.phone_number, cst.email, csto.purchase_date, csto.warantee_expire_date
FROM Customers cst
LEFT OUTER JOIN Customer_Ownership csto
ON cst.customer_id = csto.customer_id;

-- правое внешнее соединение
SELECT cst.first_name, cst.last_name, cst.gender, cst.birthdate,
cst.phone_number, cst.email, csto.purchase_date, csto.warantee_expire_date
FROM Customers cst
RIGHT OUTER JOIN Customer_Ownership csto
ON cst.customer_id = csto.customer_id;

-- соединение при помощи союзов
SELECT brand_id FROM Models
UNION
SELECT brand_id FROM Brands;
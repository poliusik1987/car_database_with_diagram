-- запросы с подзапросами и "естественным соединением":
SELECT cs.first_name, cs.last_name, cs.phone_number, co.purchase_date, co.purchase_price, d.dealer_name
FROM Customer_Ownership AS co
NATURAL JOIN Customers AS cs 
NATURAL JOIN Dealers AS d 
WHERE d.dealer_name IN (SELECT dealer_name FROM Dealers);

SELECT cs.first_name, cs.last_name, co.purchase_price, d.dealer_name
FROM Customer_Ownership AS co
NATURAL JOIN Customers AS cs 
NATURAL JOIN Dealers AS d 
WHERE co.purchase_price = (SELECT MAX(co.purchase_price) FROM Customer_Ownership AS co);

-- подзапрос как столбец выборки (SELECT)
SELECT cs.first_name, cs.last_name, (SELECT purchase_price FROM Customer_Ownership WHERE cs.customer_id = customer_id) 
AS purchase_price
FROM Customers AS cs;

-- проверка связающих ключей
SELECT cs.first_name, cs.last_name, co.purchase_price
FROM Customers AS cs 
NATURAL JOIN Customer_Ownership AS co;

-- некоррелированный подзапрос
SELECT cs.first_name, cs.last_name, co.purchase_price
FROM Customers AS cs 
NATURAL JOIN Customer_Ownership AS co
WHERE co.purchase_price > (SELECT co.purchase_price FROM Customers AS cs  NATURAL JOIN Customer_Ownership AS co
WHERE last_name = 'Parker');

-- коррелированные запросы:
-- вывод списка покупателей, моделей автомобилей, цены, бренда и дилера
SELECT cst.first_name, cst.last_name, md.model_name, md.model_base_price, br.brand_name, d.dealer_name
FROM Customers cst
INNER JOIN Customer_Ownership co ON cst.customer_id = co.customer_id
INNER JOIN Car_Vins cr ON co.vin = cr.vin
INNER JOIN Models md ON cr.model_id = md.model_id
INNER JOIN Brands br ON md.brand_id = br.brand_id
INNER JOIN Dealers d ON co.dealer_id = d.dealer_id;

-- вывести среднеюю стоимость разных моделей автомобиля, но одного бренда
SELECT ROUND(AVG(md.model_base_price),2) AS model_base_price 
FROM Customers cst
INNER JOIN Customer_Ownership co ON cst.customer_id = co.customer_id
INNER JOIN Car_Vins cr ON co.vin = cr.vin
INNER JOIN Models md ON cr.model_id = md.model_id
INNER JOIN Brands br ON md.brand_id = br.brand_id
INNER JOIN Dealers d ON co.dealer_id = d.dealer_id
WHERE d.dealer_name = 'Joes Autos';

-- вывод разницы в стоимости моделей автомобилей и их брендов по сравнению с диалером 'Joes Autos'
SELECT cst.first_name, cst.last_name, md.model_name, md.model_base_price - 
(SELECT ROUND(AVG(md.model_base_price),2) AS model_base_price 
FROM Customers cst
INNER JOIN Customer_Ownership co ON cst.customer_id = co.customer_id
INNER JOIN Car_Vins cr ON co.vin = cr.vin
INNER JOIN Models md ON cr.model_id = md.model_id
INNER JOIN Brands br ON md.brand_id = br.brand_id
INNER JOIN Dealers d ON co.dealer_id = d.dealer_id
WHERE d.dealer_name = 'Joes Autos') AS difference_base_price, md.model_base_price, br.brand_name, d.dealer_name
FROM Customers cst
INNER JOIN Customer_Ownership co ON cst.customer_id = co.customer_id
INNER JOIN Car_Vins cr ON co.vin = cr.vin
INNER JOIN Models md ON cr.model_id = md.model_id
INNER JOIN Brands br ON md.brand_id = br.brand_id
INNER JOIN Dealers d ON co.dealer_id = d.dealer_id;

-- коррелированный подзапрос с NOT EXISTS (определение покупателя, который не совершал покупки автомобиля или
-- сведения о нем не содержатся в таблице Customer_Ownership)
SELECT cst.first_name, cst.last_name, cst.customer_id, cst.birthdate, cst.phone_number, cst.email
FROM Customers cst
WHERE NOT EXISTS 
(SELECT*FROM  Customer_Ownership csto WHERE cst.customer_id = csto.customer_id);

-- коррелированный подзапрос с EXISTS (определение покупателей, которые совершили покупки автомобилей или
-- сведения о них содержатся в таблице Customer_Ownership)
SELECT cst.first_name, cst.last_name, cst.customer_id, cst.birthdate, cst.phone_number, cst.email
FROM Customers cst
WHERE EXISTS 
(SELECT*FROM  Customer_Ownership csto WHERE cst.customer_id = csto.customer_id);




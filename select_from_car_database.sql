-- SELECT*FROM Brands;
-- SELECT*FROM Car_Options; -- описание и объединение ключей и характеристик, установленная оптимальная цена
-- SELECT*FROM Car_Parts; -- завод изготовитель
-- SELECT*FROM Car_Vins; -- заводские характеристики, дата изготовления, марка
-- SELECT*FROM Customers; -- информация о покупателях
-- SELECT*FROM Customer_Ownership; -- дата покупки, рекомендованная цена, гарантия
-- SELECT*FROM Dealers; -- информация о дилерах
-- SELECT*FROM Dealer_Brand; -- связующая таблица между брендами и дилерами
-- SELECT*FROM Manufacture_Plant; -- название завода и связующей собственника
-- SELECT*FROM Models; -- перечисление модели и связующей бренда.

-- сведения о покупателях и автомобилях, которые они приобрели
SELECT cst.first_name AS fist_name_customer, cst.last_name AS last_name_customer, cst.gender, cst.phone_number, cst.email, 
md.model_name AS model_car, br.brand_name AS brand_car, cstsh.vin AS vin_car
FROM Customers cst
INNER JOIN Customer_Ownership cstsh ON cst.customer_id = cstsh.customer_id
INNER JOIN Car_Vins crv ON cstsh.vin = crv.vin
INNER JOIN Models md ON crv.model_id = md.model_id
INNER JOIN Brands br ON br.brand_id = md.brand_id
GROUP BY vin_car;

SELECT md.model_name AS model_car, br.brand_name AS brand_car 
FROM Models md
INNER JOIN Brands br 
ON br.brand_id = md.brand_id;

-- увеличение стоимости автомобиля марки на 40% 
-- вначале выводим модель и бренд автомобиля и стоимость (заодно произведем сверку ключей)
SELECT md.model_id, cr.model_id, md.model_name, br.brand_name, cr.option_set_price
FROM Car_Options cr
INNER JOIN Models md ON md.model_id = cr.model_id
INNER JOIN Brands br ON br.brand_id = md.brand_id;

-- выборка для сверки ключей моделей и брендов автомобилей
SELECT md.model_id, cr.model_id, md.model_name, br.brand_id, br.brand_name, md.model_base_price, cr.option_set_price
FROM Car_Options cr
INNER JOIN Models md ON md.model_id = cr.model_id
INNER JOIN Brands br ON br.brand_id = md.brand_id;

-- изменение цены в соответствии с номером бренда "Boujiee"
UPDATE Models_copy
SET model_base_price = model_base_price*0.4 + model_base_price
WHERE brand_id = 5;

-- изменение цены в соответствии с номером бренда "Ferrari"
UPDATE Models_copy
SET model_base_price = model_base_price*0.4 + model_base_price
WHERE brand_id = 4;
-- вывод изменной таблицы
SELECT*FROM Models_copy;

-- изменение цены укомплектовки с указанием условий ключа привязки моделей 10-13 бренда "Ferrari" 
UPDATE Car_Options_copy
SET option_set_price = option_set_price*0.3 + option_set_price
WHERE model_id IN (10, 11, 12, 13); 
SELECT*FROM Car_Options_copy
ORDER BY model_id;

-- изменение цены укомплектовки с указанием условия ключа привязки моделей 14-15 бренда "Boujiee" 
UPDATE Car_Options_copy
SET option_set_price = option_set_price*0.4 + option_set_price
WHERE model_id IN (14, 15); 
SELECT*FROM Car_Options_copy
ORDER BY model_id;

-- вывод автомобильных характеристик с указанием рекомендованной ценой и ценой укомплектованности
SELECT row_number() OVER() AS number_str, 
md.model_name AS model_car, 
br.brand_name AS brand_car, 
cro.transmission_id AS transmission_car, 
cro.chassis_id AS chassis, 
cro.color AS color_car, 
cp.part_name,
cp.manufacture_start_date,
cp.manufacture_end_date,
mp.plant_name,
mp.plant_type,
mp.plant_location,
md.model_base_price, 
cro.option_set_price 
FROM Car_Options cro
INNER JOIN Models md ON md.model_id = cro.model_id
INNER JOIN Brands br ON br.brand_id = md.brand_id
INNER JOIN Car_Parts cp ON cro.engine_id = cp.part_id
INNER JOIN Manufacture_Plant mp ON cp.manufacture_plant_id = mp.manufacture_plant_id;
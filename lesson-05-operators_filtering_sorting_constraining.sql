/*
Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение”
1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
2. Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое 
время помещались значения в формате "20.10.2017 8:10". Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.
3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, 
если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, 
чтобы они выводились в порядке увеличения значения value. Однако, нулевые запасы должны выводиться в конце, после всех записей.
4. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. 
	Месяцы заданы в виде списка английских названий ('may', 'august')
5. (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); 
	Отсортируйте записи в порядке, заданном в списке IN.
**/

-- Решение 

-- 1.a Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.

-- 1.a добавляю в базу vk требуемые поля
-- ALTER TABLE IGNORE vk.users ADD created_at DATETIME NULL;
-- ALTER TABLE IGNORE vk.users ADD updated_at DATETIME NULL;

-- 1.b заполняем пустые полятекущей датой и временем только те поля которые являются пустыми.
/*
update users 
set created_at = IF ( created_at is null,now(),created_at) 
	,updated_at= IF ( updated_at is null,now(),updated_at)
where created_at is null or updated_at is null;
*/

/*
 * 2. Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое 
 * время помещались значения в формате "20.10.2017 8:10". Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.
*/

-- Решение

-- 2.a Подготавливаю таблицу с данными создаю текстовые поля
/*
ALTER TABLE vk.users ADD created_at_txt varchar(15) NULL;
ALTER TABLE vk.users ADD updated_at_txt varchar(15) NULL;
-- Переношу исходные данныее из полей с типом дата в тектовое поле в требуемый формат
update users 
set created_at_txt = DATE_FORMAT(created_at,"%d.%m.%Y %k:%i") 
	,updated_at_txt = DATE_FORMAT(updated_at,"%d.%m.%Y %k:%i");
-- Удаляем старые поля с типом DATETIME
ALTER TABLE vk.users DROP COLUMN created_at; -- удаляю старое поле с типом DATETIME
ALTER TABLE vk.users DROP COLUMN updated_at; -- удаляю старое поле с типом DATETIME
-- Переименовываем текстовые поля  
ALTER TABLE vk.users CHANGE created_at_txt created_at varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL;  -- переименовываем поле
ALTER TABLE vk.users CHANGE updated_at_txt updated_at varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL;  -- переименовываем поле
*/
-- 2.b. преобразование поля к типу DATETIME, сохранив введеные ранее значения.
-- добовляем новые поля для преобразования

/*
ALTER TABLE vk.users ADD created_at_new datetime NULL;
ALTER TABLE vk.users ADD updated_at_new datetime NULL;
-- заполняем данные, преобразую текстовые поля даты в тип DATETIME
update users 
set created_at_new = STR_TO_DATE(created_at,"%d.%m.%Y %k:%i") 
	,updated_at_new = STR_TO_DATE(updated_at,"%d.%m.%Y %k:%i");
-- переименовываем поля
ALTER TABLE vk.users CHANGE created_at created_at_save varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL; -- к текстовому полю добовляю префикс _save
ALTER TABLE vk.users CHANGE updated_at updated_at_save varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL; -- к текстовому полю добовляю префикс _save
ALTER TABLE vk.users CHANGE created_at_new created_at datetime NULL; -- у поля с типом DATETIME убираю префикс _new
ALTER TABLE vk.users CHANGE updated_at_new updated_at datetime NULL; -- у поля с типом DATETIME убираю префикс _new
*/

/*
 * 3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, 
 *	если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, 
 * чтобы они выводились в порядке увеличения значения value. Однако, нулевые запасы должны выводиться в конце, после всех записей.
 * 
 */

-- Решение (исспользую select для генерации таблицы) 

/*
select * from 
	(
		select 0 as `value`
		union all
		select 2500  as `value`
		union all
		select 0  as `value`
		union all
		select 30  as `value`
		union all
		select 500  as `value`
		union all
		select 1  as `value`
	) as storehouses_products
order by `value`=0,`value`; -- исспользую "=", пологаясь из условия задач, что число будет положительное, сам мы поставил "<="
*/

/*
 * 4. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. 
 *	Месяцы заданы в виде списка английских названий ('may', 'august')
 */

-- Решение

/*
select * 
from users 
where LOWER(MONTHNAME(birthday))='may';
-- перевожу наименование месяца в нижний регистр (функция "LOWER"), хотя без перевода тоже работает, но не уверен, 
-- что на других платформах SQL будет также работать, поэтому перевожу для 100% результата
*/

/*
 * 5. (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); 
	Отсортируйте записи в порядке, заданном в списке IN.
 */

-- SELECT * FROM catalogs WHERE id IN (5, 1, 2)
-- ORDER BY id<>5,id 

-- Демонстрация
/*
SELECT * FROM 
	(
	select 9 as `id`
	union all
	select 8 as `id`
	union all
	select 7 as `id`
	union all
	select 6 as `id`
	union all
	select 5 as `id`
	union all
	select 4 as `id`
	union all
	select 3 as `id`
	union all
	select 2 as `id`
	union all
	select 1 as `id`
	) as catalogs 
WHERE id IN (5, 1, 2)
ORDER BY id<>5,id 
*/



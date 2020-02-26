/*
1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users,
	catalogs и products в таблицу logs помещается время и дата создания записи, название
	таблицы, идентификатор первичного ключа и содержимое поля name.
2. (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.
*/




/* Задача №1
 *Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users,
	catalogs и products в таблицу logs помещается время и дата создания записи, название
	таблицы, идентификатор первичного ключа и содержимое поля name.
 */

use shop;

DROP TABLE IF EXISTS logs;

CREATE TABLE logs (
	`datetime` DATETIME DEFAULT NOW() NOT NULL COMMENT 'Дата и время изменения объекта',
	table_name varchar(30) NOT NULL COMMENT 'Наименование таблицы',
	id BIGINT(20) NOT NULL COMMENT 'Первичный ключ таблицы',
	name varchar(255) NOT NULL COMMENT 'Наименование записи'
)
ENGINE=ARCHIVE
DEFAULT CHARSET=utf8
COLLATE=utf8_general_ci;

#Удалёю тригеры, если они существуют
DROP TRIGGER IF EXISTS `insert_users`;
DROP TRIGGER IF EXISTS `insert_catalogs`;
DROP TRIGGER IF EXISTS `insert_products`;

DELIMITER //
CREATE TRIGGER `insert_users` AFTER INSERT ON `users`
FOR EACH ROW
BEGIN
   INSERT INTO logs Set id = NEW.id, name = NEW.name, table_name="users";
END //
CREATE TRIGGER `insert_catalogs` AFTER INSERT ON `catalogs`
FOR EACH ROW
BEGIN
   INSERT INTO logs Set id = NEW.id, name = NEW.name, table_name="catalogs";
END //
CREATE TRIGGER `insert_products` AFTER INSERT ON `products`
FOR EACH ROW
BEGIN
   INSERT INTO logs Set id = NEW.id, name = NEW.name, table_name="products";
END //
DELIMITER ;


/* Задача №2
(по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.
*/

#Удаляем процедуру, если существует
DROP PROCEDURE IF EXISTS shop.create_users;
#Создаём процедуру
DELIMITER $$
$$
CREATE DEFINER=`root`@`%` PROCEDURE `shop`.`create_users`(count_user int )
begin
	set @i := 1;
	while @i<=count_user do
		begin
			INSERT INTO users (birthday_at,name) VALUES (now(),CONCAT('Пользователь №', @i));
			set @i:=@i+1;
		end;
	end while;
end$$
DELIMITER ;
#Вызываем процедуру
CALL create_users(1000000);
#Удаляем временную хранимую процедуру
DROP PROCEDURE IF EXISTS shop.create_users;

select count("x") as `Кол-во записей в таблице logs` from logs

/*
i. Заполнить все таблицы БД vk данными (по 10-100 записей в каждой таблице)
ii. Написать скрипт, возвращающий список имен (только firstname) пользователей без повторений в алфавитном порядке
iii. Написать скрипт, отмечающий несовершеннолетних пользователей как неактивных (поле is_active = false). Предварительно добавить такое поле в таблицу profiles со значением по умолчанию = true (или 1)
iv. Написать скрипт, удаляющий сообщения «из будущего» (дата позже сегодняшней)
v. Написать название темы курсового проекта (в комментарии)
*/

/*
 * i. Заполнить все таблицы БД vk данными (по 10-100 записей в каждой таблице)
 */

-- Решение

-- Файл sql запрос по заполнению данных приведен в файле: fulldb-02-02-2020-14-13-beta.sql

use vk;

/*
 * ii. Написать скрипт, возвращающий список имен (только firstname) пользователей без повторений в алфавитном порядке
 */
-- Решение

-- SELECT DISTINCT firstname FROM users order by firstname;


/*
 * iii. Написать скрипт, отмечающий несовершеннолетних пользователей как неактивных (поле is_active = false). 
 * Предварительно добавить такое поле в таблицу profiles со значением по умолчанию = true (или 1)
 */

-- Решение

-- ALTER TABLE  vk.profiles ADD is_active BOOL DEFAULT TRUE NOT NULL;
-- UPDATE vk.profiles 
-- set is_active = FALSE 
-- where DATE_ADD(NOW(),INTERVAL -18 YEAR)<birthday


/*
 * iv. Написать скрипт, удаляющий сообщения «из будущего» (дата позже сегодняшней)
 */

-- Решение

-- delete from messages 
-- where created_at>now();

/*
 *v. Написать название темы курсового проекта (в комментарии) 
 */
 
-- Тема: Система B2B - автоматизация получения заказов от контрагентов

 
 
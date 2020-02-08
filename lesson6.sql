/* Задача 1
Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение. Агрегация данных”. Работаем с БД vk и данными, которые вы сгенерировали ранее:
1. Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, 
который больше всех общался с нашим пользователем.
2. Подсчитать общее количество лайков, которые получили пользователи младше 10 лет..
3. Определить кто больше поставил лайков (всего) - мужчины или женщины?
*/


/*
 * 1. Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, 
 * который больше всех общался с нашим пользователем.
 */

-- Решение
SET @user_id=1; #ID пользователя

/*
 Не удержался, написал как мне кажется более правильно вариант с исспользование внутреннего соединения и объединения таблиц
*/
SELECT friens.friend_id as `max_likes_friens` 
FROM 
	(
	SELECT IF (fr.target_user_id = @user_id , fr.initiator_user_id , fr.target_user_id) AS  `friend_id`
		FROM friend_requests fr
		WHERE 
			@user_id IN (fr.initiator_user_id,fr.target_user_id) 
			AND fr.status LIKE "%app%" 
	) as friens #Всех друзья требуемого пользователя, таблица будет ограничивать выборку по likes
	,likes l #Связываю внутренним соединением таблицы likes, media чтобы получить media требуемого пользователя
		inner join media m on  l.media_id = m.id
WHERE 
	l.id = friens.friend_id   # Берем все лайки пользователей, которые являются друзьями из полученной таблицы при помощи подзапроса
	AND m.user_id = @user_id  # Берем все записи media требуемого пользователя
GROUP BY friens.friend_id #Группируем по друзьям 
ORDER BY COUNT('x') DESC #Сортируем по убыванию кол-во лайков друзей
LIMIT 1 #Выводим перую запись, которая будет являться идентификатором друга, который сделал больше всех лайков

/*
 * 2. Подсчитать общее количество лайков, которые получили пользователи младше 10 лет.. 
*/

-- Решение
-- Вариант №1 Не удержался, написал правильно вариант, ниже через под запрос.
SELECT count('') as `cnt` 
	FROM profiles p 
			inner join media m ON p.user_id = m.user_id
			inner join likes l ON m.id = l.media_id 
	where 
		TIMESTAMPDIFF(YEAR, p.birthday, NOW())<10

# Вариант №2 Через подзапрос
SELECT 
	SUM(
		(SELECT COUNT('x')
			FROM likes l 
			WHERE
				l.media_id  IN (
								SELECT m.id 
									FROM media m 
									WHERE m.user_id = p.user_id 
								)		
		)) as `cnt`
	FROM profiles p 
	where 
		TIMESTAMPDIFF(YEAR, p.birthday, NOW())<10

/*
 * 3. Определить кто больше поставил лайков (всего) - мужчины или женщины?
 */

# Вариант №1 Не удержался, написал правильно вариант, ниже через под запрос.
SELECT 
	IF (p.gender = 'm','male','female') as `likes_max_gender` 
from #Связываем внутренним заединением таблицы 
	profiles p
		inner join users u ON p.user_id = u.id 
		inner join likes l ON u.id = l.user_id 
GROUP BY p.gender  #Группируем по полу
ORDER BY COUNT('x') DESC #сортируем по убыванию кол-ва лайков
LIMIT 1 #Выводим первую запись, которая будет являться максимальным кол-вом лайков по полу

# Вариант №2 Через подзапрос
SELECT 
	( # Получаем пол из подзапроса (два вложенных) через таблицу users
	SELECT IF (p.gender = 'm','male','female') 
		FROM profiles p
		WHERE p.user_id = 
				(SELECT u.id 
					FROM users u
					WHERE u.id = l.user_id)
	) as `likes_max_gender` #Сразу называю правильно алиас, что бы не "городить" еще один подзарос, для переименования алиаса 
FROM likes l
GROUP BY `likes_max_gender` #Группируем по полу
ORDER BY COUNT('x') DESC #Сортируем по убыванию кол-ва лайков
LIMIT 1 #Выводим первую запись, которая будет являться максимальным кол-вом лайков по полу


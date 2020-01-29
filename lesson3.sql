/*
Написать крипт, добавляющий в БД vk, которую создали на занятии, 3 новые таблицы (с перечнем полей, указанием индексов и внешних ключей)
*/

-- Решение

-- Таблица для связи групп и новостей в группе
DROP TABLE IF EXISTS media_communities;
CREATE TABLE media_communities(
	media_id BIGINT UNSIGNED NOT NULL
	,community_id BIGINT UNSIGNED NOT NULL
  
	,PRIMARY KEY (media_id, community_id) 
    ,FOREIGN KEY (media_id) REFERENCES media(id)
    ,FOREIGN KEY (community_id) REFERENCES communities(id)
);

-- Таблица для хранение комментариев по посту
DROP TABLE IF EXISTS comments;
CREATE TABLE comments(
	id SERIAL PRIMARY KEY
    ,user_id BIGINT UNSIGNED NOT NULL
    ,media_id BIGINT UNSIGNED NOT NULL
    ,time_at DATETIME DEFAULT NOW()
	,body TEXT
    ,INDEX (user_id)
    ,INDEX (media_id)
    ,FOREIGN KEY (user_id) REFERENCES users(id)
    ,FOREIGN KEY (media_id) REFERENCES media(id)
);

-- Таблица для хранение репостов по посту на свою страницу
DROP TABLE IF EXISTS repost_media;
CREATE TABLE repost_media(
	id SERIAL PRIMARY KEY
    ,user_id BIGINT UNSIGNED NOT NULL
    ,media_id BIGINT UNSIGNED NOT NULL
    ,time_at DATETIME DEFAULT NOW()
    ,INDEX (user_id)
    ,INDEX (media_id)
    ,FOREIGN KEY (user_id) REFERENCES users(id)
    ,FOREIGN KEY (media_id) REFERENCES media(id)
);



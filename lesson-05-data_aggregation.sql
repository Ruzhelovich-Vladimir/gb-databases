/*
 * 1. Подсчитайте средний возраст пользователей в таблице users
 * 2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
 *    Следует учесть, что необходимы дни недели текущего года, а не года рождения.
 * 3. (по желанию) Подсчитайте произведение чисел в столбце таблицы
*/

/*
 * 1. Подсчитайте средний возраст пользователей в таблице users
*/

-- Решение
-- select AVG(DATE_FORMAT(FROM_DAYS(TO_DAYS(now()) - TO_DAYS(birthday )), '%Y')) from users ;
-- разницу между текущем поментом и датой рождения преобразую в года, считаю среднее

/*
 * 2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
*/
-- Решение

-- select DAYOFWEEK(birthday) as `day_of_week`,count('x') as `count` from profiles
-- group by `day_of_week`

-- дни недели вывожу в числовом формате, т.к. в задачи небыло других условий

/*
 *  * 3. (по желанию) Подсчитайте произведение чисел в столбце таблицы
*/

-- Решение
-- x1·....· xN = exp(ln(x1)+...+ ln(xN)) - вывод из матана  сумма логорифмом = равна логирифм произведения положительных чисел
-- очень надеюсь, что они положительные

-- Демонстрация
/*
SELECT EXP(SUM(LOG(ABS(Value)))) as `result`  
FROM 
	(
	SELECT 1 AS Value
	UNION ALL
	SELECT 2 AS Value
	UNION ALL
	SELECT 3 AS Value
	UNION ALL
	SELECT 4 AS Value
	UNION ALL
	SELECT 5 AS Value
	UNION ALL
	SELECT 6 AS Value
	UNION ALL
	SELECT 7 AS Value
	UNION ALL
	SELECT 8 AS Value
	UNION ALL
	SELECT 9 AS Value
	) as  `table`  
where Value <=9

*/
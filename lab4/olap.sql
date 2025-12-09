-- 1.1. Базова статистика цін на абонементи (MIN, MAX, AVG)
-- Мета: Аналіз цінової політики.
SELECT 
    MIN(price) AS min_price,
    MAX(price) AS max_price,
    ROUND(AVG(price), 2) AS avg_price
FROM membership_plan;

-- 1.2. Кількість клієнтів за кожним статусом (GROUP BY + COUNT)
-- Мета: Оцінка активності клієнтської бази.
SELECT 
    status, 
    COUNT(*) AS client_count
FROM clients
GROUP BY status
ORDER BY client_count DESC;

-- 1.3. Загальна виручка від продажу абонементів за типами (GROUP BY + SUM)
-- Мета: Визначити найприбутковіші типи абонементів.
SELECT 
    mp.plan_name,
    COUNT(cm.client_membership_id) AS total_sold,
    SUM(mp.price) AS total_revenue
FROM membership_plan mp
JOIN client_memberships cm ON mp.plan_id = cm.plan_id
GROUP BY mp.plan_name;

-- 1.4. Фільтрація тренерів за навантаженням (GROUP BY + HAVING)
-- Мета: Знайти тренерів, які провели більше 1-го групового заняття (фільтрація груп).
SELECT 
    t.last_name,
    COUNT(gw.group_work_id) AS classes_count
FROM trainers t
JOIN group_work gw ON t.train_id = gw.train_id
GROUP BY t.last_name
HAVING COUNT(gw.group_work_id) > 1;


-- ЧАСТИНА 2: ОБ'ЄДНАННЯ ТАБЛИЦЬ (JOINS)
-- Вимоги: Мінімум 3 запити з різними типами (INNER, LEFT, RIGHT/FULL/CROSS)

-- 2.1. INNER JOIN: Список клієнтів та їх активних абонементів
-- Мета: Отримати детальну інформацію про те, хто який план купив.
-- Показує тільки тих клієнтів, у яких Є абонемент.
SELECT 
    c.last_name,
    c.first_name,
    mp.plan_name,
    cm.end_date
FROM clients c
INNER JOIN client_memberships cm ON c.client_id = cm.client_id
INNER JOIN membership_plan mp ON cm.plan_id = mp.plan_id;

-- 2.2. LEFT JOIN: Тренери та їхні індивідуальні бронювання
-- Мета: Побачити всіх тренерів, навіть тих, у кого немає бронювань.
SELECT 
    t.last_name AS trainer_name,
    t.specialization,
    b.booked_for,
    b.status
FROM trainers t
LEFT JOIN booking b ON t.train_id = b.train_id;

-- 2.3. RIGHT JOIN: Перевірка популярності планів
-- Мета: Вивести всі існуючі плани, навіть якщо їх ніхто не купував.
-- Якщо план не купували, client_last_name буде NULL.
SELECT 
    c.last_name AS client_last_name,
    mp.plan_name,
    mp.price
FROM client_memberships cm
RIGHT JOIN membership_plan mp ON cm.plan_id = mp.plan_id;


-- ЧАСТИНА 3: ПІДЗАПИТИ (SUBQUERIES)
-- Вимоги: Мінімум 3 запити (у SELECT, WHERE або HAVING)

-- 3.1. Підзапит у WHERE: Клієнти, які купили найдорожчий абонемент
-- Мета: Знайти VIP-клієнтів.
SELECT first_name, last_name, email
FROM clients
WHERE client_id IN (
    SELECT client_id 
    FROM client_memberships 
    WHERE plan_id = (
        SELECT plan_id 
        FROM membership_plan 
        ORDER BY price DESC 
        LIMIT 1
    )
);

-- 3.2. Підзапит у SELECT: Порівняння ціни плану з середньою ціною
-- Мета: Аналітика, наскільки кожен план дорожчий або дешевший за середній.
SELECT 
    plan_name, 
    price,
    ROUND(price - (SELECT AVG(price) FROM membership_plan), 2) AS diff_from_avg
FROM membership_plan;

-- 3.3. Підзапит у WHERE (NOT IN): Клієнти, які ніколи не записувалися на групові заняття
-- Мета: Маркетинговий аналіз для пропозиції групових занять.
SELECT first_name, last_name
FROM clients
WHERE client_id NOT IN (
    SELECT DISTINCT client_id 
    FROM group_booking
);
INSERT INTO trainers (first_name, last_name, phone_number, specialization) VALUES
('Олег', 'Бондаренко', '+380501112233', 'Crossfit & Powerlifting'),
('Марина', 'Коваль', '+380679998877', 'Yoga & Pilates'),
('Андрій', 'Шевченко', '+380635554433', 'Boxing'),
('Ірина', 'Мельник', '+380991234567', 'Cardio & HIIT');

INSERT INTO clients (first_name, last_name, phone_number, email, status) VALUES
('Іван', 'Петренко', '+380971112233', 'ivan.petrenko@example.com', 'active'),
('Олена', 'Сидоренко', '+380502223344', 'olena.syd@example.com', 'active'),
('Максим', 'Ткаченко', '+380933334455', 'max.tkach@example.com', 'pending'),
('Анна', 'Лисенко', '+380664445566', 'anna.lys@example.com', 'inactive'),
('Дмитро', 'Козак', '+380955556677', 'dmytro.kozak@example.com', 'banned');

INSERT INTO membership_plan (plan_name, access_lvl, duration_month, price) VALUES
('Basic Month', 'basic', 1, 800.00),
('Standard Quarter', 'standard', 3, 2200.00),
('Premium Year', 'premium', 12, 8000.00),
('VIP Unlimited', 'vip', 6, 12000.00);

INSERT INTO client_memberships (client_id, plan_id, start_date, end_date) VALUES
(1, 2, '2025-01-01', '2025-04-01'),
(2, 3, '2025-01-10', '2026-01-10'),
(3, 1, '2025-02-01', '2025-03-01');

INSERT INTO group_work (train_id, type_less, work_place, max_participants, day_of_week, start_time, end_time) VALUES
(2, 'yoga', 'studio_a', 15, 'Monday', '09:00', '10:30'),
(1, 'crossfit', 'main_hall', 10, 'Wednesday', '18:00', '19:30'),
(3, 'boxing', 'outdoor', 8, 'Friday', '17:00', '18:30');

INSERT INTO group_booking (client_id, group_id, status) VALUES
(1, 2, 'confirmed'),
(2, 1, 'confirmed'),
(3, 3, 'pending');

INSERT INTO booking (client_id, train_id, booked_for, status) VALUES
(1, 1, '2025-02-15 10:00:00', 'confirmed'),
(2, 2, '2025-02-16 11:00:00', 'confirmed'),
(4, 3, '2025-02-17 14:00:00', 'cancelled');

SELECT first_name, last_name, email 
FROM clients 
WHERE status = 'active';

SELECT plan_name, price, duration_month 
FROM membership_plan 
WHERE price > 2000;

SELECT 
    c.last_name AS Client, 
    gw.type_less AS Lesson, 
    t.last_name AS Trainer, 
    gb.status
FROM group_booking gb
JOIN clients c ON gb.client_id = c.client_id
JOIN group_work gw ON gb.group_id = gw.group_work_id
JOIN trainers t ON gw.train_id = t.train_id;

UPDATE clients
SET phone_number = '+380970000000'
WHERE client_id = 1;

UPDATE membership_plan
SET price = price * 1.10
WHERE plan_name = 'VIP Unlimited';

SELECT * FROM clients WHERE client_id = 1;
SELECT * FROM membership_plan WHERE access_lvl = 'vip';

DELETE FROM booking
WHERE status = 'cancelled';

INSERT INTO clients (first_name, last_name, phone_number, email, status) 
VALUES ('Delete', 'Me', '000', 'del@me.com', 'banned');

DELETE FROM clients 
WHERE email = 'del@me.com';

SELECT * FROM booking WHERE status = 'cancelled';
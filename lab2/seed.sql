INSERT INTO trainers (first_name, last_name, phone_number, specialization) VALUES
('Viktor', 'Kovalenko', '+380501112233', 'Crossfit & Strength'),
('Olena', 'Shevchenko', '+380975554433', 'Yoga & Pilates'),
('Andriy', 'Boyko', '+380639998877', 'Boxing'),
('Igor', 'Chumakov', '+380661234567', 'Rehabilitation');

INSERT INTO membership_plan (plan_name, access_lvl, duration_month, price) VALUES
('Start Up', 'basic', 1, 800.00),
('Stay Strong', 'standard', 3, 2200.00),
('Iron Will', 'premium', 6, 4000.00),
('No Limits', 'vip', 12, 7500.00);

INSERT INTO clients (first_name, last_name, phone_number, email, status, registration_date) VALUES
('James', 'Hetfield', '+380509990001', 'james@metallica.com', 'active', '2025-09-01'),
('Ozzy', 'Osbourne', '+380509990002', 'ozzy@blacksabbath.com', 'active', '2025-09-10'),
('Amy', 'Lee', '+380509990003', 'amy@evanescence.com', 'active', '2025-10-05'),
('Chester', 'Bennington', '+380509990004', 'chester@lp.com', 'inactive', '2024-01-20'),
('Corey', 'Taylor', '+380509990005', 'corey@slipknot.com', 'active', '2025-11-15');

INSERT INTO client_memberships (client_id, plan_id, start_date, end_date) VALUES
(1, 3, '2025-09-01', '2026-03-01'),
(2, 4, '2025-09-10', '2026-09-10'),
(3, 1, '2025-11-01', '2025-12-01'),
(5, 2, '2025-11-15', '2026-02-15');

INSERT INTO group_work (train_id, type_less, work_place, max_participants, day_of_week, start_time, end_time) VALUES
(1, 'crossfit', 'main_hall', 15, 'Monday', '18:00', '19:30'),
(2, 'yoga', 'studio_a', 10, 'Tuesday', '09:00', '10:30'),
(3, 'boxing', 'main_hall', 8, 'Wednesday', '19:00', '20:30'),
(2, 'pilates', 'studio_a', 12, 'Friday', '10:00', '11:00');

INSERT INTO group_booking (client_id, group_id, book_date, status) VALUES
(1, 1, '2025-12-01', 'confirmed'),
(2, 3, '2025-12-03', 'pending'),
(3, 2, '2025-12-02', 'confirmed'),
(5, 1, '2025-12-01', 'cancelled');

INSERT INTO booking (client_id, train_id, booked_on, booked_for, status) VALUES
(1, 1, '2025-11-28 10:00:00', '2025-12-05 14:00:00', 'confirmed'),
(2, 4, '2025-11-29 11:30:00', '2025-12-06 10:00:00', 'confirmed'),
(3, 2, '2025-11-30 09:15:00', '2025-12-07 11:00:00', 'pending');
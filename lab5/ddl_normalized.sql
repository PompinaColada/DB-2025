
-- 1. Створення ENUM типів (залишаємо ті, що є дійсно типами, а не сутностями)
CREATE TYPE client_status_type AS ENUM ('active', 'inactive', 'banned', 'pending');
CREATE TYPE access_level_type AS ENUM ('basic', 'standard', 'premium', 'vip');
CREATE TYPE lesson_type AS ENUM ('yoga', 'crossfit', 'pilates', 'boxing', 'cardio');
CREATE TYPE booking_status_type AS ENUM ('confirmed', 'cancelled', 'pending', 'completed');

-- 2. Таблиця залів (Виділено з group_work для досягнення 3NF)
-- Усуває транзитивну залежність: hall_name -> capacity
CREATE TABLE halls (
    hall_id SERIAL PRIMARY KEY,
    
    hall_name VARCHAR(50) NOT NULL UNIQUE,
    capacity INT NOT NULL CHECK (capacity > 0)
);

-- Наповнення довідника залів
INSERT INTO halls (hall_name, capacity) VALUES 
('Main Hall', 30),
('Pool', 15),
('Studio A', 10),
('Outdoor Area', 50);

-- 3. Таблиця спеціалізацій (Виділено з trainers для досягнення 1NF)
-- Усуває порушення атомарності (списки значень у комірці)
CREATE TABLE specializations (
    spec_id SERIAL PRIMARY KEY,
    spec_name VARCHAR(64) NOT NULL UNIQUE
);

INSERT INTO specializations (spec_name) VALUES 
('Yoga'), ('Pilates'), ('Crossfit'), ('Powerlifting'), ('Boxing'), ('Cardio'), ('HIIT');

-- 4. Таблиця тренерів (Нормалізована)
CREATE TABLE trainers (
    train_id SERIAL PRIMARY KEY,
    first_name VARCHAR(64) NOT NULL,
    last_name VARCHAR(64) NOT NULL,
    phone_number VARCHAR(16) NOT NULL UNIQUE
    -- Стовпець specialization видалено
);

-- 5. Таблиця зв'язку Тренер-Спеціалізація (Реалізація Many-to-Many)
CREATE TABLE trainer_specializations (
    train_id INT NOT NULL,
    spec_id INT NOT NULL,
    PRIMARY KEY (train_id, spec_id),
    FOREIGN KEY (train_id) REFERENCES trainers(train_id) ON DELETE CASCADE,
    FOREIGN KEY (spec_id) REFERENCES specializations(spec_id) ON DELETE CASCADE
);

-- 6. Таблиця клієнтів (Без змін, вже в 3NF)
CREATE TABLE clients (
    client_id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    phone_number VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    status client_status_type NOT NULL DEFAULT 'active',
    registration_date DATE DEFAULT CURRENT_DATE
);

-- 7. Таблиця планів (Без змін)
CREATE TABLE membership_plan (
    plan_id SERIAL PRIMARY KEY,
    plan_name VARCHAR(255) NOT NULL,
    access_lvl access_level_type NOT NULL,
    duration_month INT NOT NULL CHECK (duration_month > 0),
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0)
);

-- 8. Таблиця абонементів клієнтів (Нормалізована для 3NF)
-- Видалено end_date, оскільки це обчислюване поле (start_date + duration)
CREATE TABLE client_memberships (
    client_membership_id SERIAL PRIMARY KEY,
    client_id INT NOT NULL,
    plan_id INT NOT NULL,
    purchase_date DATE DEFAULT CURRENT_DATE,
    start_date DATE NOT NULL,
    FOREIGN KEY (client_id) REFERENCES clients(client_id),
    FOREIGN KEY (plan_id) REFERENCES membership_plan(plan_id)
);

-- 9. Таблиця розкладу (Нормалізована)
-- Замість work_place (enum) та max_participants використовуємо hall_id
CREATE TABLE group_work (
    group_work_id SERIAL PRIMARY KEY,
    train_id INT NOT NULL,
    hall_id INT NOT NULL, 
    type_less lesson_type NOT NULL,
    day_of_week VARCHAR(20) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    FOREIGN KEY (train_id) REFERENCES trainers(train_id),
    FOREIGN KEY (hall_id) REFERENCES halls(hall_id)
);

-- 10. Бронювання (Без змін)
CREATE TABLE group_booking (
    book_id SERIAL PRIMARY KEY,
    client_id INT NOT NULL,
    group_id INT NOT NULL,
    book_date DATE DEFAULT CURRENT_DATE,
    status booking_status_type NOT NULL DEFAULT 'pending',
    FOREIGN KEY (client_id) REFERENCES clients(client_id),
    FOREIGN KEY (group_id) REFERENCES group_work(group_work_id)
);

CREATE TABLE booking (
    book_id SERIAL PRIMARY KEY,
    client_id INT NOT NULL,
    train_id INT NOT NULL,
    booked_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    booked_for TIMESTAMP NOT NULL,
    status booking_status_type NOT NULL DEFAULT 'confirmed',
    FOREIGN KEY (client_id) REFERENCES clients(client_id),
    FOREIGN KEY (train_id) REFERENCES trainers(train_id)
);
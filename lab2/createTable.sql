CREATE TYPE client_status_type AS ENUM ('active', 'inactive', 'banned', 'pending');
CREATE TYPE access_level_type AS ENUM ('basic', 'standard', 'premium', 'vip');
CREATE TYPE lesson_type AS ENUM ('yoga', 'crossfit', 'pilates', 'boxing', 'cardio');
CREATE TYPE workplace_type AS ENUM ('main_hall', 'pool', 'studio_a', 'outdoor');
CREATE TYPE booking_status_type AS ENUM ('confirmed', 'cancelled', 'pending', 'completed');

CREATE TABLE trainers (
    train_id SERIAL PRIMARY KEY,
    first_name VARCHAR(64) NOT NULL,
    last_name VARCHAR(64) NOT NULL,
    phone_number VARCHAR(16) NOT NULL UNIQUE,
    specialization VARCHAR(128)
);

CREATE TABLE clients (
    client_id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    phone_number VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    status client_status_type NOT NULL DEFAULT 'active',
    registration_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE membership_plan (
    plan_id SERIAL PRIMARY KEY,
    plan_name VARCHAR(255) NOT NULL,
    access_lvl access_level_type NOT NULL,
    duration_month INT NOT NULL CHECK (duration_month > 0),
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0)
);

CREATE TABLE client_memberships (
    client_membership_id SERIAL PRIMARY KEY,
    client_id INT NOT NULL,
    plan_id INT NOT NULL,
    purchase_date DATE DEFAULT CURRENT_DATE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    FOREIGN KEY (client_id) REFERENCES clients(client_id),
    FOREIGN KEY (plan_id) REFERENCES membership_plan(plan_id),
    CHECK (end_date >= start_date)
);

CREATE TABLE group_work (
    group_work_id SERIAL PRIMARY KEY,
    train_id INT NOT NULL,
    type_less lesson_type NOT NULL,
    work_place workplace_type NOT NULL,
    max_participants INT DEFAULT 10 CHECK (max_participants > 0),
    day_of_week VARCHAR(20) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    FOREIGN KEY (train_id) REFERENCES trainers(train_id)
);

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
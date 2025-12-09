## Аналіз функціональних залежностей (Початкова схема)

### 1. Таблиця `clients` (Клієнти)

- **Атрибути:** `client_id`, `first_name`, `last_name`, `phone_number`, `email`, `status`, `registration_date`.
- **Первинний ключ:** `client_id`.

**Функціональні залежності:**

1.  `client_id` -> `first_name`, `last_name`, `phone_number`, `email`, `status`, `registration_date` (Пряма залежність від PK).
2.  `email` -> `client_id`, `first_name`, `last_name`, `phone_number`, `status`, `registration_date` (Унікальний атрибут).
3.  `phone_number` -> `client_id`, `first_name`, `last_name`, `email`, `status`, `registration_date` (Унікальний атрибут).

**Висновок:** Таблиця знаходиться в 3NF. Аномалій не виявлено.

---

### 2. Таблиця `trainers` (Тренери)

- **Атрибути:** `train_id`, `first_name`, `last_name`, `phone_number`, `specialization`.
- **Первинний ключ:** `train_id`.

**Функціональні залежності:**

1.  `train_id` -> `first_name`, `last_name`, `phone_number`, `specialization`.
2.  `phone_number` -> `train_id`, `first_name`, `last_name`, `specialization`.

**Аналіз порушень:**

- **Порушення 1NF:** Атрибут `specialization` містить неатомарні значення (списки спеціалізацій, наприклад, "Yoga, Pilates"). Це вимагає декомпозиції.

---

### 3. Таблиця `membership_plan` (Плани підписки)

- **Атрибути:** `plan_id`, `plan_name`, `access_lvl`, `duration_month`, `price`.
- **Первинний ключ:** `plan_id`.

**Функціональні залежності:**

1.  `plan_id` -> `plan_name`, `access_lvl`, `duration_month`, `price`.
2.  `plan_name` -> `plan_id`, `access_lvl`, `duration_month`, `price` (Назва плану унікальна).

**Висновок:** Таблиця знаходиться в 3NF.

---

### 4. Таблиця `client_memberships` (Абонементи клієнтів)

- **Атрибути:** `client_membership_id`, `client_id`, `plan_id`, `purchase_date`, `start_date`, `end_date`.
- **Первинний ключ:** `client_membership_id`.

**Функціональні залежності:**

1.  `client_membership_id` -> `client_id`, `plan_id`, `purchase_date`, `start_date`, `end_date`.
2.  `{start_date, plan_id}` -> `end_date`.

**Аналіз порушень:**

- **Порушення 3NF:** Існує транзитивна залежність. `end_date` залежить не лише від первинного ключа, а логічно випливає з `start_date` та тривалості, яка прихована у `plan_id`. Це створює надлишковість.

---

### 5. Таблиця `group_work` (Розклад занять)

- **Атрибути:** `group_work_id`, `train_id`, `type_less`, `work_place`, `max_participants`, `day_of_week`, `start_time`, `end_time`.
- **Первинний ключ:** `group_work_id`.

**Функціональні залежності:**

1.  `group_work_id` -> `train_id`, `type_less`, `work_place`, `max_participants`, `day_of_week`, `start_time`, `end_time`.
2.  `work_place` -> `max_participants`.

**Аналіз порушень:**

- **Порушення 3NF (Транзитивна залежність):** Атрибут `max_participants` залежить від неключового атрибута `work_place` (місткість є властивістю зали, а не конкретного заняття).
- Залежність виглядає так: `group_work_id` -> `work_place` -> `max_participants`.

---

### 6. Таблиця `group_booking` (Бронювання груп)

- **Атрибути:** `book_id`, `client_id`, `group_id`, `book_date`, `status`.
- **Первинний ключ:** `book_id`.

**Функціональні залежності:**

1.  `book_id` -> `client_id`, `group_id`, `book_date`, `status`.
2.  `{client_id, group_id}` -> `book_id`, `book_date`, `status` (Унікальність запису клієнта на конкретне заняття).

**Висновок:** Таблиця знаходиться в 3NF.

---

### 7. Таблиця `booking` (Індивідуальні бронювання)

- **Атрибути:** `book_id`, `client_id`, `train_id`, `booked_on`, `booked_for`, `status`.
- **Первинний ключ:** `book_id`.

**Функціональні залежності:**

1.  `book_id` -> `client_id`, `train_id`, `booked_on`, `booked_for`, `status`.
2.  `{train_id, booked_for}` -> `client_id`, `status` (Тренер не може мати двох клієнтів одночасно).

**Висновок:** Таблиця знаходиться в 3NF.

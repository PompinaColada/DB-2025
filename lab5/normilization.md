### 1. Таблиця `trainers` (Тренери)

- **Атрибути:** `train_id`, `first_name`, `last_name`, `phone_number`, `specialization`.
- **Первинний ключ:** `train_id`.

**Функціональні залежності:**

1.  `train_id` -> `first_name`, `last_name`, `phone_number`, `specialization`.
2.  `phone_number` -> `train_id`, `first_name`, `last_name`, `specialization`.

**Аналіз порушень:**

- **Порушення 1NF:** Атрибут `specialization` містить неатомарні значення (списки спеціалізацій в одній комірці, наприклад, "Yoga, Pilates"). Це ускладнює пошук та фільтрацію.

**Вирішення:**

- **Декомпозиція:** Видалити стовпець `specialization` з таблиці `trainers`.
- **Нові сутності:** Створити довідник `specializations` (`spec_id`, `spec_name`).
- **Зв'язок:** Створити проміжну таблицю `trainer_specializations` (`train_id`, `spec_id`) для реалізації зв'язку "багато-до-багатьох" між тренерами та їх навичками.

---

### 2. Таблиця `client_memberships` (Абонементи клієнтів)

- **Атрибути:** `client_membership_id`, `client_id`, `plan_id`, `purchase_date`, `start_date`, `end_date`.
- **Первинний ключ:** `client_membership_id`.

**Функціональні залежності:**

1.  `client_membership_id` -> `client_id`, `plan_id`, `purchase_date`, `start_date`, `end_date`.
2.  `{start_date, plan_id}` -> `end_date`.

**Аналіз порушень:**

- **Порушення 3NF:** Існує транзитивна залежність. `end_date` (дата закінчення) логічно випливає з `start_date` та тривалості плану (яка зберігається в таблиці `membership_plan` під `plan_id`). Зберігання обчислюваного поля створює надлишковість та ризик розсинхронізації даних.

**Вирішення:**

- **Видалення атрибута:** Видалити стовпець `end_date` з таблиці.
- **Обчислення:** Дату закінчення слід обчислювати динамічно під час виконання запитів (`SELECT`) або на рівні додатку, додаючи тривалість плану до дати початку.

---

### 3. Таблиця `group_work` (Розклад занять)

- **Атрибути:** `group_work_id`, `train_id`, `type_less`, `work_place`, `max_participants`, `day_of_week`, `start_time`, `end_time`.
- **Первинний ключ:** `group_work_id`.

**Функціональні залежності:**

1.  `group_work_id` -> `train_id`, `type_less`, `work_place`, `max_participants`, `day_of_week`, `start_time`, `end_time`.
2.  `work_place` -> `max_participants`.

**Аналіз порушень:**

- **Порушення 3NF (Транзитивна залежність):** Атрибут `max_participants` залежить від неключового атрибута `work_place`. Місткість є характеристикою зали, а не конкретного заняття в розкладі. Якщо зміниться місткість зали "Main Hall", доведеться оновлювати всі записи в розкладі.

**Вирішення:**

- **Нормалізація:** Винести дані про зали в окрему таблицю `halls` (`hall_id`, `hall_name`, `capacity`).
- **Зв'язок:** У таблиці `group_work` замінити поля `work_place` та `max_participants` на зовнішній ключ `hall_id`. Це гарантує, що інформація про місткість зберігається лише в одному місці.

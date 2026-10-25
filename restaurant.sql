-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Фев 26 2026 г., 15:12
-- Версия сервера: 8.0.30
-- Версия PHP: 7.4.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `restaurant`
--

-- --------------------------------------------------------

--
-- Структура таблицы `bills`
--

CREATE TABLE `bills` (
  `bill_id` int NOT NULL,
  `order_id` int DEFAULT NULL,
  `tip_amount` decimal(10,2) DEFAULT NULL,
  `discount` int DEFAULT NULL,
  `full_sum` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `bills`
--

INSERT INTO `bills` (`bill_id`, `order_id`, `tip_amount`, `discount`, `full_sum`) VALUES
(1, 1, '200.00', 0, '1080.00'),
(2, 2, '150.00', 10, '1188.00'),
(3, 3, '0.00', 0, '350.00'),
(4, 4, '100.00', 0, '1080.00'),
(5, 5, '300.00', 15, '2125.00'),
(10, 18, '0.00', 0, '900.00'),
(11, 19, '0.00', 0, '5110.00');

-- --------------------------------------------------------

--
-- Структура таблицы `dishes`
--

CREATE TABLE `dishes` (
  `dish_id` int NOT NULL,
  `name` varchar(30) DEFAULT NULL,
  `pic` varchar(255) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `category_id` int DEFAULT NULL,
  `cook_time` time DEFAULT NULL,
  `is_available` tinyint(1) DEFAULT NULL,
  `dish_description` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `dishes`
--

INSERT INTO `dishes` (`dish_id`, `name`, `pic`, `price`, `category_id`, `cook_time`, `is_available`, `dish_description`) VALUES
(1, 'Цезарь с курицей', 'images/cezar.png', '450.00', 2, '00:15:00', 1, 'Классический салат с курицей и соусом Цезарь'),
(2, 'Борщ', 'images/borsh.jpg', '320.00', 4, '00:20:00', 1, 'Украинский борщ с пампушками'),
(3, 'Картошка фри', 'images/fries.png', '180.00', 1, '00:10:00', 1, 'Хрустящий картофель фри'),
(4, 'Куриная котлета', 'images/cutlet.jpg', '290.00', 3, '00:15:00', 1, 'Котлета из куриного филе'),
(5, 'Чизкейк', 'images/cheesecake.jpg', '350.00', 5, '00:05:00', 1, 'Нью-йоркский чизкейк');

-- --------------------------------------------------------

--
-- Структура таблицы `dish_categories`
--

CREATE TABLE `dish_categories` (
  `category_id` int NOT NULL,
  `name` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `dish_categories`
--

INSERT INTO `dish_categories` (`category_id`, `name`) VALUES
(1, 'Закуски'),
(2, 'Салаты'),
(3, 'Горячие блюда'),
(4, 'Супы'),
(5, 'Десерты');

-- --------------------------------------------------------

--
-- Структура таблицы `dish_ingredients`
--

CREATE TABLE `dish_ingredients` (
  `dish_id` int DEFAULT NULL,
  `ingredient_id` int DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `dish_ingredients`
--

INSERT INTO `dish_ingredients` (`dish_id`, `ingredient_id`, `amount`) VALUES
(1, 2, '0.15'),
(1, 3, '0.10'),
(1, 4, '0.05'),
(3, 1, '0.20'),
(4, 2, '0.20');

-- --------------------------------------------------------

--
-- Структура таблицы `ingredients`
--

CREATE TABLE `ingredients` (
  `ing_id` int NOT NULL,
  `name` varchar(30) DEFAULT NULL,
  `measure_unit` enum('кг','шт','л') DEFAULT NULL,
  `amount_in_stock` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `ingredients`
--

INSERT INTO `ingredients` (`ing_id`, `name`, `measure_unit`, `amount_in_stock`) VALUES
(1, 'Картофель', 'кг', '15.50'),
(2, 'Куриное филе', 'кг', '8.20'),
(3, 'Помидоры', 'кг', '5.00'),
(4, 'Сыр', 'кг', '3.50'),
(5, 'Молоко', 'л', '10.00');

-- --------------------------------------------------------

--
-- Структура таблицы `ingredient_requests`
--

CREATE TABLE `ingredient_requests` (
  `request_id` int NOT NULL,
  `user_id` int DEFAULT NULL,
  `ingridient_id` int DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `request_date` date DEFAULT NULL,
  `status` enum('В ожидании','Выполнена') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `ingredient_requests`
--

INSERT INTO `ingredient_requests` (`request_id`, `user_id`, `ingridient_id`, `quantity`, `request_date`, `status`) VALUES
(1, 3, 1, 10, '2024-01-15', 'Выполнена'),
(2, 3, 2, 5, '2024-01-15', 'Выполнена'),
(3, 4, 4, 2, '2024-01-16', 'В ожидании'),
(4, 3, 5, 8, '2024-01-16', 'В ожидании'),
(5, 4, 3, 3, '2024-01-16', 'В ожидании');

-- --------------------------------------------------------

--
-- Структура таблицы `orders`
--

CREATE TABLE `orders` (
  `order_id` int NOT NULL,
  `comments` text,
  `waiter_id` int DEFAULT NULL,
  `table_id` int DEFAULT NULL,
  `order_time` datetime DEFAULT NULL,
  `status` enum('Обрабатывается','В работе','Готов','Завершен') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `orders`
--

INSERT INTO `orders` (`order_id`, `comments`, `waiter_id`, `table_id`, `order_time`, `status`) VALUES
(1, 'Без острого', 1, 3, '2026-02-15 18:30:00', 'Обрабатывается'),
(2, '', 1, 2, '2026-01-15 19:00:00', 'В работе'),
(3, 'Побыстрее', 2, 1, '2026-02-15 19:30:00', 'Обрабатывается'),
(4, '', 1, 19, '2026-02-16 13:15:00', 'Завершен'),
(5, 'Спасибо', 2, 4, '2026-02-16 14:00:00', 'Готов'),
(18, '', 1, 5, '2026-02-24 23:56:57', 'Завершен'),
(19, '', 1, 20, '2026-02-26 14:24:07', 'Обрабатывается');

-- --------------------------------------------------------

--
-- Структура таблицы `order_items`
--

CREATE TABLE `order_items` (
  `order_id` int DEFAULT NULL,
  `dish_id` int DEFAULT NULL,
  `quantity` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `order_items`
--

INSERT INTO `order_items` (`order_id`, `dish_id`, `quantity`) VALUES
(1, 1, 2),
(1, 3, 1),
(2, 2, 2),
(2, 4, 2),
(3, 5, 1),
(18, 1, 2),
(19, 4, 4),
(19, 5, 10),
(19, 1, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `reviews`
--

CREATE TABLE `reviews` (
  `comment_id` int NOT NULL,
  `user_id` int DEFAULT NULL,
  `dish_id` int DEFAULT NULL,
  `text` text,
  `rate` enum('1','2','3','4','5') DEFAULT NULL,
  `comment_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `reviews`
--

INSERT INTO `reviews` (`comment_id`, `user_id`, `dish_id`, `text`, `rate`, `comment_date`) VALUES
(1, 5, 1, 'Очень вкусный салат!', '5', '2024-01-16 20:30:00'),
(2, 5, 2, 'Борщ отличный, но пампушек мало', '4', '2024-01-16 20:31:00'),
(3, 5, 3, 'Хрустящая, вкусная', '5', '2024-01-16 20:32:00'),
(4, 5, 4, 'Немного суховата', '3', '2024-01-16 20:33:00'),
(5, 5, 5, 'Лучший чизкейк в городе', '5', '2024-01-16 20:34:00');

-- --------------------------------------------------------

--
-- Структура таблицы `status_change_logs`
--

CREATE TABLE `status_change_logs` (
  `log_id` int NOT NULL,
  `user_id` int DEFAULT NULL,
  `order_id` int DEFAULT NULL,
  `change_time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `status_change_logs`
--

INSERT INTO `status_change_logs` (`log_id`, `user_id`, `order_id`, `change_time`) VALUES
(1, 1, 1, '2024-01-15 18:35:00'),
(2, 3, 1, '2024-01-15 18:50:00'),
(3, 3, 2, '2024-01-15 19:15:00'),
(4, 2, 3, '2024-01-15 19:35:00'),
(5, 4, 4, '2024-01-16 13:30:00');

-- --------------------------------------------------------

--
-- Структура таблицы `tables`
--

CREATE TABLE `tables` (
  `table_id` int NOT NULL,
  `status` enum('Свободен','Занят','Не убран','Зарезервировано') DEFAULT NULL,
  `chair_nums` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `tables`
--

INSERT INTO `tables` (`table_id`, `status`, `chair_nums`) VALUES
(1, 'Занят', 2),
(2, 'Занят', 4),
(3, 'Занят', 4),
(4, 'Занят', 6),
(5, 'Свободен', 2),
(6, 'Свободен', 2),
(7, 'Свободен', 2),
(8, 'Свободен', 4),
(9, 'Свободен', 4),
(10, 'Зарезервировано', 4),
(11, 'Зарезервировано', 6),
(12, 'Не убран', 2),
(13, 'Свободен', 4),
(14, 'Свободен', 4),
(15, 'Свободен', 6),
(16, 'Свободен', 2),
(17, 'Свободен', 4),
(18, 'Свободен', 4),
(19, 'Занят', 6),
(20, 'Занят', 2);

-- --------------------------------------------------------

--
-- Структура таблицы `table_bookings`
--

CREATE TABLE `table_bookings` (
  `booking_id` int NOT NULL,
  `table_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `booking_date` datetime DEFAULT NULL,
  `contact` varchar(30) DEFAULT NULL,
  `guests_num` int DEFAULT NULL,
  `status` enum('активна','отменена') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `table_bookings`
--

INSERT INTO `table_bookings` (`booking_id`, `table_id`, `user_id`, `booking_date`, `contact`, `guests_num`, `status`) VALUES
(1, 2, 5, '2024-01-20 19:00:00', '+7(999)555-66-77', 4, 'активна'),
(2, 4, 5, '2024-01-21 18:30:00', '+7(999)555-66-77', 5, 'активна'),
(3, 1, 5, '2024-01-15 13:00:00', '+7(999)555-66-77', 2, 'отменена'),
(4, 3, 5, '2024-01-22 20:00:00', '+7(999)555-66-77', 4, 'активна'),
(5, 5, 5, '2024-01-15 12:00:00', '+7(999)555-66-77', 2, 'отменена');

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `user_id` int NOT NULL,
  `username` varchar(30) DEFAULT NULL,
  `password` varchar(30) DEFAULT NULL,
  `name` varchar(30) DEFAULT NULL,
  `surname` varchar(30) DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `role` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`user_id`, `username`, `password`, `name`, `surname`, `phone`, `role`) VALUES
(1, 'ivanov', 'pass123', 'Иван', 'Иванов', '+7(999)111-22-33', 'официант'),
(2, 'petrova', 'pass123', 'Мария', 'Петрова', '+7(999)222-33-44', 'официант'),
(3, 'sidorov', 'pass123', 'Петр', 'Сидоров', '+7(999)333-44-55', 'повар'),
(4, 'smirnova', 'pass123', 'Анна', 'Смирнова', '+7(999)444-55-66', 'повар'),
(5, 'kozlov', 'pass123', 'Алексей', 'Козлов', '+7(999)555-66-77', 'гость');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `bills`
--
ALTER TABLE `bills`
  ADD PRIMARY KEY (`bill_id`),
  ADD KEY `order_id` (`order_id`);

--
-- Индексы таблицы `dishes`
--
ALTER TABLE `dishes`
  ADD PRIMARY KEY (`dish_id`),
  ADD KEY `category_id` (`category_id`);

--
-- Индексы таблицы `dish_categories`
--
ALTER TABLE `dish_categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Индексы таблицы `dish_ingredients`
--
ALTER TABLE `dish_ingredients`
  ADD KEY `dish_id` (`dish_id`),
  ADD KEY `ingredient_id` (`ingredient_id`);

--
-- Индексы таблицы `ingredients`
--
ALTER TABLE `ingredients`
  ADD PRIMARY KEY (`ing_id`);

--
-- Индексы таблицы `ingredient_requests`
--
ALTER TABLE `ingredient_requests`
  ADD PRIMARY KEY (`request_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `ingridient_id` (`ingridient_id`);

--
-- Индексы таблицы `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `user_id` (`waiter_id`),
  ADD KEY `table_id` (`table_id`);

--
-- Индексы таблицы `order_items`
--
ALTER TABLE `order_items`
  ADD KEY `order_id` (`order_id`),
  ADD KEY `dish_id` (`dish_id`);

--
-- Индексы таблицы `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`comment_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `dish_id` (`dish_id`);

--
-- Индексы таблицы `status_change_logs`
--
ALTER TABLE `status_change_logs`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `order_id` (`order_id`);

--
-- Индексы таблицы `tables`
--
ALTER TABLE `tables`
  ADD PRIMARY KEY (`table_id`);

--
-- Индексы таблицы `table_bookings`
--
ALTER TABLE `table_bookings`
  ADD PRIMARY KEY (`booking_id`),
  ADD KEY `table_id` (`table_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `bills`
--
ALTER TABLE `bills`
  MODIFY `bill_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT для таблицы `dishes`
--
ALTER TABLE `dishes`
  MODIFY `dish_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT для таблицы `dish_categories`
--
ALTER TABLE `dish_categories`
  MODIFY `category_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT для таблицы `ingredients`
--
ALTER TABLE `ingredients`
  MODIFY `ing_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT для таблицы `ingredient_requests`
--
ALTER TABLE `ingredient_requests`
  MODIFY `request_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT для таблицы `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT для таблицы `reviews`
--
ALTER TABLE `reviews`
  MODIFY `comment_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT для таблицы `status_change_logs`
--
ALTER TABLE `status_change_logs`
  MODIFY `log_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT для таблицы `tables`
--
ALTER TABLE `tables`
  MODIFY `table_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT для таблицы `table_bookings`
--
ALTER TABLE `table_bookings`
  MODIFY `booking_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `bills`
--
ALTER TABLE `bills`
  ADD CONSTRAINT `bills_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`);

--
-- Ограничения внешнего ключа таблицы `dishes`
--
ALTER TABLE `dishes`
  ADD CONSTRAINT `dishes_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `dish_categories` (`category_id`);

--
-- Ограничения внешнего ключа таблицы `dish_ingredients`
--
ALTER TABLE `dish_ingredients`
  ADD CONSTRAINT `dish_ingredients_ibfk_1` FOREIGN KEY (`dish_id`) REFERENCES `dishes` (`dish_id`),
  ADD CONSTRAINT `dish_ingredients_ibfk_2` FOREIGN KEY (`ingredient_id`) REFERENCES `ingredients` (`ing_id`);

--
-- Ограничения внешнего ключа таблицы `ingredient_requests`
--
ALTER TABLE `ingredient_requests`
  ADD CONSTRAINT `ingredient_requests_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `ingredient_requests_ibfk_2` FOREIGN KEY (`ingridient_id`) REFERENCES `ingredients` (`ing_id`);

--
-- Ограничения внешнего ключа таблицы `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`waiter_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`table_id`) REFERENCES `tables` (`table_id`);

--
-- Ограничения внешнего ключа таблицы `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`dish_id`) REFERENCES `dishes` (`dish_id`);

--
-- Ограничения внешнего ключа таблицы `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`dish_id`) REFERENCES `dishes` (`dish_id`);

--
-- Ограничения внешнего ключа таблицы `status_change_logs`
--
ALTER TABLE `status_change_logs`
  ADD CONSTRAINT `status_change_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `status_change_logs_ibfk_2` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`);

--
-- Ограничения внешнего ключа таблицы `table_bookings`
--
ALTER TABLE `table_bookings`
  ADD CONSTRAINT `table_bookings_ibfk_1` FOREIGN KEY (`table_id`) REFERENCES `tables` (`table_id`),
  ADD CONSTRAINT `table_bookings_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

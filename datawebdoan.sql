
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `db_admin`
--

DROP TABLE IF EXISTS `db_admin`;
CREATE TABLE IF NOT EXISTS `db_admin` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `fullname` varchar(255) NOT NULL,
  `mail` varchar(255) NOT NULL,
  `phone` varchar(10) NOT NULL,
  `address` varchar(255) NOT NULL,
  `role` enum('admin','manager') NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
)ENGINE = InnoDB;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `db_brand`
--

DROP TABLE IF EXISTS `db_brand`;
CREATE TABLE IF NOT EXISTS `db_brand` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `code` varchar(255) NOT NULL,
  `image` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `create_date` varchar(255) NOT NULL,
  `user` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
)ENGINE = InnoDB;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `db_cart`
--

DROP TABLE IF EXISTS `db_cart`;
CREATE TABLE IF NOT EXISTS `db_cart` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_customer` int NOT NULL,
  `total_num` int NOT NULL,
  `total_price` float NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_customer` (`id_customer`)
)ENGINE = InnoDB;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `db_category`
--

DROP TABLE IF EXISTS `db_category`;
CREATE TABLE IF NOT EXISTS `db_category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `code` varchar(255) NOT NULL,
  `image` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `create_date` varchar(255) NOT NULL,
  `user` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
)ENGINE = InnoDB;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `db_customer`
--

DROP TABLE IF EXISTS `db_customer`;
CREATE TABLE IF NOT EXISTS `db_customer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `fullname` varchar(255) NOT NULL,
  `mail` varchar(255) NOT NULL,
  `phone` varchar(10) NOT NULL,
  `address` text NOT NULL,
  `create_date` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
)ENGINE = InnoDB;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `db_detail_cart`
--

DROP TABLE IF EXISTS `db_detail_cart`;
CREATE TABLE IF NOT EXISTS `db_detail_cart` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_cart` int NOT NULL,
  `id_product` int NOT NULL,
  `num_total` int NOT NULL,
  `sub_total_price` float NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_cart` (`id_cart`),
  KEY `id_product` (`id_product`)
)ENGINE = InnoDB;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `db_detail_order`
--

DROP TABLE IF EXISTS `db_detail_order`;
CREATE TABLE IF NOT EXISTS `db_detail_order` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_order` int NOT NULL,
  `id_product` int NOT NULL,
  `qty` int NOT NULL,
  `sub_total_price` float NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_product` (`id_product`),
  KEY `id_order` (`id_order`)
)ENGINE = InnoDB;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `db_order`
--

DROP TABLE IF EXISTS `db_order`;
CREATE TABLE IF NOT EXISTS `db_order` (
  `id` int NOT NULL AUTO_INCREMENT,
  `custom_id` int NOT NULL,
  `total_price` float NOT NULL,
  `total_num_product` int NOT NULL,
  `create_date` varchar(255) NOT NULL,
  `note` text NOT NULL,
  `payment_method` varchar(255) NOT NULL,
  `status` enum('Thành công','Chờ xác nhận','Hủy','') NOT NULL,
  `id_cart` int NOT NULL,
  `time` varchar(255) NOT NULL,
  `code` varchar(255) NOT NULL,
  `date_confirm` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_cart` (`id_cart`),
  KEY `db_order_ibfk_1` (`custom_id`)
)ENGINE = InnoDB;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `db_product`
--

DROP TABLE IF EXISTS `db_product`;
CREATE TABLE IF NOT EXISTS `db_product` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_category` int NOT NULL,
  `id_brand` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `code` varchar(255) NOT NULL,
  `price` float NOT NULL,
  `quantity` int NOT NULL,
  `status` enum('còn hàng','hết hàng','hàng sắp về') NOT NULL,
  `description` text NOT NULL,
  `screen` varchar(255) NOT NULL,
  `ram` varchar(255) NOT NULL,
  `cpu` varchar(255) NOT NULL,
  `memory` varchar(255) NOT NULL,
  `operating_system` varchar(255) NOT NULL,
  `front_camera` varchar(255) NOT NULL,
  `rear_camera` varchar(255) NOT NULL,
  `user` varchar(255) NOT NULL,
  `create_date` varchar(255) NOT NULL,
  `image` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_brand` (`id_brand`),
  KEY `id_category` (`id_category`)
)ENGINE = InnoDB;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `db_slider`
--

DROP TABLE IF EXISTS `db_slider`;
CREATE TABLE IF NOT EXISTS `db_slider` (
  `id` int NOT NULL AUTO_INCREMENT,
  `image` varchar(255) NOT NULL,
  `user` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
)ENGINE = InnoDB;

--
-- Các ràng buộc cho bảng `db_cart`
--
ALTER TABLE `db_cart`
  ADD CONSTRAINT `db_cart_ibfk_1` FOREIGN KEY (`id_customer`) REFERENCES `db_customer` (`id`);

--
-- Các ràng buộc cho bảng `db_detail_cart`
--
ALTER TABLE `db_detail_cart`
  ADD CONSTRAINT `db_detail_cart_ibfk_1` FOREIGN KEY (`id_cart`) REFERENCES `db_cart` (`id`),
  ADD CONSTRAINT `db_detail_cart_ibfk_2` FOREIGN KEY (`id_product`) REFERENCES `db_product` (`id`);

--
-- Các ràng buộc cho bảng `db_detail_order`
--
ALTER TABLE `db_detail_order`
  ADD CONSTRAINT `db_detail_order_ibfk_1` FOREIGN KEY (`id_product`) REFERENCES `db_product` (`id`),
  ADD CONSTRAINT `db_detail_order_ibfk_2` FOREIGN KEY (`id_order`) REFERENCES `db_order` (`id`);

--
-- Các ràng buộc cho bảng `db_order`
--
ALTER TABLE `db_order`
  ADD CONSTRAINT `db_order_ibfk_1` FOREIGN KEY (`custom_id`) REFERENCES `db_customer` (`id`),
  ADD CONSTRAINT `db_order_ibfk_2` FOREIGN KEY (`id_cart`) REFERENCES `db_cart` (`id`);

--
-- Các ràng buộc cho bảng `db_product`
--
ALTER TABLE `db_product`
  ADD CONSTRAINT `db_product_ibfk_1` FOREIGN KEY (`id_brand`) REFERENCES `db_brand` (`id`),
  ADD CONSTRAINT `db_product_ibfk_2` FOREIGN KEY (`id_category`) REFERENCES `db_category` (`id`);

COMMIT;

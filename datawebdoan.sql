-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1:3306
-- Thời gian đã tạo: Th12 11, 2024 lúc 10:44 AM
-- Phiên bản máy phục vụ: 8.3.0
-- Phiên bản PHP: 8.2.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `webdoan`
--

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
  `mail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `phone` varchar(10) NOT NULL,
  `address` varchar(255) NOT NULL,
  `role` enum('admin','manager') NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng `db_admin`
--

INSERT INTO `db_admin` (`id`, `username`, `password`, `fullname`, `mail`, `phone`, `address`, `role`, `create_date`) VALUES
(1, 'admin', 'admin123', 'Admin User', 'admin@example.com', '0123456789', 'Admin Address', 'admin', '2024-11-17 03:48:44');

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
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng `db_brand`
--

INSERT INTO `db_brand` (`id`, `name`, `code`, `image`, `description`, `create_date`, `user`) VALUES
(12, 'iPhone', '1', '1733030168518-pngegg.png', '', '2024-12-01T05:16:08.520Z', 'Admin'),
(13, 'Samsung', '2', '1733388097414-logosamsung.png', '', '2024-12-05T08:41:37.417Z', 'Admin');

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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng `db_category`
--

INSERT INTO `db_category` (`id`, `name`, `code`, `image`, `description`, `create_date`, `user`) VALUES
(3, 'Điện thoại ', '1', '1733033630870-default-image.jpg', '', '2024-12-01T05:16:29.661Z', 'Admin');

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
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng `db_customer`
--

INSERT INTO `db_customer` (`id`, `username`, `password`, `fullname`, `mail`, `phone`, `address`, `create_date`) VALUES
(6, 'nguyenvana', 'matkhau123', 'Nguyễn Văn A2', 'nguyenvana@gmail.com', '0912345678', '123 Đường Láng, Hà Nội', '2024-01-01 10:00:00'),
(7, 'tranthib', 'matkhau456', 'Trần Thị B', 'tranthib@gmail.com', '0987654321', '456 Nguyễn Trãi, TP.HCM', '2024-01-02 11:00:00'),
(8, 'phamvanhoa', 'matkhau789', 'Phạm Văn Hòa', 'phamhoa@gmail.com', '0934567890', '789 Hai Bà Trưng, Đà Nẵng', '2024-01-03 12:00:00'),
(9, 'hoangthixuan', 'matkhau321', 'Hoàng Thị Xuân', 'xuanhoang@gmail.com', '0901234567', '101 Phan Đình Phùng, Hải Phòng', '2024-01-04 13:00:00'),
(11, 'dangngocanh', 'matkhau987', 'Đặng Ngọc Anh', 'ngocanh@gmail.com', '0978901234', '303 Lý Tự Trọng, Cần Thơ', '2024-01-06 15:00:00'),
(12, 'ngothilinh', 'matkhau741', 'Ngô Thị Linh', 'ngothilinh@gmail.com', '0923456789', '404 Lê Lợi, Quảng Ninh', '2024-01-07 16:00:00'),
(13, 'votuananh', 'matkhau852', 'Võ Tuấn Anh', 'tuananh@gmail.com', '0967890123', '505 Phạm Văn Đồng, Vũng Tàu', '2024-01-08 17:00:00'),
(14, 'nguyenthuykieu', 'matkhau963', 'Nguyễn Thúy Kiều', 'thuykieu@gmail.com', '0913456789', '606 Trần Hưng Đạo, Huế', '2024-01-09 18:00:00'),
(20, 'khoaquoc1', '$2b$10$18FjsUcKYUQ3A8MpUCTf3OfDist2Fcit7ThhYS7YQfvEMVljx1f0K', 'khoanguyen', 'khoaquoc21@gmail.com', '070 671 89', '123', '2024-11-21T03:13:08.984Z'),
(23, 'khoaquoc', '$2b$10$edkhC6yJ484Cp8HSGwBOwOnjcLoDsFTXVCuzzM7pDgTOvOh9.AEk6', 'khoanguyen', 'khoa12@gmail.com', '070 671 89', '1', '2024-12-01T06:26:31.861Z');

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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng `db_detail_order`
--

INSERT INTO `db_detail_order` (`id`, `id_order`, `id_product`, `qty`, `sub_total_price`) VALUES
(2, 2, 8, 1, 16590000),
(3, 2, 9, 1, 33690000),
(4, 3, 8, 1, 16590000),
(5, 3, 9, 1, 33690000),
(6, 3, 10, 1, 9690000),
(7, 5, 8, 1, 16590000),
(8, 5, 11, 1, 24990000),
(9, 6, 8, 1, 16590000),
(10, 6, 9, 1, 33690000),
(11, 7, 9, 1, 33690000),
(12, 8, 8, 1, 16590000);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `db_order`
--

DROP TABLE IF EXISTS `db_order`;
CREATE TABLE IF NOT EXISTS `db_order` (
  `id` int NOT NULL AUTO_INCREMENT,
  `custom_id` int NOT NULL,
  `customer_name` varchar(255) NOT NULL,
  `customer_phone` varchar(15) NOT NULL,
  `customer_email` varchar(255) NOT NULL,
  `customer_address` text NOT NULL,
  `total_price` float NOT NULL,
  `total_num_product` int NOT NULL,
  `create_date` varchar(255) NOT NULL,
  `note` text NOT NULL,
  `payment_method` varchar(255) NOT NULL,
  `status` enum('Thành công','Chờ xác nhận','Hủy','') NOT NULL,
  `time` varchar(255) NOT NULL,
  `code` varchar(255) NOT NULL,
  `date_confirm` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `db_order_ibfk_1` (`custom_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng `db_order`
--

INSERT INTO `db_order` (`id`, `custom_id`, `customer_name`, `customer_phone`, `customer_email`, `customer_address`, `total_price`, `total_num_product`, `create_date`, `note`, `payment_method`, `status`, `time`, `code`, `date_confirm`) VALUES
(2, 23, 'khoanguyen', '1234567890', 'K@gmail.com', 'dddd', 50280000, 2, '2024-12-10 18:02:15', 'sdasd', 'COD', 'Chờ xác nhận', '2024-12-10 18:02:15', 'ORD-1733828535936', '2024-12-10 18:02:15'),
(3, 23, 'khoanguyen', '1234567890', 'K@gmail.com', 'ggggg', 59970000, 3, '2024-12-10 18:12:49', '', 'COD', 'Chờ xác nhận', '2024-12-10 18:12:49', 'ORD-1733829169223', '2024-12-10 18:12:49'),
(5, 23, 'khoanguyen12344545', '3321030123', 'HJ@gmail.com', 'tphcm', 41580000, 2, '2024-12-10 19:15:38', '1245677sdfsfsfsfdsfdsf', 'COD', 'Chờ xác nhận', '2024-12-10 19:15:38', 'ORD-1733832938784', '2024-12-10 19:15:38'),
(6, 23, 'khoanguyendd', '3321030123', 'HJdd@gmail.com', 'wwwwww, Phường 04, Quận 8, Thành phố Hồ Chí Minh', 50280000, 2, '2024-12-11 16:23:46', '', 'COD', 'Chờ xác nhận', '2024-12-11 16:23:46', 'ORD-1733909026457', '2024-12-11 16:23:46'),
(7, 23, 'khoanguyen2', '1234567890', 'q@gmail.com', '12d, Xã Bắc Sơn, Huyện Sóc Sơn, Thành phố Hà Nội', 33690000, 1, '2024-12-11 16:37:31', 'hi', 'Direct', 'Chờ xác nhận', '2024-12-11 16:37:31', 'ORD-1733909851555', '2024-12-11 16:37:31'),
(8, 23, 'khoanguyen88888', '0706718920', 'HJdddddd@gmail.com', 'dddasda343, Xã Mường Chiên, Huyện Quỳnh Nhai, Tỉnh Sơn La', 16590000, 1, '2024-12-11 16:56:50', 'dddadas', 'Direct', 'Chờ xác nhận', '2024-12-11 16:56:50', 'ORD-1733911010618', '2024-12-11 16:56:50');

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
  `images` text,
  PRIMARY KEY (`id`),
  KEY `id_brand` (`id_brand`),
  KEY `id_category` (`id_category`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng `db_product`
--

INSERT INTO `db_product` (`id`, `id_category`, `id_brand`, `name`, `code`, `price`, `quantity`, `status`, `description`, `screen`, `ram`, `cpu`, `memory`, `operating_system`, `front_camera`, `rear_camera`, `user`, `create_date`, `images`) VALUES
(8, 3, 12, 'iPhone 14', '1', 16590000, 100, 'còn hàng', 'iPhone 14 128GB được xem là mẫu sxmartphone bùng nổ của nhà táo trong năm 2022, ấn tượng với ngoại hình trẻ trung, màn hình chất lượng đi kèm với những cải tiến về hệ điều hành và thuật toán xử lý hình ảnh, giúp máy trở thành cái tên thu hút được đông đảo người dùng quan tâm tại thời điểm ra mắt.', 'OLED', '6 GB', 'Apple A15 Bionic', '128 GB', 'iOS 17', '12 MP', '2 camera 12 MP', 'Admin', '2024-12-01', '[\"1733031102777-iphone-14_1.webp\"]'),
(9, 3, 12, 'iPhone 16 Pro Max 256GB', '2', 33690000, 1000, 'còn hàng', 'Đặc điểm nổi bật của iPhone 16 Pro Max 256GB\r\nMàn hình Super Retina XDR 6,9 inch lớn hơn có viền mỏng hơn, đem đến cảm giác tuyệt vời khi cầm trên tay.\r\nĐiều khiển Camera - Chỉ cần trượt ngón tay để điều chỉnh camera giúp chụp ảnh hoặc quay video đẹp hoàn hảo và siêu nhanh.\r\niPhone 16 Pro Max có thiết kế titan cấp 5 với lớp hoàn thiện mới, tinh tế được xử lý bề mặt vi điểm.\r\niPhone 16 Pro Max được cài đặt sẵn hệ điều hành iOS 18, cho giao diện trực quan, dễ sử dụng và nhiều tính năng hữu ích.', 'Super Retina XDR OLED', '6 GB', 'CPU 6 lõi mới với 2 lõi hiệu năng và 4 lõi hiệu suất', '256 GB', 'iOS 18', '12MP, ƒ/1.9, Tự động lấy nét theo pha Focus Pixels', 'Camera chính: 48MP, f/1.78, 24mm, 2µm, chống rung quang học dịch chuyển cảm biến thế hệ thứ hai, Focus Pixels 100% Telephoto 2x 12MP: 52 mm, ƒ/1.6 Camera góc siêu rộng: 48MP, 13 mm,ƒ/2.2 và trường ảnh 120°, Hybrid Focus Pixels, ảnh có độ phân giải', 'Admin', '2024-12-03', '[\"1733239940811-iphone-16-pro-max.webp\"]'),
(10, 3, 12, 'iPhone 11 128GB', '3', 9690000, 1000, 'còn hàng', 'iPhone 11 128GB chính hãng có thiết kế hiện đại, thừa hưởng khá nhiều từ sự các thế hệ trước như Xs hay X. Khung viền nhôm chắc chắn cùng với mặt kính đem lại vẻ sang trọng, đẳng cấp. Các góc cạnh được bo tròn. Mặt kính cường lực không chỉ giúp màn hình “mạnh mẽ” hơn mà còn chống xước, chống bám vân tay tốt hơn so với đời trước.', ' IPS LCD', '4 GB', ' Apple A13 Bionic (7 nm+)', '128 GB', ' iOS 13', ' 12 MP, f/2.2', ' 12 MP + 12 MP,', 'Admin', '2024-12-03', '[\"1733236052282-1683605592281_thumb_iphone_11_didongviet.webp\"]'),
(11, 3, 13, 'Samsung Galaxy Z Flip6 12GB 256GB', '4', 24990000, 100, 'còn hàng', 'Đặc điểm nổi bật của Samsung Galaxy Z Flip6 12GB 256GB\r\nChip Snapdragon 8 Gen 3 8 nhân mang đến hiệu năng mạnh mẽ, cho phép bạn xử lý các tác vụ hàng ngày một cách mượt mà.\r\nMàn hình gập 6.7 inch Dynamic AMOLED 2X 120Hz mang đến trải nghiệm hình ảnh tuyệt vời, với độ phân giải cao.\r\nCamera sau 50MP + 12MP cho phép bạn chụp ảnh chất lượng cao, với độ chi tiết cao và màu sắc rực rỡ. \r\nPin dung lượng 4000 mAh cho phép bạn sử dụng điện thoại cả ngày dài mà không cần lo lắng về việc hết pin. \r\nSamsung Z Flip 6 là chiếc điện thoại gập vỏ sò chạy chip Snapdragon 8 Gen 3 for Galaxy mạnh mẽ bậc nhất hiện nay. Máy có cụm camera kép độ phân giải 50MP sắc nét. Đi kèm là bộ nhớ RAM 12GB và thời lượng pin được nâng cấp thêm 4 tiếng sử dụng. Màn hình ngoài Z Flip6 tăng kích thước lên 3.4 inch cho khả năng đa nhiệm vượt trội. Sản phẩm chính thức được ra mắt ngày 10/7/2024 tại sự kiện Galaxy Unpacked diễn ra ở thủ đô Paris nước Pháp.', 'Dynamic AMOLED 2X', '12 GB', ' Snapdragon 8 Gen 3 for Galaxy Tăng lên 42% AI', '256 GB', 'Android', '10.0 MP, f/2.2', 'Camera góc chụp rộng: 50.0 MP, f/1.8, thu phóng quang học 2x Góc chụp siêu rộng: 12.0 MP, f/2.2', 'Admin', '2024-12-05', '[\"1733388272527-flip-vang.webp\"]');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Các ràng buộc cho các bảng đã đổ
--

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
  ADD CONSTRAINT `db_order_ibfk_1` FOREIGN KEY (`custom_id`) REFERENCES `db_customer` (`id`);

--
-- Các ràng buộc cho bảng `db_product`
--
ALTER TABLE `db_product`
  ADD CONSTRAINT `db_product_ibfk_1` FOREIGN KEY (`id_brand`) REFERENCES `db_brand` (`id`),
  ADD CONSTRAINT `db_product_ibfk_2` FOREIGN KEY (`id_category`) REFERENCES `db_category` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

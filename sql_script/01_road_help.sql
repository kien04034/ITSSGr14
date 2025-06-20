
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = #
#                                           Create DataBase                                           #
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = #

# SET @DATABASE_Name = 'road_help';

DROP DATABASE IF EXISTS `road_help`;
CREATE DATABASE IF NOT EXISTS `road_help` CHARACTER SET utf8 COLLATE utf8_unicode_ci;

USE `road_help`;

SET time_zone = '+07:00';
ALTER DATABASE `road_help` CHARACTER SET utf8 COLLATE utf8_unicode_ci;

# SET SQL_MODE = 'ALLOW_INVALID_DATES';

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = #
#                                            Create Tables                                            #
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = #

# Create Table users
DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users`
(
    `id`         INT AUTO_INCREMENT,

    `username`   VARCHAR(64) UNIQUE  NOT NULL,
    `email`      VARCHAR(128) UNIQUE NOT NULL,
    `password`   VARCHAR(64)         NOT NULL,

    `image`      VARCHAR(128),
    `gender`     int, #1 nam, 2 nữ
    `first_name` VARCHAR(64),
    `last_name`  VARCHAR(64),
    `phone`      VARCHAR(16) UNIQUE NULL,
    `address`    VARCHAR(128),
    `rate_avg`   DOUBLE       DEFAULT 0,

    `active`     BOOLEAN      DEFAULT TRUE,

    `request_become_partner`    BOOL DEFAULT FALSE,
    `verification_member_code`  CHAR(16),
    `verification_partner_code` CHAR(16),
    `reset_password_code`       CHAR(16),

    `created_by` NVARCHAR(32) DEFAULT 'Codedy',
    `created_at` TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    `updated_by` NVARCHAR(32) DEFAULT 'Codedy',
    `updated_at` TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    `version`    INT          DEFAULT 1,
    `deleted`    BOOLEAN      DEFAULT FALSE,

    PRIMARY KEY (`id`)
) ENGINE InnoDB;


DROP TABLE IF EXISTS `garage`;
CREATE TABLE IF NOT EXISTS `garage`
(
    `id`              INT AUTO_INCREMENT,

    `user_partner_id` INT         NOT NULL,
    `province_id`     INT         NOT NULL,
    `district_id`     INT         NOT NULL,
    `ward_id`         INT         NOT NULL,

    `name`            VARCHAR(64) NOT NULL,
    `phone`           VARCHAR(16) NOT NULL,
    `rate_avg`        DOUBLE       DEFAULT 0,
    `address`         VARCHAR(128),
    `longitude`       double,
    `latitude`        double,
    `description`     VARCHAR(500),
    `active`          BOOLEAN      DEFAULT TRUE,
    `is_featured`     BOOLEAN,

    `created_by`      NVARCHAR(32) DEFAULT 'Codedy',
    `created_at`      TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    `updated_by`      NVARCHAR(32) DEFAULT 'Codedy',
    `updated_at`      TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    `version`         INT          DEFAULT 1,
    `deleted`         BOOLEAN      DEFAULT FALSE,

    PRIMARY KEY (`id`)
) ENGINE InnoDB;

DROP TABLE IF EXISTS `garageImage`;
CREATE TABLE IF NOT EXISTS `garageImage`
(
    `id`         INT AUTO_INCREMENT,

    `garage_id`  INT          NOT NULL,
    `image`      VARCHAR(128) NOT NULL,

    `created_by` NVARCHAR(32) DEFAULT 'Codedy',
    `created_at` TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    `updated_by` NVARCHAR(32) DEFAULT 'Codedy',
    `updated_at` TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    `version`    INT          DEFAULT 1,
    `deleted`    BOOLEAN      DEFAULT FALSE,

    PRIMARY KEY (`id`)
) ENGINE InnoDB;

DROP TABLE IF EXISTS `ratingIssues`;
CREATE TABLE IF NOT EXISTS `ratingIssues`
(
    `id`             INT AUTO_INCREMENT,
    `user_member_id` INT          NOT NULL,
    `issue_id`       INT          NOT NULL,
    `rate_point`     INT          NOT NULL,
    `comment`        VARCHAR(256) NULL,

    `created_by`     NVARCHAR(32) DEFAULT 'Codedy',
    `created_at`     TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    `updated_by`     NVARCHAR(32) DEFAULT 'Codedy',
    `updated_at`     TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    `version`        INT          DEFAULT 1,
    `deleted`        BOOLEAN      DEFAULT FALSE,

    PRIMARY KEY (`id`)
) ENGINE InnoDB;

DROP TABLE IF EXISTS `ratingGarage`;
CREATE TABLE IF NOT EXISTS `ratingGarage`
(
    `id`             INT AUTO_INCREMENT,

    `garage_id`      INT          NOT NULL,
    `user_member_id` INT          NOT NULL,

    `rate_point`     INT          NOT NULL,
    `comment`        VARCHAR(256) NULL,

    `created_by`     NVARCHAR(32) DEFAULT 'Codedy',
    `created_at`     TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    `updated_by`     NVARCHAR(32) DEFAULT 'Codedy',
    `updated_at`     TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    `version`        INT          DEFAULT 1,
    `deleted`        BOOLEAN      DEFAULT FALSE,

    PRIMARY KEY (`id`)
) ENGINE InnoDB;

DROP TABLE IF EXISTS `issue`;
CREATE TABLE IF NOT EXISTS `issue`
(
    `id`              INT AUTO_INCREMENT,
    `user_member_id`  INT NOT NULL,
    `user_partner_id` int NULL,

    `longitude`       double,
    `latitude`        double,

    `phone`           VARCHAR(16),
    `address`         VARCHAR(128),
    `category`        INT null,
    `description`     VARCHAR(500),

    `status`          int          DEFAULT 0,#     0. vừa gửi chưa có ai nhận giúp | 1. chờ xác nhận | 2. đã được userPartner xác nhận tới giúp | 3. hủy bởi user | 4. thành công
    `created_by`      NVARCHAR(32) DEFAULT 'Codedy',
    `created_at`      TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    `updated_by`      NVARCHAR(32) DEFAULT 'Codedy',
    `updated_at`      TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    `version`         INT          DEFAULT 1,
    `deleted`         BOOLEAN      DEFAULT FALSE,

    PRIMARY KEY (`id`)
) ENGINE InnoDB;


# Create Table authorities
DROP TABLE IF EXISTS `authorities`;
CREATE TABLE IF NOT EXISTS `authorities`
(
    `id`         INT AUTO_INCREMENT,

    `username`   VARCHAR(64)  NOT NULL,
    `authority`  VARCHAR(128) NOT NULL,

    `created_by` NVARCHAR(32) DEFAULT 'Codedy',
    `created_at` TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    `updated_by` NVARCHAR(32) DEFAULT 'Codedy',
    `updated_at` TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    `version`    INT          DEFAULT 1,
    `deleted`    BOOLEAN      DEFAULT FALSE,

    PRIMARY KEY (`id`)
) ENGINE InnoDB;



# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = #
#                                             Insert Data                                             #
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = #

# Default password: 123456
#region Insert Users
INSERT INTO users (id, username, email, password, image, gender, first_name, last_name,phone,address, active, request_become_partner)
VALUE (1, 'Host', 'host.codedy@gmail.com', '$2y$10$//Od0OmEqRwFepW3wynrYOwslyvaS.snzBbpWwskF1Zrg5fNI.eTe','host.jpg', 1, 'CODEDY', 'Host', '032 87 99 000','Hà Nội', TRUE, FALSE);

INSERT INTO users (id, username, email, password, image, gender, first_name, last_name,phone,address, active, request_become_partner)
VALUE (2, 'Admin', 'admin.codedy@gmail.com', '$2y$10$//Od0OmEqRwFepW3wynrYOwslyvaS.snzBbpWwskF1Zrg5fNI.eTe','admin.jpg', 1, 'CODEDY', 'Admin', '0868 6633 13','Hoàn Kiếm', TRUE, FALSE);

INSERT INTO users (id, username, email, password, image, gender, first_name, last_name,phone,address, active, request_become_partner)
VALUE (3, 'Admin_Demo', 'admin_demo.codedy@gmail.com', '$2y$10$//Od0OmEqRwFepW3wynrYOwslyvaS.snzBbpWwskF1Zrg5fNI.eTe','admin_demo.jpg', 1, 'CODEDY', 'Admin Demo', '0868 6633 16','Hồ Tây', FALSE, FALSE);

INSERT INTO users (id, username, email, password, image, gender, first_name, last_name,phone,address, active, request_become_partner)
VALUE (4, 'Partner', 'partner.codedy@gmail.com', '$2y$10$//Od0OmEqRwFepW3wynrYOwslyvaS.snzBbpWwskF1Zrg5fNI.eTe','partner.jpg', 1, 'CODEDY', 'Partner', '0868 6633 17','Hà Đông', TRUE, FALSE);

INSERT INTO users (id, username, email, password, image, gender, first_name, last_name,phone,address, active, request_become_partner)
VALUE (5, 'Partner_B', 'partner_b.codedy@gmail.com', '$2y$10$//Od0OmEqRwFepW3wynrYOwslyvaS.snzBbpWwskF1Zrg5fNI.eTe','partner_b.jpg', 2, 'CODEDY', 'Partner B', '0869 6633 18','Hà Tây', FALSE, FALSE);

INSERT INTO users (id, username, email, password, image, gender, first_name, last_name,phone,address, active, request_become_partner)
VALUE (6, 'Member', 'member.codedy@gmail.com', '$2y$10$//Od0OmEqRwFepW3wynrYOwslyvaS.snzBbpWwskF1Zrg5fNI.eTe','member.jpg', 1, 'CODEDY', 'Member', '0869 6633 19','Hà Nội', TRUE, FALSE);

INSERT INTO users (id, username, email, password, image, gender, first_name, last_name,phone,address, active, request_become_partner)
VALUE (7, 'AnhNTTH1908059', 'AnhNTTH1908059@fpt.edu.vn', '$2y$10$//Od0OmEqRwFepW3wynrYOwslyvaS.snzBbpWwskF1Zrg5fNI.eTe','AnhNTTH1908059.jpg', 1, 'Nguyễn Trung', 'Anh', '0869 6633 20','Hà Nội', TRUE, FALSE);

INSERT INTO users (id, username, email, password, image, gender, first_name, last_name,phone,address, active, request_become_partner)
VALUE (8, 'HuyVQTH1909003', 'HuyVQTH1909003@fpt.edu.vn', '$2y$10$//Od0OmEqRwFepW3wynrYOwslyvaS.snzBbpWwskF1Zrg5fNI.eTe','HuyVQTH1909003.jpg', 1, 'Vũ Quang', 'Huy', '0870 6633 21','Hà Nội', TRUE, FALSE);

INSERT INTO users (id, username, email, password, image, gender, first_name, last_name,phone,address, active, request_become_partner)
VALUE (9, 'HungNPMTH1908050', 'HungNPMTH1908050@fpt.edu.vn', '$2y$10$//Od0OmEqRwFepW3wynrYOwslyvaS.snzBbpWwskF1Zrg5fNI.eTe','HungNPMTH1908050.jpg', 1, 'Nông Phan Mạnh', 'Hùng', '0870 6633 22','Hà Nội', TRUE, FALSE);

INSERT INTO users (id, username, email, password, image, gender, first_name, last_name,phone,address, active, request_become_partner)
VALUE (10, 'DinhHieu8896', 'HieuNDTH1908028@fpt.edu.vn', '$2y$10$//Od0OmEqRwFepW3wynrYOwslyvaS.snzBbpWwskF1Zrg5fNI.eTe','DinhHieu8896.jpg', 1, 'Nguyễn Đình', 'Hiếu', '0868 6633 15','Thanh Xuân, Hà Nội', TRUE, FALSE);

INSERT INTO users (id, username, email, password, image, gender, first_name, last_name,phone,address, active, request_become_partner)
VALUE (11, 'ThiDk', 'ThiDK@fpt.edu.vn ', '$2y$10$//Od0OmEqRwFepW3wynrYOwslyvaS.snzBbpWwskF1Zrg5fNI.eTe','ThiDk.jpg', 2, 'Đặng Kim', 'Thi', '0871 6633 24','Hà Nội', TRUE, FALSE);

INSERT INTO users (id, username, email, password, image, gender, first_name, last_name,phone,address, active, request_become_partner)
VALUE (12, 'Member_B', 'member_b.codedy@gmail.com', '$2y$10$//Od0OmEqRwFepW3wynrYOwslyvaS.snzBbpWwskF1Zrg5fNI.eTe','member_b.jpg', 1, 'CODEDY', 'Member B', '0871 6633 25','Hà Nội', FALSE, TRUE);

INSERT INTO users (id, username, email, password, image, gender, first_name, last_name,phone,address, active, request_become_partner)
VALUE (13, 'ManhHung', 'ManhHung@fpt.edu.vn ', '$2y$10$//Od0OmEqRwFepW3wynrYOwslyvaS.snzBbpWwskF1Zrg5fNI.eTe','ManhHung.jpg', 2, 'Manh', 'Hung', '0871 6633 26','Hà Nội', TRUE, FALSE);

INSERT INTO users (id, username, email, password, image, gender, first_name, last_name,phone,address, active, request_become_partner)
VALUE (14, 'VuHVTH1908054', 'VuHVTH1908054@fpt.edu.vn', '$2y$10$//Od0OmEqRwFepW3wynrYOwslyvaS.snzBbpWwskF1Zrg5fNI.eTe','VuHVTH1908054.jpg', 1, 'Hà Văn', 'Vũ', '0825894329','Hà Nội', TRUE, FALSE);

INSERT INTO users (id, username, email, password, image, gender, first_name, last_name,phone,address, active, request_become_partner)
VALUE (15, 'HoaDTCTH1909001', 'HoaDTCTH1909001@fpt.edu.vn', '$2y$10$//Od0OmEqRwFepW3wynrYOwslyvaS.snzBbpWwskF1Zrg5fNI.eTe','HoaDTCTH1909001.jpg', 2, 'Đỗ Thị Chan', 'Hòa', '0981159826','Hà Nội', TRUE, FALSE);




#endregion

#region Insert garage
INSERT INTO garage (id,user_partner_id,district_id,province_id,ward_id,name,rate_avg,latitude, longitude, address, description, phone, active,is_featured)
VALUE (1,5,32,2, 476,'Sửa xe, bơm vá Vũ Hòa', 4.0,21.012252, 105.840863, 'Đường Lê Duẩn', 'chuyên sửa xe', '032 87 99 000', TRUE,1);

INSERT INTO garage (id,user_partner_id,district_id,province_id,ward_id,name,rate_avg,latitude, longitude, address, description, phone, active,is_featured)
VALUE (2,4,32,2, 476,'Garage Quang Huy', 4.1,21.012125, 105.839031, 'Đường Lê Duẩn', 'chuyên sửa xe', '0868 6633 15', TRUE,1);

INSERT INTO garage (id,user_partner_id,district_id,province_id,ward_id,name,rate_avg,latitude, longitude, address, description, phone, active,is_featured)
VALUE (3,4,32,2, 476,'Tiệm sửa xe Minh Khai', 4.2,21.010844, 105.839912, '296 Minh Khai', 'chuyên sửa xe', '0869 6633 16', FALSE,1);

INSERT INTO garage (id,user_partner_id,district_id,province_id,ward_id,name,rate_avg,latitude, longitude, address, description, phone, active,is_featured)
VALUE (4,4,32,2, 476,'Sửa xe Mạnh Hùng', 4.3,21.009477, 105.841029, 'Ven Hồ Ba Mẫu', 'chuyên sửa xe', '0869 6633 51', TRUE,1);

INSERT INTO garage (id,user_partner_id,district_id,province_id,ward_id,name,rate_avg,latitude, longitude, address, description, phone, active,is_featured)
VALUE (5,4,32,2, 476,'Sửa xe Trung Anh', 4.4,21.008315, 105.841887, 'Ven Hồ Ba Mẫu', 'chuyên sửa xe', '0870 6633 52', TRUE,1);

INSERT INTO garage (id,user_partner_id,district_id,province_id,ward_id,name,rate_avg,latitude, longitude, address, description, phone, active,is_featured)
VALUE (6,5,32,2, 476,'Sửa xe, bơm vá Vũ Vũ', 4.5,21.008075, 105.843947, 'Ven Hồ Ba Mẫu', 'chuyên sửa xe', '0870 6633 45', TRUE,0);

INSERT INTO garage (id,user_partner_id,district_id,province_id,ward_id,name,rate_avg,latitude, longitude, address, description, phone, active,is_featured)
VALUE (7,4,32,2, 476,'Sửa xe Hoa Hoa', 4.6,21.008706, 105.845481, 'Ven Hồ Ba Mẫu', 'chuyên sửa xe', '0871 6633 11', TRUE,0);

INSERT INTO garage (id,user_partner_id,district_id,province_id,ward_id,name,rate_avg,latitude, longitude, address, description, phone, active,is_featured)
VALUE (8,5,32,2, 476,'Garage Hoa Hồng', 4.7,21.009637, 105.845857, 'Ven Hồ Ba Mẫu', 'chuyên sửa xe', '0871 6633 33', TRUE,0);

INSERT INTO garage (id,user_partner_id,district_id,province_id,ward_id,name,rate_avg,latitude, longitude, address, description, phone, active,is_featured)
VALUE (9,4,32,2, 476,'Garage Hoa Hồng 2', 4.8,21.011054, 105.846041, 'Ven Hồ Ba Mẫu', 'chuyên sửa xe', '0872 6633 44', TRUE,0);

INSERT INTO garage (id,user_partner_id,district_id,province_id,ward_id,name,rate_avg,latitude, longitude, address, description, phone, active,is_featured)
VALUE (10,5,32,2, 476,'Garage Quang Huy 2', 4.9,21.013774, 105.841152, 'Đường Lê Duẩn', 'chuyên sửa xe', '0872 6633 55', TRUE,0);

INSERT INTO garage (id,user_partner_id,district_id,province_id,ward_id,name,rate_avg,latitude, longitude, address, description, phone, active,is_featured)
VALUE (11,5,32,2, 476,'Garage Quang Huy 3', 4.1,21.014415, 105.840133, 'Đường Lê Duẩn', 'chuyên sửa xe', '0873 6633 66', TRUE,0);

INSERT INTO garage (id,user_partner_id,district_id,province_id,ward_id,name,rate_avg,latitude, longitude, address, description, phone, active,is_featured)
VALUE (12,5,32,2, 476,'Garage Quang Huy 4', 5.0,21.013804, 105.839543, 'Đường Lê Duẩn', 'chuyên sửa xe', '0873 6633 22', TRUE,0);

INSERT INTO garage (id,user_partner_id,district_id,province_id,ward_id,name,rate_avg,latitude, longitude, address, description, phone, active,is_featured)
VALUE (13,4,285,20, 4148,'Tiệm sửa xe Trương Định', 4.9,18.672235, 105.692798, '18 Trương Định , Hoàng Mai Hà Nội', 'Chuyên mua bán, sửa chữa các loại xe gắn máy tay ga xe số. Thay thế, lắp đặt phụ tùng chính hãng.', '0868 6633 15', TRUE,0);

INSERT INTO garage (id,user_partner_id,district_id,province_id,ward_id,name,rate_avg,latitude, longitude, address, description, phone, active,is_featured)
VALUE (14,4,285,20, 4148,'Sửa xe máy Thanh motor', 4.9,18.726102, 105.6632644, 'Xóm 15, Nghi Kim, tp Vinh, Nghệ An', 'Chuyên sửa xe ga, xe số', '0981 416 436', TRUE,1);

INSERT INTO garage (id,user_partner_id,district_id,province_id,ward_id,name,rate_avg,latitude, longitude, address, description, phone, active,is_featured)
VALUE (15,4,285,20, 4148,'Sửa Xe Huy Mân', 4.5,18.6801207, 105.6739363, '129 Lý Thường Kiệt, Lê Lợi, tp Vinh, Nghệ An', 'Sửa chữa thay thế phụ tùng xe máy', '0977652842', TRUE,1);

INSERT INTO garage (id,user_partner_id,district_id,province_id,ward_id,name,rate_avg,latitude, longitude, address, description, phone, active,is_featured)
VALUE (16,4,285,20, 4148,'Sữa Xe Máy Thanh Đào', 4.8,18.741316, 105.6586408, 'Đường Thăng Long, Nghi Liên, TP Vinh', 'Uy tín, Chất lượng, Sửa nhanh', '0987179107', TRUE,1);

INSERT INTO garage (id,user_partner_id,district_id,province_id,ward_id,name,rate_avg,latitude, longitude, address, description, phone, active,is_featured)
VALUE (17,4,285,20, 4148,'Tiệm Sửa Xe Minh Khai', 4.6,18.6643792, 105.6901323, '296 Minh Khai , Hai Bà Trưng , Hà Nội', 'Chuyên cứu hộ xe máy', '0932 394 999', TRUE,1);

INSERT INTO garage (id,user_partner_id,district_id,province_id,ward_id,name,rate_avg,latitude, longitude, address, description, phone, active,is_featured)
VALUE (18,4,285,20, 4148,'Tiệm Sửa Xe Tam Trinh', 4.8,18.730966, 105.659688, '18 Tam Trinh ,Hoàng Mai', 'Chuyên mua bán, sửa chữa các loại xe gắn máy tay ga xe số. Thay thế, lắp đặt phụ tùng chính hãng.', '0868 6633 15', TRUE,1);



#endregion

#region Insert garage image
INSERT INTO garageimage (id, garage_id,image)
VALUE (1, 1, 'tiem1.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (2, 1, 'tiem2.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (3, 1, 'tiem3.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (4, 2, 'tiem4.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (5, 2, 'tiem5.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (6, 2, 'tiem6.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (7, 3, 'tiem7.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (8, 4, 'tiem8.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (9, 5, 'tiem9.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (10, 6, 'tiem10.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (11, 7, 'tiem10.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (12, 8, 'tiem10.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (13, 9, 'tiem10.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (14, 10, 'tiem9.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (15, 11, 'tiem6.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (16, 12, 'tiem8.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (17, 16, 'sua-xe-may-thanh-dao-1.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (18, 16, 'sua-xe-may-thanh-dao-2.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (19, 15, 'Thanh_Motor_1.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (20, 15, 'Thanh_Motor_2.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (21, 14, 'sua-xe-huy-man-1.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (22, 14, 'sua-xe-huy-man-2.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (23, 14, 'sua-xe-huy-man-3.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (24, 17, 'TiemSuaXeGiang-1.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (25, 17, 'TiemSuaXeGiang-2.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (26, 17, 'TiemSuaXeGiang-3.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (27, 17, 'TiemSuaXeGiang-4.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (28, 17, 'TiemSuaXeGiang-5.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (29, 18, 'Showroom-Kien-1.jpeg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (30, 18, 'Showroom-Kien-2.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (31, 18, 'Showroom-Kien-3.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (32, 18, 'Showroom-Kien-4.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (33, 18, 'Showroom-Kien-5.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (34, 18, 'Showroom-Kien-6.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (35, 13, 'Showroom-Kien2-1.jpg');

INSERT INTO garageimage (id, garage_id,image)
VALUE (36, 13, 'Showroom-Kien2-2.jpg');





#endregion

# #region Insert issue
INSERT INTO issue(id, user_member_id,user_partner_id, latitude, longitude,category, phone,address,description, status)
VALUE (1, 6, NULL, '21.012252', '105.840863','0',  '032 87 99 000',  'Đường Lê Duẩn','Lốp trước bị thủng hết hơi, không thể di chuyển, hãy giúp tôi', '0');

INSERT INTO issue(id, user_member_id,user_partner_id, latitude, longitude,category, phone,address,description, status)
VALUE (2, 7, NULL, '21.012125', '105.839031','1',  '0868 6633 15',  'Đường Lê Duẩn','', '0');

INSERT INTO issue(id, user_member_id,user_partner_id, latitude, longitude,category, phone,address,description, status)
VALUE (3, 8, NULL, '21.010844', '105.839912','2',  '0868 6633 16',  'Ven Hồ Ba Mẫu','', '0');

INSERT INTO issue(id, user_member_id,user_partner_id, latitude, longitude,category, phone,address,description, status)
VALUE (4, 9, 4, '21.009477', '105.841029','1',  '0868 6633 17',  'Ven Hồ Ba Mẫu','', '1');

INSERT INTO issue(id, user_member_id,user_partner_id, latitude, longitude,category, phone,address,description, status)
VALUE (5, 10, 4, '21.008315', '105.841887','3',  '0869 6633 18',  'Ven Hồ Ba Mẫu','', '2');

INSERT INTO issue(id, user_member_id,user_partner_id, latitude, longitude,category, phone,address,description, status)
VALUE (6, 9, NULL, '21.008075', '105.843947','3',  '0869 6633 19',  'Ven Hồ Ba Mẫu','', '0');

INSERT INTO issue(id, user_member_id,user_partner_id, latitude, longitude,category, phone,address,description, status)
VALUE (7, 6, 4, '21.008706', '105.845481','1',  '0869 6633 20',  'Ven Hồ Ba Mẫu','', '4');

INSERT INTO issue(id, user_member_id,user_partner_id, latitude, longitude,category, phone,address,description, status)
VALUE (8, 7, 4, '21.009637', '105.845857','1',  '0870 6633 21',  'Ven Hồ Ba Mẫu','', '5');

INSERT INTO issue(id, user_member_id,user_partner_id, latitude, longitude,category, phone,address,description, status)
VALUE (9, 10, NULL, '21.011054', '105.846041','0',  '0870 6633 22',  'Ven Hồ Ba Mẫu','', '0');

INSERT INTO issue(id, user_member_id,user_partner_id, latitude, longitude,category, phone,address,description, status)
VALUE (10, 9, 4, '21.013774', '105.841152','1',  '0870 6633 23',  'Đường Lê Duẩn','', '1');

INSERT INTO issue(id, user_member_id,user_partner_id, latitude, longitude,category, phone,address,description, status)
VALUE (11, 10, 4, '21.014415', '105.840133','1',  '0871 6633 24',  'Đường Lê Duẩn','', '2');

INSERT INTO issue(id, user_member_id,user_partner_id, latitude, longitude,category, phone,address,description, status)
VALUE (12, 11, NULL, '21.013804', '105.839543','1',  '0871 6633 25',  'Đường Lê Duẩn','', '0');

INSERT INTO issue(id, user_member_id,user_partner_id, latitude, longitude,category, phone,address,description, status)
VALUE (13, 12, NULL, '18.658182', '105.695828','2',  '0869 6633 18',  'Bến Thủy, Thành phố Vinh, Nghệ An','Tôi cần hỗ trợ, hãy giúp tôi', '0');

INSERT INTO issue(id, user_member_id,user_partner_id, latitude, longitude,category, phone,address,description, status)
VALUE (14, 6, NULL, '18.671909', '105.696026','0',  '0868 6633 15',  '36 Phan Đăng Lưu, Trường Thi, TP Vinh, Nghệ An','', '0');

INSERT INTO issue(id, user_member_id,user_partner_id, latitude, longitude,category, phone,address,description, status)
VALUE (15, 14, NULL, '18.773700', '105.647588','1',  '0868 6633 16',  'Quốc Lộ 1A, Nghi Trung, Nghi Lộc, Nghệ An','', '0');

INSERT INTO issue(id, user_member_id,user_partner_id, latitude, longitude,category, phone,address,description, status)
VALUE (16, 7, NULL, '18.665677', '105.687710','2',  '0868 6633 17',  'Trần Phú, Trường Thi, Thành phố Vinh, Nghệ An','', '0');

INSERT INTO issue(id, user_member_id,user_partner_id, latitude, longitude,category, phone,address,description, status)
VALUE (17, 8, NULL, '18.758592', '105.693202','3',  '0869 6633 18',  'TP Vinh, Nghệ An','Chết máy giữa đường', '0');

INSERT INTO issue(id, user_member_id,user_partner_id, latitude, longitude,category, phone,address,description, status)
VALUE (18, 15, NULL, '18.713355', '105.661815','0',  '0869 6633 19',  'Ngõ 186, Đặng Thai Mai, Nghi Kim, TP Vinh, Nghệ An','Lốp trước bị thủng hết hơi, không thể di chuyển, hãy giúp tôi', '0');

INSERT INTO issue(id, user_member_id,user_partner_id, latitude, longitude,category, phone,address,description, status)
VALUE (19, 9, NULL, '18.735383', '105.660725','1',  '0869 6633 20',  'Nghi Liên, TP Vinh, Nghệ An','', '0');

INSERT INTO issue(id, user_member_id,user_partner_id, latitude, longitude,category, phone,address,description, status)
VALUE (20, 11, NULL, '18.718552', '105.672800','2',  '0870 6633 21',  'Nghi Phú, Thành Phố Vinh, Nghệ An','', '0');

INSERT INTO issue(id, user_member_id,user_partner_id, latitude, longitude,category, phone,address,description, status)
VALUE (21, 10, NULL, '18.669665', '105.670037','3',  '0870 6633 22',  'Đào Tấn, Cửa Nam, TP Vinh, Nghệ An','Xe không nổ máy được, hãy giúp tôi.', '0');


#endregion


#region Insert ratingGarage
INSERT INTO ratingGarage (id, user_member_id, garage_id, rate_point, comment) 
VALUE (1, 1, 12, 3, 'Tàm tạm.');

INSERT INTO ratingGarage (id, user_member_id, garage_id, rate_point, comment) 
VALUE (2, 2, 11, 5, 'Tốt');

INSERT INTO ratingGarage (id, user_member_id, garage_id, rate_point, comment) 
VALUE (3, 3, 10, 5, 'Tốt');

INSERT INTO ratingGarage (id, user_member_id, garage_id, rate_point, comment) 
VALUE (4, 4, 9, 5, 'Tốt');

INSERT INTO ratingGarage (id, user_member_id, garage_id, rate_point, comment) 
VALUE (5, 5, 8, 5, 'Tốt');

INSERT INTO ratingGarage (id, user_member_id, garage_id, rate_point, comment) 
VALUE (6, 6, 7, 4, 'Tốt');

INSERT INTO ratingGarage (id, user_member_id, garage_id, rate_point, comment) 
VALUE (7, 7, 6, 4, 'Tốt');

INSERT INTO ratingGarage (id, user_member_id, garage_id, rate_point, comment) 
VALUE (8, 8, 5, 4, 'Tốt');

INSERT INTO ratingGarage (id, user_member_id, garage_id, rate_point, comment) 
VALUE (9, 9, 4, 4, 'Tốt');

INSERT INTO ratingGarage (id, user_member_id, garage_id, rate_point, comment) 
VALUE (10, 10, 3, 4, 'Tốt');

INSERT INTO ratingGarage (id, user_member_id, garage_id, rate_point, comment) 
VALUE (11, 11, 2, 4, 'Tốt');

INSERT INTO ratingGarage (id, user_member_id, garage_id, rate_point, comment) 
VALUE (12, 12, 1, 5, 'Tốt');

INSERT INTO ratingGarage (id, user_member_id, garage_id, rate_point, comment)
VALUE (13, 10, 16, 5, 'Hài lòng về giá cả và thái độ phục vụ');

INSERT INTO ratingGarage (id, user_member_id, garage_id, rate_point, comment)
VALUE (14, 11, 16, 4, 'Uy Tín, Nhiệt tình');

INSERT INTO ratingGarage (id, user_member_id, garage_id, rate_point, comment)
VALUE (15, 10, 15, 5, 'Địa chỉ dễ tìm, nhiệt tình, cẩn thận. Vote 5☆');

INSERT INTO ratingGarage (id, user_member_id, garage_id, rate_point, comment)
VALUE (16, 11, 15, 4, 'Cửa hàng làm ăn uy tín chất lượng.lần sau tới tiếp');

INSERT INTO ratingGarage (id, user_member_id, garage_id, rate_point, comment)
VALUE (17, 10, 14, 5, 'Dịch vụ sửa xe máy rất tốt, rất chuyên nghiệp, đội ngũ thợ sửa xe đông, vui tính');

INSERT INTO ratingGarage (id, user_member_id, garage_id, rate_point, comment)
VALUE (18, 10, 17, 5, 'Cứu hộ xe rất nhiệt tình');

INSERT INTO ratingGarage (id, user_member_id, garage_id, rate_point, comment)
VALUE (19, 15, 17, 4, 'Cửa hàng uy tín');

INSERT INTO ratingGarage (id, user_member_id, garage_id, rate_point, comment)
VALUE (20, 8, 18, 5, 'NV kt kinh nghiệm.  Nhanh nhẹn.. Và rất thân thiệt. Đánh giá 5☆ luôn ủng hộ');

INSERT INTO ratingGarage (id, user_member_id, garage_id, rate_point, comment)
VALUE (21, 9, 18, 4, 'Hài lòng về giá cả và thái độ phục vụ của cửa hàng');

INSERT INTO ratingGarage (id, user_member_id, garage_id, rate_point, comment)
VALUE (22, 11, 18, 5, 'Chất lượng dịch vụ quá xuất sắc. mùa covid nắng nóng nhưng vẫn hỗ trợ giao xe tại nhà. nhân viên giao nhận vui vẻ nhiệt tình hướng dẫn');

INSERT INTO ratingGarage (id, user_member_id, garage_id, rate_point, comment)
VALUE (23, 15, 13, 5, 'Rất hài lòng về chất lượng phục vụ, sửa chữa rất nhanh');




#endregion
#region Insert ratingIssues
INSERT INTO ratingIssues(id, user_member_id, issue_id, rate_point, comment) 
VALUE (1, 4, 4, 3, 'Tạm được');

INSERT INTO ratingIssues(id, user_member_id, issue_id, rate_point, comment) 
VALUE (2, 5, 5, 5, 'Tốt');

INSERT INTO ratingIssues(id, user_member_id, issue_id, rate_point, comment) 
VALUE (3, 6, 6, 5, 'Tốt');

INSERT INTO ratingIssues(id, user_member_id, issue_id, rate_point, comment) 
VALUE (4, 7, 7, 5, 'Tốt');

INSERT INTO ratingIssues(id, user_member_id, issue_id, rate_point, comment) 
VALUE (5, 8, 8, 5, 'Tốt');

INSERT INTO ratingIssues(id, user_member_id, issue_id, rate_point, comment) 
VALUE (6, 9, 9, 4, 'Tốt');

INSERT INTO ratingIssues(id, user_member_id, issue_id, rate_point, comment) 
VALUE (7, 10, 10, 4, 'Tốt');

INSERT INTO ratingIssues(id, user_member_id, issue_id, rate_point, comment) 
VALUE (8, 11, 11, 4, 'Tốt');

INSERT INTO ratingIssues(id, user_member_id, issue_id, rate_point, comment) 
VALUE (9, 12, 12, 4, 'Tốt');



#endregion

INSERT INTO authorities (username, authority)
VALUES
('Host', 'ROLE_HOST'),
('Admin', 'ROLE_ADMIN'),
('Admin', 'ROLE_PARTNER'),
('Admin', 'ROLE_MEMBER'),
('Admin_Demo', 'ROLE_ADMIN'),
('Partner', 'ROLE_PARTNER'),
('Partner', 'ROLE_MEMBER'),
('Partner_B', 'ROLE_PARTNER'),
('Partner_B', 'ROLE_MEMBER'),
('Member', 'ROLE_MEMBER'),
('AnhNTTH1908059', 'ROLE_MEMBER'),
('HuyVQTH1909003', 'ROLE_MEMBER'),
('HungNPMTH1908050', 'ROLE_MEMBER'),
('DinhHieu8896', 'ROLE_MEMBER'),
('ThiDk', 'ROLE_MEMBER'),
('Member_B', 'ROLE_MEMBER'),
('ManhHung', 'ROLE_MEMBER');

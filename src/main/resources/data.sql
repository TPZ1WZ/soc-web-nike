-- Insert users with simplified format
INSERT INTO users (full_name, email, password_hash, role, is_active, created_at, updated_at, avatar_url)
VALUES ('DangKhoa', 'dangkhoa@example.com',
        '$2a$12$7d5RDRcYVCxxINajw.n9HOwEaIe5dyBtGGbIUfaQVujFy0IuR7Rea',
        'GUEST', TRUE, NOW(), NOW(), 'uploads/avatars/defaultAvt.jpg') ON CONFLICT DO NOTHING;

INSERT INTO users (full_name, email, password_hash, role, is_active, created_at, updated_at, avatar_url)
VALUES ('TuanKiet', 'tuankiet@example.com',
        '$2a$12$7d5RDRcYVCxxINajw.n9HOwEaIe5dyBtGGbIUfaQVujFy0IuR7Rea',
        'MEMBER', TRUE, NOW(), NOW(), 'uploads/avatars/defaultAvt.jpg') ON CONFLICT DO NOTHING;

-- Add more users following the same pattern
INSERT INTO users (full_name, email, password_hash, role, is_active, created_at, updated_at, avatar_url)
VALUES ('Admin User', 'admin@example.com',
        '$2a$12$7d5RDRcYVCxxINajw.n9HOwEaIe5dyBtGGbIUfaQVujFy0IuR7Rea',
        'ADMIN', TRUE, NOW(), NOW(), 'uploads/avatars/defaultAvt.jpg') ON CONFLICT DO NOTHING;

INSERT INTO users (full_name, email, password_hash, role, is_active, created_at, updated_at, avatar_url)
VALUES ('Root User', 'root@example.com',
        '$2a$12$7d5RDRcYVCxxINajw.n9HOwEaIe5dyBtGGbIUfaQVujFy0IuR7Rea',
        'ROOT', TRUE, NOW(), NOW(), 'uploads/avatars/defaultAvt.jpg') ON CONFLICT DO NOTHING;

INSERT INTO users (full_name, email, password_hash, role, is_active, created_at, updated_at, avatar_url)
VALUES ('Regular User', 'user@example.com',
        '$2a$12$7d5RDRcYVCxxINajw.n9HOwEaIe5dyBtGGbIUfaQVujFy0IuR7Rea',
        'GUEST', TRUE, NOW(), NOW(), 'uploads/avatars/defaultAvt.jpg') ON CONFLICT DO NOTHING;
INSERT INTO users (id, created_at, updated_at, avatar_url, email, full_name, is_active, password_hash, phone, refresh_token, role) VALUES (6, '2025-10-31 11:38:48.839995', '2025-10-31 11:38:48.839995', null, 'phat@gmail.com', 'Phat Tan', true, '$2a$10$E802YrzPA1YoB2ih2EPR2.0g5G9CKxhycAlJr4W0qjvvhnqvtwUk2', null, null, 'MEMBER') ON CONFLICT DO NOTHING;




-- Thêm dữ liệu mẫu cho bảng category
INSERT INTO category (is_delete, created_at, updated_at, description, name)
SELECT false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
       'Nam.', 'Nam'
    WHERE NOT EXISTS (SELECT 1 FROM category WHERE name = 'Nam');

INSERT INTO category (is_delete, created_at, updated_at, description, name)
SELECT false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
       'Nữ.', 'Nữ'
    WHERE NOT EXISTS (SELECT 1 FROM category WHERE name = 'Nữ');

INSERT INTO category (is_delete, created_at, updated_at, description, name)
SELECT false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
       'Trẻ em.', 'Trẻ em'
    WHERE NOT EXISTS (SELECT 1 FROM category WHERE name = 'Trẻ em');

INSERT INTO category (is_delete, created_at, updated_at, description, name)
SELECT false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
       'Khác.', 'Khác'
    WHERE NOT EXISTS (SELECT 1 FROM category WHERE name = 'Khác');

INSERT INTO category (is_delete, created_at, updated_at, description, name)
SELECT false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
       'Mới nhất', 'Mới nhất'
    WHERE NOT EXISTS (SELECT 1 FROM category WHERE name = 'Mới nhất');



INSERT INTO public.product (id, created_at, updated_at, description, images, is_delete, name, price, slug, stock, sub_title, category_id) VALUES (2, '2025-10-30 10:08:42.443858', '2025-10-30 17:12:06.954009', 'Giày chạy bộ cao cấp với đệm ZoomX, thiết kế thoáng khí.', '{"2.png"}', false, 'Nike Vomero cao cấp', 3500000, 'nike-vomero-cao-cap', 25, 'Phiên bản giới hạn 2025', 1) ON CONFLICT DO NOTHING;
INSERT INTO public.product (id, created_at, updated_at, description, images, is_delete, name, price, slug, stock, sub_title, category_id) VALUES (4, '2025-10-30 10:08:42.638174', '2025-10-30 17:37:42.965530', 'Nike Shox TL phai màu là mẫu giày nữ nổi bật với hệ thống đệm Shox độc đáo, mang lại cảm giác đàn hồi và phong cách hiện đại. Thiết kế phai màu tinh tế giúp dễ phối đồ và phù hợp cho cả luyện tập lẫn dạo phố.', '{"4.jpg"}', false, 'Nike Shox TL phai màu', 4900000, 'nike-shox-tl-phai-mau', 30, 'Legendary Basketball Shoes', 2) ON CONFLICT DO NOTHING;
INSERT INTO public.product (id, created_at, updated_at, description, images, is_delete, name, price, slug, stock, sub_title, category_id) VALUES (3, '2025-10-30 10:08:42.580252', '2025-10-30 17:41:33.303577', 'Nike Air Max Muse SE là mẫu giày nữ nổi bật với thiết kế hiện đại và phần đế Air đặc trưng, mang lại cảm giác êm ái, bền bỉ và phong cách thể thao thời thượng.', '{"3.jpg"}', false, 'Nike Air Max Muse SE', 4900000, 'nike-air-max-muse-se', 20, 'Lifestyle Sneakers', 2) ON CONFLICT DO NOTHING;
INSERT INTO public.product (id, created_at, updated_at, description, images, is_delete, name, price, slug, stock, sub_title, category_id) VALUES (5, '2025-10-30 10:08:42.678722', '2025-10-30 17:48:57.681469', 'Nike Stellar Ride là mẫu giày chạy bộ dành cho trẻ lớn, với thiết kế nhẹ, đế đàn hồi và phần thân lưới thoáng khí giúp mang lại sự thoải mái và linh hoạt trong từng bước chạy.', '{"5.avif"}', false, 'Nike Stellar Ride', 1420000, 'nike-stellar-ride', 20, 'Giày chạy bộ cho trẻ lớn hơn', 3) ON CONFLICT DO NOTHING;
INSERT INTO public.product (id, created_at, updated_at, description, images, is_delete, name, price, slug, stock, sub_title, category_id) VALUES (6, '2025-10-30 17:55:53.416794', '2025-10-30 17:55:53.416794', 'Nike Jr. Mercurial Superfly 10 Academy là đôi giày bóng đá cổ cao cho trẻ em, sử dụng đệm Air Zoom bền nhẹ và vật liệu tái chế, mang lại cảm giác ôm chân, kiểm soát bóng linh hoạt và tốc độ tối ưu trên sân cỏ.', '{"6.avif"}', false, 'Giày Nike Jr. Mercurial Superfly 10 Academy', 2200000, 'nike-jr-mercurial-superfly-10-academy', 35, 'Giày bóng đá cổ cao đa năng cho trẻ em nhỏ/lớn tuổi', 3) ON CONFLICT DO NOTHING;
INSERT INTO public.product (id, created_at, updated_at, description, images, is_delete, name, price, slug, stock, sub_title, category_id) VALUES (7, '2025-10-30 18:00:14.029970', '2025-10-30 18:00:14.029970', 'Nike Pegasus EasyOn là giày chạy bộ nam với thiết kế EasyOn dễ mang, đệm ZoomX đàn hồi và phần thân lưới thoáng khí, mang lại sự êm ái và ổn định cho mọi quãng đường dài', '{"7.jpg"}', false, 'Nike Pegasus EasyOn', 400000, 'nike-pegasus-easyon', 10, 'Giày chạy bộ đường trường dành cho nam', 1) ON CONFLICT DO NOTHING;
INSERT INTO public.product (id, created_at, updated_at, description, images, is_delete, name, price, slug, stock, sub_title, category_id) VALUES (8, '2025-10-30 18:03:31.658887', '2025-10-30 18:03:31.658887', 'Nike Air Max 90 LTR là đôi giày thể thao cho trẻ lớn với thiết kế cổ điển, đệm Air êm ái và phần da bền bỉ, mang lại phong cách năng động và thoải mái mỗi ngày.', '{"8.jpg"}', false, 'Nike Air Max 90 LTR', 900000, 'nike-air-max-90-ltr', 10, 'Giày thể thao cho trẻ lớn', 3) ON CONFLICT DO NOTHING;
INSERT INTO public.product (id, created_at, updated_at, description, images, is_delete, name, price, slug, stock, sub_title, category_id) VALUES (10, '2025-10-30 18:14:48.451625', '2025-10-30 18:14:48.451625', 'Nike Everyday Plus Cushioned là bộ 3 đôi tất cổ thấp được thiết kế cho tập luyện, có đệm lót êm ở gót và mũi chân, giúp tăng độ thoải mái và giảm ma sát trong mỗi chuyển động.', '{"10.jpg"}', false, 'Nike Everyday Plus Cushioned', 90000, 'nike-everyday-plus-cushioned', 20, 'Tất cổ thấp tập luyện (3 đôi)', 4) ON CONFLICT DO NOTHING;
INSERT INTO public.product (id, created_at, updated_at, description, images, is_delete, name, price, slug, stock, sub_title, category_id) VALUES (11, '2025-10-30 18:27:19.662368', '2025-10-30 18:27:19.662368', 'Ja 3 “Mùa ma quái” là phiên bản giới hạn của dòng giày bóng rổ Ja Morant, nổi bật với phối màu xanh neon bắt mắt và đệm Zoom X linh hoạt, mang lại độ bám và phản hồi tối đa trong từng pha di chuyển.', '{"11.jpg"}', false, 'Ja 3 “Mùa ma quái”', 4100000, 'ja-3-mua-ma-quai', 10, 'Giày bóng rổ', 5) ON CONFLICT DO NOTHING;
INSERT INTO public.product (id, created_at, updated_at, description, images, is_delete, name, price, slug, stock, sub_title, category_id) VALUES (12, '2025-10-30 18:30:28.217136', '2025-10-30 18:30:28.217136', 'Jordan Tatum 4 mang đến sự linh hoạt và tốc độ tối đa, với phần upper gia cố tăng độ ổn định và đệm êm nhẹ giúp bạn kiểm soát tốt trong từng pha di chuyển. Thiết kế phối màu Green Glow/Black hiện đại, đậm chất sân đấu.', '{"12.jpg"}', false, 'Jordan Tatum 4', 3850000, 'jordan-tatum-4', 10, 'Giày bóng rổ', 5) ON CONFLICT DO NOTHING;
INSERT INTO public.product (id, created_at, updated_at, description, images, is_delete, name, price, slug, stock, sub_title, category_id) VALUES (13, '2025-10-30 18:32:09.635875', '2025-10-30 18:32:09.635875', 'Jordan 4 Retro phiên bản trẻ nhỏ mang thiết kế da lộn mềm mại và tông màu be cổ điển, tái hiện phong cách huyền thoại trong dáng vẻ đáng yêu và thoải mái cho bé.', '{"13.jpg"}', false, 'Jordan 4 Retro', 1760000, 'jordan-4-retro-baby', 5, 'Giày cho bé / trẻ nhỏ', 5) ON CONFLICT DO NOTHING;
INSERT INTO public.product (id, created_at, updated_at, description, images, is_delete, name, price, slug, stock, sub_title, category_id) VALUES (1, '2025-10-30 10:08:42.391113', '2025-10-30 18:38:35.523297', 'Nike Vomero cao cấp là mẫu giày chạy bộ đường trường dành cho nam, nổi bật với phần đế ZoomX siêu êm, trọng lượng nhẹ và thiết kế lưới thoáng khí. Phần đệm khí màu xanh neon mang lại cảm giác đàn hồi tối ưu cho mỗi bước chạy, phù hợp cho cả tập luyện và chạy đường dài.', '{"1.jpg"}', false, 'Nike Vomero cao cấp', 6600000, 'nike-vomero-cao-cap', 29, 'Giày chạy bộ đường trường dành cho nam', 1) ON CONFLICT DO NOTHING;
INSERT INTO public.product (id, created_at, updated_at, description, images, is_delete, name, price, slug, stock, sub_title, category_id) VALUES (9, '2025-10-30 18:07:22.147460', '2025-10-30 19:18:59.499265', 'Nike Air Max 90 G là đôi giày golf mang phong cách cổ điển của dòng Air Max, được trang bị đệm Air êm ái, phần đế chống trượt và chất liệu chống thấm, giúp mang lại sự thoải mái và ổn định trên mọi sân cỏ.', '{"9.jpg"}', false, 'Nike Air Max 90 G', 352000, 'nike-air-max-90-g', 9, 'Giày golf', 1) ON CONFLICT DO NOTHING;
INSERT INTO public.product (id, created_at, updated_at, description, images, is_delete, name, price, slug, stock, sub_title, category_id) VALUES (19, '2025-10-30 20:25:18.469582', '2025-10-30 20:25:18.469582', 'Nike Field General mang phong cách retro pha hiện đại, kết hợp chất liệu da lộn và vải mềm, đế cao su nâu chắc chắn, phù hợp cho cả phong cách thể thao và thời trang đường phố.', '{"19.avif"}', false, 'Nike Field General', 2929000, 'nike-field-general', 10, 'Giày nữ', 2) ON CONFLICT DO NOTHING;
INSERT INTO public.product (id, created_at, updated_at, description, images, is_delete, name, price, slug, stock, sub_title, category_id) VALUES (20, '2025-10-30 20:28:37.539844', '2025-10-30 20:28:37.539844', 'Nike Air Force 1 ’07 LV8 mang phong cách cổ điển với phối màu trắng – đỏ nổi bật, chất liệu da cao cấp và đế cao su nâu, mang lại cảm giác êm ái và phong cách vượt thời gian.', '{"20.avif"}', false, 'Nike Air Force 1 ’07 LV8', 3519000, 'nike-air-force-1-07-lv8', 10, 'Giày nam', 1) ON CONFLICT DO NOTHING;
INSERT INTO public.product (id, created_at, updated_at, description, images, is_delete, name, price, slug, stock, sub_title, category_id) VALUES (21, '2025-10-30 20:35:18.934476', '2025-10-30 20:35:18.934476', 'Nike Air Force 1 ’07 mang lại vẻ ngoài cổ điển với phối màu trắng – đen tinh giản, kết hợp chất liệu da cao cấp, đệm Air êm ái và thiết kế vượt thời gian – biểu tượng phong cách đường phố.', '{"21.avif"}', false, 'Nike Air Force 1 ’07', 2929000, 'nike-air-force-1-07', 10, '“Da lộn cao cấp, phối màu trắng đỏ nổi bật”', 1) ON CONFLICT DO NOTHING;
INSERT INTO public.product (id, created_at, updated_at, description, images, is_delete, name, price, slug, stock, sub_title, category_id) VALUES (17, '2025-10-30 11:41:00.629299', '2025-10-30 21:07:27.573692', 'The shoe that started it all. Classic Jordan 1 with premium materials.', '{"17.jpg"}', false, 'Air Jordan 1 High', 4500000, 'air-jordan-1-high', 100, 'Legendary Basketball Shoes', 2) ON CONFLICT DO NOTHING;
INSERT INTO public.product (id, created_at, updated_at, description, images, is_delete, name, price, slug, stock, sub_title, category_id) VALUES (14, '2025-10-30 11:41:00.282721', '2025-10-30 21:07:47.874720', 'Iconic basketball shoe with timeless style and maximum comfort.', '{"14.avif"}', false, 'Nike Air Force 1', 2500000, 'nike-air-force-1', 100, 'Classic White Sneakers', 1) ON CONFLICT DO NOTHING;
INSERT INTO public.product (id, created_at, updated_at, description, images, is_delete, name, price, slug, stock, sub_title, category_id) VALUES (16, '2025-10-30 11:41:00.531623', '2025-10-30 21:08:03.700013', 'Versatile basketball-inspired shoe perfect for everyday wear.', '{"16.jpg"}', false, 'Nike Dunk Low', 2800000, 'nike-dunk-low', 100, 'Lifestyle Sneakers', 2) ON CONFLICT DO NOTHING;
INSERT INTO public.product (id, created_at, updated_at, description, images, is_delete, name, price, slug, stock, sub_title, category_id) VALUES (18, '2025-10-30 11:41:00.787897', '2025-10-30 21:08:24.950821', 'Designed to keep you running with maximum cushioning and support.', '{"18.avif"}', false, 'Nike React Infinity Run', 3800000, 'nike-react-infinity-run', 99, 'Professional Running Shoes', 3) ON CONFLICT DO NOTHING;
INSERT INTO public.product (id, created_at, updated_at, description, images, is_delete, name, price, slug, stock, sub_title, category_id) VALUES (22, '2025-10-30 20:42:30.648143', '2025-10-30 20:42:30.648653', 'Phiên bản đặc biệt của dòng Nike Dunk Low với phối màu tím – đen – xanh ngọc cực kỳ nổi bật. Chất liệu da cao cấp kết hợp đế cao su cổ điển mang lại độ bám tốt và cảm giác êm ái. Lý tưởng cho phong cách đường phố và sưu tầm sneaker.', '{"22.avif"}', false, 'Nike Dunk Low Retro Limited', 3829000, '', 10, '“Phối màu giới hạn – đậm chất retro và cá tính” (theo phong cách cảm hứng, không ghi “giày nam/đôi giày”)', 5) ON CONFLICT DO NOTHING;
INSERT INTO public.product (id, created_at, updated_at, description, images, is_delete, name, price, slug, stock, sub_title, category_id) VALUES (23, '2025-10-30 20:47:38.564826', '2025-10-30 20:47:38.564826', 'Air Jordan 1 Low mang thiết kế cổ điển với phối màu trắng toàn phần, chất liệu da cao cấp và logo Air Jordan huyền thoại ở gót. Phần đệm Air êm ái cùng đế cao su bền bỉ giúp tạo cảm giác thoải mái và phong cách năng động mỗi ngày.', '{"23.jpg"}', false, 'Nike Air Jordan 1 Low', 3239000, 'air-jordan-1-low', 6, '“Tối giản – tinh tế – biểu tượng vượt thời gian”', 5) ON CONFLICT DO NOTHING;
INSERT INTO public.product (id, created_at, updated_at, description, images, is_delete, name, price, slug, stock, sub_title, category_id) VALUES (24, '2025-10-30 20:53:34.185987', '2025-10-30 20:53:34.186596', 'Nike Blazer Mid ’77 Vintage kết hợp phong cách cổ điển với chất liệu da mịn cao cấp và đế cao su chắc chắn. Thiết kế cổ mid cùng logo Swoosh lớn đen mang đậm tinh thần retro từ thập niên 70. Thích hợp cho phong cách casual và thời trang đường phố.', '{"24.avif"}', false, 'Nike Blazer Mid ’77 Vintage', 290000, 'nike-blazer-mid-77-vintage', 7, '“Phong cách retro – tinh thần thể thao cổ điển”', 3) ON CONFLICT DO NOTHING;
INSERT INTO public.product (id, created_at, updated_at, description, images, is_delete, name, price, slug, stock, sub_title, category_id) VALUES (25, '2025-10-30 20:58:55.890189', '2025-10-30 20:58:55.890189', 'Phiên bản áo đấu sân nhà mùa giải 2025/26 của FC Barcelona, thiết kế bởi Nike với công nghệ Dri-FIT giúp thoáng khí và khô nhanh. Màu đỏ lam truyền thống được kết hợp cùng sọc đậm, biểu trưng cho tinh thần và lịch sử của câu lạc bộ. Logo Spotify và biểu trưng FCB thêu nổi bật trước ngực.', '{"25.avif"}', false, 'Áo FC Barcelona 2025/26 Trang Chủ (Nike Dri-FIT Replica)', 1939000, 'fc-barcelona-2025-26-home-jersey', 5, '“Tinh thần Catalan – màu cờ, niềm tự hào và đam mê bất diệt”', 4) ON CONFLICT DO NOTHING;
INSERT INTO public.product (id, created_at, updated_at, description, images, is_delete, name, price, slug, stock, sub_title, category_id) VALUES (26, '2025-10-30 21:03:16.696685', '2025-10-30 21:03:16.696685', 'Áo thun Nike One Fitted được thiết kế dành cho các bé gái năng động với chất liệu Dri-FIT giúp thấm hút mồ hôi, co giãn nhẹ và thoáng khí. Phom dáng fitted ôm vừa vặn cơ thể, cho cảm giác thoải mái trong mọi hoạt động thể thao hoặc học tập hằng ngày. Logo Swoosh in nổi bật ở ngực trước tạo điểm nhấn thể thao hiện đại.', '{"26.avif"}', false, 'Nike One Fitted Tee (Bé gái)', 65000, 'nike-one-fitted-girls-dri-fit-tee', 5, '“Thoải mái, tự tin – năng động mỗi ngày”', 4)  ON CONFLICT DO NOTHING;
INSERT INTO public.product (id, created_at, updated_at, description, images, is_delete, name, price, slug, stock, sub_title, category_id) VALUES (15, '2025-10-30 11:41:00.450155', '2025-10-30 21:05:42.018904', 'The classic Air Max 90 with visible air cushioning and retro style.', '{"15.avif"}', false, 'Nike Air Max 90', 3200000, 'nike-air-max-90', 100, 'Retro Running Shoes', 1) ON CONFLICT DO NOTHING;

INSERT INTO coupons (discount_value, is_active, max_discount_amount, min_order_amount, usage_limit, used_count,
                     created_at, end_date, id, start_date, updated_at, code, name, description, discount_type)
VALUES (150000, true, 120000, 120000, 10, 0, '2025-10-31 11:33:43.695552', '2025-11-05 11:33:00.000000', 1,
        '2025-10-30 11:33:00.000000', '2025-10-31 11:33:43.695552', 'OCT_FUN', 'OCT_FUN', 'GIẢM GIÁ THÁNG 10',
        'FIXED_AMOUNT')
ON CONFLICT DO NOTHING;
INSERT INTO coupons (discount_value, is_active, max_discount_amount, min_order_amount, usage_limit, used_count,
                     created_at, end_date, id, start_date, updated_at, code, name, description, discount_type)
VALUES (5, true, 190000, 200000, 10, 0, '2025-10-31 11:34:57.613538', '2025-11-08 11:34:00.000000', 2,
        '2025-10-28 11:34:00.000000', '2025-10-31 11:34:57.613538', 'OCT_SALE', 'OCT_SALE',
        'GIẢM GIÁ THÁNG 10 SIÊU SALE', 'PERCENTAGE')
ON CONFLICT DO NOTHING;
INSERT INTO coupons (discount_value, is_active, max_discount_amount, min_order_amount, usage_limit, used_count,
                     created_at, end_date, id, start_date, updated_at, code, name, description, discount_type)
VALUES (99000, true, 99000, 99000, 10, 0, '2025-10-31 11:35:37.297257', '2025-11-22 11:35:00.000000', 3,
        '2025-10-29 11:35:00.000000', '2025-10-31 11:35:37.297257', 'OCT_99K', 'OCT_99K', 'GIẢM GIÁ 99K',
        'FIXED_AMOUNT')
ON CONFLICT DO NOTHING;

USE test_tigaraksa;

-- 1. Buat tabel users untuk login
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('Administrator','General') NOT NULL
);

-- 2. Tambahkan data dummy
INSERT INTO users (username, password, role) VALUES
('admin', 'admin123', 'Administrator'),
('johndoe', 'johndoe123', 'General');

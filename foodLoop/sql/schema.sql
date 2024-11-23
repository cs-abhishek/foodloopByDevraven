CREATE DATABASE IF NOT EXISTS foodloop;

USE foodloop;

CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    address TEXT NOT NULL,
    role ENUM('user', 'admin', 'delivery_person') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status ENUM('active', 'inactive') DEFAULT 'active'
);

CREATE INDEX idx_email ON users(email);

CREATE TABLE IF NOT EXISTS food_categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE IF NOT EXISTS donations (
    donation_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    food_type VARCHAR(100) NOT NULL,
    category_id INT NOT NULL,
    quantity INT NOT NULL,
    status ENUM('pending', 'accepted', 'delivered') DEFAULT 'pending',
    donation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES food_categories(category_id) ON DELETE RESTRICT
);

CREATE INDEX idx_user_id ON donations(user_id);
CREATE INDEX idx_category_id ON donations(category_id);

CREATE TABLE IF NOT EXISTS requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    donation_id INT NOT NULL,
    admin_id INT NOT NULL,
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    request_notes TEXT,
    FOREIGN KEY (donation_id) REFERENCES donations(donation_id) ON DELETE CASCADE,
    FOREIGN KEY (admin_id) REFERENCES users(user_id) ON DELETE SET NULL
);

CREATE INDEX idx_donation_id ON requests(donation_id);

CREATE TABLE IF NOT EXISTS delivery_locations (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    contact_number VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS deliveries (
    delivery_id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NOT NULL,
    delivery_person_id INT NOT NULL,
    pickup_location_id INT NOT NULL,
    drop_location_id INT NOT NULL,
    delivery_status ENUM('pending', 'in-transit', 'completed') DEFAULT 'pending',
    delivery_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (request_id) REFERENCES requests(request_id) ON DELETE CASCADE,
    FOREIGN KEY (delivery_person_id) REFERENCES users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (pickup_location_id) REFERENCES delivery_locations(location_id) ON DELETE CASCADE,
    FOREIGN KEY (drop_location_id) REFERENCES delivery_locations(location_id) ON DELETE CASCADE
);

CREATE INDEX idx_request_id ON deliveries(request_id);

CREATE TABLE IF NOT EXISTS transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    donation_id INT NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method ENUM('cash', 'online', 'credit_card') NOT NULL,
    FOREIGN KEY (donation_id) REFERENCES donations(donation_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS audit_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INT NOT NULL,
    action_type ENUM('create', 'update', 'delete') NOT NULL,
    table_name VARCHAR(50) NOT NULL,
    record_id INT NOT NULL,
    old_value TEXT,
    new_value TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
);

CREATE INDEX idx_user_log ON audit_log(user_id);

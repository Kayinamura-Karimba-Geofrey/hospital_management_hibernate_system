-- Initial Schema for Hospital Management System

CREATE TABLE IF NOT EXISTS departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL DEFAULT ''
);

CREATE TABLE IF NOT EXISTS app_users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL,
    two_factor_secret VARCHAR(255),
    is_two_factor_enabled BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS doctors (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    specialisation VARCHAR(255),
    email VARCHAR(255),
    department_id INTEGER REFERENCES departments(id)
);

CREATE TABLE IF NOT EXISTS nurses (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    department_id INTEGER REFERENCES departments(id)
);

CREATE TABLE IF NOT EXISTS patients (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    disease VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    doctor_id INTEGER REFERENCES doctors(id),
    nurse_id INTEGER REFERENCES nurses(id)
);

CREATE TABLE IF NOT EXISTS appointments (
    id SERIAL PRIMARY KEY,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status VARCHAR(50),
    patient_id INTEGER REFERENCES patients(id),
    doctor_id INTEGER REFERENCES doctors(id),
    nurse_id INTEGER REFERENCES nurses(id)
);

CREATE TABLE IF NOT EXISTS patient_record (
    id SERIAL PRIMARY KEY,
    diagnosis TEXT,
    treatment TEXT,
    file_path VARCHAR(255),
    patient_id INTEGER REFERENCES patients(id)
);

CREATE TABLE IF NOT EXISTS audit_logs (
    id BIGSERIAL PRIMARY KEY,
    action VARCHAR(255),
    entity_name VARCHAR(255),
    entity_id VARCHAR(255),
    details TEXT,
    timestamp TIMESTAMP,
    user_id BIGINT REFERENCES app_users(id)
);

CREATE TABLE IF NOT EXISTS notifications (
    id SERIAL PRIMARY KEY,
    message TEXT,
    type VARCHAR(50),
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP,
    user_id BIGINT REFERENCES app_users(id)
);

-- Missing Core Tables
CREATE TABLE IF NOT EXISTS wards (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS beds (
    id SERIAL PRIMARY KEY,
    bed_number VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'AVAILABLE',
    ward_id INTEGER REFERENCES wards(id)
);

CREATE TABLE IF NOT EXISTS admissions (
    id SERIAL PRIMARY KEY,
    admission_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    discharge_date TIMESTAMP,
    patient_id INTEGER REFERENCES patients(id),
    bed_id INTEGER REFERENCES beds(id)
);

CREATE TABLE IF NOT EXISTS prescriptions (
    id SERIAL PRIMARY KEY,
    medication VARCHAR(255) NOT NULL,
    dosage VARCHAR(255),
    instructions TEXT,
    patient_id INTEGER REFERENCES patients(id)
);

CREATE TABLE IF NOT EXISTS invoices (
    id SERIAL PRIMARY KEY,
    amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(50) DEFAULT 'UNPAID',
    issued_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    patient_id INTEGER REFERENCES patients(id)
);

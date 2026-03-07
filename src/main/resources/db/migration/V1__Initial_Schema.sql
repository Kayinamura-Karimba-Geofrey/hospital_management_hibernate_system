-- Initial Schema for Hospital Management System

CREATE TABLE IF NOT EXISTS app_users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL DEFAULT ''
);

CREATE TABLE IF NOT EXISTS doctors (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    specialisation VARCHAR(255),
    email VARCHAR(255),
    department_id INTEGER REFERENCES department(id)
);

CREATE TABLE IF NOT EXISTS nurses (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    department_id INTEGER REFERENCES department(id)
);

CREATE TABLE IF NOT EXISTS patients (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    illness VARCHAR(255),
    email VARCHAR(255),
    doctor_id INTEGER REFERENCES doctors(id)
);

CREATE TABLE IF NOT EXISTS appointments (
    id SERIAL PRIMARY KEY,
    appointment_date TIMESTAMP NOT NULL,
    status VARCHAR(50),
    patient_id INTEGER REFERENCES patients(id),
    doctor_id INTEGER REFERENCES doctors(id)
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
-- Note: Add other tables (Ward, Bed, Admission, Surgery, Invoice, etc.) as needed based on hibernate.cfg.xml mappings.

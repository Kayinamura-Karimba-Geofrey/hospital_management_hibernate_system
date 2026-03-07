-- V2: Add missing tables and columns to align schema with Hibernate entity definitions

-- =====================================================================
-- FIX EXISTING TABLE: rename 'department' -> 'departments' if needed
-- =====================================================================
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'department') THEN
        ALTER TABLE department RENAME TO departments;
    END IF;
END $$;

-- Add missing 'location' column to departments table
ALTER TABLE departments ADD COLUMN IF NOT EXISTS location VARCHAR(255) NOT NULL DEFAULT '';

-- =====================================================================
-- FIX EXISTING TABLE: doctors
-- =====================================================================
ALTER TABLE doctors ADD COLUMN IF NOT EXISTS phone VARCHAR(50);

-- =====================================================================
-- FIX EXISTING TABLE: nurses
-- =====================================================================
ALTER TABLE nurses ADD COLUMN IF NOT EXISTS email VARCHAR(255);

-- =====================================================================
-- FIX EXISTING TABLE: patients
-- =====================================================================
-- The V1 schema used 'illness' but the entity uses 'disease'
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='patients' AND column_name='illness') THEN
        ALTER TABLE patients RENAME COLUMN illness TO disease;
    END IF;
END $$;
ALTER TABLE patients ADD COLUMN IF NOT EXISTS phone VARCHAR(50);
ALTER TABLE patients ADD COLUMN IF NOT EXISTS nurse_id INTEGER REFERENCES nurses(id);
ALTER TABLE patients ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT NOW();

-- =====================================================================
-- FIX EXISTING TABLE: appointments
-- The V1 schema had a single 'appointment_date TIMESTAMP' but the entity
-- has separate LocalDate + LocalTime + nurse_id FK.
-- =====================================================================
DO $$
BEGIN
    -- Add appointment_time if not present
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='appointments' AND column_name='appointment_time') THEN
        ALTER TABLE appointments ADD COLUMN appointment_time TIME;
    END IF;
    -- Rename appointment_date to correct type if it's a TIMESTAMP
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='appointments' AND column_name='appointment_date' AND data_type='timestamp without time zone') THEN
        ALTER TABLE appointments ALTER COLUMN appointment_date TYPE DATE USING appointment_date::DATE;
    END IF;
END $$;
ALTER TABLE appointments DROP COLUMN IF EXISTS status;
ALTER TABLE appointments ADD COLUMN IF NOT EXISTS nurse_id INTEGER REFERENCES nurses(id);

-- =====================================================================
-- NEW TABLE: prescriptions
-- =====================================================================
CREATE TABLE IF NOT EXISTS prescriptions (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(id),
    doctor_id INTEGER REFERENCES doctors(id),
    medication_name VARCHAR(255),
    dosage VARCHAR(100),
    frequency VARCHAR(100),
    instructions TEXT,
    prescribed_date TIMESTAMP DEFAULT NOW()
);

-- =====================================================================
-- NEW TABLE: lab_tests
-- =====================================================================
CREATE TABLE IF NOT EXISTS lab_tests (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(id),
    doctor_id INTEGER REFERENCES doctors(id),
    test_name VARCHAR(255),
    status VARCHAR(50) DEFAULT 'REQUESTED',
    result_file_url VARCHAR(500),
    observations TEXT,
    requested_date TIMESTAMP DEFAULT NOW(),
    completed_date TIMESTAMP
);

-- =====================================================================
-- NEW TABLE: invoices
-- =====================================================================
CREATE TABLE IF NOT EXISTS invoices (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(id),
    amount DOUBLE PRECISION NOT NULL DEFAULT 0,
    status VARCHAR(50) DEFAULT 'UNPAID',
    description TEXT,
    invoice_date TIMESTAMP DEFAULT NOW()
);

-- =====================================================================
-- NEW TABLE: insurance_details
-- =====================================================================
CREATE TABLE IF NOT EXISTS insurance_details (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(id),
    provider VARCHAR(255),
    policy_number VARCHAR(255),
    coverage_percentage DOUBLE PRECISION
);

-- =====================================================================
-- NEW TABLE: inventory_items
-- =====================================================================
CREATE TABLE IF NOT EXISTS inventory_items (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    type VARCHAR(50),
    quantity INTEGER DEFAULT 0,
    unit_price DOUBLE PRECISION DEFAULT 0,
    expiry_date DATE,
    min_threshold INTEGER DEFAULT 0
);

-- =====================================================================
-- NEW TABLE: wards
-- =====================================================================
CREATE TABLE IF NOT EXISTS wards (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(100) NOT NULL
);

-- =====================================================================
-- NEW TABLE: beds
-- =====================================================================
CREATE TABLE IF NOT EXISTS beds (
    id BIGSERIAL PRIMARY KEY,
    bed_number VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'AVAILABLE',
    ward_id BIGINT REFERENCES wards(id)
);

-- =====================================================================
-- NEW TABLE: admissions
-- =====================================================================
CREATE TABLE IF NOT EXISTS admissions (
    id BIGSERIAL PRIMARY KEY,
    patient_id INTEGER NOT NULL REFERENCES patients(id),
    bed_id BIGINT NOT NULL REFERENCES beds(id),
    admission_date TIMESTAMP NOT NULL,
    discharge_date TIMESTAMP
);

-- =====================================================================
-- NEW TABLE: surgeries
-- =====================================================================
CREATE TABLE IF NOT EXISTS surgeries (
    id BIGSERIAL PRIMARY KEY,
    patient_id INTEGER NOT NULL REFERENCES patients(id),
    surgeon_id INTEGER NOT NULL REFERENCES doctors(id),
    anesthetist_id INTEGER REFERENCES doctors(id),
    ot_room_name VARCHAR(255) NOT NULL,
    surgery_date_time TIMESTAMP NOT NULL,
    duration_minutes INTEGER NOT NULL,
    equipment VARCHAR(500)
);

--
-- PostgreSQL database dump
--

\restrict kKHZkj0iPQyQY1nBHyJ8Q0ZcycZRzXQWdR3atidWQttGAhViUoeSSq1AT5eQ579

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admissions (
    patient_id integer NOT NULL,
    admissiondate timestamp(6) without time zone NOT NULL,
    bed_id bigint NOT NULL,
    dischargedate timestamp(6) without time zone,
    id bigint NOT NULL
);


ALTER TABLE public.admissions OWNER TO postgres;

--
-- Name: admissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.admissions_id_seq OWNER TO postgres;

--
-- Name: admissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admissions_id_seq OWNED BY public.admissions.id;


--
-- Name: app_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.app_users (
    id bigint NOT NULL,
    email character varying(255) NOT NULL,
    fullname character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    role character varying(255) NOT NULL,
    username character varying(255) NOT NULL,
    two_factor_secret character varying(255),
    is_two_factor_enabled boolean DEFAULT false
);


ALTER TABLE public.app_users OWNER TO postgres;

--
-- Name: app_users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.app_users_id_seq OWNER TO postgres;

--
-- Name: app_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.app_users_id_seq OWNED BY public.app_users.id;


--
-- Name: appointments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.appointments (
    appointmentdate date,
    appointmenttime time(6) without time zone,
    doctor_id integer,
    id integer NOT NULL,
    nurse_id integer,
    patient_id integer,
    appointment_time time without time zone
);


ALTER TABLE public.appointments OWNER TO postgres;

--
-- Name: appointments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.appointments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.appointments_id_seq OWNER TO postgres;

--
-- Name: appointments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.appointments_id_seq OWNED BY public.appointments.id;


--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_logs (
    id bigint NOT NULL,
    "timestamp" timestamp(6) without time zone NOT NULL,
    user_id bigint,
    details character varying(1000),
    action character varying(255) NOT NULL,
    entity_id character varying(255),
    entity_name character varying(255) NOT NULL
);


ALTER TABLE public.audit_logs OWNER TO postgres;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.audit_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.audit_logs_id_seq OWNER TO postgres;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.audit_logs_id_seq OWNED BY public.audit_logs.id;


--
-- Name: beds; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.beds (
    id bigint NOT NULL,
    ward_id bigint,
    bednumber character varying(255) NOT NULL,
    status character varying(255) NOT NULL
);


ALTER TABLE public.beds OWNER TO postgres;

--
-- Name: beds_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.beds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.beds_id_seq OWNER TO postgres;

--
-- Name: beds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.beds_id_seq OWNED BY public.beds.id;


--
-- Name: departments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departments (
    id integer NOT NULL,
    location character varying(255) NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.departments OWNER TO postgres;

--
-- Name: departments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.departments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.departments_id_seq OWNER TO postgres;

--
-- Name: departments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.departments_id_seq OWNED BY public.departments.id;


--
-- Name: doctors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctors (
    department_id integer,
    id integer NOT NULL,
    email character varying(255),
    name character varying(255),
    specialisation character varying(255),
    phone character varying(50)
);


ALTER TABLE public.doctors OWNER TO postgres;

--
-- Name: doctors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.doctors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.doctors_id_seq OWNER TO postgres;

--
-- Name: doctors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctors_id_seq OWNED BY public.doctors.id;


--
-- Name: flyway_schema_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE public.flyway_schema_history OWNER TO postgres;

--
-- Name: insurance_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insurance_details (
    coveragepercentage double precision NOT NULL,
    id integer NOT NULL,
    patient_id integer,
    policynumber character varying(255),
    provider character varying(255)
);


ALTER TABLE public.insurance_details OWNER TO postgres;

--
-- Name: insurance_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.insurance_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.insurance_details_id_seq OWNER TO postgres;

--
-- Name: insurance_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.insurance_details_id_seq OWNED BY public.insurance_details.id;


--
-- Name: inventory_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_items (
    expirydate date,
    id integer NOT NULL,
    minthreshold integer NOT NULL,
    quantity integer NOT NULL,
    unitprice double precision NOT NULL,
    name character varying(255),
    type character varying(255)
);


ALTER TABLE public.inventory_items OWNER TO postgres;

--
-- Name: inventory_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventory_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_items_id_seq OWNER TO postgres;

--
-- Name: inventory_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventory_items_id_seq OWNED BY public.inventory_items.id;


--
-- Name: invoices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invoices (
    amount double precision NOT NULL,
    id integer NOT NULL,
    patient_id integer,
    invoicedate timestamp(6) without time zone,
    description character varying(255),
    status character varying(255)
);


ALTER TABLE public.invoices OWNER TO postgres;

--
-- Name: invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.invoices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.invoices_id_seq OWNER TO postgres;

--
-- Name: invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.invoices_id_seq OWNED BY public.invoices.id;


--
-- Name: lab_tests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lab_tests (
    doctor_id integer,
    id integer NOT NULL,
    patient_id integer,
    completeddate timestamp(6) without time zone,
    requesteddate timestamp(6) without time zone,
    observations text,
    resultfileurl character varying(255),
    status character varying(255),
    testname character varying(255)
);


ALTER TABLE public.lab_tests OWNER TO postgres;

--
-- Name: lab_tests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lab_tests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lab_tests_id_seq OWNER TO postgres;

--
-- Name: lab_tests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lab_tests_id_seq OWNED BY public.lab_tests.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    is_read boolean,
    created_at timestamp(6) without time zone,
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    message character varying(255) NOT NULL,
    type character varying(255) NOT NULL
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notifications_id_seq OWNER TO postgres;

--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: nurses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nurses (
    department_id integer,
    id integer NOT NULL,
    name character varying(255),
    email character varying(255)
);


ALTER TABLE public.nurses OWNER TO postgres;

--
-- Name: nurses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nurses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nurses_id_seq OWNER TO postgres;

--
-- Name: nurses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.nurses_id_seq OWNED BY public.nurses.id;


--
-- Name: patient_records; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patient_records (
    heartrate integer NOT NULL,
    id integer NOT NULL,
    patient_id integer,
    temperature double precision NOT NULL,
    lastupdated timestamp(6) without time zone,
    allergies text,
    bloodpressure character varying(255),
    immunizations text,
    medicalhistory text,
    file_path character varying(255)
);


ALTER TABLE public.patient_records OWNER TO postgres;

--
-- Name: patient_records_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patient_records_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patient_records_id_seq OWNER TO postgres;

--
-- Name: patient_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.patient_records_id_seq OWNED BY public.patient_records.id;


--
-- Name: patients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patients (
    doctor_id integer,
    id integer NOT NULL,
    nurse_id integer,
    created_at timestamp(6) without time zone,
    disease character varying(255),
    email character varying(255),
    name character varying(255),
    phone character varying(50)
);


ALTER TABLE public.patients OWNER TO postgres;

--
-- Name: patients_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patients_id_seq OWNER TO postgres;

--
-- Name: patients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.patients_id_seq OWNED BY public.patients.id;


--
-- Name: prescriptions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prescriptions (
    doctor_id integer,
    id integer NOT NULL,
    patient_id integer,
    prescribeddate timestamp(6) without time zone,
    dosage character varying(255),
    frequency character varying(255),
    instructions character varying(255),
    medicationname character varying(255)
);


ALTER TABLE public.prescriptions OWNER TO postgres;

--
-- Name: prescriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.prescriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.prescriptions_id_seq OWNER TO postgres;

--
-- Name: prescriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.prescriptions_id_seq OWNED BY public.prescriptions.id;


--
-- Name: surgeries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.surgeries (
    anesthetist_id integer,
    durationminutes integer NOT NULL,
    patient_id integer NOT NULL,
    surgeon_id integer NOT NULL,
    id bigint NOT NULL,
    surgerydatetime timestamp(6) without time zone NOT NULL,
    equipment character varying(255),
    otroomname character varying(255) NOT NULL
);


ALTER TABLE public.surgeries OWNER TO postgres;

--
-- Name: surgeries_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.surgeries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.surgeries_id_seq OWNER TO postgres;

--
-- Name: surgeries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.surgeries_id_seq OWNED BY public.surgeries.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying(255) NOT NULL,
    fullname character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    username character varying(255) NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: wards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wards (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255) NOT NULL
);


ALTER TABLE public.wards OWNER TO postgres;

--
-- Name: wards_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.wards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.wards_id_seq OWNER TO postgres;

--
-- Name: wards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.wards_id_seq OWNED BY public.wards.id;


--
-- Name: admissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admissions ALTER COLUMN id SET DEFAULT nextval('public.admissions_id_seq'::regclass);


--
-- Name: app_users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_users ALTER COLUMN id SET DEFAULT nextval('public.app_users_id_seq'::regclass);


--
-- Name: appointments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments ALTER COLUMN id SET DEFAULT nextval('public.appointments_id_seq'::regclass);


--
-- Name: audit_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs ALTER COLUMN id SET DEFAULT nextval('public.audit_logs_id_seq'::regclass);


--
-- Name: beds id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beds ALTER COLUMN id SET DEFAULT nextval('public.beds_id_seq'::regclass);


--
-- Name: departments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.departments_id_seq'::regclass);


--
-- Name: doctors id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors ALTER COLUMN id SET DEFAULT nextval('public.doctors_id_seq'::regclass);


--
-- Name: insurance_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insurance_details ALTER COLUMN id SET DEFAULT nextval('public.insurance_details_id_seq'::regclass);


--
-- Name: inventory_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_items ALTER COLUMN id SET DEFAULT nextval('public.inventory_items_id_seq'::regclass);


--
-- Name: invoices id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices ALTER COLUMN id SET DEFAULT nextval('public.invoices_id_seq'::regclass);


--
-- Name: lab_tests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_tests ALTER COLUMN id SET DEFAULT nextval('public.lab_tests_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: nurses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nurses ALTER COLUMN id SET DEFAULT nextval('public.nurses_id_seq'::regclass);


--
-- Name: patient_records id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_records ALTER COLUMN id SET DEFAULT nextval('public.patient_records_id_seq'::regclass);


--
-- Name: patients id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients ALTER COLUMN id SET DEFAULT nextval('public.patients_id_seq'::regclass);


--
-- Name: prescriptions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prescriptions ALTER COLUMN id SET DEFAULT nextval('public.prescriptions_id_seq'::regclass);


--
-- Name: surgeries id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.surgeries ALTER COLUMN id SET DEFAULT nextval('public.surgeries_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: wards id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wards ALTER COLUMN id SET DEFAULT nextval('public.wards_id_seq'::regclass);


--
-- Data for Name: admissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admissions (patient_id, admissiondate, bed_id, dischargedate, id) FROM stdin;
\.


--
-- Data for Name: app_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.app_users (id, email, fullname, password, role, username, two_factor_secret, is_two_factor_enabled) FROM stdin;
3	tim@gmail.com	tim	$2a$10$BHIILHEx/hM/gry5BGk6m.EFUg0dE1Ssu/0sayAy1jxyinr4BSOzO	PATIENT	tim	DWLB2EHQWYTJBBZUOVMLLBIX3PFUN223	t
4	kim@gmail.com	kim	$2a$10$l2V1HQ9KAbWqVMF/UmRmu.H2xRYYzxKDpzEi3hJOm/IJJ6O2RIv4K	PATIENT	kim	GARYZPX3N3ZTIRXHFCIDV4MGQQY3CVXZ	f
5	pop@gmail.com	pop smoke 	$2a$10$2nu9OEhtMuRG9I4./GVgZuGY3xbHFqVV/rnX05eEd0234s5YDtcTW	PATIENT	pop	QEFQGQ2ITDJAMHXRS3UXAX3BORQUBFMF	t
1	geofreykayin@gmail.com	Geofrey	$2a$10$pi/OMTFHrcELdHhuh9/tDOTlKPiJ/pGvMriuqLA4thGih/Y1hNlba	ADMIN	geofrey	AQQTJMSLIH33TF6LLIEWDNQ523BMUAPN	t
6	mary@gmail.com	mary	$2a$10$YVR6GFIgPAUDOeYm9Hjne.QZS.0BkTzgFhVl4NPWYuEygmu.wQsAa	NURSE	mary@gmail.com	\N	f
2	georgekayinamura9@gmail.com	george bush	$2a$10$NkerGGKYYUOqbKjiSqy6wO.191ol4eMEsqwa/T/Z/SSymSwMMgLCi	DOCTOR	georgekayinamura9@gmail.com	KX5UBZBLBKAIN2YOPMNGEDFSWPKTGNFA	t
7	aaron@gmail.com	Aaron	$2a$10$JQ/xzmfWuodFCm6zmWQqyO5Uvi//nWhuHRRkNnu3wgD7u98PO9lDq	DOCTOR	aaron@gmail.com	\N	f
8	james@gmail.com	james	$2a$10$.RyOc9MjlY4RMzjZDKSoX.TrOKXr4FZCJSbqT8eBy.Jl17..3vNAS	PATIENT	james	WH3LBHB7KON6YVIOTOOFARDOAPHLG2LR	t
\.


--
-- Data for Name: appointments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.appointments (appointmentdate, appointmenttime, doctor_id, id, nurse_id, patient_id, appointment_time) FROM stdin;
2026-04-15	06:41:00	\N	1	\N	1	\N
2026-03-27	05:56:00	\N	2	\N	2	\N
\.


--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audit_logs (id, "timestamp", user_id, details, action, entity_id, entity_name) FROM stdin;
1	2026-03-07 12:34:12.137775	1	New DOCTOR registration: george bush	REGISTER	george	User
2	2026-03-10 06:13:19.6268	1	Created new nurse: mary (mary@gmail.com)	CREATE	1	Nurse
3	2026-03-10 06:41:28.611839	1	Created new appointment for patient: tim	CREATE	1	Appointment
4	2026-03-10 08:27:12.881962	1	Updated doctor: george bush (georgekayinamura9@gmail.com)	UPDATE	1	Doctor
5	2026-03-12 05:53:29.19309	1	Created new doctor: Aaron (aaron@gmail.com)	CREATE	2	Doctor
6	2026-03-12 05:56:26.194148	1	Created new appointment for patient: kim	CREATE	2	Appointment
\.


--
-- Data for Name: beds; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.beds (id, ward_id, bednumber, status) FROM stdin;
\.


--
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.departments (id, location, name) FROM stdin;
1	Block A, Floor 1	Cardiology
2	Block B, Floor 2	Pediatrics
3	Block A, Floor 3	Neurology
4	Ground Floor, Entrance	Emergency
5	Basement 1	Radiology
6	Block C, Floor 1	General Medicine
\.


--
-- Data for Name: doctors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.doctors (department_id, id, email, name, specialisation, phone) FROM stdin;
3	1	georgekayinamura9@gmail.com	george bush	General	
1	2	aaron@gmail.com	Aaron	cardiologist	+250792831659
\.


--
-- Data for Name: flyway_schema_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	<< Flyway Baseline >>	BASELINE	<< Flyway Baseline >>	\N	postgres	2026-03-07 20:20:54.155697	0	t
2	2	Add Missing Tables And Columns	SQL	V2__Add_Missing_Tables_And_Columns.sql	-1382520158	postgres	2026-03-07 20:37:09.936948	135	t
3	3	Add 2FA Columns	SQL	V3__Add_2FA_Columns.sql	-1271671032	postgres	2026-03-09 21:13:03.700946	34	t
\.


--
-- Data for Name: insurance_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insurance_details (coveragepercentage, id, patient_id, policynumber, provider) FROM stdin;
\.


--
-- Data for Name: inventory_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_items (expirydate, id, minthreshold, quantity, unitprice, name, type) FROM stdin;
2030-02-10	1	4	47	10	penecilin	MEDICINE
2030-02-10	2	4	48	10	amoxylin	MEDICINE
\.


--
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invoices (amount, id, patient_id, invoicedate, description, status) FROM stdin;
5000	2	2	2026-03-10 06:39:53.035885	consultation	UNPAID
10000	3	2	2026-03-10 06:40:20.06406	consultation 	PAID
\.


--
-- Data for Name: lab_tests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lab_tests (doctor_id, id, patient_id, completeddate, requesteddate, observations, resultfileurl, status, testname) FROM stdin;
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (is_read, created_at, id, user_id, message, type) FROM stdin;
\.


--
-- Data for Name: nurses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nurses (department_id, id, name, email) FROM stdin;
2	1	mary	mary@gmail.com
\.


--
-- Data for Name: patient_records; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patient_records (heartrate, id, patient_id, temperature, lastupdated, allergies, bloodpressure, immunizations, medicalhistory, file_path) FROM stdin;
\.


--
-- Data for Name: patients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patients (doctor_id, id, nurse_id, created_at, disease, email, name, phone) FROM stdin;
\N	1	\N	2026-03-09 21:01:11.148382	Consultation	tim@gmail.com	tim	\N
\N	2	\N	2026-03-09 21:57:56.874867	Consultation	kim@gmail.com	kim	\N
\N	3	\N	2026-03-10 06:00:24.982579	Consultation	pop@gmail.com	pop smoke 	\N
\N	4	\N	2026-03-12 10:59:13.657729	Consultation	james@gmail.com	james	\N
\.


--
-- Data for Name: prescriptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.prescriptions (doctor_id, id, patient_id, prescribeddate, dosage, frequency, instructions, medicationname) FROM stdin;
\.


--
-- Data for Name: surgeries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.surgeries (anesthetist_id, durationminutes, patient_id, surgeon_id, id, surgerydatetime, equipment, otroomname) FROM stdin;
1	180	1	1	1	2026-03-10 07:55:00	laser, Robotic arm 	OT-3 (Minor)
2	120	2	2	2	2026-03-26 05:54:00	laser, Robotic arm 	OT-2 (Cardiac)
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, fullname, password, username) FROM stdin;
1	geofreykayin@gmail.com	dondurkeim	1234567	don
\.


--
-- Data for Name: wards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wards (id, name, type) FROM stdin;
\.


--
-- Name: admissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admissions_id_seq', 1, false);


--
-- Name: app_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_users_id_seq', 8, true);


--
-- Name: appointments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appointments_id_seq', 2, true);


--
-- Name: audit_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.audit_logs_id_seq', 6, true);


--
-- Name: beds_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.beds_id_seq', 1, false);


--
-- Name: departments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.departments_id_seq', 6, true);


--
-- Name: doctors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctors_id_seq', 2, true);


--
-- Name: insurance_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insurance_details_id_seq', 1, false);


--
-- Name: inventory_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventory_items_id_seq', 2, true);


--
-- Name: invoices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.invoices_id_seq', 3, true);


--
-- Name: lab_tests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lab_tests_id_seq', 1, false);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifications_id_seq', 1, false);


--
-- Name: nurses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nurses_id_seq', 1, true);


--
-- Name: patient_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patient_records_id_seq', 1, false);


--
-- Name: patients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patients_id_seq', 4, true);


--
-- Name: prescriptions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.prescriptions_id_seq', 1, false);


--
-- Name: surgeries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.surgeries_id_seq', 2, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: wards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.wards_id_seq', 1, false);


--
-- Name: admissions admissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admissions
    ADD CONSTRAINT admissions_pkey PRIMARY KEY (id);


--
-- Name: app_users app_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_users
    ADD CONSTRAINT app_users_pkey PRIMARY KEY (id);


--
-- Name: app_users app_users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_users
    ADD CONSTRAINT app_users_username_key UNIQUE (username);


--
-- Name: appointments appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (id);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: beds beds_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beds
    ADD CONSTRAINT beds_pkey PRIMARY KEY (id);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- Name: doctors doctors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_pkey PRIMARY KEY (id);


--
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- Name: insurance_details insurance_details_patient_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insurance_details
    ADD CONSTRAINT insurance_details_patient_id_key UNIQUE (patient_id);


--
-- Name: insurance_details insurance_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insurance_details
    ADD CONSTRAINT insurance_details_pkey PRIMARY KEY (id);


--
-- Name: inventory_items inventory_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_items
    ADD CONSTRAINT inventory_items_pkey PRIMARY KEY (id);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: lab_tests lab_tests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_tests
    ADD CONSTRAINT lab_tests_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: nurses nurses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nurses
    ADD CONSTRAINT nurses_pkey PRIMARY KEY (id);


--
-- Name: patient_records patient_records_patient_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_records
    ADD CONSTRAINT patient_records_patient_id_key UNIQUE (patient_id);


--
-- Name: patient_records patient_records_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_records
    ADD CONSTRAINT patient_records_pkey PRIMARY KEY (id);


--
-- Name: patients patients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_pkey PRIMARY KEY (id);


--
-- Name: prescriptions prescriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prescriptions
    ADD CONSTRAINT prescriptions_pkey PRIMARY KEY (id);


--
-- Name: surgeries surgeries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.surgeries
    ADD CONSTRAINT surgeries_pkey PRIMARY KEY (id);


--
-- Name: users uk_r43af9ap4edm43mmtq01oddj6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uk_r43af9ap4edm43mmtq01oddj6 UNIQUE (username);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: wards wards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wards
    ADD CONSTRAINT wards_pkey PRIMARY KEY (id);


--
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX flyway_schema_history_s_idx ON public.flyway_schema_history USING btree (success);


--
-- Name: prescriptions fk597ip8v14wyiidi1q9kepgoc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prescriptions
    ADD CONSTRAINT fk597ip8v14wyiidi1q9kepgoc FOREIGN KEY (patient_id) REFERENCES public.patients(id);


--
-- Name: doctors fk77hjl8damnfnghnt1194mpdd2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT fk77hjl8damnfnghnt1194mpdd2 FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: surgeries fkbd84frhd2nty6nah0ecyq85ai; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.surgeries
    ADD CONSTRAINT fkbd84frhd2nty6nah0ecyq85ai FOREIGN KEY (patient_id) REFERENCES public.patients(id);


--
-- Name: admissions fkbge98m8vnmk3fvlh1p9ljnmnm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admissions
    ADD CONSTRAINT fkbge98m8vnmk3fvlh1p9ljnmnm FOREIGN KEY (bed_id) REFERENCES public.beds(id);


--
-- Name: patient_records fkc3ewid8a9rdajvjlbah29d3kh; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient_records
    ADD CONSTRAINT fkc3ewid8a9rdajvjlbah29d3kh FOREIGN KEY (patient_id) REFERENCES public.patients(id);


--
-- Name: beds fkccoswfceny9biqfp1jkcpcrqy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beds
    ADD CONSTRAINT fkccoswfceny9biqfp1jkcpcrqy FOREIGN KEY (ward_id) REFERENCES public.wards(id);


--
-- Name: nurses fkfrk6c3im648rj4puv7rffvkuy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nurses
    ADD CONSTRAINT fkfrk6c3im648rj4puv7rffvkuy FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: prescriptions fkg1l37o56td557xw90avy7hw8n; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prescriptions
    ADD CONSTRAINT fkg1l37o56td557xw90avy7hw8n FOREIGN KEY (doctor_id) REFERENCES public.doctors(id);


--
-- Name: surgeries fkhu3og629gj3873cwxy2ycegsh; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.surgeries
    ADD CONSTRAINT fkhu3og629gj3873cwxy2ycegsh FOREIGN KEY (surgeon_id) REFERENCES public.doctors(id);


--
-- Name: patients fkhvoe2jk276rgb4bwqnmonvg8x; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT fkhvoe2jk276rgb4bwqnmonvg8x FOREIGN KEY (doctor_id) REFERENCES public.doctors(id);


--
-- Name: patients fki2vc6ut4a8xelyl2x3olydc77; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT fki2vc6ut4a8xelyl2x3olydc77 FOREIGN KEY (nurse_id) REFERENCES public.nurses(id);


--
-- Name: appointments fkjgj0qqy9n6ab3wlu8hiyhqk27; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT fkjgj0qqy9n6ab3wlu8hiyhqk27 FOREIGN KEY (nurse_id) REFERENCES public.nurses(id);


--
-- Name: appointments fkkf5i6esc2pgkk4cerpmiq7mmg; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT fkkf5i6esc2pgkk4cerpmiq7mmg FOREIGN KEY (patient_id) REFERENCES public.patients(id);


--
-- Name: notifications fkkxpkwudgh8fqu6yqw1evf53u1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fkkxpkwudgh8fqu6yqw1evf53u1 FOREIGN KEY (user_id) REFERENCES public.app_users(id);


--
-- Name: surgeries fkm529jc9avm2uxks2h13s4hykn; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.surgeries
    ADD CONSTRAINT fkm529jc9avm2uxks2h13s4hykn FOREIGN KEY (anesthetist_id) REFERENCES public.doctors(id);


--
-- Name: appointments fkmk288u914hs72vline797lqpk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT fkmk288u914hs72vline797lqpk FOREIGN KEY (doctor_id) REFERENCES public.doctors(id);


--
-- Name: invoices fknif1h1eutghib5hiauuavqclq; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT fknif1h1eutghib5hiauuavqclq FOREIGN KEY (patient_id) REFERENCES public.patients(id);


--
-- Name: insurance_details fkobcaxeewryq2yq3f9mpi4gylx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insurance_details
    ADD CONSTRAINT fkobcaxeewryq2yq3f9mpi4gylx FOREIGN KEY (patient_id) REFERENCES public.patients(id);


--
-- Name: lab_tests fkouqt92pn4om5n3h6qmqyln6x; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_tests
    ADD CONSTRAINT fkouqt92pn4om5n3h6qmqyln6x FOREIGN KEY (patient_id) REFERENCES public.patients(id);


--
-- Name: admissions fkovt7y1pyp3x9v17hb0si3hk0m; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admissions
    ADD CONSTRAINT fkovt7y1pyp3x9v17hb0si3hk0m FOREIGN KEY (patient_id) REFERENCES public.patients(id);


--
-- Name: audit_logs fkqtxpcyjfyvcehqtn8n73di8du; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT fkqtxpcyjfyvcehqtn8n73di8du FOREIGN KEY (user_id) REFERENCES public.app_users(id);


--
-- Name: lab_tests fkyhn5e9j59rhs58jxq84un2jy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_tests
    ADD CONSTRAINT fkyhn5e9j59rhs58jxq84un2jy FOREIGN KEY (doctor_id) REFERENCES public.doctors(id);


--
-- PostgreSQL database dump complete
--

\unrestrict kKHZkj0iPQyQY1nBHyJ8Q0ZcycZRzXQWdR3atidWQttGAhViUoeSSq1AT5eQ579


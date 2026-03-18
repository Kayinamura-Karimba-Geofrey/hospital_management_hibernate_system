-- V4: Fix admin email from erroneous seed
-- The DBInitializer seeded the admin with 'geofreykayin@gmail.com' instead of the
-- intended canonical email 'geofreykayin1@gmail.com'. This migration corrects that.
UPDATE app_users
SET email = 'geofreykayin1@gmail.com',
    two_factor_secret = NULL,
    is_two_factor_enabled = FALSE
WHERE (email = 'geofreykayin@gmail.com' OR email = 'geofreykayin1@gmail.com')
  AND role = 'ADMIN';

-- Add columns for 2FA tracking and secret key
ALTER TABLE app_users ADD COLUMN IF NOT EXISTS two_factor_secret VARCHAR(255);
ALTER TABLE app_users ADD COLUMN IF NOT EXISTS is_two_factor_enabled BOOLEAN DEFAULT FALSE;

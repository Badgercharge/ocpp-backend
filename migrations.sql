-- Initial migration + weather-mode columns
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;

CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  hashed_password TEXT,
  oidc_subject TEXT,
  role TEXT NOT NULL DEFAULT 'driver',
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS stations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  station_uid TEXT UNIQUE NOT NULL,
  vendor_id TEXT,
  model TEXT,
  serial_number TEXT,
  location GEOGRAPHY(POINT,4326),
  status TEXT,
  firmware_version TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  -- Wetter-Modus Spalten
  weather_mode_enabled BOOLEAN DEFAULT false,
  weather_location VARCHAR(255),
  min_power_kw NUMERIC(6,2) DEFAULT 2.0,
  max_power_kw NUMERIC(6,2) DEFAULT 11.0
);

CREATE TABLE IF NOT EXISTS connectors (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  station_id UUID REFERENCES stations(id) ON DELETE CASCADE,
  connector_index INT,
  max_power_kw NUMERIC(6,2),
  connector_type TEXT,
  status TEXT
);

CREATE TABLE IF NOT EXISTS charge_points (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  charge_point_id TEXT UNIQUE NOT NULL,
  station_id UUID REFERENCES stations(id),
  ocpp_version TEXT,
  last_seen TIMESTAMPTZ,
  connection_state TEXT
);

CREATE TABLE IF NOT EXISTS transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  station_id UUID REFERENCES stations(id),
  connector_id UUID REFERENCES connectors(id),
  start_time TIMESTAMPTZ,
  stop_time TIMESTAMPTZ,
  start_meter_wh BIGINT,
  stop_meter_wh BIGINT,
  kwh NUMERIC(10,3),
  duration_seconds INT,
  status TEXT,
  tariff_id UUID,
  cost_cents BIGINT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

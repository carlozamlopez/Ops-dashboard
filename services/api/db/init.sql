-- OPS Dashboard — Inicialización de DB
-- Se ejecuta automáticamente en MySQL local (docker-compose)
-- En Azure se corre manualmente una vez contra MySQL Flexible Server

CREATE DATABASE IF NOT EXISTS opsdb 
  CHARACTER SET utf8mb4 
  COLLATE utf8mb4_unicode_ci;

USE opsdb;

CREATE TABLE IF NOT EXISTS metrics (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    service_name VARCHAR(100) NOT NULL,
    metric_name  VARCHAR(100) NOT NULL,
    value        DECIMAL(10,2) NOT NULL,
    unit         VARCHAR(50),
    environment  VARCHAR(20) DEFAULT 'dev',
    recorded_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_service (service_name),
    INDEX idx_recorded (recorded_at)
);

-- Datos de prueba
INSERT INTO metrics (service_name, metric_name, value, unit, environment) VALUES
('frontend', 'response_time_ms', 145.5, 'ms', 'dev'),
('frontend', 'requests_per_min', 320.0, 'rpm', 'dev'),
('api',      'response_time_ms', 89.2,  'ms', 'dev'),
('api',      'requests_per_min', 185.0, 'rpm', 'dev'),
('mysql',    'connections_active', 12.0, 'count', 'dev'),
('mysql',    'query_time_avg_ms', 5.3,  'ms', 'dev'),
('aks',      'cpu_usage_pct', 34.7,    '%', 'dev'),
('aks',      'memory_usage_pct', 52.1, '%', 'dev');
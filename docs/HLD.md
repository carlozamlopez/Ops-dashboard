# HLD — OPS Dashboard · Azure Microservices Platform
**Versión:** 1.0  
**Autor:** Carlos Amador López (Azure Infra Architect)  
**Fecha:** 2026-03-18  
**Estado:** Draft

## 1. Objetivo
Desplegar un dashboard de métricas operacionales usando arquitectura 
de microservicios en Azure, con alta disponibilidad, seguridad Zero Trust 
y pipeline CI/CD completo para un equipo de 3 personas.

## 2. Arquitectura de Alto Nivel

​```
Internet
    │ HTTPS :443
    ▼
Application Gateway (WAF v2)
    │ Path-based routing
    ├── / ──────────────▶ frontend (Flask UI)
    └── /api/* ─────────▶ api (Flask REST)
         │
         │ (ambos dentro de AKS Cluster - eastus)
         │
         │ Private Endpoint
         ▼
Azure MySQL Flexible Server (PaaS)
    • Public access: DISABLED
    • Solo accesible via IP privada

Servicios de soporte:
    • ACR — imágenes Docker
    • Key Vault — secretos
    • Log Analytics — monitoreo
​```

## 3. Componentes principales

| Componente | Servicio Azure | Justificación |
|------------|---------------|---------------|
| Orquestación | AKS | Kubernetes administrado — Microsoft gestiona el control plane |
| Ingress | Application Gateway + AGIC | L7, path-based routing, WAF integrado |
| Base de datos | MySQL Flexible Server | PaaS — backups, HA y patches administrados por Azure |
| Acceso privado DB | Private Endpoint | Tráfico nunca sale a internet — Zero Trust |
| Imágenes | ACR | Registry privado integrado con AKS |
| Secretos | Key Vault | Centralizado, auditado, rotación automática |
| IaC | Terraform | Modular, multicloud, estado remoto en Azure Storage |
| CI/CD | GitHub Actions | Integrado con GitHub, gratuito para repos públicos |

## 4. Ambientes

| Parámetro | DEV | STAGING | PROD |
|-----------|-----|---------|------|
| AKS nodos | 1x B2s | 2x B2s | 3x D4s |
| MySQL SKU | Burstable B1ms | GP D2ds | GP D4ds + Zone HA |
| App Gateway | Standard_v2 | Standard_v2 | WAF_v2 |
| Auto-shutdown | ✅ | ❌ | ❌ |
| Geo-backup | ❌ | ❌ | ✅ westus |
| RTO | 4 horas | 2 horas | 1 hora |
| RPO | 24 horas | 4 horas | 15 minutos |

## 5. Decisiones de diseño

| Decisión | Alternativa descartada | Razón |
|----------|----------------------|-------|
| App Gateway | Load Balancer | LB opera en L4/TCP — no entiende HTTP |
| MySQL PaaS | MySQL en VM | PaaS reduce TCO — Azure gestiona backups y patches |
| Private Endpoint | Acceso público con firewall | Zero Trust — tráfico nunca sale a internet |
| Terraform modular | Scripts PowerShell | Idempotente, versionable, reutilizable por ambiente |
| GitHub Flow | GitFlow | Más simple para equipo de 3, suficiente para 3 ambientes |
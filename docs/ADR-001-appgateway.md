# ADR-001 — Usar Application Gateway en lugar de Load Balancer

**Fecha:** 2026-03-18  
**Estado:** Aceptado  
**Autor:** Carlos Amador López (Arch)

## Contexto

En el proyecto anterior (cloud-aks-platform) se usó Load Balancer 
para exponer servicios de AKS. Generó problemas persistentes porque 
opera en capa 4 (TCP) — no entiende HTTP, causando desconexiones 
y problemas de estado en el frontend. El browser nunca logró 
conectarse aunque los pods funcionaban correctamente.

## Decisión

Usar Application Gateway con AGIC (Application Gateway Ingress 
Controller) como punto de entrada para todos los servicios HTTP/S.
Opera en capa 7 — entiende el protocolo HTTP completo.

## Consecuencias positivas

- Path-based routing: / → frontend, /api/* → API
- SSL termination en el gateway — los pods reciben HTTP interno
- WAF integrado sin costo adicional de servicio
- Health probes HTTP reales, no solo TCP
- Resuelve el problema de conexión del proyecto anterior

## Consecuencias negativas

- Costo mayor que Load Balancer básico
- Configuración más compleja — AGIC requiere identidad gestionada
- Tiempo de provisioning más largo (~5 min vs ~1 min)

## Alternativas descartadas

- **Load Balancer L4:** Descartado — problema comprobado en proyecto anterior
- **NGINX Ingress + LB:** Agrega una capa extra. App Gateway + AGIC es nativo Azure
- **Azure Front Door:** Diseñado para multi-región, overkill para este alcance
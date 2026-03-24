# ROADMAP — OPS Dashboard

## ✅ FASE 0 — Base del proyecto (COMPLETADA)
- [x] README con roles del equipo
- [x] Estructura de carpetas enterprise
- [x] .gitignore (Terraform, Python, secretos)
- [x] HLD — Arquitectura de alto nivel
- [x] ADR-001 — App Gateway vs Load Balancer
- [x] HADR — HA, DR, RTO/RPO, Runbook
- [x] FINOPS — Presupuesto + optimización 12 meses
- [x] Todo en GitHub con flujo PR enterprise (9 PRs)
- [x] Branch main protegida con bypass Arch

## ✅ FASE 1 — Docker local (COMPLETADA)
- [x] Dockerfile frontend (multi-stage, non-root user)
- [x] Dockerfile API (multi-stage, non-root user)
- [x] Docker Compose completo con healthchecks
- [x] Flask API: /health, /api/metrics, /api/metrics/summary
- [x] Flask Frontend: dashboard visual + proxy a API
- [x] MySQL init.sql con schema y datos de prueba
- [x] Verificado: docker compose up funciona
- [x] Verificado: API health db:connected
- [x] Verificado: Dashboard mostrando métricas reales

## ✅ FASE 2 — Terraform infra (COMPLETADA)
- [x] Módulo networking: VNet, 4 subnets, NSGs, Log Analytics
- [x] Módulo ACR: Container Registry + AcrPull role
- [x] Módulo MySQL: Flexible Server + Private Endpoint opcional
- [x] Módulo AKS: Cluster + AGIC + zonas + monitoreo
- [x] Módulo AppGateway: App Gateway + WAF + lifecycle AGIC
- [x] Módulo KeyVault: RBAC + CSI Driver + secretos
- [x] Environment dev: orquestador completo
- [x] terraform plan: 28 recursos sin errores
- [x] terraform apply: exitoso en westus
- [x] terraform destroy: limpio
- [x] API con modo in-memory cuando no hay DB

## ✅ FASE 3 — Kubernetes (COMPLETADA)
- [x] Namespace: ops-dashboard
- [x] Deployment + Service: API (ClusterIP port 5000)
- [x] Deployment + Service: Frontend (NodePort port 30000)
- [x] Kustomize base + overlays por ambiente (base/api, base/frontend, overlays/dev)
- [x] Probes: liveness y readiness en ambos servicios
- [x] Resource limits y requests definidos
- [x] imagePullPolicy: Always para forzar pull desde ACR en cloud
- [x] Verificado: pods Running 1/1 en Docker Desktop K8s local
- [x] Verificado: pods Running 1/1 en AKS westus
- [x] Verificado: Dashboard accesible via kubectl port-forward
- [x] Extensión Kubernetes en VS Code configurada

## ✅ FASE 4 — CI/CD GitHub Actions (COMPLETADA)
- [x] Pipeline CI: build + push imágenes al ACR con tag commit SHA
- [x] Pipeline CD dev: deploy automático a AKS al mergear a develop
- [x] Kustomize override de imagen ACR por ambiente (overlays/dev)
- [x] kubectl apply -k crea namespace y deployments automáticamente
- [x] Verify rollout: API y Frontend con timeout 300s
- [x] Secretos GitHub: AZURE_CREDENTIALS, ACR_NAME, AZURE_CLIENT_ID, AZURE_CLIENT_SECRET, AZURE_TENANT_ID, AZURE_SUBSCRIPTION_ID
- [x] Verificado: CI verde — imágenes en ACR con SHA del commit
- [x] Verificado: CD verde — pods Running 1/1 en AKS westus end-to-end
- [x] 19+ PRs mergeados — flujo enterprise completo

## ✅ FASE 5 — App Gateway + Acceso público (COMPLETADA)
- [x] Ingress AGIC configurado en AKS con ingressClassName azure-application-gateway
- [x] AGIC permisos: Reader en RG, Contributor en AppGW, Network Contributor en subnet
- [x] Routing / → frontend (puerto 3000)
- [x] Routing /api/* → API (puerto 5000)
- [x] Verificado: Dashboard accesible desde internet vía IP pública 20.237.243.94
- [x] Fix proxy path /proxy/metrics para evitar conflicto con routing AGIC

## ✅ FASE 6 — Frontend visual (COMPLETADA)
- [x] Dashboard con métricas en tiempo real consumiendo API real desde AKS
- [x] Cards de resumen por servicio (API, AKS, MySQL, Frontend)
- [x] Tabla de detalle: promedio, máximo, mínimo, registros por servicio
- [x] Auto-refresh cada 30 segundos
- [ ] Gráficas con Chart.js (pendiente)

## Fase 7 — Monitoreo y cierre
- [ ] Log Analytics conectado a AKS
- [ ] Alertas básicas configuradas
- [ ] LLD final
- [ ] terraform destroy ordenado
- [ ] Documentación final del proyecto
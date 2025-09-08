# Sécurité réseau
- Flux: Internet → NGINX (443/80) → backend (8080) → DB (privée, non exposée).
- Firewall: deny-by-default; SSH par clé; pas d'accès direct DB.
- Secrets/IAM: variables d'env hors repo; coffre-fort; moindre privilège.

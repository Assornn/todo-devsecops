# Rapport d’incident et post‑mortem

## Informations générales

- **Date et heure de l’incident** : 29 juillet 2025, 10:15 CET  
- **Services impactés** : API TODO  
- **Gravité** : modérée

## Résumé

Une erreur serveur (HTTP 500) a été déclenchée volontairement en accédant à l’endpoint `/error`. Cette erreur a provoqué une hausse significative du taux d’erreurs sur l’API, impactant potentiellement la disponibilité du service pour les utilisateurs. L’incident a été détecté rapidement grâce aux métriques remontées dans Prometheus et visualisées dans Grafana.

## Timeline

| Heure (CET) | Événement |
|-------------|-----------|
| 10:15 | Déclenchement de l’erreur 500 lors de l’appel à `/error` |
| 10:16 | Alerte visuelle dans Grafana suite à la montée du taux d’erreurs |
| 10:20 | Analyse des métriques et logs pour identifier la cause racine |
| 10:30 | Correction temporaire appliquée (désactivation de l’endpoint) |
| 10:45 | Validation du rétablissement du service et des métriques |

## Détection et diagnostic

La panne a été détectée via les alertes visuelles du dashboard Grafana, qui montrait une augmentation du nombre de réponses HTTP 500. La requête Prometheus sur le taux d’erreurs (`rate(flask_http_request_exceptions_total[1m])`) a confirmé la montée soudaine d’exceptions. L’analyse des logs et des métriques a permis d’isoler l’endpoint `/error` comme source du problème.

## Cause racine

L’incident a été provoqué par la division par zéro volontairement insérée dans la route `/error` du fichier `app.py` pour simuler une panne. L’absence de gestion d’erreur autour de cette opération a conduit à un crash serveur lors de l’appel de cette route. Aucun test n’avait été prévu pour cette situation.

## Actions correctives et rétablissement

- L’endpoint `/error` a été désactivé temporairement pour restaurer la stabilité du service.  
- Le service a été redéployé via Docker Compose.  
- Des vérifications sur les métriques Prometheus ont confirmé la disparition des erreurs 500.  
- Un suivi du trafic a été effectué pendant 30 minutes pour s’assurer de la stabilité.

## Leçons apprises et actions de prévention

- Intégrer des tests unitaires et d’intégration pour les endpoints critiques, y compris les endpoints de test/panne.  
- Mettre en place une gestion d’erreur plus robuste dans l’application Flask pour éviter les crashs brutaux.  
- Configurer des alertes automatiques Prometheus sur les erreurs HTTP pour une détection rapide.  
- Documenter clairement les endpoints de test afin qu’ils ne soient pas utilisés en production sans précautions.  
- Améliorer la communication autour des simulations d’incidents dans l’équipe pour éviter les confusions.

---

Ce post-mortem est conçu pour apprendre de l’incident et renforcer la résilience du service TODO tout en évitant la recherche de responsabilité individuelle.

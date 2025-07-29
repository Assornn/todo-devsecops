Rapport d’incident et post‑mortem
Informations générales
Date et heure de l’incident : 29 juillet 2025, 14:30 CET

Services impactés : API TODO

Gravité : modérée

Résumé
Lors d’un test de résilience, un appel volontaire à l’endpoint /error a provoqué une erreur serveur 500 (division par zéro). Cette erreur a été détectée via une augmentation du taux d’erreur HTTP dans Prometheus et Grafana, impactant temporairement la disponibilité de l’API pour certains utilisateurs.

Timeline
Heure (CET)	Événement
14:30	Déclenchement volontaire de l’erreur 500 via /error
14:31	Augmentation du taux d’erreur visible dans Grafana
14:35	Analyse des logs et vérification du code source
14:40	Confirmation du bug de division par zéro volontaire dans app.py
14:50	Décision de supprimer ou désactiver l’endpoint /error
15:00	Redéploiement de l’application corrigée
15:05	Retour à un taux d’erreur normal sur Prometheus

Détection et diagnostic
La panne a été détectée grâce à la surveillance continue des métriques exposées par l’application. Le dashboard Grafana montrait une hausse significative des erreurs HTTP 500. La consultation des logs d’application a confirmé une exception non gérée. L’analyse du code a permis d’identifier la source exacte : une division par zéro volontaire dans la route /error.

Cause racine
L’incident est lié à un endpoint /error qui provoque intentionnellement une exception pour simuler une panne. Aucun mécanisme de gestion d’erreur ou d’alerte n’était mis en place pour anticiper ou limiter l’impact de cette erreur sur le service global.

Actions correctives et rétablissement
L’endpoint /error a été temporairement désactivé pour éviter d’autres incidents.

Le code a été modifié pour ajouter une gestion d’erreur robuste sur cette route.

L’application a été redéployée via le pipeline CI/CD.

Les métriques ont été surveillées pour confirmer le retour à la normale.

Leçons apprises et actions de prévention
Il est important de séparer clairement les endpoints de test/simulation des endpoints de production.

Mettre en place des alertes automatiques sur l’augmentation des erreurs HTTP.

Ajouter des tests unitaires et d’intégration pour valider les comportements attendus.

Envisager la mise en place d’une gestion d’erreurs centralisée pour améliorer la résilience.


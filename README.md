OCPP Backend with Weather-Dependent Charging - Bundle
----------------------------------------------------

Inhalt:
- Backend (FastAPI) mit integriertem Wetter-Modul (OpenWeatherMap)
- SQL migrations (including weather-mode columns)
- Simulierter Charger (tools/simulated_charger.py)
- Frontend scaffold mit WeatherSettings Komponente
- docker-compose.yml für lokales Testen
- Anleitung: Wie du das Projekt auf Render.com deployst (keine lokale Installation nötig)

Wichtige Umgebungsvariablen (bei Render oder anderem Hosting):
- OPENWEATHER_API_KEY : dein API Key von OpenWeatherMap
- WEATHER_CHECK_INTERVAL_MINUTES : z.B. 10
- DATABASE_URL : z.B. sqlite:///data/data.db (für Render reicht das)

Hinweise:
- Dieses Bundle ist als Startpaket gedacht. Achte bei produktivem Betrieb auf TLS, Persistenz (managed Postgres), und Sicherheits- / Backup-Strategien.

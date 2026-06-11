flutter run -d linux --dart-define=API_BASE_URL=http://localhost:8080

make web 
docker build -t alexandreqrz/open-receivables-app:latest . &&
docker push alexandreqrz/open-receivables-app:latest
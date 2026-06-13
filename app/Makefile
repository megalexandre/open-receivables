IMAGE_NAME = alexandreqrz/organizagrana
TAG = latest

-include .env
export

# Lê variáveis do .env e converte em DART_DEFINES
DART_DEFINES = $(foreach var,$(shell grep -v '^\#' .env | grep -v '^$$' | cut -d= -f1),--dart-define=$(var)=$($(var)))

# Permite sobrescrever API_BASE_URL via linha de comando: make linux API_BASE_URL=http://seu-backend:3000
ifdef API_BASE_URL
  DART_DEFINES := --dart-define=API_BASE_URL=$(API_BASE_URL)
endif

.PHONY: all publish run chrome linux web build push clean mock help

help:
	@echo "Targets disponíveis:"
	@echo "  make linux [API_BASE_URL=...]    - Rodar Flutter no Linux (lê .env ou aceita override)"
	@echo "  make chrome [API_BASE_URL=...]   - Rodar Flutter no Chrome"
	@echo "  make web [API_BASE_URL=...]      - Build web (lê .env ou aceita override)"
	@echo "  make build                       - Build Docker image"
	@echo "  make push                        - Push para Docker Hub"
	@echo "  make all                         - Build web + Docker + push"
	@echo "  make clean                       - Limpar artefatos"
	@echo "  make mock                        - Rodar WireMock em localhost:8080"
	@echo ""
	@echo "Exemplos:"
	@echo "  make linux                                      # Usa .env"
	@echo "  make linux API_BASE_URL=http://localhost:3000  # Override .env"
	@echo "  make web API_BASE_URL=http://api.prod.com      # Build para prod"

all: web build push

publish: web build push
	@echo "Publicação concluída: $(IMAGE_NAME):$(TAG)"

run:
	@echo "Iniciando Flutter em modo debug..."
	flutter run

chrome:
	@echo "Iniciando Flutter no Chrome (CORS desabilitado)..."
	flutter run -d chrome --web-browser-flag="--disable-web-security" $(DART_DEFINES)

linux:
	@echo "Iniciando Flutter no Linux com API_BASE_URL: $(word 2,$(subst =, ,$(DART_DEFINES)))"
	flutter run -d linux $(DART_DEFINES)

web:
	@echo "Gerando build Flutter Web com API_BASE_URL: $(word 2,$(subst =, ,$(DART_DEFINES)))"
	flutter build web $(DART_DEFINES)

build:
	@echo "Criando imagem Docker: $(IMAGE_NAME):$(TAG)"
	docker build -t $(IMAGE_NAME):$(TAG) .

push:
	@echo "Fazendo push para o Docker Hub..."
	docker push $(IMAGE_NAME):$(TAG)

mock:
	@echo "Subindo WireMock em localhost:8080..."
	docker compose up wiremock

clean:
	@echo "Limpando artefatos de build..."
	flutter clean

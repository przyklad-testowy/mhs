#!/bin/bash

# Funkcja do przetwarzania wybranego Dashboardu
process_dashboard() {
    local id=$1
    
    # Prośba o podanie klucza prywatnego dla danego Dashboardu
    read -p "Wprowadź klucz prywatny dla Dashboard${id}: " PRIV_KEY
    
    # Prośba o wprowadzenie ilości tokenów do stakingu dla danego Dashboardu
    read -p "Wprowadź ilość tokenów do stakingu dla Dashboard${id}: " TOKENS_AMOUNT

    # Wchodzenie w kontener Dockera dla odpowiedniego Dashboardu
    docker exec -it shardeum-dashboard${id} /bin/bash -c "
        # Eksportowanie klucza prywatnego
        export PRIV_KEY=${PRIV_KEY}
        
        # Wprowadzenie ilości tokenów
        operator-cli stake ${TOKENS_AMOUNT}
        
        # Uruchomienie GUI
        operator-cli gui start
    "
}

# Prośba o wprowadzenie numerów dashboardów do uruchomienia
read -p "Wprowadź numery Dashboardów do uruchomienia (oddzielone spacjami, np. '0 3 5'): " -a DASHBOARD_NUMBERS

for i in "${DASHBOARD_NUMBERS[@]}"; do
    process_dashboard $i
done

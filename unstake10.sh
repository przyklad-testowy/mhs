#!/bin/bash

# Funkcja do przetwarzania wybranego Dashboardu
process_dashboard() {
    local id=$1

    # Prośba o podanie klucza prywatnego dla danego Dashboardu
    read -p "Wprowadź klucz prywatny dla Dashboard${id}: " PRIV_KEY

    # Wchodzenie w kontener Dockera dla odpowiedniego Dashboardu
    docker exec -it shardeum-dashboard${id} /bin/bash -c "
        # Eksportowanie klucza prywatnego
        export PRIV_KEY=${PRIV_KEY}
        
        # Wykonanie operacji unstake
        operator-cli unstake 11
        
        # Uruchomienie GUI
        operator-cli gui start
    "
}

# Iteracja przez 10 dashboardów
for i in {0..9}
do
    process_dashboard $i
done

echo "Operacja unstake została zakończona dla wszystkich dashboardów!"

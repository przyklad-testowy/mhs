#!/bin/bash

# Aktualizacja systemu i instalacja wymaganych pakietów
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl docker.io openssl expect

# Pobranie skryptu instalacyjnego Shardeum i nadanie mu uprawnień do wykonania
curl -O https://gitlab.com/shardeum/validator/dashboard/-/raw/main/installer.sh
chmod +x installer.sh

# Instalacja Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Pobierz i nadaj uprawnienia wykonawcze instalatorowi Shardeum
curl -O https://gitlab.com/shardeum/validator/dashboard/-/raw/main/installer.sh
chmod +x installer.sh

# Generowanie losowego hasła i zapisanie go do pliku
password=$(openssl rand -base64 12)
echo $password > password.txt

# Tworzenie skryptu expect
cat << 'EOF' > install_shardeum.exp
#!/usr/bin/expect

set timeout -1
spawn ./installer.sh

# Ustawić rzeczywiste hasło poniżej zamiast "password"
set mypassword "password"

expect {
    "*By running this installer, you agree to allow the Shardeum team to collect this data. (Y/n)?:*" {
        send "y\r"
        exp_continue
    }
    "*What base directory should the node use (default ~/.shardeum):*" {
        send "\r"
        exp_continue
    }
    "*Do you want to run the web based Dashboard? (Y/n):*" {
        send "y\r"
        exp_continue
    }
    "*Set the password to access the Dashboard:*" {
        send "$mypassword\r"
        exp_continue
    }
    "*Enter the port (1025-65536) to access the web based Dashboard (default 8080):*" {
        send "\r"
        exp_continue
    }
    "*If you wish to set an explicit external IP, enter an IPv4 address (default=auto):*" {
        send "\r"
        exp_continue
    }
    "*If you wish to set an explicit internal IP, enter an IPv4 address (default=auto):*" {
        send "\r"
        exp_continue
    }
    "*Enter the first port (1025-65536) for p2p communication (default 9001):*" {
        send "\r"
        exp_continue
    }
    "*Enter the second port (1025-65536) for p2p communication (default 10001):*" {
        send "\r"
        exp_continue
    }
}

expect eof
EOF

# Nadanie uprawnień do wykonania skryptowi expect
chmod +x install_shardeum.exp
# Uruchomienie skryptu expect
./install_shardeum.exp
# Sprawdzenie, czy Docker i Docker Compose zostały poprawnie zainstalowane
if ! command -v docker &> /dev/null || ! command -v docker-compose &> /dev/null; then
    echo "Nie udało się zainstalować Docker lub Docker Compose. Sprawdź kroki instalacji i spróbuj ponownie."
    exit 1
fi

echo "Instalacja węzła walidatora Shardeum jest zakończona! Soczystego AirDropa ;)
Twoje hasło do serwera to:"
cat password.txt

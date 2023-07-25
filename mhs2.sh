#!/bin/bash

# Download the start_node.sh script
wget -O /root/start_node.sh https://github.com/przyklad-testowy/mhs/blob/5a63781569fe4a83010aadfd1eecb8c13734281d/start_node.sh

# Make the script executable
chmod +x /root/start_node.sh

# Create the systemd service file
echo -e "[Unit]\nDescription=Start Node\n\n[Service]\nExecStart=/bin/bash /root/start_node.sh\n\n[Install]\nWantedBy=multi-user.target" | sudo tee /etc/systemd/system/start-node.service

# Reload the systemd daemon
sudo systemctl daemon-reload

# Enable the service to run at startup
sudo systemctl enable start-node

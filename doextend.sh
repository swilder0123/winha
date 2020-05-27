az vm extension set \
    -g winha-rg  \
    --vm-name winha-node-0 \
    --publisher Microsoft.Compute \
    --name JsonADDomainExtension \
    --version 1.3 \
    --settings ./settings.json \
    --protected-settings ./protected_settings.json

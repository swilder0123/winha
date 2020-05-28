# winha - A scaffold for Windows Server clusters on Azure

This project allows you to stand up Windows Server failover clusters on Microsoft Azure. You can quickly specify the following parameters:

- Cluster naming prefix (used to programmatically generate names for most objects)
- Number of cluster nodes (from 2-4)
- Azure region for deployment
- The (existing) Windows Server AD domain to configure against (this is required)
- The (existing) Key Vault where you want to keep your secrets
- vNet information: Address space, prefixes for your subnets, hub vNet to peer with, etc.

You can also choose:
- VM size
- Disk sizes
- Windows OS version and SKU info


The setup will automatically create an availability set and deploy your nodes across the resulting fault domains.

More instructions to follow...

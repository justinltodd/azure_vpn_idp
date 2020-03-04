# Work In Progress - Intent to provide inital config for  IDP(SSO) with Apereo CAS.
## Environment OpenVPN authenticates with FreeIPA LDAP Solution.
## NGINX provides a proxy for the Apereo CAS servers.  

## Terraform CAS IDP, OpenVPN, FreeIPA, Authentication, NGINX Proxy/Loadbalancer
### CentOS v8 


1. Builds Two OPENVPN Server CentOS 8 w/ latest version of EasyRSA for Certificate Authority. Stack CA for Failover
2. Builds Two CAS Servers v6.2 IDP provider
3. Creates Two FreeIPA servers for LDAP and DNS, CA Authority
4. Initial CAS Auth authentication with FreeIPA
6. Build a windows 10 pro desktop. 
7. Security rule for HTTP, HTTPS, WINRM, RDP
8. NGINX Proxy/Load balancing and HTTPS termination with LetsEncrypt

### Terraform:

* Terraform Process
1. NSLDAP01 and NSLDAP02 have to be present before setting up the other instances. These are the FreeIPA Primary and Secondary LDAP and DNS servers
2. Some of the LetsEncrypt is a manual process. It is in the tf files, can be modified to fit your environment. (NGINX) (VPN) (FreeIPA)
### 

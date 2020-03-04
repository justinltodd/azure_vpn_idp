## Terraform CAS IDP, OpenVPN, FreeIPA, Authentication, NGINX Proxy/Loadbalancer for CAS01/02
#


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

### 

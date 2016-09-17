company: $COMPANY
sysadmin: $SYSADMIN
sysadmin_email: $EMAIL
file_header: "** THIS FILE IS MANAGED BY SALT; CHANGES WILL BE OVERWRITTEN **"

RedHat_gpg_keys:
  RPM-GPG-KEY-redhat-release: "567E 347A D004 4ADE 55BA 8A5F 199E 2F91 FD43 1D51"
  RPM-GPG-KEY-redhat-legacy-release: "47DB 2877 89B2 1722 B6D9 5DDE 5326 8101 3701 7186"
  RPM-GPG-KEY-redhat-legacy-former: "CA20 8686 2BD6 9DFC 65F6 ECC4 2191 80CD DB42 A60E"
  RPM-GPG-KEY-redhat-legacy-rhx: "01AD EFD1 5A95 AE43 14DE 83C2 39A1 3A12 4219 3E6B"

CentOS_gpg_keys:
  RPM-GPG-KEY-CentOS-6: "C1DA C52D 1664 E8A4 386D  BA43 0946 FCA2 C105 B9DE"

epel_gpg_keys:
  RPM-GPG-KEY-EPEL-6: "8C3B E96A F230 9184 DA5C  0DAE 3B49 DF2A 0608 B895"


## 3.6 Configure Network Time Protocol (NTP)
# You should change this servers if you have local ntp servers in your organization
ntp_servers:
  primary: ntp1.site1.org.com
  secondary: ntp1.site2.org.com
  tertiary: ntp2.site1.org.com
  forth: ntp2.site2.org.com


## Extra options for NTP, default is empty -- this is to use, for example, -g
ntpd_extraopts: ''

{% if grains['os_family'] == 'RedHat' and grains['osrelease'].startswith('6') %}


UTC:
  timezone.system:
    - utc: True

## Copy core files
core_copy_files:
  file:
    - recurse
    - name: /opt/core/files  
    - source: salt://core/files
    - file_mode: 755
    - dir_mode: 700
    - template: jinja
    - clean: True
#


## Set saltstack managed files
/etc/yum.conf:
  file:
   - managed
   - source: salt://core/files/etc.yum.conf
   - mode: 644
   - template: jinja

# this keeps fighting with the managed repo definition below
# so this is being commented out
/etc/yum.repos.d/HP-spp.repo:
  file:
   - managed
   - source: salt://core/files/etc.yum.repos.d.hp-spp.repo
   - mode: 644
   - template: jinja

/etc/wgetrc:
  file:
   - managed
   - source: salt://core/files/etc.wgetrc
   - mode: 644
   - template: jinja

/etc/resolv.conf:
  file:
   - managed
   - source: salt://core/files/etc.resolv.conf
   - mode: 644
   - template: jinja

/etc/security/limits.conf:
    file:
        - managed
        - source: salt://core/files/etc.security.limits.conf
        - mode: 644
        - user: root
        - group: root

/etc/sysconfig/network:
    file:
        - managed
        - source: salt://core/files/etc.sysconfig.network
        - mode: 644
        - user: root
        - group: root
        - template: jinja

/etc/rc.d/rc.local:
    file.managed:
        - source: salt://core/files/etc.rc.local
        - mode: 755
        - user: root
        - group: root

/etc/rc.local:
    file.symlink:
        - target: rc.d/rc.local

## set saltstack managed repos


#-----------------------------------------------------------------------------------------------------
# Hacky-sack to make the bonding config use an ARP test instead of counting on carrier alone
#
# currently the bounce_bond0 rule fails because to work all of the time because of a bug in
# Salt's onchanges magic.  It's been fixed in upstream already, and may be fixed here soon
#
#   see https://github.com/saltstack/salt/pull/24703/commits
#-----------------------------------------------------------------------------------------------------

/etc/modprobe.d/bond0.conf:
    file.absent

/etc/modprobe.d/bonding.conf:
    file:
        - managed
        - source: salt://core/files/etc.modprobe.d.bonding.conf
        - mode: 0644
        - user: root
        - group: root

/etc/sysconfig/network-scripts/ifcfg-bond0:
    file.replace:
        - append_if_not_found: True
        - pattern: 'BONDING_OPTS=.*'
        - repl: 'BONDING_OPTS="mode=1 arp_interval=2000 arp_ip_target={{ salt.cmd.run('ip route show | grep default | grep bond0 | cut -d " " -f 3') }}"'

bounce_bond0:
    cmd.run:
        - name: "service network stop ; rmmod bonding ; service network start"
        - user: root
        - group: root
        - onchanges:
            - file: /etc/sysconfig/network-scripts/ifcfg-bond0
            - file: /etc/modprobe.d/bonding.conf
            - file: /etc/modprobe.d/bond0.conf



## 3.6 Configure Network Time Protocol (NTP)
ntpd:
  service:
    - running
    - required:
      - file: /etc/ntp.conf
    - name: ntpd
    - enable: True
    - sig: ntpd
    - watch:
      - file: /etc/ntp.conf
      - file: /etc/sysconfig/ntpd

# Manage the ntp config file
/etc/ntp.conf:
  file:
    - managed
    - source: salt://core/files/etc.ntp.conf
    - mode: 644
    - template: jinja

# Make sure that the daemon is running as an unprivileged user:
/etc/sysconfig/ntpd:
  file:
    - managed
    - source: salt://core/files/etc.sysconfig.ntpd
    - mode: 644
    - template: jinja




## endif of grains['os_family'] == 'RedHat'
{% endif %}

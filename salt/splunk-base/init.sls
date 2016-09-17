##{% if grains['os_family'] == 'RedHat' and grains['osrelease'].startswith('6') %}

splunk_rpms:
  pkg.installed:
    - sources:
{% if '-spksh-' in grains['localhost'] %}
      - splunk: salt://rpms/splunk-6.3.3.2-1c1e99984d4c-linux-2.6-x86_64.rpm
{% else %}
      - splunk: salt://rpms/splunk-6.3.3-f44afce176d0-linux-2.6-x86_64.rpm
{% endif %}


tickle_splunk:
    cmd.run:
        - name: "/opt/splunk/bin/splunk version --accept-license --answer-yes --no-prompt"
        - user: splunk
        - group: splunk
        - onchanges:
            - pkg: splunk_rpms

## Copy core files
#
#
## Set saltstack managed files
/opt/splunk/etc/auth/splunk.secret:
    file:
        - managed
        - source: salt://splunk-base/files/opt.splunk.etc.auth.splunk.secret
        - mode: 600
        - user: splunk
        - group: splunk

/opt/splunk/etc/splunk-launch.conf:
    file:
        - managed
        - source: salt://splunk-base/files/opt.splunk.etc.splunk-launch.conf
        - mode: 660
        - user: splunk
        - group: splunk

/opt/splunk/etc/system/local/inputs.conf:
    file:
        - managed
        - source: salt://splunk-base/files/opt.splunk.etc.system.local.inputs.conf
        - template: jinja
        - mode: 660
        - user: splunk
        - group: splunk

/opt/splunk/etc/system/local/server.conf:
    file:
        - managed
        - source: salt://splunk-base/files/opt.splunk.etc.system.local.server.conf
        - template: jinja
        - mode: 660
        - user: splunk
        - group: splunk

/opt/splunk/.bash_profile:
    file:
        - managed
        - source: salt://splunk-base/files/opt.splunk.bash.profile
        - mode: 700
        - user: splunk
        - group: splunk

/opt/splunk/.bashrc:
    file:
        - managed
        - source: salt://splunk-base/files/opt.splunk.bashrc
        - mode: 700
        - user: splunk
        - group: splunk


/etc/init.d/splunk:
    file:
        - managed
        - source: salt://splunk-base/files/etc.init.d.splunk
        - mode: 755
        - user: root
        - group: root

splunk_init_links:
    file.symlink:
        - target: ../init.d/splunk
        - names: 
            - /etc/rc.d/rc0.d/K60splunk
            - /etc/rc.d/rc1.d/K60splunk
            - /etc/rc.d/rc2.d/S90splunk
            - /etc/rc.d/rc3.d/S90splunk
            - /etc/rc.d/rc4.d/S90splunk
            - /etc/rc.d/rc5.d/S90splunk
            - /etc/rc.d/rc6.d/K60splunk


#push apps to all splunk servers
{% for APP in [

'org_full_license_server'
]%}

{{ "base-app_%s" % (APP) }}:
    file.recurse:
        - name: /opt/splunk/etc/apps/{{APP}}
        - source: salt://splunk-deployment-apps/{{APP}}
        - clean: true
        - exclude_pat: "*.pyc"
        - user: splunk
        - group: splunk
        - include_empty: true
        - dir_mode: 0770
{% endfor %}


## endif of grains['os_family'] == 'RedHat'
##{% endif %}



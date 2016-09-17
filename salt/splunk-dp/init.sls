##{% if grains['os_family'] == 'RedHat' and grains['osrelease'].startswith('6') %}

## Copy core files
#
#
## Set saltstack managed files
/opt/splunk/etc/system/local/serverclass.conf:
    file.symlink:
        - name: /opt/splunk/etc/system/local/serverclass.conf
        - target: ../../deployment-apps/serverclass.conf
        - user: splunk
        - group: splunk
        - force: False


/opt/splunk/etc/deployment-apps:
    file.recurse:
        - source: salt://splunk-deployment-apps
        - clean: true
        - user: splunk
        - group: splunk
        - include_empty: true
        - dir_mode: 0770

/opt/splunk/etc/apps/org_cluster_forwarder_outputs:
    file.recurse:
        - source: salt://splunk-deployment-apps/org_cluster_forwarder_outputs/
        - exclude_pat: "E@\\.\\./"
        - clean: true
        - user: splunk
        - group: splunk
        - include_empty: true
        - dir_mode: 0770
#the following section reloads the Deployment server as part of applying the salt state, doing something like this in ../splunk-cm/init.sls will enable you to do this for the cluster master as well for bundle application
reload_ds:
    cmd.run:
        - name: "/opt/splunk/bin/splunk reload deploy-server -auth admin:changeme --accept-license --answer-yes --no-prompt"
        - user: splunk
        - group: splunk
        - onchanges:
            - file: /opt/splunk/etc/deployment-apps
    

# Hacks for filesystem permissions because 'recurse' doesn't do it right
# See https://github.com/saltstack/salt/issues/2707

{% set perms_hack_base_path = '/opt/splunk/etc/deployment-apps'  %}
{% for FILE in [
    'TA-sos/bin/lsof_sos.sh',
    'TA-sos/bin/ps_sos_solaris.sh',
    'TA-sos/bin/common.sh',
    'TA-sos/bin/ps_sos.sh',
    'SA-eventgen/build.sh',
 ]%}

{{perms_hack_base_path}}/{{FILE}}:
    file.managed:
        - mode: 750
        - require-in:
            - cmd: reload_ds 
        - onchanges-in:
            - cmd: reload_ds 

{%endfor%}

## endif of grains['os_family'] == 'RedHat'
##{% endif %}

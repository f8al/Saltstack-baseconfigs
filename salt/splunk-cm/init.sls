/opt/splunk/etc/apps/org-multisite_master_base:
  file.recurse:
      - source: salt://splunk-deployment-apps/org-multisite_master_base
      - clean: true
      - user: splunk
      - group: splunk
      - include_empty: true
      - dir_mode: 0770


# SA-eventgen is here to silence cluster bundle validation errors during applys
# because of apps that have the eventgen config files built in
/opt/splunk/etc/apps/SA-eventgen:
    file.recurse:
        - source: salt://splunk-deployment-apps/SA-eventgen
        - clean: true
        - exclude_pat: "*.pyc"
        - user: splunk
        - group: splunk
        - include_empty: true
        - dir_mode: 0770


#---------------------------------------------------------------------
# Licenses
#---------------------------------------------------------------------
/opt/splunk/etc/apps/org_full_license_server:
  file.recurse:
      - source: salt://splunk-deployment-apps/org_full_license_server
      - clean: true
      - user: splunk
      - group: splunk
      - include_empty: true
      - dir_mode: 0770


/opt/splunk/etc/licenses:
    file.directory:
        - user: splunk
        - group: splunk
        - dir_mode: 770

/opt/splunk/etc/licenses/enterprise:
    file.directory:
        - user: splunk
        - group: splunk
        - dir_mode: 770 

/opt/splunk/etc/licenses/enterprise/your-license-file:
  file:
   - managed
   - source: salt://splunk-cm/files/opt.splunk.etc.licenses.enterprise.lic
   - mode: 660
   - user: splunk
   - group: splunk

    

#---------------------------------------------------------------------------
# Cluster master master-apps ... list of master-apps goes here
#
# This template expands out to drop all of these apps in place on the
# cluster master nodes - both primary and secondary.  Add new apps here
# and if an app needs to be removed, you'll probably need an 'absent'
# state to get rid of it.
#
# This does NOT automatically do a 'splunk apply cluster-bundle'.  
# Because we want to be careful and not just blanket push broken stuff
#---------------------------------------------------------------------------
{% for APP in [
'_cluster',
'TA-sos',
'org_all_indexes',
'org_cluster_indexer_inputs',
'org_cluster_indexer_volume_indexes',
'org_all_indexer_base'
]%}

{{ "cm_master-app_%s" % (APP) }}:
    file.recurse:
        - name: /opt/splunk/etc/master-apps/{{APP}}
        - source: salt://splunk-deployment-apps/{{APP}}
        - clean: true
        - exclude_pat: "*.pyc"
        - user: splunk
        - group: splunk
        - include_empty: true
        - dir_mode: 0770
{% endfor %}

# Hacks for filesystem permissions because 'recurse' doesn't do it right
# See https://github.com/saltstack/salt/issues/2707
# Making me angrier .. I can't figure out how to 'include' this into the template
# for both master-apps and deployment-apps.

{% set perms_hack_base_path = '/opt/splunk/etc/master-apps'  %}
{% for FILE in [
    'TA-sos/bin/lsof_sos.sh',
    'TA-sos/bin/ps_sos_solaris.sh',
    'TA-sos/bin/common.sh',
    'TA-sos/bin/ps_sos.sh',
    'SA-eventgen/build.sh'
 ]%}

{{perms_hack_base_path}}/{{FILE}}:
    file.managed:
        - mode: 750

{%endfor%}


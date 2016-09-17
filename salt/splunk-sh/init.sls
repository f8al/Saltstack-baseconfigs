{% for APP in [

'org_cluster_search_base',
'org_cluster_search_deploymentclient',
]%}

{{ "sh-app_%s" % (APP) }}:
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

/opt/splunk/etc/apps/org_cluster_indexer_base:
    file.recurse:
        - source: salt://splunk-deployment-apps/org_cluster_indexer_base
        - clean: true
        - user: splunk
        - group: splunk
        - include_empty: true
        - dir_mode: 0770

#--- This is in slave-apps normally and got put into apps once
# because of password setting crud
/opt/splunk/etc/apps/org_cluster_indexer_inputs:
    file.absent


/splunkdata:
    file.directory:
        - user: splunk
        - group: splunk
        - dir_mode: 770
        # No no do not ever let salt clean that would be bad
        - clean: false
        

/hot_storage:
    file.directory:
        - user: splunk
        - group: splunk
        - dir_mode: 770
        # No no do not ever let salt clean that would be bad
        - clean: false
        

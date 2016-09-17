/opt/splunk/etc/apps/org_site_1_indexer_base:
  file.recurse:
      - source: salt://splunk-deployment-apps/org_site_1_indexer_base
      - clean: true
      - user: splunk
      - group: splunk
      - include_empty: true
      - dir_mode: 0770
      - file_mode: 0600

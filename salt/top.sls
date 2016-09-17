base:
    '*':
        - core
        #cis removed for now

    '*spksh*':
        - splunk-sh
        - splunk-base-not-ix

    '*spkdp*':
        - splunk-dp
        - splunk-base-not-ix

    # Indexers
    '*spkix*':
        - splunk-ix
    'site1-spkix*':
        - splunk-ix-site1
    'site2-spkix*':
        - splunk-ix-site2

    # Cluster masters get the indexer state
    # as well to pick up the site definition
    '*-spkcm-*': 
        - splunk-cm
        - splunk-base-not-ix
    'site1-spkcm-*':
        - splunk-ix-site1
    'site2-spkcm-*':
        - splunk-ix-site2


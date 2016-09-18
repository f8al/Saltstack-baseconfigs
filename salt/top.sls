base:
    '*':
        - core
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
    '*-spkcm-*': 
        - splunk-cm
        - splunk-base-not-ix
    'site1-spkcm-*':
        - splunk-ix-site1
    'site2-spkcm-*':
        - splunk-ix-site2

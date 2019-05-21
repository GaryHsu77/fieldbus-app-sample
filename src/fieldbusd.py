import json

def load_cfg():
    devices = {}
    with open('/etc/fieldbusd/configuration.json') as cfg:
        configuration = json.load(cfg)
        for device in configuration['deviceList']:
            with open('/etc/fieldbusd/template.d/'+device['templateName']) as tmp:
                temp = json.load(tmp)
                devices['tagList'] = temp['tagList']
    return devices

print (load_cfg())
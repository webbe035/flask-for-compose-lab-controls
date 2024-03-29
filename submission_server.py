import json
import os
import requests

# token = "dt1-daZUHiuSz7CUfsyDk2mmFCK9ddeiSS9DCs5LZV532hA3v-43dzqWFnWd8KBa1yev1g3UKnzVxZkkTbfWvjdF2AUv2xiPLeCSj6EJEqvC7HywPfdC"
# endpoint = "/api/take-submission"
# url = "http://localhost:6544"

def request_job(token, endpoint, url):
    features = {'disk_available_mb': 100000,
                'disk_total_mb': 256000,
                'processor_free_percent' : 95,
                'nduckiebots' : 6,
                'x86_64' : 1,
                'processor_frequency_mhz' : 3500,
                'map_aido2_LF_pub': 1,
                'map_aido2_LFV_pub': 1,
                'map_aido2_LFVI_pub': 1,
                'gpu': 0,
                'mac': 0,
                'armv7l': 0,
                'ram_total_mb':16000,
                'ram_available_mb':10000,
                'nprocessors':12,
                'p1': 1,
                'picamera': 0,
                'ipfs': 1

    }
    data_get = {'submission_id': None,
                'machine_id': 'autolab_server',
                'process_id': 'autolab_server-1',
                'evaluator_version': 1,
                'features': features,
                'reset': False}

    tmp = requests.get(url+endpoint,data=json.dumps(data_get), headers={'X-Messaging-Token':token})
    return tmp.content


def upload_job(token, endpoint, url):
    stats = {'msg': 'bla_msg', 
            'scores': {}}

    uploaded = [{'storage': {},
                'size': 21543,
                'mime_type': 'text/yaml',
                'rpath': 'path/to/my/container',
                'sha256hex': 'E94281471ADCB12BCDCEDD5D7205A7F447447F15C49A12C906D73D015AC339C8'
                }]

    data_post = {'job_id': 16,
                'uid': 'user367',
                'machine_id': 'autolab_server',
                'process_id': 'autolab_server-1',
                'result': 'success',
                'stats': stats,
                'uploaded': uploaded,
                'ipfs_hashes': {'rpath1':'cid1'},
                'evaluator_version': 1}

    tmp = requests.post(url+endpoint,data=json.dumps(data_post), headers={'X-Messaging-Token':token})
    return tmp.content
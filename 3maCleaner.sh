#!/bin/bash

if [ -z "$1" ]; then
	echo "no file supplied"
	exit 1
fi

jq 'del(.[][] | nulls)' "$1" >"cleaned_$1" && rm $1 && mv "cleaned_$1" $1

# INFO: use the next function in a python script to use the above bash commands.

# def cleanup_jsons():
#     '''Cleanup jsons of pandas NaN (null) values.'''
#     files = os.listdir()
#
#     for file in files:
#         if file.endswith('.json'):
#             try:
#                 content = subprocess.run([f'/home/anon/Documents/git/pythonScripts/diverse/3maCleaner.sh', file],
#                                         check=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
#
#             except subprocess.CalledProcessError as e:
#                 print(f"error in json cleanup: {e.stderr.decode('utf-8')}")

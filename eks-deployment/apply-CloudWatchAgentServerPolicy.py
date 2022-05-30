import json
  
# Opening JSON file
f = open('terraform.tfstate')
  
# returns JSON object as 
# a dictionary
data = json.load(f)
  
# Iterating through the json
# list
print(data['config_map_aws_auth'])
  
# Closing file
f.close()
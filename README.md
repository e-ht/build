# build

a collection of scripts for use on computer systems

todo 
- env processing for future bjorg implemetation
- tidy up bird bgp route setup 
- automate network interface creation and route assign 
- use ```SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )``` for safely assuming our
place in the universe and chaining scripts
- auto vhost creation for nginx
- .env concept to load with init scripts
### Firewall todo:

- for ip addressing with BIRD, ```DENY ALL``` for institutional IP (maybe)
  - consider whitelist access only

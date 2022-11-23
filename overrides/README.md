**Config Overrides**

This directory is ignored by git except for this file (README.md).

#### If any of the following files are found in this directory they will be used instead of the ones located in the playbook:
1. whitelist.tsv
2. blacklist.tsv
3. trunk.tsv.j2
4. channels.tsv
4. icecast.xml.j2
5. op25.liq.j2
6. op25.sh.j2

#### The locations of files will be resolved in this order:
1. overrides/\<ansible hostname>/\<filename>/
2. overrides/\<filename>
3. roles/files/\<filename>

The intent is for the end user to be able to tweak their OP25 configs.  It is strongly reccommended you use variables 
whenever possible vs config overrides.

**PROTIP**: To run the ansible playbook and limit the run to config-related tasks for far improved speed:
`ansible-playbook -t configs -i hosts.local.yml site.yml` (from the root of this repo)
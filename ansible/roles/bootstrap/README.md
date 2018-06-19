These roles are used to bootstrap the remote host for further tasks.

Bootstrapping could be tasks involving installing pre-requisite packages, setting up some accounts etc.
For better categorization, its the tasks that need to be done on remote host (host being provisioned by Ansible)
that do not require any interaction with guest host (on which ansible is running), before running the tasks that
require the interaction between the two.

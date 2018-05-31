#!/usr/bin/env bash
set -ex
db_host="montagu.vaccineimpact.org"
user_and_host="aws@$db_host"

source ./db_passwords && rm ./db_passwords

mkdir barman && cd barman
git clone https://github.com/vimc/montagu-db
cd montagu-db/backup
git checkout i1771  # TODO: return to master
pip3 install -r requirements.txt

# -M -S - Set up SSH in (M)aster mode for connection sharing via the specified
#         (S)ocket file
# -nNT  - Don't read, do anything remotely, or allocate a remote terminal
# -f    - Run in background
# -p    - Connect to SSH server on 10022, as production has a non-standard port
# -L    - Sets up tunnel from local port to remote host & port
ssh -M -S socket \
    -nNT \
    -f \
    -p 10022 \
    -L 5432:$db_host:5432 \
    $user_and_host

# Check the connection is up
ssh -S socket -O check $user_and_host

trap "ssh -S socket -O exit $user_and_host" SIGINT SIGTERM

# -u makes Python not buffer stdout, so we can monitor remotely
# localhost is forwarded by SSH to the true host
python3 -u ./barman-montagu setup --pull-image --image-source=vimc --no-clean-on-error localhost
